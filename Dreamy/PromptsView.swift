import SwiftUI

struct PromptsView: View {
    @Environment(PromptsStore.self) var store

    @State var visibleImageId: ImageId?

    private let itemsSpacing: CGFloat = 6

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                if let visiblePrompt = visibleImageId?.prompt ?? store.prompts.first {
                    Text(visiblePrompt.text)
                        .foregroundStyle(Color.white.opacity(0.7))
                        .font(.body)
                        .fontWeight(.medium)
                        .padding()
                        .padding(.top, 48)
                        .animation(.easeIn, value: visibleImageId)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    MosaicLayout(viewportWidth: UIScreen.main.bounds.width, spacing: itemsSpacing) {
                        ForEach(store.prompts) { prompt in
                            ForEach(0..<4) { index in
                                Image(prompt.imageNames[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .id(ImageId(prompt: prompt, index: index))
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

                HStack {
                    Button("Start") {
                        visibleImageId = ImageId(prompt: store.prompts[0], index: 0)
                    }

                    Button("Middle") {
                        visibleImageId = ImageId(prompt: store.prompts[1], index: 0)
                    }

                    Button("End") {
                        visibleImageId = ImageId(prompt: store.prompts.last!, index: 0)
                    }
                }
            }
        }
        .background {
            Color(white: 0.1).ignoresSafeArea(.all)
        }
    }
}

#Preview {
    PromptsView()
        .environment(PromptsStore())
}
