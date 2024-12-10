import SwiftUI

struct ImageSlideshowView: View {
    var images: [ImageId]

    @State var scrollBounds: CGRect = .zero

    @Binding var visibleImageId: ImageId?

    var onDismiss: () -> Void

    var body: some View {
        ScrollViewReader { proxy  in
            ScrollViewWithBounds(axis: .horizontal, bounds: $scrollBounds) {
                HStack(spacing: 0) {
                    ForEach(images) { image in
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(4/3, contentMode: .fit)
                            .containerRelativeFrame([.horizontal, .vertical])
                            .id(image)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $visibleImageId, anchor: .leading)
            .onTapGesture(perform: onDismiss)
            .background {
                let visibleIndices = (scrollBounds.minX * CGFloat(images.count) / scrollBounds.width)
                    .clamped(min: 0, max: CGFloat(images.count - 1))

                let fromIndex = Int(visibleIndices.rounded(.down))

                ZStack {
                    Image(images[fromIndex])
                        .resizable()

                    let reminder = visibleIndices - visibleIndices.rounded(.down)

                    if reminder > 0 {
                        Image(images[fromIndex + 1])
                            .resizable()
                            .opacity(reminder)
                    }
                }
                .overlay {
                    Rectangle().fill(.ultraThinMaterial)
                }
            }.onAppear {
                if let visibleImageId {
                    proxy.scrollTo(visibleImageId, anchor: .leading)
                }
            }
        }
    }
}

extension Image {
    init(_ imageId: ImageId) {
        self.init(imageId.prompt.imageNames[imageId.index])
    }
}

extension CGFloat {
    func clamped(min a: CGFloat, max b: CGFloat) -> CGFloat {
        a < self ? Swift.min(self, b) : a
    }
}

private let store = PromptsStore()

#Preview {
    @Previewable @State var visibleImageId: ImageId? = store.prompts[0].allImageIds[3]

    ZStack {
        ImageSlideshowView(images: store.prompts[0].allImageIds, visibleImageId: $visibleImageId) {
            print("Dismissing view")
        }
    }
}
