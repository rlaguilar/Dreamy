import Foundation
import SwiftUI

struct ImageId: Hashable, Identifiable {
    var id: String {
        return "\(prompt.id)x\(index)"
    }
    
    var prompt: Prompt

    var index: Int
}
