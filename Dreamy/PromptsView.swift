import SwiftUI

struct PromptsView: View {
    @Environment(PromptsStore.self) var store
    @State var viewModel = PromptsViewModel()

    private let itemsSpacing: CGFloat = 6

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                if let visiblePrompt = viewModel.visiblePromptId.map(store.promptWithId(_:)) ?? store.prompts.first {
                    Text(visiblePrompt.text)
                        .foregroundStyle(Color.white.opacity(0.7))
                        .font(.body)
                        .fontWeight(.medium)
                        .padding()
                        .padding(.top, 48)
                        .animation(.easeIn, value: viewModel.visiblePromptId)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    MosaicLayout(viewportWidth: UIScreen.main.bounds.width, spacing: itemsSpacing) {
                        ForEach(store.prompts.flatMap { p in p.imageNames.map { (p.id, $0) } }, id: \.1) { (id, imageName) in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .id(viewModel.imageId(for: imageName, promptId: id))
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $viewModel.selectedImageId)
                .scrollClipDisabled()
                // FIXME: Make scrollTargetBehavior(.paging) work without having these `itemSpacing` all over the place.
                .padding(.leading, 2 * itemsSpacing)
                .padding(.trailing, itemsSpacing)
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
