import Foundation

/// Returns the user's real home directory, bypassing the sandbox container redirect.
/// In a sandboxed app, `FileManager.default.homeDirectoryForCurrentUser` returns
/// the container path. This uses the password database to get the actual home.
enum RealHome {
    static let path: String = {
        if let pw = getpwuid(getuid()), let home = pw.pointee.pw_dir {
            return String(cString: home)
        }
        return NSHomeDirectory()
    }()

    static let url: URL = URL(fileURLWithPath: path)

    /// Resolve a path relative to the real home directory.
    static func appending(_ relativePath: String) -> URL {
        url.appendingPathComponent(relativePath)
    }
}
