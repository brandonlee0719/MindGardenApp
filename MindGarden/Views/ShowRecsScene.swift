//
//  ShowRecsScene.swift
//  MindGarden
//
//  Created by Dante Kim on 1/24/22.
//

import SwiftUI

struct ShowRecsScene: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @State private var animateRow = false
    var meditations: [Int]
    @Binding var title: String
    
    
    var body: some View {
        GeometryReader { g in
            let width = g.size.width

            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    HStack {
                        CloseButton() {
                            presentationMode.wrappedValue.dismiss()
                        }.padding(.leading, 32)
                        .padding(.top)
                        Spacer()
                        Text(title)
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.bold, size: 20))
                            .padding(.top)
                        Spacer()
                        CloseButton() {
                        }.opacity(0)
                        .padding(.trailing, 32)
                    }.padding(.top)
                    .frame(width: width, alignment: .center)
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(0...max(0, meditations.count - 1), id: \.self) { index in
                            let isBreath =  Breathwork.breathworks.contains(where: { work in
                                work.id == meditations[index]
                            })
                            MeditationRow(id: meditations[index], isBreathwork: isBreath)
                                .padding(.top, 10)
                                .animation(Animation.easeInOut(duration: 1.5).delay(3))
                                .opacity(animateRow ? 1 : 0)
                                .onAppear {
                                    withAnimation {
                                        animateRow = true
                                    }
                                }.padding(.horizontal, 32)
                        }
                    }.frame(width: width, alignment: .center)
                }
            }
        }
    }
}


struct ShowRecsScene_Previews: PreviewProvider {
    static var previews: some View {
        ShowRecsScene(meditations: [0], title: .constant("favs"))
    }
}
