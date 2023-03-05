//
//  SplashView.swift
//  MindGarden
//
//  Created by Vishal Davara on 20/03/22.
//

import SwiftUI

struct SplashView: View {
    @State private var image: Image = Img.plant1
    @State private var timer : Timer?
    private let imageNames: [Image] = [Img.plant1, Img.plant2, Img.plant3, Img.plant4]
    var body: some View {
        ZStack(alignment:.center) {
            Clr.superWhite
            Img.launcher
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
            HStack(spacing:0) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                Img.loadingyour
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                    .offset(y: 15)
            }.frame(width: 280,height:100)
            .offset(y: -50)
        }.onAppear() {
            self.animate()
        }.onDisappear(){
            timer?.invalidate()
        }
    }
    
    private func animate() {
        var imageIndex: Int = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
            if imageIndex < self.imageNames.count {
                self.image = self.imageNames[imageIndex]
                imageIndex += 1
            }
            else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.animate()
                }
            }
        }
    }
}
