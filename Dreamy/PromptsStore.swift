import SwiftUI

@Observable
class PromptsStore {
    var prompts = readAllPrompts()
}

private func readAllPrompts() -> [Prompt] {
    let url = Bundle.main.url(forResource: "prompts", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode([Prompt].self, from: data)
}
