//
//  PlusButtonPopup.swift
//  sample
//
//  Created by Vishal Davara on 21/02/22.
//

import SwiftUI
struct PlusButtonPopup: View {
    @Binding var showPopup: Bool
    @Binding var scale : CGFloat
    @Binding var selectedOption : PlusMenuType
    @Binding var isOnboarding: Bool
    
    private let buttonRadius : CGFloat = 12.0
    private let popupRadius : CGFloat = 32.0
            
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing:0) {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.topLeading)
                    VStack(spacing:-10) {
                        ZStack {
                        PlusButtonShape(cornerRadius: popupRadius)
                            .fill(Clr.darkWhite)
                            .plusPopupStyle(size: geometry.size, scale: scale)
                            
                            PlusMenuView(showPopup:$showPopup, selectedOption: $selectedOption, isOnboarding: $isOnboarding).cornerRadius(popupRadius)
                            .plusPopupStyle(size: geometry.size, scale: scale)
                        }.zIndex(1)
                        Button {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                DispatchQueue.main.async {
                                    withAnimation(.spring()) {
                                        DispatchQueue.main.async {
                                            showPopup.toggle()
                                        }
                                    }
                                }
                            
                        } label: {
                            PlusButtonShape(cornerRadius: buttonRadius)
                                .fill(Clr.darkWhite)
                                .shadow(color:.black.opacity(0.25), radius: 4, x: 4, y: 4)
                                .plusButtonStyle(scale: scale)
                                .overlay(RoundedRectangle(cornerRadius: buttonRadius).stroke(.black, lineWidth: 1.5))
                        }.buttonStyle(ScalePress())
                    }
                    Spacer()
                        .frame(height:32)
                }
            }
            .offset(y: -24)
            .ignoresSafeArea()
            .onChange(of: showPopup) { value in
                withAnimation(.easeInOut(duration: 0.1)) {
                    DispatchQueue.main.async {
                        withAnimation(.spring()) {
                            DispatchQueue.main.async {
                                scale = scale < 1.0 ? 1.0 : 0.01
                            }
                        }
                    }
                }
            }
            
        }
    }
}
