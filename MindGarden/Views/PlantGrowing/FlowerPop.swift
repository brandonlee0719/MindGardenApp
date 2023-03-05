//
//  FlowerPop.swift
//  demo
//
//  Created by Vishal Davara on 04/04/22.
//

import SwiftUI

struct FlowerPop: View {
    @EnvironmentObject var userModel: UserViewModel
    @State private var scale = 0.0
    @State private var isEquipped = false
    @State private var euipeButtonTitle = "Equip?"
    @State private var img = UIImage()
    @State private var showSharing = false
    @State private var showButtons = true
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            GeometryReader { g in
                LottieAnimationView(filename: "background", loopMode: .loop, isPlaying: .constant(true))
                    .frame(width: g.size.width , height: g.size.height, alignment: .center)
                    .overlay(
                        userModel.willBuyPlant?.coverImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: g.size.width/2, height: g.size.height/3)
                            .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
                            .animation(Animation
                                        .spring(response: 0.3, dampingFraction: 3.0), value: scale)
                    )
                VStack() {
                    Spacer()
                        .frame(height: 75, alignment: .center)
                    Text(userModel.willBuyPlant?.title == "Real Tree" ? "🌍 Planet Earth \nThanks You!": "New!\n\(userModel.willBuyPlant?.title ?? "Red Tulips")")
                        .frame(width: g.size.width, alignment: .center)
                        .font(.fredoka(.bold, size: 40))
                        .foregroundColor(Clr.black1)
                        .multilineTextAlignment(.center)
                    if userModel.willBuyPlant?.title == "Real Tree" {
                        Img.treesForTheFuture
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                    }
                    Spacer()
                    if showButtons {
                        HStack {
                            Button { } label: {
                                HStack {
                                    Text("Continue")
                                        .foregroundColor(.black)
                                        .font(Font.fredoka(.bold, size: 24))
                                }.frame(width: g.size.width * 0.50, height: 60)
                                    .background(Clr.yellow)
                                    .cornerRadius(25)
                                    .onTapGesture {
                                        withAnimation {
                                            Analytics.shared.log(event: .store_animation_continue)
                                            let impact = UIImpactFeedbackGenerator(style: .light)
                                            impact.impactOccurred()
                                            userModel.triggerAnimation = false
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                            }.buttonStyle(NeumorphicPress())
                            Button {
                                showButtons = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    img = takeScreenshot(origin: g.frame(in: .global).origin, size: g.size)
                                    showSharing = true
                                }
                            } label: {
                                Img.share
                                    .padding()
                            }
                        }
                        .padding(.horizontal,50)
                        .padding(.bottom,100)
                    }
                }
            }
        }
        .onChange(of: showSharing) { value in
            showButtons = !value
        }
        .sheet(isPresented: $showSharing) {
            ShareView(img:img)
        }
        .onAppear() {
            DispatchQueue.main.async {
                MGAudio.sharedInstance.stopSound()
                MGAudio.sharedInstance.playSound(soundFileName: "plantUnlock.mp3")
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 3.0)) {
                    scale = 1.0
                }
            }
        }
    }
}

struct FlowerPop_Previews: PreviewProvider {
    static var previews: some View {
        FlowerPop()
    }
}
