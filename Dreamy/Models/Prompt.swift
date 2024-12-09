import Foundation

struct Prompt: Hashable, Codable, Identifiable {
    var id: String
    var text: String

    var imageNames: [String] {
        (1...4).map { "\(id)-\($0)" }
    }
}

struct ImageId: Hashable {
    var prompt: Prompt
    
    var index: Int
}
