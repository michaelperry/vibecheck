import SwiftUI
import UserNotifications

enum RankChangeType {
    case movedUp(Int)    // passed N warriors
    case movedDown(Int)  // got passed by N warriors
    case newRank         // first time on board
}

struct RankChangeEvent: Equatable {
    let type: RankChangeType
    let newRank: Int
    let total: Int
    let timestamp: Date

    static func == (lhs: RankChangeEvent, rhs: RankChangeEvent) -> Bool {
        lhs.timestamp == rhs.timestamp
    }

    var message: String {
        switch type {
        case .movedUp(let n):
            return n == 1 ? "You just passed a warrior!" : "You passed \(n) warriors!"
        case .movedDown(let n):
            return n == 1 ? "A warrior just passed you!" : "\(n) warriors just passed you!"
        case .newRank:
            return "You're on the leaderboard!"
        }
    }

    var emoji: String {
        switch type {
        case .movedUp: return "⚔️"
        case .movedDown: return "💀"
        case .newRank: return "🏆"
        }
    }

    var color: Color {
        switch type {
        case .movedUp: return .vibeGreen
        case .movedDown: return .vibeOrange
        case .newRank: return .vibePurple
        }
    }
}

// MARK: - Animated Banner View

struct RankChangeBanner: View {
    let event: RankChangeEvent
    @State private var isVisible = false
    @State private var scale: CGFloat = 0.8

    var body: some View {
        HStack(spacing: 8) {
            Text(event.emoji)
                .font(.system(size: 18))
                .scaleEffect(scale)
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.5).delay(0.2),
                    value: scale
                )

            VStack(alignment: .leading, spacing: 1) {
                Text(event.message)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Now #\(event.newRank) of \(event.total)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(event.color.opacity(0.9))
                .shadow(color: event.color.opacity(0.4), radius: 8, y: 2)
        )
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : -20)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
                scale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    scale = 1.0
                }
            }
        }
    }
}

// MARK: - System Notification

enum RankNotifier {
    static func sendSystemNotification(event: RankChangeEvent) {
        let content = UNMutableNotificationContent()
        content.title = "\(event.emoji) VibeWars"
        content.body = "\(event.message) Now #\(event.newRank) of \(event.total)."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "rank-change-\(event.timestamp.timeIntervalSince1970)",
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}
