//
//  NextSteps.swift
//  MindGarden
//
//  Created by Dante Kim on 7/23/22.
//

import SwiftUI

var isNextSteps = false
struct NextSteps: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentationMode
    @State private var playAnim = false
    var body: some View {
        ZStack {
            AnimatedBackground(colors:[Clr.brightGreen, Clr.yellow, Clr.darkWhite]).edgesIgnoringSafeArea(.all).blur(radius: 50)

            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                
                VStack {
                    Text("Next Steps")
                        .font(Font.fredoka(.medium, size: 24))
                        .foregroundColor(Clr.black2)
                        .padding(.vertical, 40)
                    ReminderView(playAnim: $playAnim)
                        .padding(.bottom, playAnim ? height * -0.25 : 24)          
                    Button { } label: {
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(32)
                                .addBorder(.black, width: 1.5,  cornerRadius: 32)
                            Button {
                                
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.brightGreen)
                                        .frame(width: width * 0.3, height: 40, alignment: .center)
                                        .cornerRadius(28)
                                        .addBorder(.black, cornerRadius: 28)
                                        .overlay(
                                            VStack {
                                                Text("Sign Up")
                                                    .foregroundColor(.white)
                                                    .font(Font.fredoka(.semiBold, size: 20))
                                            }
                                        )
                                        .padding(.horizontal, 8)
                                }.onTapGesture { signUp() }
                            }.buttonStyle(ScalePress())
                             .position(x: width * 0.65, y: height * 0.15)

                            VStack {
                                HStack {
                                    Text("2. ✍️ Save your progress")
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .foregroundColor(Clr.black2)
                                    Spacer()
//                                    Image(systemName: "xmark")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .foregroundColor(Clr.black2)
//                                        .frame(width: 15)
                                }
                                Text("Create an account to save your progress & access your MindGarden anywhere")
                                    .font(Font.fredoka(.medium, size: 16))
                                    .foregroundColor(Clr.darkGray)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: width * 0.7, alignment: .leading)
                        
                            }.padding([.horizontal, .bottom], 24)
                            .offset(y: -10)
                        }.frame(height: height * 0.2, alignment: .leading)
                            .onTapGesture {  signUp() }
                        }.buttonStyle(ScalePress())
                    Spacer()

                }.padding(.horizontal, 32)
                .padding(.top)
            }
            if playAnim {
                LottieAnimationView(filename: "party", loopMode: .playOnce, isPlaying: $playAnim)
                        .scaleEffect(2)
                        .frame(height: UIScreen.screenHeight * 0.175)
                        .position(x: UIScreen.screenWidth/2, y: 75)
            }
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                Analytics.shared.log(event: .nextsteps_tapped_done)
                withAnimation {
                    presentationMode.wrappedValue.dismiss()
                    viewRouter.currentPage = .garden
                }
            } label: {
                ZStack {
                    Rectangle()
                        .fill(Clr.yellow)
                        .frame(height: 45, alignment: .center)
                        .cornerRadius(28)
                        .addBorder(.black, cornerRadius: 24)
                        .overlay(
                            VStack {
                                Text("Done")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.semiBold, size: 20))
                            }
                        )
                        .padding(.horizontal, 8)
                }
            }.buttonStyle(ScalePress())
            .padding(.horizontal, 32)
            .position(x: UIScreen.screenWidth/2, y: UIScreen.screenHeight - 100)
        }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .onAppearAnalytics(event: .screen_load_nextsteps)
        .onAppear {
            isNextSteps = true
        }
        .onDisappear {
            isNextSteps = false
        }
    }
    
    private func signUp() {
        Analytics.shared.log(event: .nextsteps_tapped_save_progress)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation {
            presentationMode.wrappedValue.dismiss()
            viewRouter.currentPage = .authentication
        }
    }
}

struct NextSteps_Previews: PreviewProvider {
    static var previews: some View {
        NextSteps()
    }
}
