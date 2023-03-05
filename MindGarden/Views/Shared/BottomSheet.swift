//
//  BottomSheet.swift
//  MindGarden
//
//  Created by Dante Kim on 2/23/22.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @Binding var isOpen: Bool
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        HStack {
            Text("Done").padding().foregroundColor(Clr.darkWhite)
                .opacity(0)
            Spacer()
            RoundedRectangle(cornerRadius: Constants.radius)
                .fill(Color.secondary)
                .frame(
                    width: Constants.indicatorWidth,
                    height: Constants.indicatorHeight
                )
            Spacer()
            Text("Done")
                .font(Font.fredoka(.bold, size: 18))
                .padding(.horizontal)
                .opacity(0)
        }
    }

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    let trigger: () -> Void

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat, trigger: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * minHeight
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        self.trigger = trigger
        
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                self.indicator.padding([.horizontal, .top])
                self.content
//                    .offset(y: -20)
            }.offset(y: -20)
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(32)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else { return }
                    self.isOpen = value.translation.height < 0
                    self.trigger()
                }
            )
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(isOpen: .constant(true), maxHeight: 100, minHeight: 0.2, trigger: {
            print("bingo")
        }) {
            VStack {
                Text("preview")
            }
        }
    }
}
