import SwiftUI

struct Word: Identifiable {
    var id: UUID

    var text: String
}

struct DiffView: View {
    @Binding var text: String

    var wordsSpacing: CGFloat = 4.2

    var linesHeight: CGFloat = 1

    @State private var words: [Word] = []

    var body: some View {
        WordsLayout(spacing: wordsSpacing, linesHeight: linesHeight) {
            ForEach(words) { word in
                Text(word.text)
            }
        }
        .onChange(of: text) {
            withAnimation {
                computeWords()
            }
        }
        .onAppear {
            computeWords()
        }
    }

    func computeWords() {
        words = EditDistance.computeDiff(words: words, newText: text)
    }
}

extension EditDistance {
    static func computeDiff(words: [Word], newText: String) -> [Word] {
        let editActions = EditDistance(
            fromWords: words.map(\.text),
            toWords: newText.split(separator: " ").map { String($0) }
        ).editActions()

        var answer: [Word] = []
        var wordsIndex = 0

        for action in editActions {
            switch action {
            case .keep:
                answer.append(words[wordsIndex])
                wordsIndex += 1
            case .insert(let word):
                answer.append(Word(id: UUID(), text: word))
            case .delete:
                wordsIndex += 1
            }
        }

        return answer
    }
}

#Preview {
    @Previewable @State var index = 0
    @Previewable @State var texts = [
        "Love is a deep affection, care, and connection, often selfless, shared between people, ideas, or life itself.",
        "What is love",
        "This is amazing love"
    ]
    NavigationStack {
        DiffView(text: $texts[index])
            .overlay {
                // Uncomment to see how our custom layout compares to the default SwiftUI text layout.
                Text(texts[index])
                    .border(Color.green)
            }
            .toolbar {
                Button("Change Text") {
                    index = (index + 1) % texts.count
                }
            }
    }

}
