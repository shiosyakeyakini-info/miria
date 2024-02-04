import UIKit
import Flutter
import Social
import MobileCoreServices
import Photos

class ShareViewController: UIViewController, FlutterPluginRegistry {
    private let imageContentType = kUTTypeImage as String
    private let videoContentType = kUTTypeMovie as String
    private let textContentType = kUTTypeText as String
    private let urlContentType = kUTTypeURL as String
    private let fileURLType = kUTTypeFileURL as String;
    private let sharedKey = "ShareKey"
    private let hostAppBundleIdentifier = "info.shiosyakeyakini.miria"
    
    private var shareText: [String] = []
    private var shareFiles: [SharedMediaFile] = []
    
    private let flutterViewController: FlutterViewController = FlutterViewController(project: nil, initialRoute: "/share-extension", nibName: nil, bundle: nil)
    
    
    @objc func registrar(forPlugin pluginKey: String) -> FlutterPluginRegistrar? {
        return flutterViewController.registrar(forPlugin: pluginKey)
    }
    
    @objc func hasPlugin(_ pluginKey: String) -> Bool {
        return flutterViewController.hasPlugin(pluginKey)
    }
    
    @objc func valuePublished(byPlugin pluginKey: String) -> NSObject? {
        return flutterViewController.valuePublished(byPlugin: pluginKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            if let contents = content.attachments {
                for (index, attachment) in (contents).enumerated() {
                    if attachment.hasItemConformingToTypeIdentifier(imageContentType) {
                        handleImages(content: content, attachment: attachment, index: index)
                    } else if attachment.hasItemConformingToTypeIdentifier(textContentType) {
                        handleText(content: content, attachment: attachment, index: index)
                    } else if attachment.hasItemConformingToTypeIdentifier(fileURLType) {
                        handleFiles(content: content, attachment: attachment, index: index)
                    } else if attachment.hasItemConformingToTypeIdentifier(urlContentType) {
                        let attributedTitle = content.attributedTitle?.string
                        let attributedContent = content.attributedContentText?.string
                        handleUrl(content: content, attachment: attachment, index: index, title: attributedTitle ?? attributedContent);
                    } else if attachment.hasItemConformingToTypeIdentifier(videoContentType) {
                        handleVideos(content: content, attachment: attachment, index: index)
                    }
                }

            }
        }
        ShareExtensionPluginRegistrant.register(with: self)
        
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
    }
    
    private func save() {
        let userDefaults = UserDefaults(suiteName: "group.\(self.hostAppBundleIdentifier)")
        let encoder = JSONEncoder()
        let json = try? encoder.encode(SendData(text: self.shareText, files: self.shareFiles))
        guard let encoded = json else {
            return
        }
        userDefaults?.set(String(data: encoded, encoding: .utf8), forKey: self.sharedKey)
        userDefaults?.synchronize()
    }
    
