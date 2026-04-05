import Foundation

protocol ActivityProvider {
    var providerName: String { get }
    var todayTokens: Int { get }
    var weekTokens: Int { get }
}

struct ClaudeProvider: ActivityProvider {
    let providerName = "Claude"
    let todayTokens: Int
    let weekTokens: Int
}
