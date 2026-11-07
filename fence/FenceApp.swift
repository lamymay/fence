import SwiftUI

@main
struct FenceApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    // 不显示 WindowGroup，让 AppDelegate 控制窗口
    Settings {
      EmptyView()
    }
  }
}
