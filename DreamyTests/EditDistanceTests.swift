//

import Testing
@testable import Dreamy

struct EditDistanceTests {
    @Test func editActions_whenNoDifferences_keepsAllWords() async throws {
        let words = ["hello", "world"]
        let editDistance = EditDistance(
            fromWords: words,
            toWords: words
        )

        let actions = editDistance.editActions()
        #expect(actions == words.map { _ in .keep })
    }

    @Test func editActions_whenToWordsHasExtraWords_insertsThem() async throws {
        let editDistance = EditDistance(
            fromWords: ["hello"],
            toWords: ["hello", "world"]
        )

        let actions = editDistance.editActions()
        #expect(actions == [.keep, .insert("world")])
    }

    @Test func editActions_whenFromWordsHasExtraWords_removesThem() async throws {
        let editDistance = EditDistance(
            fromWords: ["hello", "world"],
            toWords: ["hello"]
        )

        let actions = editDistance.editActions()
        #expect(actions == [.keep, .delete])
    }

    @Test func editActions_whenWordsAreDifferent_deletesAndInsertsWordsCorrectly() async throws {
        let editDistance = EditDistance(
            fromWords: ["hello"],
            toWords: ["world"]
        )

        let actions = editDistance.editActions()
        #expect(actions == [.delete, .insert("world")])
    }

    @Test func editActions_whenNonTrivialDiff_handlesIt() async throws {
        let editDistance = EditDistance(
            fromWords: ["this", "is", "amazing", "love"],
            toWords: ["what", "is", "love"]
        )

        let actions = editDistance.editActions()
        #expect(actions == [.delete, .insert("what"), .keep, .delete, .keep])
    }
}
