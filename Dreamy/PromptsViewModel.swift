import SwiftUI

@Observable
class PromptsViewModel {
    var selectedImageId: String?

    var visiblePromptId: String? {
        selectedImageId?.split(separator: "$").first.map { String($0) }
    }

    func imageId(for imageName: String, promptId: String) -> String {
        "\(promptId)$\(imageName)"
    }
}
