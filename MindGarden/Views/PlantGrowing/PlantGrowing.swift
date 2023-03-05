//
//  PlantGrowing.swift
//  demo
//
//  Created by Vishal Davara on 04/04/22.
//

import SwiftUI

struct PlantGrowing: View {
    @EnvironmentObject var userModel: UserViewModel
    @State private var isTransit = false
    @State private var shake = 0
    @State private var calendarWiggles = false
    @State var plant : Plant?
    
    var body: some View {
        ZStack {
            VStack {
                if !isTransit {
                    plant?.packetImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth*0.7, alignment: .center)
                        .modifier(Shake1(animatableData: CGFloat(shake)))
                        .rotationEffect(.degrees(calendarWiggles ? 16 : -8), anchor: .bottom)
                        .animation(Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true))
                } else {
                    FlowerPop()
                        .transition(.scale)
                }
            }
        }
        .onAppear() {
            plant = userModel.willBuyPlant
            if plant?.title == "Real Tree" {
                isTransit = true
            }
            if let selectedPlant = plant?.id, (Plant.badgePlants.first(where: { $0.id == selectedPlant }) != nil) {
                isTransit = true
                UserDefaults.standard.setValue(plant?.title, forKey: K.defaults.selectedPlant)
                userModel.selectedPlant = plant
            } else {
                DispatchQueue.main.async {
                    MGAudio.sharedInstance.stopSound()
                    MGAudio.sharedInstance.playSound(soundFileName: "seedPacket.wav")
                    withAnimation(.linear(duration: 3.0)) {
                        calendarWiggles = true
                        shake = 10
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation() {
                        isTransit = true
                    }
                }
            }
        }
    }
}


struct PlantGrowing_Previews: PreviewProvider {
    static var previews: some View {
        PlantGrowing()
    }
}

struct Shake1: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)) ))
    }
}

