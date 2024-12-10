import SwiftUI

struct ImageSlideshowView: View {
    var imageIds: [ImageId]

    @State var scrollBounds: CGRect = .zero

    @Binding var visibleImageId: ImageId?

    var onDismiss: () -> Void = { }

    var body: some View {
        ScrollViewReader { proxy  in
            ScrollViewWithBounds(axis: .horizontal, showIndicators: false, bounds: $scrollBounds) {
                HStack(spacing: 0) {
                    ForEach(imageIds) { imageId in
                        imageId.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .containerRelativeFrame([.horizontal])
                            .id(imageId)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $visibleImageId, anchor: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .onAppear {
                if let visibleImageId {
                    proxy.scrollTo(visibleImageId, anchor: .leading)
                }
            }
        }
        .frame(minHeight: 0, maxHeight: .infinity)
        .background {
            blurBackground
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    onDismiss()
                }
        }
    }

    @ViewBuilder
    var blurBackground: some View {
        ZStack {
            let visibleIndices = (scrollBounds.minX * CGFloat(imageIds.count) / scrollBounds.width)
                .clamped(min: 0, max: CGFloat(imageIds.count - 1))

            let fromIndex = Int(visibleIndices.rounded(.down))

            imageIds[fromIndex].image
                .resizable()

            let reminder = visibleIndices - visibleIndices.rounded(.down)

            if reminder > 0 {
                imageIds[fromIndex + 1].image
                    .resizable()
                    .opacity(reminder)
            }

            Rectangle().fill(.ultraThinMaterial)
        }
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

    ImageSlideshowView(imageIds: store.prompts[0].allImageIds, visibleImageId: $visibleImageId)
}
