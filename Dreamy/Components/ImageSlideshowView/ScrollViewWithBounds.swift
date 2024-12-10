import SwiftUI

private struct BoundsPreferenceKey: PreferenceKey {
    static let defaultValue = CGRect.zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }
}

struct ScrollViewWithBounds<Content: View>: View {
    var axis: Axis.Set = [.vertical]
    var showIndicators: Bool = true

    @Binding var bounds: CGRect

    @ViewBuilder var content: Content

    var coordinateSpaceName = UUID()

    var body: some View {
        ScrollView(axis, showsIndicators: showIndicators) {
            content
                .background {
                    GeometryReader { geometry in
                        let frame = geometry.frame(in: .named(coordinateSpaceName))

                        Color.clear.preference(
                            key: BoundsPreferenceKey.self,
                            value: CGRect(
                                origin: CGPoint(x: -frame.minX, y: -frame.minY),
                                size: frame.size
                            )
                        )
                    }
                    .onPreferenceChange(BoundsPreferenceKey.self) { newBounds in
                        bounds = newBounds
                    }
                }
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}

#Preview {
    @Previewable @State var bounds: CGRect = .zero
    ScrollViewWithBounds(bounds: $bounds) {
        Text("Hello, World!")
    }
    .onChange(of: bounds) {
        print(bounds)
    }
}
