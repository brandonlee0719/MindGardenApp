//
//  CircularLoading.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/06/22.
//

import SwiftUI

struct CircleLoadingView<Content>: View where Content: View {
    struct ActivityIndicator: UIViewRepresentable {

        @Binding var isAnimating: Bool
        let style: UIActivityIndicatorView.Style

        func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
            return UIActivityIndicatorView(style: style)
        }

        func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
            isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        }
    }
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var isShowing: Bool
    @State var animationDuration = 6500
    var content: () -> Content
    
    @State private var playanim = false
    @State private var percentage = 0
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.content()
                    .disabled(self.isShowing)
                Group {
                    Circle().fill(Clr.brightGreen.opacity(0.7))
                        .frame(width:180)
                    Img.circle
                        .renderingMode(.template)
                        .resizable()
                        .frame(width:200,height:195)
                        .foregroundColor(Clr.brightGreen.opacity(0.8))
                        .rotationEffect(Angle(degrees: playanim ? 360 : 0 ))
                        .animation(.linear(duration: 6).repeatForever(autoreverses: false))
                        .offset(y:-10)
                    Img.circle
                        .renderingMode(.template)
                        .resizable()
                        .frame(width:200,height:200)
                        .foregroundColor(Clr.brightGreen.opacity(0.8))
                        .rotationEffect(Angle(degrees: playanim ? 360 : 0 ))
                        .animation(.linear(duration: 6).repeatForever(autoreverses: false))
                        .offset(y:10)
                    Img.circle
                        .resizable()
                        .renderingMode(.template)
                        .frame(width:200,height:195)
                        .foregroundColor(Clr.brightGreen.opacity(0.8))
                        .rotationEffect(Angle(degrees: playanim ? -360 : 0 ))
                        .animation(.linear(duration: 5).repeatForever(autoreverses: false))
                        .offset(x:5)
                    Img.circle
                        .renderingMode(.template)
                        .resizable()
                        .frame(width:205,height:190)
                        .foregroundColor(Clr.brightGreen.opacity(0.8))
                        .rotationEffect(Angle(degrees: playanim ? -360 : 0 ))
                        .animation(.linear(duration:4).repeatForever(autoreverses: false))
                        .offset(x:-5)
                    Text("  \(percentage)%  ")
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .font(Font.fredoka(.bold, size: 28))
                }
                .offset(y: -150)
                .opacity(self.isShowing ? 1 : 0)
            }
            .frame(width: UIScreen.screenWidth, alignment: .center)
            .onAppear() {
                withAnimation {
                    playanim = true
                }
                if isShowing { addNumberWithRollingAnimation() }
            }
            .onChange(of: isShowing) { val in
                if val {
                    percentage = 0
                    addNumberWithRollingAnimation()
                }
            }
        }
    }
    
    private func addNumberWithRollingAnimation() {
        withAnimation {
            let steps = 100
            let stepDuration = (animationDuration / steps)
            
            percentage += 100 % steps
            (0..<steps).forEach { step in
                let updateTimeInterval = DispatchTimeInterval.milliseconds(step * stepDuration)
                let deadline = DispatchTime.now() + updateTimeInterval
                
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    self.percentage += Int(100 / steps)
                    if percentage == 99 {
                        viewRouter.currentPage = .meditate
                    }
                }
            }
        }
    }

}
