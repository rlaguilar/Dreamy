import SwiftUI

struct PromptListView: View {
    @Environment(PromptsStore.self) var store

    @State var visiblePromptText = ""

    @Binding var visibleImageId: ImageId?

    var onSelectImage: (ImageId) -> Void

    private let itemsSpacing: CGFloat = 6

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                // To support dynamic type we need to use @ScaledMetric for these values
                DiffView(text: $visiblePromptText, wordsSpacing: 4.3, linesHeight: 1.09)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .font(.body)
                    .fontWeight(.medium)
                    .padding()
                    .padding(.top, 48)
                    .animation(.easeIn, value: visibleImageId)

                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        MosaicLayout(viewportWidth: UIScreen.main.bounds.width, spacing: itemsSpacing) {
                            ForEach(store.prompts) { prompt in
                                ForEach(0..<4) { index in
                                    let imageId = ImageId(prompt: prompt, index: index)

                                    Image(prompt.imageNames[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .onTapGesture {
                                            onSelectImage(imageId)
                                        }
                                        .id(imageId)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $visibleImageId, anchor: .leading)
                    .scrollClipDisabled()
                    // FIXME: Make scrollTargetBehavior(.paging) work without having these `itemSpacing` all over the place.
                    .padding(.leading, 2 * itemsSpacing)
                    .padding(.trailing, itemsSpacing)
                    .onAppear {
                        if let visibleImageId {
                            proxy.scrollTo(visibleImageId, anchor: .leading)
                        }
                    }
                }
            }
        }
        .onChange(of: visibleImageId) {
            visiblePromptText = visibleImageId?.prompt.text ?? store.prompts.first?.text ?? ""
        }
        .onAppear {
            visiblePromptText = visibleImageId?.prompt.text ?? store.prompts.first?.text ?? ""
        }
        .background {
            Color(white: 0.1).ignoresSafeArea(.all)
        }
    }
}

private let store = PromptsStore()

#Preview {
    @Previewable @State var visibleImageId: ImageId? = store.prompts[2].allImageIds[0]

    PromptListView(visibleImageId: $visibleImageId, onSelectImage: { _ in })
        .environment(store)
}
