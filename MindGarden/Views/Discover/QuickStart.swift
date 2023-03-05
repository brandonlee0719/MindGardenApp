//
//  QuickStart.swift
//  MindGarden
//
//  Created by Vishal Davara on 28/05/22.
//

import SwiftUI
import Amplitude

struct QuickStart: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isShowCategory = false
    @State private var category : QuickStartType = .minutes3
    @State private var playEntryAnimation = false
    var body: some View {
        ZStack {
            if isShowCategory {
                CategoriesScene(isSearch: false, showSearch: .constant(true), isBack: $isShowCategory, isFromQuickstart: true, selectedCategory:category)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer()
                        .frame(height:16)
                    ForEach(quickStartTabList) { item in
                        Button {
                            Amplitude.instance().logEvent("quickstart_selected_category", withEventProperties: ["category": item.name])
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.linear(duration: 0.3)) {
                                category = item.title
                                middleToSearch = item.name
                                isShowCategory = true
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .frame(height: 56.0, alignment: .center)
                                    .cornerRadius(28)
                                    .addBorder(.black, cornerRadius: 28)
                                HStack {
                                    Text(item.name)
                                        .font(Font.fredoka(.semiBold, size: 16))
                                        .foregroundColor(Clr.black2)
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 16)
                                        .padding(.leading,20)
                                    Spacer()
                                    item.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 56.0)
                                }
                                .frame(height: 56.0, alignment: .center)
                                .cornerRadius(28)
                            }.padding(.horizontal,24)
                        }.padding(6)
                        .offset(y: playEntryAnimation ? 0 : 100)
                        .opacity(playEntryAnimation ? 1 : 0)
                        .animation(.spring().delay(item.delay), value: playEntryAnimation)
                        .buttonStyle(NeoPress())
                    }
                }.padding(.bottom, 100)
                Spacer()
                    .frame(height:200)
            }
        }.onAppear {
            viewRouter.previousPage = .learn
            withAnimation {
                if middleToSearch != "" {
                    category = QuickStartMenuItem.getName(str: middleToSearch)
                    isShowCategory = true
                    playEntryAnimation = true
                } else {
                    playEntryAnimation = true
                }
            }
        }
    }
}


struct QuickStart_Previews: PreviewProvider {
    static var previews: some View {
        QuickStart()
    }
}
