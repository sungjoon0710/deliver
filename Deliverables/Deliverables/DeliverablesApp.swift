import SwiftUI

// Notification for triggering create deliverable sheet
extension Notification.Name {
    static let showCreateDeliverable = Notification.Name("showCreateDeliverable")
}

@main
struct DeliverablesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Empty settings window - we're a menu bar only app
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var contextMenu: NSMenu?
    private var settingsWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        setupContextMenu()
        
        // Hide dock icon - menu bar only app
        NSApp.setActivationPolicy(.accessory)
    }
    
    private func setupMenuBar() {
        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            // Use SF Symbol "checklist"
            button.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "Deliverables")
            button.target = self
            button.action = #selector(handleClick)
            
            // Enable both left and right click
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Create popover
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 320, height: 400)
        popover?.behavior = .transient
        popover?.animates = true
        popover?.contentViewController = NSHostingController(
            rootView: MenuBarView(dataStore: DataStore.shared)
        )
    }
    
    private func setupContextMenu() {
        contextMenu = NSMenu()
        
        // New Deliverable
        let newItem = NSMenuItem(title: "New Deliverable", action: #selector(newDeliverable), keyEquivalent: "n")
        newItem.target = self
        contextMenu?.addItem(newItem)
        
        // Separator
        contextMenu?.addItem(NSMenuItem.separator())
        
        // Open Deliverables
        let openItem = NSMenuItem(title: "Open Deliverables", action: #selector(openDeliverables), keyEquivalent: "o")
        openItem.target = self
        contextMenu?.addItem(openItem)
        
        // Settings
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        contextMenu?.addItem(settingsItem)
        
        // Quit
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        contextMenu?.addItem(quitItem)
    }
    
    @objc private func handleClick() {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // Right click - show context menu
            if let button = statusItem?.button, let menu = contextMenu {
                statusItem?.menu = menu
                button.performClick(nil)
                statusItem?.menu = nil // Reset so left click works again
            }
        } else {
            // Left click - toggle popover
            togglePopover()
        }
    }
    
    private func togglePopover() {
        guard let popover = popover, let button = statusItem?.button else { return }
        
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    @objc private func newDeliverable() {
        // Open popover
        if let popover = popover, let button = statusItem?.button {
            if !popover.isShown {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover.contentViewController?.view.window?.makeKey()
            }
        }
        
        // Post notification to trigger create sheet
        NotificationCenter.default.post(name: .showCreateDeliverable, object: nil)
    }
    
    @objc private func openDeliverables() {
        togglePopover()
    }
    
    @objc private func openSettings() {
        // Close popover if open
        popover?.performClose(nil)
        
        // If window already exists, just bring it to front
        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // Create settings window
        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)
        
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Settings"
        window.styleMask = [.titled, .closable]
        window.center()
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        
        // Bring app to foreground
        NSApp.activate(ignoringOtherApps: true)
        
        settingsWindow = window
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
