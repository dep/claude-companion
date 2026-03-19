import AppKit

class MenuBarManager {
    private var statusItem: NSStatusItem?
    private weak var panel: CompanionPanel?

    init(panel: CompanionPanel) {
        self.panel = panel
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "Claude Companion")
        }
        buildMenu()
    }

    private func buildMenu() {
        let menu = NSMenu()

        let toggleItem = NSMenuItem(title: "Show Companion", action: #selector(togglePanel), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)

        menu.addItem(.separator())

        let loginItem = NSMenuItem(
            title: LoginItemManager.shared.isEnabled ? "Disable Launch at Login" : "Launch at Login",
            action: #selector(toggleLoginItem),
            keyEquivalent: ""
        )
        loginItem.target = self
        menu.addItem(loginItem)

        menu.addItem(.separator())

        let volumeItem = NSMenuItem(title: "Volume", action: nil, keyEquivalent: "")
        let volumeMenu = NSMenu()
        for (label, value) in [("10%", Float(0.1)), ("25%", Float(0.25)), ("50%", Float(0.5)), ("75%", Float(0.75)), ("100%", Float(1.0))] {
            let item = NSMenuItem(title: label, action: #selector(setVolume(_:)), keyEquivalent: "")
            item.target = self
            item.tag = Int(value * 100)
            item.state = SoundManager.shared.volume == value ? .on : .off
            volumeMenu.addItem(item)
        }
        volumeItem.submenu = volumeMenu
        menu.addItem(volumeItem)

        menu.addItem(.separator())

        let muteItem = NSMenuItem(
            title: SoundManager.shared.isMuted ? "Unmute" : "Mute",
            action: #selector(toggleMute),
            keyEquivalent: ""
        )
        muteItem.target = self
        menu.addItem(muteItem)

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem?.menu = menu
    }

    @objc private func toggleLoginItem() {
        LoginItemManager.shared.toggle()
        buildMenu() // Refresh menu title
    }

    @objc private func setVolume(_ sender: NSMenuItem) {
        SoundManager.shared.volume = Float(sender.tag) / 100.0
        buildMenu()
    }

    @objc private func toggleMute() {
        SoundManager.shared.isMuted.toggle()
        if SoundManager.shared.isMuted {
            SoundManager.shared.stopLoop()
        }
        buildMenu()
    }

    @objc private func togglePanel() {
        guard let panel else { return }
        if panel.isVisible {
            panel.orderOut(nil)
            statusItem?.menu?.item(at: 0)?.title = "Show Companion"
        } else {
            panel.orderFront(nil)
            statusItem?.menu?.item(at: 0)?.title = "Hide Companion"
        }
    }
}
