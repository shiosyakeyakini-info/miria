// Skia も package:image も読めない画像フォーマットを Rust 側で読む。
//
// SPDX-FileCopyrightText: miria contributors
// SPDX-License-Identifier: AGPL-3.0-only

use std::io::Cursor;

use jpeg2k::{Image as Jpeg2000Image, ImagePixelData};
use jpegxr::{ImageDecode, PixelFormat};
use jxl_oxide::JxlImage;

/// デコード結果。`rgba` には RGBA8 が width * height * 4 バイト並ぶ。
pub struct DecodedImage {
    pub width: u32,
    pub height: u32,
    pub rgba: Vec<u8>,
}

/// JPEG XL を読む。読めなければ `None`。
///
/// アニメーションのものは最初のキーフレームだけを返す。
pub fn decode_jpeg_xl(bytes: Vec<u8>) -> Option<DecodedImage> {
    let image = JxlImage::builder().read(std::io::Cursor::new(bytes)).ok()?;
    let render = image.render_frame(0).ok()?;
    let frame = render.image_all_channels();

    let width = frame.width();
    let height = frame.height();
    let channels = frame.channels();
    if width == 0 || height == 0 || channels == 0 {
        return None;
    }

    let mut rgba = Vec::with_capacity(width * height * 4);
    for pixel in frame.buf().chunks_exact(channels) {
        let (r, g, b, a) = match channels {
            1 => (pixel[0], pixel[0], pixel[0], 1.0),
            2 => (pixel[0], pixel[0], pixel[0], pixel[1]),
            3 => (pixel[0], pixel[1], pixel[2], 1.0),
            _ => (pixel[0], pixel[1], pixel[2], pixel[3]),
        };
        rgba.extend_from_slice(&[to_u8(r), to_u8(g), to_u8(b), to_u8(a)]);
    }

    Some(DecodedImage {
        width: width as u32,
        height: height as u32,
        rgba,
    })
}

/// JPEG XR を読む。読めなければ `None`。
///
/// jxrlib (Microsoft が公開した参照実装) に任せる。素の `Copy` は 8bit の
/// 形式で必ず失敗するので、フォーマットコンバータを噛ませたうえで、
/// その前にデコーダのアルファモードを立てておく。この2つが揃わないと
/// 8bit は読めない (imagecodecs の Python バインディングと同じ手順)。
pub fn decode_jpeg_xr(bytes: Vec<u8>) -> Option<DecodedImage> {
    let mut decoder = ImageDecode::with_reader(Cursor::new(bytes)).ok()?;
    let (width, height) = decoder.get_size().ok()?;
    if width <= 0 || height <= 0 {
        return None;
    }
    let (width, height) = (width as usize, height as usize);

    let format = decoder.get_pixel_format().ok()?;
    let (channels, alpha_mode) = match format {
        PixelFormat::PixelFormat32bppRGBA
        | PixelFormat::PixelFormat32bppBGRA
        | PixelFormat::PixelFormat32bppPRGBA
        | PixelFormat::PixelFormat32bppPBGRA => (4usize, 2u8),
        PixelFormat::PixelFormat24bppRGB | PixelFormat::PixelFormat24bppBGR => (3, 0),
        PixelFormat::PixelFormat8bppGray => (1, 0),
        // HDR 用の 16bit や float は絵文字やアイコンには出てこない
        _ => return None,
    };
    let bgr = matches!(
        format,
        PixelFormat::PixelFormat32bppBGRA
            | PixelFormat::PixelFormat32bppPBGRA
            | PixelFormat::PixelFormat24bppBGR
    );

    let stride = width * channels;
    let mut raw = vec![0u8; stride * height];
    decoder
        .copy_all_converted(&mut raw, stride, format, alpha_mode)
        .ok()?;

    let mut rgba = Vec::with_capacity(width * height * 4);
    for row in raw.chunks_exact(stride) {
        for pixel in row.chunks_exact(channels) {
            let (r, g, b) = match channels {
                1 => (pixel[0], pixel[0], pixel[0]),
                _ if bgr => (pixel[2], pixel[1], pixel[0]),
                _ => (pixel[0], pixel[1], pixel[2]),
            };
            let a = if channels == 4 { pixel[3] } else { 255 };
            rgba.extend_from_slice(&[r, g, b, a]);
        }
    }

    Some(DecodedImage {
        width: width as u32,
        height: height as u32,
        rgba,
    })
}

