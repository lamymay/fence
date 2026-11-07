import AppKit
import SwiftUI

struct ContentView: View {
  @State private var blockColor: Color = .blue

  var body: some View {
    Rectangle()
      .fill(blockColor)
      .frame(width: 300, height: 150)
      .onReceive(NotificationCenter.default.publisher(for: .colorChanged)) { notification in
        if let nsColor = notification.object as? NSColor {
          blockColor = Color(nsColor)
        }
      }
  }
}

#Preview {
  ContentView()
    .frame(width: 400, height: 300)
}
