import SwiftUI

struct VibeState {
    let emoji: String
    let label: String
    let subtitle: String
    let color: Color
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    static let vibeGray = Color(hex: "#888780")
    static let vibeGreen = Color(hex: "#1D9E75")
    static let vibePurple = Color(hex: "#7F77DD")
    static let vibeOrange = Color(hex: "#EF9F27")
}
