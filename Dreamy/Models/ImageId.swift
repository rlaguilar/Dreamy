import Foundation
import SwiftUI

struct ImageId: Hashable, Identifiable {
    var id: String {
        return "\(prompt.id)x\(index)"
    }
    
    var prompt: Prompt

    var index: Int
}

extension Prompt {
    var allImageIds: [ImageId] {
        return (0 ..< imageNames.count).map { ImageId(prompt: self, index: $0) }
    }
}
