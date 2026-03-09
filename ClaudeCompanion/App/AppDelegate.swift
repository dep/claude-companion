import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: CompanionPanel?
    private var menuBarManager: MenuBarManager?
    let stateManager = CompanionStateManager()
    private var escMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        panel = CompanionPanel(stateManager: stateManager)
        panel?.orderFront(nil)

        menuBarManager = MenuBarManager(panel: panel!)

        stateManager.startMonitoring()
        registerEscapeKeyMonitor()

        // Register as login item on first launch
        if !LoginItemManager.shared.isEnabled {
            LoginItemManager.shared.enable()
        }
    }

    private func registerEscapeKeyMonitor() {
        escMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard event.keyCode == 53 else { return } // 53 = Escape
            self?.stateManager.forceIdle()
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
