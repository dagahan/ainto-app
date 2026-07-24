import AppKit

// mac_setup fork addition: route app launches through the AeroSpace fork's
// `smart-open` command so an already-running, multi-window app gets a fresh
// window on the current workspace instead of yanking focus to an existing one.
// Falls back to a plain launch if AeroSpace isn't installed, so the launcher
// still works standalone.
enum AintoLaunch {
    private static let aerospace = "/opt/homebrew/bin/aerospace"

    static func smartOpen(appName: String, fallbackPath: String) {
        guard FileManager.default.isExecutableFile(atPath: aerospace) else {
            plainOpen(fallbackPath)
            return
        }
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: aerospace)
        proc.arguments = ["smart-open", appName]
        do {
            try proc.run()
        } catch {
            plainOpen(fallbackPath)
        }
    }

    private static func plainOpen(_ path: String) {
        NSWorkspace.shared.open(URL(fileURLWithPath: path))
    }
}
