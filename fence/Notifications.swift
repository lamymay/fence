import AppKit
import Foundation

// 自定义通知名，用于颜色面板选择回调
extension Notification.Name {
  static let colorChanged = Notification.Name("colorChanged")
}
