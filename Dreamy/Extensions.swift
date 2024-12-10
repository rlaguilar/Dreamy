import SwiftUI

extension ImageId {
    var image: Image {
        Image(prompt.imageNames[index])
    }
}
