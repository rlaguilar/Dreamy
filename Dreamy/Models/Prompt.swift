import Foundation

struct Prompt: Hashable, Codable, Identifiable {
    var id: String
    var text: String

    var imageNames: [String] {
        (1...4).map { "\(id)-\($0)" }
    }
}
