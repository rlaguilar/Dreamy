import SwiftUI

struct MosaicLayout: Layout {
    var viewportWidth: CGFloat

    var spacing: CGFloat

    private var doubleSpacing: CGFloat {
        spacing * 2
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache aspectRatios: inout [CGFloat]) -> CGSize {
        let positions = layout(aspectRatios: aspectRatios)

        return CGSize(
            width: positions.map(\.maxX).max().map { $0 + spacing } ?? 0,
            height: positions.map(\.maxY).max() ?? 0
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache aspectRatios: inout [CGFloat]) {
        let positions = layout(aspectRatios: aspectRatios)

        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + positions[index].minX,
                    y: bounds.minY + positions[index].minY
                ),
                proposal: .init(positions[index].size)
            )
        }
    }

    func makeCache(subviews: Subviews) -> [CGFloat] {
        subviews.map { $0.sizeThatFits(.init(width: 100, height: 100)).aspectRatio }
    }

    private func layout(aspectRatios: [CGFloat]) -> [CGRect] {
        var answer: [CGRect] = []
        var heights: [CGFloat] = []

        for index in stride(from: 0, to: aspectRatios.count, by: 4) {
            let xOffset = answer.last.map { $0.maxX + spacing } ?? 0
            let layout = aspectRatios[index] < 1 ? portraitLayout : landscapeLayout
            let rects = layout(aspectRatios, index, xOffset)
            answer.append(contentsOf: rects)
            heights.append(rects.map { $0.maxY }.max()!)
        }

        // make sure that all the regions are centered vertically
        let maxHeight = heights.max() ?? 0

        for index in stride(from: 0, to: aspectRatios.count, by: 4) {
            let regionHeight = heights[index / 4]

            if (regionHeight < maxHeight) {
                for i in index..<index + 4 {
                    answer[i].origin.y += (maxHeight - regionHeight) / 2
                }
            }
        }

        return answer
    }

    private func portraitLayout(aspectRatios: [CGFloat], startIndex index: Int, xOffset: CGFloat) -> [CGRect] {
        let largeWidth = (viewportWidth - 2 * doubleSpacing - spacing) / 2
        let largeHeight = largeWidth / aspectRatios[index]
        let smallHeight = 2 * largeHeight / 3
        let smallWidth = smallHeight * aspectRatios[index + 1]

        let one = CGRect(
            x: xOffset, //answer.last.map { $0.maxX + spacing } ?? 0,
            y: 0,
            width: largeWidth,
            height: largeHeight
        )

        let two = CGRect(
            x: one.maxX - smallWidth,
            y: one.maxY + spacing,
            width: smallWidth,
            height: smallHeight
        )

        let three = CGRect(
            x: one.maxX + spacing,
            y: 0,
            width: smallWidth,
            height: smallHeight
        )

        let four = CGRect(
            x: three.minX,
            y: three.maxY + spacing,
            width: largeWidth,
            height: largeHeight
        )

        return [one, two, three, four]
    }

    private func landscapeLayout(aspectRatios: [CGFloat], startIndex index: Int, xOffset: CGFloat) -> [CGRect] {
        let largeWidth = (viewportWidth - 2 * doubleSpacing) / 7 * 4
        let largeHeight = largeWidth / aspectRatios[index]
        let smallWidth = (viewportWidth - 2 * doubleSpacing) - largeWidth - spacing
        let smallHeight = smallWidth / aspectRatios[index]

        let one = CGRect(
            x: xOffset, // answer.last.map { $0.maxX + spacing } ?? 0,
            y: 0,
            width: largeWidth,
            height: largeHeight
        )

        let two = CGRect(
            x: one.maxX + spacing,
            y: one.maxY - smallHeight,
            width: smallWidth,
            height: smallHeight
        )

        let three = CGRect(
            x: one.minX,
            y: one.maxY + spacing,
            width: smallWidth,
            height: smallHeight
        )

        let four = CGRect(
            x: three.maxX + spacing,
            y: three.minY,
            width: largeWidth,
            height: largeHeight
        )

        return [one, two, three, four]
    }
}

struct CarouselScrollTargetBehaviour: ScrollTargetBehavior {
    var spacing: CGFloat

    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        let pageWidth = context.containerSize.width - 3 * spacing
        let remaining = target.rect.origin.x.remainder(dividingBy: pageWidth)
        target.rect.origin.x -= remaining
    }
}

private extension CGSize {
    var aspectRatio: CGFloat {
        width / height
    }
}
