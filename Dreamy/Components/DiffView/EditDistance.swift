enum EditAction: Equatable {
    case delete, keep, insert(String)
}

class EditDistance {
    let fromWords: [String]

    let toWords: [String]

    private var cache: [[Int?]]

    init(fromWords: [String], toWords: [String]) {
        self.fromWords = fromWords
        self.toWords = toWords

        cache = Array(repeating: Array(repeating: nil, count: toWords.count), count: fromWords.count)
    }

    func editActions() -> [EditAction] {
        var fromIndex = 0
        var toIndex = 0

        var answer: [EditAction] = []

        while fromIndex < fromWords.count || toIndex < toWords.count {
            if fromIndex == fromWords.count {
                answer.append(.insert(toWords[toIndex]))
                toIndex += 1
            } else if toIndex == toWords.count {
                answer.append(.delete)
                fromIndex += 1
            } else {
                var result = EditAction.delete
                var cost = 1 + compute(fromIndex: fromIndex + 1, toIndex: toIndex)

                var increment = {
                    fromIndex += 1
                }

                let insertCost = 1 + compute(fromIndex: fromIndex, toIndex: toIndex + 1)

                if insertCost < cost {
                    cost = insertCost
                    result = .insert(toWords[toIndex])

                    increment = {
                        toIndex += 1
                    }
                }

                if (fromWords[fromIndex] == toWords[toIndex]) {
                    let keepCost = compute(fromIndex: fromIndex + 1, toIndex: toIndex + 1)

                    if keepCost <= cost {
                        cost = keepCost
                        result = .keep

                        increment = {
                            fromIndex += 1
                            toIndex += 1
                        }
                    }
                }

                increment()
                answer.append(result)
            }
        }

        return answer
    }

    private func compute(fromIndex: Int, toIndex: Int) -> Int {
        if fromIndex == fromWords.count {
            return toWords.count - toIndex
        }

        if toIndex == toWords.count {
            return fromWords.count - fromIndex
        }

        if let value = cache[fromIndex][toIndex] {
            return value
        }

        var cost = 1 + min(
            compute(fromIndex: fromIndex + 1, toIndex: toIndex),
            compute(fromIndex: fromIndex, toIndex: toIndex + 1)
        )

        if fromWords[fromIndex] == toWords[toIndex] {
            cost = min(cost,
                compute(fromIndex: fromIndex + 1, toIndex: toIndex + 1)
            )
        }

        cache[fromIndex][toIndex] = cost
        return cost
    }
}
