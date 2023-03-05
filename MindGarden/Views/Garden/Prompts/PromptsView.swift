//
//  PromptsView.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI
import Amplitude

struct PromptsView: View {
    
    @Binding var question:String
    @State var selectedPrompts: [Journal] = []
    @State var selectedTab: PromptsTabType = .gratitude
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter

    
    var body: some View {
        ZStack {
            Clr.darkWhite.ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height:40)
                HStack() {
                    CloseButton() {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    Spacer()
                    Text("Journal Prompts")
                        .font(Font.fredoka(.bold, size: 16))
                        .foregroundColor(Clr.black2)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.screenWidth/3, height:30)
                    Spacer()
                    CloseButton() {}.opacity(0)
                }.padding(.horizontal, 32)
                .padding(.bottom)
           
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(promptsTabList) { item in
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                        #if !targetEnvironment(simulator)
                                    Amplitude.instance().logEvent("prompts_tapped_tab", withEventProperties: ["tab": item.tabName])
                        #endif
                                    print("logging, \("prompts_tab_\(item.tabName)")")
                                    
                                    selectedTab = item.tabName
                                    selectedPrompts = Journal.prompts.filter({ prompt in
                                        prompt.category == selectedTab
                                    })
                                }
                            } label: {
                                HStack {
                                    Text(item.name)
                                        .font(Font.fredoka(.medium, size: 16))
                                        .foregroundColor(selectedTab == item.tabName ? Clr.black2 : Clr.black2 )
                                        .padding(.horizontal)

                                }
                                .padding(8)
                                .background(selectedTab == item.tabName ? Clr.yellow : Clr.darkWhite)
                                .cornerRadius(16)
                                .addBorder(.black, width: selectedTab == item.tabName ? 2 : 1, cornerRadius: 16)
                            }
                            .frame(height:32)
                            .buttonStyle(NeumorphicPress())
                        }
                    }.frame(height:45)
                }
                .frame(height:45)
                .padding(.leading, 32)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: -20) {
                        ForEach(selectedPrompts, id: \.self) { prompt in
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            if !UserDefaults.standard.bool(forKey: "isPro") && selectedTab == .bigPicture {
                                fromPage = "journal"
                                viewRouter.currentPage = .pricing
                            } else {
                            #if !targetEnvironment(simulator)
                                Amplitude.instance().logEvent("prompt_selected", withEventProperties: ["prompts": prompt.title])
                            #endif
                                print("logging, \("prompt_\(prompt.title)")")
                                question = prompt.description
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } label: {
                            ZStack {
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight * 0.115, alignment: .center)
                                        .cornerRadius(16)
                                        .addBorder(.black, width: 1.5, cornerRadius: 16)
                                        .neoShadow()
                                    HStack(spacing:0) {
                                        prompt.img
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                            .padding()
                                            .padding(.horizontal,0)
                                            .offset(x: -5)
                                        VStack(alignment:.leading) {
                                            Text(prompt.title)
                                                .font(Font.fredoka(.semiBold, size: 20))
                                                .foregroundColor(Clr.black2)
                                                .multilineTextAlignment(.leading)
                                            Text(prompt.description)
                                                .font(Font.fredoka(.medium, size: 12))
                                                .foregroundColor(Clr.black2)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(3)
                                                .frame(width: UIScreen.screenWidth * (K.isSmall() ? 0.6 : 0.55), alignment: .leading)
                                        }.frame(width: UIScreen.screenWidth * (K.isSmall() ? 0.6 : 0.55), alignment: .leading)
                                            .offset(x: -5)
                                    }
                                    .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight * 0.115, alignment: .center)
                                    .cornerRadius(16)
                                    .padding()
                                }.opacity(!UserDefaults.standard.bool(forKey: "isPro") && selectedTab == .bigPicture ? 0.5 : 1)
                                if !UserDefaults.standard.bool(forKey: "isPro") && selectedTab == .bigPicture {
                                    Img.lockIcon
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .position(x: UIScreen.screenWidth - 70, y: 40)
                                }
                            }
                        }
                        .padding(5)
                    }
                    }.padding(.horizontal, 48)
                }
            }.frame(width: UIScreen.screenWidth)
        }
        .ignoresSafeArea()
        .onAppear {
            selectedPrompts = Journal.prompts.filter({ prompt in
                prompt.category == selectedTab
            })
        }
    }
}


//MARK: - preview
struct PromptsView_Previews: PreviewProvider {
    static var previews: some View {
        PromptsView(question: .constant(""), selectedTab: .gratitude)
    }
}
