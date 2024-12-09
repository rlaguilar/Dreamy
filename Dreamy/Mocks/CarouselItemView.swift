import SwiftUI

struct CarouselItemView: View {
    var item: CarouselItem

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(item.color)
            .aspectRatio(item.aspectRatio, contentMode: .fit)
    }
}
