import SwiftUI

struct ContentView: View {
    @Environment(PromptsStore.self) var promptsStore

    @State var promptListVisibleImageId: ImageId?

    @State var slideShowVisibleImageId: ImageId?

    var body: some View {
        // TODO: Implement transition using MatchedGeometryEffect
        if slideShowVisibleImageId == nil {
            PromptListView(visibleImageId: $promptListVisibleImageId, onSelectImage: { imageId in
                withAnimation {
                    slideShowVisibleImageId = imageId
                }
            })
        } else {
            ImageSlideshowView(
                imageIds: promptsStore.prompts.flatMap(\.allImageIds),
                visibleImageId: $slideShowVisibleImageId,
                onDismiss: {
                    if let slideShowVisibleImageId {
                        promptListVisibleImageId = slideShowVisibleImageId.prompt.allImageIds.first
                    }

                    withAnimation {
                        slideShowVisibleImageId = nil
                    }
                }
            )
        }
    }
}

#Preview {
    ContentView()
        .environment(PromptsStore())
}
