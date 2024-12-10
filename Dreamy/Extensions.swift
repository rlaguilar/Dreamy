import SwiftUI

extension Prompt {
    var allImageIds: [ImageId] {
        return (0 ..< imageNames.count).map { ImageId(prompt: self, index: $0) }
    }
}

extension ImageId {
    var image: Image {
        Image(prompt.imageNames[index])
    }
}

extension CGFloat {
    func clamped(min a: CGFloat, max b: CGFloat) -> CGFloat {
        a < self ? Swift.min(self, b) : a
    }
}

extension CGSize {
    var aspectRatio: CGFloat {
        width / height
    }
}
