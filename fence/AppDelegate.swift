import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
  var window: NSWindow!
  var colorView: DraggableView!
  var statusItem: NSStatusItem!
  private var originalFrame: NSRect?  // 保存最小化前的位置

  func applicationDidFinishLaunching(_ notification: Notification) {
    setupStatusBar()
    let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600)

    let windowWidth = screenFrame.width * 0.7  // 宽度占屏幕70%
    let windowHeight = screenFrame.height / 16  // 高度占屏幕1/3
    let windowX = (screenFrame.width - windowWidth) / 2  // 居中
    let windowY = (screenFrame.height - windowHeight) / 2

    // 创建无边框窗口
    window = NSWindow(
      contentRect: NSRect(x: windowX, y: windowY, width: windowWidth, height: windowHeight),
      styleMask: [.borderless],
      backing: .buffered,
      defer: false
    )
    window.isOpaque = false
    window.backgroundColor = .clear
    window.level = .floating
    window.makeKeyAndOrderFront(nil)
    window.acceptsMouseMovedEvents = true
    window.collectionBehavior = [
      .canJoinAllSpaces,  // 所有 Space 都显示
      .fullScreenAuxiliary,  // 全屏时作为“辅助窗口”
    ]

    // 添加可拖动色块
    colorView = DraggableView(frame: window.contentView!.bounds)
    colorView.wantsLayer = true
    colorView.layer?.backgroundColor = NSColor.black.cgColor
    window.contentView?.addSubview(colorView)

    // 窗口大小变化时更新色块
    NotificationCenter.default.addObserver(
      self, selector: #selector(windowDidResize), name: NSWindow.didResizeNotification,
      object: window)

    // 监听 Command + P / Command + M
    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
      guard event.modifierFlags.contains(.command) else { return event }
      switch event.charactersIgnoringModifiers {
      case "p":
        self.openColorPanel()
      case ",":
        self.openColorPanel()
      case "m":
        self.customMinimize()
      case "h":
        self.customMinimize()
      case "q":
        NSApp.terminate(nil)
      default:
        break
      }
      return nil
    }
  }

  func setupStatusBar() {
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    if let button = statusItem.button {
      button.image = NSImage(
        systemSymbolName: "circle.fill",
        accessibilityDescription: "Floating Tool"
      )
      button.action = #selector(statusBarClicked)
      button.target = self
    }
  }

@objc func statusBarClicked() {
    if window.isVisible {
        window.orderOut(nil)
    } else {
        window.makeKeyAndOrderFront(nil)
    }
}

  @objc func windowDidResize() {
    colorView.frame = window.contentView!.bounds
  }

  func openColorPanel() {
    let panel = NSColorPanel.shared
    panel.setTarget(self)
    panel.setAction(#selector(colorChanged(_:)))
    panel.makeKeyAndOrderFront(nil)
  }

  @objc func colorChanged(_ sender: NSColorPanel) {
    colorView.layer?.backgroundColor = sender.color.cgColor
  }

  // MARK: - 自定义最小化
  func customMinimize() {
    guard let window = self.window else { return }
    if originalFrame == nil {
      // 保存最小化前位置
      originalFrame = window.frame

      // 缩到屏幕顶部
      let screenFrame = NSScreen.main?.frame ?? NSRect.zero
      let miniHeight: CGFloat = 1  // 高度最小值，可以自己调整
      let miniFrame = NSRect(
        x: window.frame.origin.x,
        y: screenFrame.height - miniHeight,  // 顶部
        width: window.frame.width,
        height: miniHeight
      )
      window.setFrame(miniFrame, display: true, animate: true)
    } else {
      // 还原窗口
      window.setFrame(originalFrame!, display: true, animate: true)
      originalFrame = nil
    }
  }

}
