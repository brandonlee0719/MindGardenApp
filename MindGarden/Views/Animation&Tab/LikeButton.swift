//
//  Home.swift
//
//
//  Created by Vishal Davara on 22/06/22.
//

import SwiftUI

struct LikeButton : View {
    @State private var isTapped: Bool = false
    @State private var startAnimation: Bool
    @State private var bgAnimation: Bool
    @State private var circletAnimation: Bool
    @State var isLiked: Bool
    @State private var fireworkAnimation: Bool
    @State private var animationEnded: Bool
    @State private var tapComplete: Bool
    @State var size: Double
    @State var speed: Double = 0.5
    let action: () -> Void
    
    init(isLiked:Bool = false, size:Double = 30.0, action: @escaping () -> Void) {
        self.isLiked = isLiked
        self.size = size
        self.action = action
        startAnimation = isLiked
        bgAnimation = isLiked
        circletAnimation = isLiked
        fireworkAnimation = isLiked
        animationEnded = isLiked
        tapComplete = isLiked
        isTapped = isLiked
    }
    
    var body: some View {
        Image(systemName: isLiked ? "suit.heart.fill" : "suit.heart")
            .font(.system(size: size))
            .foregroundColor(isLiked ? .red : .red)
            .scaleEffect(isTapped ? 0 : 1)
            .background(
                ZStack{
                    Circle()
                        .stroke(lineWidth: circletAnimation ? 0.0 : 5.0)
                        .fill(Color.white.opacity(0.5))
                        .clipShape(Circle())
                        .frame(width: size, height: size)
                        .scaleEffect(bgAnimation ? 2.2 : 0)
                    
                    if isLiked {
                        ZStack {
                            let colors: [Color] = [.red, .purple, .green, .yellow, .pink]
                            ForEach(1...6, id: \.self) {index in
                                Circle()
                                    .fill(colors.randomElement() ?? Clr.darkgreen)
                                    .frame(width: 12, height: 12)
                                    .offset(x: fireworkAnimation ? 80 : 0)
                                    .rotationEffect(.init(degrees: Double(index) * 60))
                            }
                            ForEach(1...6, id: \.self) {index in
                                Circle()
                                    .fill(colors.randomElement() ?? Clr.darkgreen)
                                    .frame(width: 8, height: 8)
                                    .offset(x: fireworkAnimation ? 64 : 0)
                                    .rotationEffect(.init(degrees: Double(index) * 60))
                                    .rotationEffect(.init(degrees: -45))
                            }
                        }
                            .opacity(fireworkAnimation ? 0 : 1)
                    }
                }
            )
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isLiked.toggle()
                }
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                isTapped = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                    isTapped = false
                    }
                }
                heartPressed()
                action()
            }
            .onDisappear {
                isLiked = false
            }
    }
    
    private func heartPressed() {
        if tapComplete {
            MGAudio.sharedInstance.playBubbleSound()
            startAnimation = false
            bgAnimation = false
            circletAnimation = false
            isLiked = false
            fireworkAnimation = false
            animationEnded = false
            tapComplete = false
            return
        }
        
        if startAnimation {
            return
        }
                
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
            
            startAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speed*0.25) {
            
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                
                bgAnimation = true
            }
            
            withAnimation(.linear) {
                
                circletAnimation = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + speed*0.3) {
                MGAudio.sharedInstance.playBubbleSound()
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                    isLiked = true
                }
                
                withAnimation(.spring()) {
                    fireworkAnimation = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + speed*0.4) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        animationEnded = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + speed*0.3) {
                    tapComplete = true
                }
            }
        }
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(isLiked:true) {
        }
    }
}

struct CustomShape: Shape {
    
    var radius: CGFloat
    
    var animatableData: CGFloat {
        get{return radius}
        set{radius = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path {path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.move(to: CGPoint(x: 0, y: rect.height))
            path.move(to: CGPoint(x: rect.width, y: rect.height))
            path.move(to: CGPoint(x: rect.width, y: 0))
            
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: .zero, endAngle: .init(degrees: 360), clockwise: false)
        }
    }
}