    private func handleText (content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: textContentType, options: nil) { [weak self] data, error in

            if error == nil, let item = data as? String, let this = self {
                this.shareText.append(item)
                if index == (content.attachments?.count)! - 1 {
                    this.save()
                }
            }
        }
    }

    private func handleUrl (content: NSExtensionItem, attachment: NSItemProvider, index: Int, title: String?) {
        attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in

            if error == nil, let item = data as? URL, let this = self {
                let text: String
                if(title != nil) {
                    text = "[\(title ?? "")](\(item.absoluteString))"
                } else {
                    text = item.absoluteString
                }
                this.shareText.append(text)
                if index == (content.attachments?.count)! - 1 {
                    this.save()
                }
            }
        }
    }

    private func handleImages (content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: imageContentType, options: nil) { [weak self] data, error in

            if error == nil, let url = data as? URL, let this = self {

                // Always copy
                let fileName = this.getFileName(from: url, type: .image)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(this.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if(copied) {
                    this.shareFiles.append(SharedMediaFile(path: newPath.absoluteString, thumbnail: nil, duration: nil, type: .image))
                }
                if index == (content.attachments?.count)! - 1 {
                    this.save()
                }
            }
        }
    }

    private func handleVideos (content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: videoContentType, options: nil) { [weak self] data, error in

            if error == nil, let url = data as? URL, let this = self {

                // Always copy
                let fileName = this.getFileName(from: url, type: .video)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(this.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if(copied) {
                    guard let sharedFile = this.getSharedMediaFile(forVideo: newPath) else {
                        return
                    }
                    this.shareFiles.append(sharedFile)
                }
                if index == (content.attachments?.count)! - 1 {
                    this.save()
                }
            }
        }
    }

    private func handleFiles (content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: fileURLType, options: nil) { [weak self] data, error in
            if error == nil, let url = data as? URL, let this = self {
                // Always copy
                let fileName = this.getFileName(from :url, type: .file)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(this.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if (copied) {
                    this.shareFiles.append(SharedMediaFile(path: newPath.absoluteString, thumbnail: nil, duration: nil, type: .file))
                }
                if index == (content.attachments?.count)! - 1 {
                    this.save()
                }
            }
        }
    }
    func getExtension(from url: URL, type: SharedMediaType) -> String {
        let parts = url.lastPathComponent.components(separatedBy: ".")
        var ex: String? = nil
        if (parts.count > 1) {
            ex = parts.last
        }

        if (ex == nil) {
            switch type {
                case .image:
                    ex = "PNG"
                case .video:
                    ex = "MP4"
                case .file:
                    ex = "TXT"
            }
        }
        return ex ?? "Unknown"
    }

    func getFileName(from url: URL, type: SharedMediaType) -> String {
        var name = url.lastPathComponent

        if (name.isEmpty) {
            name = UUID().uuidString + "." + getExtension(from: url, type: type)
        }

        return name
    }

    func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }

    private func getSharedMediaFile(forVideo: URL) -> SharedMediaFile? {
        let asset = AVAsset(url: forVideo)
        let duration = (CMTimeGetSeconds(asset.duration) * 1000).rounded()
        let thumbnailPath = getThumbnailPath(for: forVideo)

        if FileManager.default.fileExists(atPath: thumbnailPath.path) {
            return SharedMediaFile(path: forVideo.absoluteString, thumbnail: thumbnailPath.absoluteString, duration: duration, type: .video)
        }

        var saved = false
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //        let scale = UIScreen.main.scale
        assetImgGenerate.maximumSize =  CGSize(width: 360, height: 360)
        do {
            let img = try assetImgGenerate.copyCGImage(at: CMTimeMakeWithSeconds(600, preferredTimescale: Int32(1.0)), actualTime: nil)
            try UIImage.pngData(UIImage(cgImage: img))()?.write(to: thumbnailPath)
            saved = true
        } catch {
            saved = false
        }

        return saved ? SharedMediaFile(path: forVideo.absoluteString, thumbnail: thumbnailPath.absoluteString, duration: duration, type: .video) : nil

    }

    private func getThumbnailPath(for url: URL) -> URL {
        let fileName = Data(url.lastPathComponent.utf8).base64EncodedString().replacingOccurrences(of: "==", with: "")
        let path = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.\(hostAppBundleIdentifier)")!
            .appendingPathComponent("\(fileName).jpg")
        return path
    }


    class SharedMediaFile: Codable {
        var path: String; // can be image, video or url path. It can also be text content
        var thumbnail: String?; // video thumbnail
        var duration: Double?; // video duration in milliseconds
        var type: SharedMediaType;


        init(path: String, thumbnail: String?, duration: Double?, type: SharedMediaType) {
            self.path = path
            self.thumbnail = thumbnail
            self.duration = duration
            self.type = type
        }

        // Debug method to print out SharedMediaFile details in the console
        func toString() {
            print("[SharedMediaFile] \n\tpath: \(self.path)\n\tthumbnail: \(self.thumbnail)\n\tduration: \(self.duration)\n\ttype: \(self.type)")
        }
    }
    
    struct SendData: Encodable {
        let text: [String]
        let files: [SharedMediaFile]
    }

    enum SharedMediaType: Int, Codable {
        case image
        case video
        case file
    }

    func toData(data: [SharedMediaFile]) -> Data {
        let encodedData = try? JSONEncoder().encode(data)
        return encodedData!
    }
}