/// JPEG 2000 を読む。読めなければ `None`。
///
/// `jpeg2k` の純Rust実装 (openjp2) に任せる。C の openjpeg も選べるが、
/// ビルドに C のツールチェインが要るので使わない。
///
/// 扱うのは 8bit のグレー・RGB・RGBA だけ。16bit のものは絵文字や
/// アイコンには出てこない。
pub fn decode_jpeg_2000(bytes: Vec<u8>) -> Option<DecodedImage> {
    let image = Jpeg2000Image::from_bytes(&bytes).ok()?;
    let pixels = image.get_pixels(Some(255)).ok()?;
    let (width, height) = (pixels.width, pixels.height);
    if width == 0 || height == 0 {
        return None;
    }

    let rgba: Vec<u8> = match pixels.data {
        ImagePixelData::L8(data) => {
            data.iter().flat_map(|&g| [g, g, g, 255]).collect()
        }
        ImagePixelData::La8(data) => data
            .chunks_exact(2)
            .flat_map(|p| [p[0], p[0], p[0], p[1]])
            .collect(),
        ImagePixelData::Rgb8(data) => data
            .chunks_exact(3)
            .flat_map(|p| [p[0], p[1], p[2], 255])
            .collect(),
        ImagePixelData::Rgba8(data) => data,
        _ => return None,
    };
    if rgba.len() != width as usize * height as usize * 4 {
        return None;
    }

    Some(DecodedImage {
        width,
        height,
        rgba,
    })
}

fn to_u8(value: f32) -> u8 {
    (value.clamp(0.0, 1.0) * 255.0).round() as u8
}

#[cfg(test)]
mod tests {
    use super::*;

    fn fixture(name: &str) -> Vec<u8> {
        std::fs::read(format!("../test/assets/images/formats/{name}")).unwrap()
    }

    fn pixel(image: &DecodedImage, x: u32, y: u32) -> (u8, u8, u8, u8) {
        let i = ((y * image.width + x) * 4) as usize;
        (
            image.rgba[i],
            image.rgba[i + 1],
            image.rgba[i + 2],
            image.rgba[i + 3],
        )
    }

    #[test]
    fn reads_jpeg_xl() {
        let image = decode_jpeg_xl(fixture("sample.jxl")).expect("読めなかった");
        assert_eq!((image.width, image.height), (8, 8));
        assert_eq!(image.rgba.len(), 8 * 8 * 4);

        // 地は白、対角線上だけ黒く塗ってある
        let (r, _, _, a) = pixel(&image, 5, 2);
        assert!(r > 200, "(5,2) が白くない: {r}");
        assert_eq!(a, 255);
        let (r, _, _, _) = pixel(&image, 4, 4);
        assert!(r < 100, "(4,4) が黒くない: {r}");
    }

    #[test]
    fn reads_jpeg_xr() {
        let image = decode_jpeg_xr(fixture("sample.jxr")).expect("読めなかった");
        assert_eq!((image.width, image.height), (8, 8));
        assert_eq!(image.rgba.len(), 8 * 8 * 4);

        let (r, _, _, a) = pixel(&image, 5, 2);
        assert!(r > 200, "(5,2) が白くない: {r}");
        assert_eq!(a, 255);
        let (r, _, _, _) = pixel(&image, 4, 4);
        assert!(r < 100, "(4,4) が黒くない: {r}");
    }

    #[test]
    fn reads_jpeg_2000() {
        let image = decode_jpeg_2000(fixture("sample.jp2")).expect("読めなかった");
        assert_eq!((image.width, image.height), (8, 8));
        assert_eq!(image.rgba.len(), 8 * 8 * 4);

        let (r, _, _, a) = pixel(&image, 5, 2);
        assert!(r > 200, "(5,2) が白くない: {r}");
        assert_eq!(a, 255);
        let (r, _, _, _) = pixel(&image, 4, 4);
        assert!(r < 100, "(4,4) が黒くない: {r}");
    }

    #[test]
    fn rejects_other_formats() {
        assert!(decode_jpeg_xl(fixture("sample.png")).is_none());
        assert!(decode_jpeg_xl(vec![]).is_none());
        assert!(decode_jpeg_xr(fixture("sample.png")).is_none());
        assert!(decode_jpeg_xr(vec![]).is_none());
        assert!(decode_jpeg_2000(fixture("sample.png")).is_none());
        assert!(decode_jpeg_2000(vec![]).is_none());
    }
}
