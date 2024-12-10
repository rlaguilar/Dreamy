import SwiftUI

struct Word: Identifiable {
    var id: UUID

    var text: String
}

struct DiffView: View {
    var wordsSpacing: CGFloat = 4.3

    var linesHeight: CGFloat = 1

    @Binding var text: String

    @State var words: [Word] = []

    var body: some View {
        HStack(spacing: wordsSpacing) {
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
        "What is love",
        "This is amazing love"
    ]
    NavigationStack {
        DiffView(text: $texts[index])
            .toolbar {
                Button("Change Text") {
                    index = (index + 1) % texts.count
                }
            }
    }

}
