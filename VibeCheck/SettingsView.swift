import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        TabView {
            SettingsTab()
                .environmentObject(store)
                .tabItem { Label("General", systemImage: "gearshape") }
                .padding(24)
                .frame(width: 400)
        }
        .frame(width: 400, height: 300)
    }
}
