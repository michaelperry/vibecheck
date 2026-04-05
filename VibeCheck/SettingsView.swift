import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        Form {
            Section("GitHub") {
                SecureField("Personal Access Token", text: $store.githubToken)
                if !store.githubUsername.isEmpty {
                    LabeledContent("Username", value: store.githubUsername)
                }
                if let error = store.githubError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            Section("Claude API") {
                SecureField("API Key", text: $store.claudeApiKey)
                if let error = store.claudeError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            Section("Rankings") {
                Toggle("Participate in anonymous rankings", isOn: $store.rankingsEnabled)
                Text("Only your composite VibeScore (a single number) is shared anonymously. No activity details, usernames, or API keys are ever transmitted.")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if store.rankingsEnabled {
                    HStack {
                        Circle()
                            .fill(store.iCloudAvailable ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(store.iCloudAvailable ? "iCloud connected" : "iCloud not available")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section {
                Button("Refresh Now") {
                    Task { await store.refreshAll() }
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 380)
    }
}
