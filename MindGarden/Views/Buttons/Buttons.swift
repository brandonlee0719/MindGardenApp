//
//  Buttons.swift
//  MindGarden
//
//  Created by Vishal Davara on 05/04/22.
//

import SwiftUI

struct ExitButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .renderingMode(.template)
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundColor(Clr.black1)
            
        }.padding(20)
    }
}

struct ExitButton_Previews: PreviewProvider {
    static var previews: some View {
        ExitButton(action: {
            // tap event
        })
    }
}

enum buttonType {
    case lightYellow,darkGreen,simpleWhite
    
    var textColor : Color {
        switch self {
        case .lightYellow:
            return Clr.superBlack
        case .darkGreen:
            return Clr.superWhite
        case .simpleWhite:
            return Clr.superWhite
        }
    }
    
    var backgroundColor : Color {
        switch self {
        case .lightYellow:
            return Clr.yellow
        case .darkGreen:
            return Clr.darkgreen
        case .simpleWhite:
            return Clr.darkWhite
        }
    }
}

struct LightButton: View {
    @State var type : buttonType = .lightYellow
    @Binding var title : String
    @State var showNextArrow : Bool = false
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Button {
                action()
            } label: {
                HStack {
                    Text(title)
                        .foregroundColor(type.textColor)
                        .font(Font.fredoka(.bold, size: 22))
                        .padding()
                    if showNextArrow {
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color.black)
                            .font(.system(size: 22, weight: .bold))
                    }
                }
                .padding()
                .background(type.backgroundColor)
            }
            .frame(height: 58, alignment: .center)
            .buttonStyle(BonusPress())
            .cornerRadius(28)
        }
    }
}

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Clr.darkWhite)
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .background(Circle().foregroundColor(Clr.black2).padding(1))
        }.buttonStyle(NeoPress())
    }
}

struct LightButton_Previews: PreviewProvider {
    static var previews: some View {
        LightButton(title: .constant(""), action: {
            // tap event
        })
    }
}
