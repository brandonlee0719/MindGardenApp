import SwiftUI

/// Builds a Group of `Content` on `iPhone 12 Pro Max`,
/// `iPhone 12 mini`, `iPhone SE (2nd generation)`,
/// and `iPod touch (7th generation)`.
struct PreviewDisparateDevices<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        Group {
            content
                .edgesIgnoringSafeArea(.vertical)
                .previewDevice("iPhone 12 Pro Max")
                .previewDisplayName("iPhone 12 Pro Max")
            content
                .edgesIgnoringSafeArea(.vertical)
                .previewDevice("iPhone 12 mini")
                .previewDisplayName("iPhone 12 mini")
            content
                .edgesIgnoringSafeArea(.vertical)
                .previewDevice("iPhone SE (2nd generation)")
                .previewDisplayName("iPhone SE (2nd generation)")
            content
                .edgesIgnoringSafeArea(.vertical)
                .previewDevice("iPod touch (7th generation)")
                .previewDisplayName("iPod Touch")
        }
    }
}

struct PreviewDisparateDevices_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            Text( "Hello, world!")
        }
    }
}
