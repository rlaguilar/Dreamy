import SwiftUI

struct PromptsView: View {
    @Environment(PromptsStore.self) var promptStore

    private let itemsSpacing: CGFloat = 6

    var body: some View {
        ZStack {
            Color(white: 0.1).ignoresSafeArea(.all)

            ScrollView(.horizontal, showsIndicators: false) {
                MosaicLayout(viewportWidth: UIScreen.main.bounds.width, spacing: itemsSpacing) {
                    ForEach(promptStore.prompts.flatMap { $0.imageNames }, id: \.self) {
                        Image($0)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .scrollClipDisabled()
            // FIXME: Make scrollTargetBehavior(.paging) work without having these `itemSpacing` all over the place.
            .padding(.leading, 2 * itemsSpacing)
            .padding(.trailing, itemsSpacing)
        }
    }
}

#Preview {
    PromptsView()
        .environment(PromptsStore())
}
