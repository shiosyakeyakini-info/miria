// Skia も package:image も読めない画像フォーマットを Rust 側で読む。
//
// SPDX-FileCopyrightText: miria contributors
// SPDX-License-Identifier: AGPL-3.0-only

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
    fn rejects_other_formats() {
        assert!(decode_jpeg_xl(fixture("sample.png")).is_none());
        assert!(decode_jpeg_xl(vec![]).is_none());
    }
}
