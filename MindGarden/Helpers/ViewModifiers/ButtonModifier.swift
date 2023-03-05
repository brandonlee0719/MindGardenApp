//
//  ButtonStyle.swift
//  Lottery.com
//
//

import SwiftUI

struct NeumorphicPress: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .drawingGroup()
                .scaleEffect(configuration.isPressed ? 0.98: 1)
                .animation(.easeOut(duration: 0.1))
                .shadow(color:  colorScheme == .light ? Clr.shadow.opacity(0.3) :  Clr.shadow.opacity(0.3), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Color.white.opacity(0.95), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
        } else {
            configuration.label
                .drawingGroup()
                .scaleEffect(configuration.isPressed ? 0.98: 1)
                .animation(.easeOut(duration: 0.1))
                .shadow(color:  colorScheme == .light ? Clr.shadow.opacity(0.3) : Clr.shadow.opacity(0.3), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Color.white.opacity(0.95), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
        }

    }
}

struct BonusPress: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.98: 1)
                .animation(.easeOut(duration: 0.1))
                .shadow(color:  colorScheme == .light ? Clr.shadow.opacity(0.3) : Clr.shadow.opacity(0.3), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) :Color.white.opacity(0.95), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
        } else {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.98: 1)
                .animation(.easeOut(duration: 0.1))
                .shadow(color:  colorScheme == .light ? Clr.shadow.opacity(0.3) : Clr.shadow.opacity(0.3), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Color.white.opacity(0.95), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
        }

    }
}

struct NeoPress: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.98: 1)
                .shadow(color:  colorScheme == .light ? Clr.shadow.opacity(0.3) : Clr.shadow.opacity(0.3), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Color.white.opacity(0.95), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
        } else {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.98: 1)
                .shadow(color:  colorScheme == .light ? Clr.shadow.opacity(0.3) : Clr.shadow.opacity(0.3), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Color.white.opacity(0.95), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
        }

    }
}

struct ScalePress: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.96 : 1)
                .animation(.easeOut(duration: 0.1))
                .shadow(color: .black.opacity(0.25) , radius: configuration.isPressed ? 1 : 6 , x: configuration.isPressed ? 1 : 3 , y: configuration.isPressed ? 1 : 3)
//                .shadow(color: Color.white.opacity(0.95), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
        } else {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.98: 1)
                .animation(.easeOut(duration: 0.1))
        }

    }
}
