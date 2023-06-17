import Foundation

class SharingFile: Codable {
    var value: String;
    var thumbnail: String?; // video thumbnail
    var duration: Double?; // video duration in milliseconds
    var type: SharingFileType;


    init(value: String, thumbnail: String?, duration: Double?, type: SharingFileType) {
        self.value = value
        self.thumbnail = thumbnail
        self.duration = duration
        self.type = type
    }

    // toString method to print out SharingFile details in the console
    func toString() {
        print("[SharingFile] \n\tvalue: \(self.value)\n\tthumbnail: \(self.thumbnail ?? "--" )\n\tduration: \(self.duration ?? 0)\n\ttype: \(self.type)")
    }

    func toData(data: [SharingFile]) -> Data {
        let encodedData = try? JSONEncoder().encode(data)
        return encodedData!
    }
}