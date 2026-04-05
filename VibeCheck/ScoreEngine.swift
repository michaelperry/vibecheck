import Foundation

struct VibeScore {
    let total: Double          // 0–100
    let commitPoints: Double   // 0–35
    let aiPoints: Double       // 0–35
    let streakPoints: Double   // 0–15
    let diversityPoints: Double // 0–15

    var rounded: Int { Int(total.rounded()) }
}

enum ScoreEngine {

    /// Compute a composite VibeScore from activity data.
    ///
    /// - Parameters:
    ///   - commits: number of commits in the period
    ///   - providers: array of active AI providers with token counts
    ///   - streak: current consecutive-day streak
    static func calculate(
        commits: Int,
        providers: [ActivityProvider],
        streak: Int
    ) -> VibeScore {
        // Commits: 0–35, capped at 20
        let commitPoints = min(Double(commits), 20.0) / 20.0 * 35.0

        // AI tokens: 0–35, capped at 500K total across all providers
        let totalTokens = providers.reduce(0) { $0 + $1.todayTokens }
        let aiPoints = min(Double(totalTokens), 500_000.0) / 500_000.0 * 35.0

        // Streak: 0–15, capped at 14 days
        let streakPoints = min(Double(streak), 14.0) / 14.0 * 15.0

        // Diversity: 0–15, bonus for using multiple AI tools
        let activeProviders = providers.filter { $0.todayTokens > 0 }.count
        let diversityPoints = min(Double(activeProviders), 3.0) / 3.0 * 15.0

        let total = commitPoints + aiPoints + streakPoints + diversityPoints

        return VibeScore(
            total: total,
            commitPoints: commitPoints,
            aiPoints: aiPoints,
            streakPoints: streakPoints,
            diversityPoints: diversityPoints
        )
    }

    /// Map a VibeScore to a display-friendly VibeState.
    static func vibeState(from score: VibeScore) -> VibeState {
        switch score.rounded {
        case 0:
            return VibeState(emoji: "👻", label: "Ghost mode", subtitle: "No activity yet — get after it", color: .vibeGray)
        case 1...25:
            return VibeState(emoji: "🌊", label: "Coasting", subtitle: "Light day so far, warming up", color: .vibeGreen)
        case 26...60:
            return VibeState(emoji: "🔒", label: "Locked in", subtitle: "Solid progress, keep the momentum", color: .vibePurple)
        default:
            return VibeState(emoji: "🔥", label: "Cooking", subtitle: "You're absolutely ripping today", color: .vibeOrange)
        }
    }
}
