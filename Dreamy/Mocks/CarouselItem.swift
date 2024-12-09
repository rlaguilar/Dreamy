import CoreGraphics
import SwiftUI

struct CarouselItem: Identifiable {
    var id: Int
    var aspectRatio: CGFloat
    var color: Color
}

extension CarouselItem {
    static var allItem: [CarouselItem] {
        [
            CarouselItem(id: 5, aspectRatio: 3/4, color: .red),
            CarouselItem(id: 6, aspectRatio: 3/4, color: .blue),
            CarouselItem(id: 7, aspectRatio: 3/4, color: .green),
            CarouselItem(id: 8, aspectRatio: 3/4, color: .yellow),
            CarouselItem(id: 1, aspectRatio: 4/3, color: .red),
            CarouselItem(id: 2, aspectRatio: 4/3, color: .blue),
            CarouselItem(id: 3, aspectRatio: 4/3, color: .green),
            CarouselItem(id: 4, aspectRatio: 4/3, color: .yellow),
            CarouselItem(id: 9, aspectRatio: 3/4, color: .red),
            CarouselItem(id: 10, aspectRatio: 3/4, color: .blue),
            CarouselItem(id: 11, aspectRatio: 3/4, color: .green),
            CarouselItem(id: 12, aspectRatio: 3/4, color: .yellow),
        ]
    }
}
