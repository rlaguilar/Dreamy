import SwiftUI

struct ItemDetailsView: View {
    var item: CarouselItem

    var body: some View {
        CarouselItemView(item: item)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color(white: 0.1).ignoresSafeArea(.all)
            }
    }
}
