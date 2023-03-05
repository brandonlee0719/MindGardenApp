//
//  WidgetPrompt.swift
//  MindGarden
//
//  Created by Vishal Davara on 27/08/22.
//

import SwiftUI

struct WidgetPrompt: View {
    @ObservedObject var profileModel: ProfileViewModel
    @State private var showNext = false
    @State private var currentStep = 0
    @State private var playAnim = false
    
    var body: some View {
        GeometryReader { geomatry in
            ZStack(alignment:.bottom) {
                Color.clear.opacity(0.5)
                VStack {
                    Spacer()
                        .frame(height: 10)                    
                    if showNext {
                        NextButtonView
                    } else {
                        Text("New MindGarden Widget")
                            .font(Font.fredoka(.bold, size: K.isSmall() ? 20 : 24))
                            .foregroundColor(Clr.black2)
                            .multilineTextAlignment(.center)
                        Text("Stay motivated. Visualize your progress.")
                            .font(Font.fredoka(.medium, size: K.isSmall() ? 16 : 16))
                            .foregroundColor(Clr.black2)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(width:UIScreen.screenWidth*0.8)
                            .padding([.horizontal, .bottom])
                        Img.widgetPrompt
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: geomatry.size.height*0.45)
                            .cornerRadius(20).padding(.bottom, 12)
                        AddWidgetView
                    }
                    
                    Spacer()
                        .frame(height:20)
                }
                .frame(width: geomatry.size.width, height: geomatry.size.height*0.8)
                .background(Clr.darkWhite)
                .cornerRadius(20, corners:[.topLeft,.topRight])
            }.offset(y: playAnim ? 0 : 1000)
            .ignoresSafeArea()
                .onAppear {
                    withAnimation {
                        playAnim = true
                    }
            }
        }
    }
    
    var AddWidgetView: some View {
        VStack {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    showNext = true
                }
            } label: {
                Rectangle()
                    .fill(Clr.yellow)
                    .overlay(
                        Text("Add Widget")
                            .foregroundColor(Clr.darkgreen)
                            .font(Font.fredoka(.bold, size: 20))
                    ).addBorder(Color.black, width: 1.5, cornerRadius: 20)
            }
            .frame(width:UIScreen.screenWidth*0.8, height: 40)
            .buttonStyle(NeumorphicPress())
            .padding(.top)
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                noThanksTap()
            } label: {
                Text("No Thanks")
                    .font(Font.fredoka(.bold, size: 20))
                    .foregroundColor(Clr.darkGray)
            }
            .buttonStyle(NeumorphicPress())
            .padding()
            .offset(y: 10)
            Spacer()
                .frame(height:20)
        }
    }
    
    var NextButtonView: some View {
            VStack {
                getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .padding(20)
                    .frame(width:UIScreen.screenWidth*0.8)
                ZStack {
                    Rectangle()
                        .fill(Clr.brightGreen.opacity(0.5))
                        .frame(height:5)
                        .padding()
                    HStack {
                        ForEach(0...3, id: \.self) {index in
                            ZStack {
                                Circle()
                                    .fill(currentStep == index ? Clr.brightGreen : Clr.darkGray)
                                    .frame(width: 40, height: 40)
                                Text("\(index + 1)")
                                    .foregroundColor(.white)
                                    .font(Font.fredoka(.bold, size: 20))
                            }.scaleEffect(currentStep == index ? 1.2 : 1.0)
                                .onTapGesture {
                                    withAnimation {
                                        currentStep = index
                                    }
                                }
                            if index != 3 {
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.bottom,20)
                .frame(width:UIScreen.screenWidth*0.60)
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation {
                        if currentStep == 3 {
                            finishAllSteps()
                        } else {
                            currentStep+=1
                        }
                    }
                } label: {
                    Rectangle()
                        .fill(Clr.yellow)
                        .overlay(
                            Text(currentStep == 3 ? "Done" : "Next")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.fredoka(.bold, size: 20))
                        ).addBorder(Color.black, width: 1.5, cornerRadius: 20)
                }
                .frame(width:UIScreen.screenWidth*0.8, height: 40)
                .buttonStyle(NeumorphicPress())
          
                Spacer()
                    .frame(height:40)
            }
    }
    
    private func getImage()->Image {
        switch currentStep {
        case 0 :
            return Img.widgetStep1
        case 1 :
            return Img.widgetStep2
        case 2 :
            return Img.widgetStep3
        default :
            return Img.widgetStep4
        }
    }
    
     func noThanksTap(){
         Analytics.shared.log(event: .widget_tapped_no_thanks)
        UserDefaults.standard.setValue(true, forKey: "showWidget")
        withAnimation {
            profileModel.showWidget = false
        }
    }
     func finishAllSteps(){
         Analytics.shared.log(event: .widget_tapped_finished)
         UserDefaults.standard.setValue(true, forKey: "showWidget")
         withAnimation {
             profileModel.showWidget = false
         }
    }
}
