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
        let visibleIndices = (scrollBounds.minX * CGFloat(imageIds.count) / scrollBounds.width)
            .clamped(min: 0, max: CGFloat(imageIds.count - 1))

        let fromIndex = Int(visibleIndices.rounded(.down))
        let reminder = visibleIndices - visibleIndices.rounded(.down)

        ZStack {
            // we are using full sized images here, but could get away with low quality ones if necessary
            imageIds[fromIndex].image
                .resizable()

            if reminder > 0 {
                imageIds[fromIndex + 1].image
                    .resizable()
                    .opacity(reminder)
            }

            Rectangle().fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    @Previewable @State var visibleImageId: ImageId?

    let store = PromptsStore()
    ImageSlideshowView(imageIds: store.prompts[0].allImageIds, visibleImageId: $visibleImageId)
}
