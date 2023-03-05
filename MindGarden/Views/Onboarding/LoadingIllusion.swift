//
//  LoadingIllusion.swift
//  MindGarden
//
//  Created by Dante Kim on 6/24/22.
//

import SwiftUI

struct LoadingIllusion: View {
    @State private var showCircleProgress = true
    
    @State var meditateTimer: Timer?
    @State var time = 1.5
    @State var index = -1
    @State var topics = [ "✅ Analyzing your answers",
                          "✅ Creating custom journal questions",
                         "✅ Creating custom meditation plan",
                         "✅ Encrypting and securing your data"]
    
    var body: some View {
        CircleLoadingView(isShowing: $showCircleProgress) {
            ZStack(alignment:.bottom) {
                AnimatedBackground(colors:[Clr.yellow, Clr.yellow, Clr.darkWhite]).edgesIgnoringSafeArea(.all).blur(radius: 50)
                HStack {
                    VStack(alignment:.leading, spacing: 15) {
                        Text("🛠 Preparing Your Personal Plan")
                            .font(Font.fredoka(.bold, size: 32))
                            .foregroundColor(Clr.brightGreen)
                        if index >= 0 {
                            ForEach(0...index, id: \.self) { idx in
                                Text(topics[idx])
                                    .font(Font.fredoka(.medium, size: 20))
                                    .foregroundColor(Clr.black2)
                            }
                        }
                        Spacer()
                            .frame(height:100)
                    }
                    Spacer()
                }.frame(width: UIScreen.screenWidth - 50, alignment: .center)
                .offset(y: 50)
                .padding(50)
            }
        }.onAppear() {
            Analytics.shared.log(event: .onboarding_loading_illusion)
            meditateTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { timer in
                withAnimation(.easeOut) {
                    index += 1
                    if index == topics.count-1 {
                        meditateTimer?.invalidate()
                    }
                }
            }
        }.onDisappear() {
            meditateTimer?.invalidate()
        }
    }
}

struct LoadingIllusion_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIllusion()
    }
}
