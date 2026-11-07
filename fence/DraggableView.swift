import Cocoa

class DraggableView: NSView {
  private var isResizing = false
  private var isMoving = false
  private var dragStartPoint: NSPoint = .zero
  private var initialFrame: NSRect = .zero
  private let edgeWidth: CGFloat = 10  // 可调整大小的边缘宽度

  override func mouseDown(with event: NSEvent) {
    guard let window = self.window else { return }
    dragStartPoint = event.locationInWindow
    initialFrame = window.frame

    // 判断鼠标是否在右下角区域
    let location = event.locationInWindow
    if location.x >= window.frame.width - edgeWidth && location.y <= edgeWidth {
      isResizing = true
      isMoving = false
    } else {
      isResizing = false
      isMoving = true
    }
  }

  override func mouseDragged(with event: NSEvent) {
    guard let window = self.window else { return }
    let currentPoint = event.locationInWindow
    let deltaX = currentPoint.x - dragStartPoint.x
    let deltaY = currentPoint.y - dragStartPoint.y

    if isResizing {
      var newFrame = initialFrame
      newFrame.size.width += deltaX
      newFrame.size.height -= deltaY
      newFrame.origin.y += deltaY
      window.setFrame(newFrame, display: true)
    } else if isMoving {
      var newFrame = initialFrame
      newFrame.origin.x += deltaX
      newFrame.origin.y += deltaY
      window.setFrame(newFrame, display: true)
    }
  }

  override func mouseUp(with event: NSEvent) {
    isResizing = false
    isMoving = false
  }
}
