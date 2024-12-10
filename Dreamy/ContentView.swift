import SwiftUI

struct ContentView: View {
    @Environment(PromptsStore.self) var promptsStore

    @State var promptListVisibleImageId: ImageId?

    @State var slideShowVisibleImageId: ImageId?

    var body: some View {
        if slideShowVisibleImageId != nil {
            ImageSlideshowView(images: promptsStore.prompts.flatMap(\.allImageIds), visibleImageId: $slideShowVisibleImageId) {
                if let slideShowVisibleImageId {
                    promptListVisibleImageId = slideShowVisibleImageId.prompt.allImageIds.first
                }

                slideShowVisibleImageId = nil
            }
        }
        else {
            PromptListView(visibleImageId: $promptListVisibleImageId) { imageId in
                slideShowVisibleImageId = imageId
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(PromptsStore())
}
