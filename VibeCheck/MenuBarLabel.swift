import SwiftUI

struct MenuBarLabel: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        HStack(spacing: 6) {
            Text(vibe.emoji)
                .font(.system(size: 13))

            Text(vibe.label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(vibe.color)

            Text("·")
                .foregroundColor(.secondary)
                .font(.system(size: 11))

            Text("\(store.commitsToday)c")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.primary)

            if store.currentStreak > 1 {
                Text("·")
                    .foregroundColor(.secondary)
                    .font(.system(size: 11))
                Text("\(store.currentStreak)d")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#EF9F27"))
            }
        }
        .padding(.horizontal, 4)
    }

    var vibe: VibeState {
        let commits = store.commitsToday
        let streak = store.currentStreak
        let hasTokens = (store.claudeInputTokensToday + store.claudeOutputTokensToday) > 0

        var score = commits
        if streak >= 3 { score += 2 }
        if streak >= 7 { score += 3 }
        if hasTokens { score += 2 }

        switch score {
        case 0:
            return VibeState(emoji: "👻", label: "Ghost mode", subtitle: "No activity yet — get after it", color: Color(hex: "#888780"))
        case 1...3:
            return VibeState(emoji: "🌊", label: "Coasting", subtitle: "Light day so far, warming up", color: Color(hex: "#1D9E75"))
        case 4...9:
            return VibeState(emoji: "🔒", label: "Locked in", subtitle: "Solid progress, keep the momentum", color: Color(hex: "#7F77DD"))
        default:
            return VibeState(emoji: "🔥", label: "Cooking", subtitle: "You're absolutely ripping today", color: Color(hex: "#EF9F27"))
        }
    }
}

