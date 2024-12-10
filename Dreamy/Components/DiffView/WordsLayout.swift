import SwiftUI

struct WordsLayout: Layout {
    var spacing: CGFloat

    var linesHeight: CGFloat = 1.1

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache wordSizes: inout [CGSize]) -> CGSize {
        let positions = layout(sizes: wordSizes, containerWidth: proposal.width ?? .infinity)

        return zip(positions, wordSizes).reduce(into: CGSize.zero) { (maxSize, viewRect) in
            let (position, size) = viewRect
            maxSize.width = max(maxSize.width, position.x + size.width)
            maxSize.height = max(maxSize.height, position.y + size.height)
        }
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache wordSizes: inout [CGSize]) {
        let positions = layout(sizes: wordSizes, containerWidth: bounds.width)

        for (view, position) in zip(subviews, positions) {
            view.place(
                at: CGPoint(x: position.x + bounds.minX, y: position.y + bounds.minY),
                proposal: .unspecified
            )
        }
    }

    func makeCache(subviews: Subviews) -> [CGSize] {
        subviews.map { $0.sizeThatFits(.unspecified) }
    }

    private func layout(sizes: [CGSize], containerWidth: CGFloat) -> [CGPoint] {
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        var positions: [CGPoint] = []

        for size in sizes {
            if xOffset + size.width > containerWidth && xOffset > 0 {
                xOffset = 0
                yOffset += size.height * linesHeight
            }

            positions.append(CGPoint(x: xOffset, y: yOffset))
            xOffset += size.width + spacing
        }

        return positions
    }
}
