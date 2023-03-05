//
//  WiggleModifier.swift
//  MindGarden
//
//  Created by Vishal Davara on 18/03/22.

import SwiftUI

extension View {
    func wiggling() -> some View {
        modifier(WiggleModifier())
    }
    func wiggling1() -> some View {
        modifier(WiggleModifier1())
    }
}

struct WiggleModifier: ViewModifier {
    @State private var buttonRotating = -10.0
    
    private let rotateAnimation = Animation
        .interpolatingSpring(stiffness: 170, damping: 5)
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(Double(buttonRotating)), anchor: .center)
            .animation(rotateAnimation.repeatForever(autoreverses: false), value: buttonRotating)
            .onAppear() {
                    DispatchQueue.main.async {
                        withAnimation(Animation.interpolatingSpring(stiffness: 170, damping: 5)) {
                            buttonRotating = 0
                        }
                    }
            }
    }
}
struct WiggleModifier1: ViewModifier {
    @State private var buttonRotating = -10.0
    
    private let rotateAnimation = Animation
        .interpolatingSpring(stiffness: 170, damping: 5)
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(Double(buttonRotating)), anchor: .center)
            .animation(rotateAnimation.repeatForever(autoreverses: false), value: buttonRotating)
            .onAppear() {
                DispatchQueue.main.async {
                    withAnimation(Animation.interpolatingSpring(stiffness: 170, damping: 5)) {
                        buttonRotating = 0
                    }
                }
            }
    }
}
