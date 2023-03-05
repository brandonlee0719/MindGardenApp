//
//  HomeSquare.swift
//  MindGarden
//
//  Created by Dante Kim on 6/13/21.
//

import SwiftUI

//FONTs Used
// Title: 16, semibold
// subscript: 12, regular

struct HomeSquare: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isSmaller = false
    @State private var isBreath = false
    @State private var isLocked = false
    @State private var breathWork = Breathwork.breathworks[0]
    let width, height: CGFloat
    let meditation: Meditation
    let breathwork: Breathwork?
   
    var body: some View {
        ZStack() {
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .border(Clr.darkWhite)
                    .cornerRadius(16)
                    .frame(width: width * 0.42, height: height * (K.hasNotch() ? 0.225 : 0.25), alignment: .center)
                    .addBorder(.black, width: 1.5, cornerRadius: 16)
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: -2) {
                                Spacer()
                                Text(isBreath ? breathWork.title : meditation.title)
                                    .frame(width: width * 0.225, alignment: .leading)
                                    .font(Font.fredoka(.semiBold, size: isBreath ? 18 : 16))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Clr.black2)
                                    .minimumScaleFactor(0.05)
                                    .lineLimit(3)
                                HStack(spacing: 4) {
                                    
                                    Image(systemName: isBreath ? "wind" : "speaker.wave.2.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 10)
                                    Text(isBreath ? "Breathwork" : "Meditation")
                                        .font(.caption)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                }
                                .padding(.top, 10)
                                .foregroundColor(Clr.lightTextGray)
                                HStack(spacing: 4) {
                                    Image(systemName: isBreath ? breathWork.color.image : "timer")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 10)
                                    Text(isBreath ? breathWork.color.name.capitalized : Int(meditation.duration) == 0 ? "Course" : (Int(meditation.duration/60) == 0 ? "1/2" : "\(Int(meditation.duration/60))") + " mins")
                                        .padding(.leading, 2)
                                        .font(.caption)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                }
                                .padding(.top, 5)
                                .foregroundColor(Clr.lightTextGray)
                                HStack(spacing: 4) {
                                    Image(systemName: isBreath ? "eye" : "person.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 10)
                                    Text(isBreath ? "Visual" : "\(meditation.instructor)")
                                        .padding(.leading, 2)
                                        .font(.caption)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                }
                                .padding(.top, 5)
                                .foregroundColor(Clr.lightTextGray)
                                Spacer()
                            }.padding(.leading, isSmaller ? 15 : 20)
                                .frame(width: width * 0.25, height: height * (K.hasNotch() ? 0.18 : 0.2), alignment: .top)
                            Group {
                                if isBreath {
                                    breathWork.img
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: width * (isSmaller ? 0.14 : 0.15), height: height * 0.14, alignment: .center)
                                } else {
                                    if meditation.imgURL != "" {
                                        UrlImageView(urlString: meditation.imgURL)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: width * (isSmaller ? 0.14 : 0.17), height: height * 0.14, alignment: .center)
                                    } else {
                                        meditation.img
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: width * (isSmaller ? 0.14 : 0.17), height: height * 0.14, alignment: .center)
                                    }
                                }
                            } .padding(.leading, -16)
                            .padding(.top, isSmaller ? 30 : 20)
                    
                        }.offset(x: -4)
                if meditation.isNew {
                    Capsule()
                        .fill(Clr.redGradientBottom)
                        .frame(width: 45, height: 20)
                        .overlay(
                            Text("New")
                                .font(Font.fredoka(.semiBold, size: 12))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                        )
                        .position(x: width * (viewRouter.currentPage == .learn || searchScreen ? 0.385 : 0.34), y: viewRouter.currentPage == .learn || searchScreen ? 20 : 17)
                        .opacity(0.8)
                }
            }.opacity(isLocked ? 0.45 : 1)
            if isLocked {
                Img.lockIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .position(x: UIScreen.main.bounds.width * (viewRouter.currentPage == .learn || searchScreen ? 0.275 : 0.2), y: height * (K.hasNotch() ? 0.225 : 0.25) * 0.8 + (viewRouter.currentPage == .learn || searchScreen ? 0 : 10) - (isSmaller ? 10 : 0))
            }
        }.onAppear {
            if width != UIScreen.screenWidth {
                isSmaller = true
            }
            if let work = breathwork {
                isBreath = true
                breathWork = work
                isLocked = !UserDefaults.standard.bool(forKey: "isPro") && Breathwork.lockedBreaths.contains(work.id)
            } else {
                isLocked = !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(meditation.id)
            }
        }
        
    }
}

struct HomeSquare_Previews: PreviewProvider {
    static var previews: some View {
        HomeSquare(width: 425, height: 800, meditation: Meditation.allMeditations[0], breathwork: nil)
    }
}
