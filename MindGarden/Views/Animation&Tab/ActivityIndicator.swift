
import SwiftUI

public protocol LoadingAnimatable: View {
    var isAnimating: Bool { get }

    var color: Color { get }

    var size: CGSize { get set }

    var strokeLineWidth: CGFloat { get }
}

public enum ActivityIndicator {}

extension ActivityIndicator {
    public struct CircleLoadingView: LoadingAnimatable {
        
        public var isAnimating: Bool = true
        public var color: Color = .black.opacity(0.2)
        public var size: CGSize = CGSize(width: 30, height: 30)
        public var strokeLineWidth: CGFloat = 3
        
        public var trimEndFraction: CGFloat = 0.8
        
        @State private var rotation: Double = 0
        
        private let timer = Timer
            .publish(every: 0.1, on: .main, in: .common)
            .autoconnect()

        public init(isAnimating: Bool = true, color: Color = .black.opacity(0.2), size: CGSize = CGSize(width: 30, height: 30), trimEndFraction: CGFloat = 0.8, strokeLineWidth: CGFloat = 3) {
            self.isAnimating = isAnimating
            self.color = color
            self.size = size
            self.trimEndFraction = trimEndFraction
            self.strokeLineWidth = strokeLineWidth
        }
        
        public var body: some View {
            Circle()
                .trim(from: 0, to: trimEndFraction)
                .stroke(color, lineWidth: strokeLineWidth)
                .frame(width: size.width, height: size.height)
                .rotationEffect(.degrees(rotation))
                .animation(isAnimating ? .linear : .none)
                .onReceive(timer) { _ in
                    if isAnimating { rotation += 36 }
                }
        }
    }

}

