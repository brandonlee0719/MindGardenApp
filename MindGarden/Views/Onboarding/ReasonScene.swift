//
//  ExperienceScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/5/21.
//

import SwiftUI
import OneSignal
import Amplitude

var arr = [String]()
//TODO fix navigation bar items not appearing in ios 15 phones
struct ReasonScene: View {
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 5), count: 2)

    @State var selected: [ReasonItem] = []
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel

    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        VStack {
                GeometryReader { g in
                    let width = g.size.width
                    let height = g.size.height
                    ZStack {
                        Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                        VStack {
                            if !K.isSmall() && K.hasNotch()  {
                                HStack {
                                    Img.topBranch
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.screenWidth * 0.6)
                                        .padding(.leading, -20)
                                        .offset(x: -20, y: -15)
                                    Spacer()
                                }
                            } else {
                                Spacer()
                            }

                            Text("What brings you to MindGarden? (up to 3)")
                                .font(Font.fredoka(.bold, size: 28))
                                .foregroundColor(Clr.darkgreen)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 20)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .padding(.bottom, 15)
                            
                            LazyVGrid(columns: gridItemLayout) {
                                ForEach(reasonList, id: \.self) { reason in
                                    SelectionRow(width: width, height: height, reason: reason, selected: $selected)
                                }
                            }.frame(width: width * 0.9)
                    
                            Button {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    MGAudio.sharedInstance.stopSound()
                                    MGAudio.sharedInstance.playSound(soundFileName: "waterdrops.mp3")
                                }
                                Analytics.shared.log(event: .reason_tapped_continue)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                selected.forEach { item in
                                    arr.append(item.title)
                                    Analytics.shared.log(event: item.event)
                                }
                                let stringRepresentation = arr.joined(separator: " | ")
                                let identify = AMPIdentify()
                                    .set("reasons", value: NSString(utf8String: stringRepresentation))
                                Amplitude.instance().identify(identify ?? AMPIdentify())
                                
                                if selected.count > 0 {
                                    for reason in selected {
                                        if reason.title == "Sleep better" {
                                            if let oldSegs = UserDefaults.standard.array(forKey: "oldSegments") as? [String] {
                                                var segs = oldSegs
                                                segs.append("sleep 1")
                                                UserDefaults.standard.setValue(segs, forKey: "oldSegments")
                                            }
                                        }
                                    }
                                    
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        DispatchQueue.main.async {
                                            viewRouter.progressValue += 0.2
                                            viewRouter.currentPage = .name
                                        }
                                    }
                                } //TODO gray out button if not selected
                            } label: {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Continue 👉")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.fredoka(.bold, size: 20))
                                    ).addBorder(Color.black, width: 1.5, cornerRadius: 24)
                            }.frame( height: 50)
                                .padding(.top, 30)
                                .buttonStyle(NeumorphicPress())
                                .padding(.horizontal)
                        }.frame(width: width * 0.9)
                }
            }
        }.onDisappear {
            meditationModel.getFeaturedMeditation()
        }
        .onAppearAnalytics(event: .screen_load_reason)
        .transition(.move(edge: .trailing))
    }

    struct SelectionRow: View {
        var width, height: CGFloat
        @State var reason: ReasonItem
        @Binding var selected: [ReasonItem]
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            Button {
                if !UserDefaults.standard.bool(forKey: "firstTap") {
                    switch reason.title {
                    case "Sleep better", "Get more focused", "Improve your focus", "Improve your mood", "Be more present":
                        PaywallService.setUser(reasons: "📈 " + reason.title)
                    case "Managing Stress & Anxiety":
                        PaywallService.setUser(reasons: "📉 Reduce your stress & anxiety")
                    default:
                        PaywallService.setUser(reasons: "📈 Become more mindful in")
                    }
                    UserDefaults.standard.setValue(reason.title, forKey: "reason1")
                    UserDefaults.standard.setValue(true, forKey: "firstTap")
                }
                MGAudio.sharedInstance.playBubbleSound()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    if selected.contains(where: { $0.id == reason.id }) {
                        selected.removeAll(where: { $0.id == reason.id })
                        if reason.title == "Sleep better" {
                            if selected.count == 1 {
                                UserDefaults.standard.setValue("Sleep better", forKey: "reason")
                            }
                        } else if reason.title == "Just trying it out" {
                            if selected.count == 1 {
                                UserDefaults.standard.setValue("Just trying it out", forKey: "reason")
                            }
                        }
                        selected = Array(Set(selected))
                        return
                    }
                    

                    if selected.count >= 3 {
                        selected.removeFirst()
                    }
                    
                    selected = Array(Set(selected))
                    selected.append(reason)
               
                    if reason.title == "Sleep better" {
                        if selected.count == 1 {
                            UserDefaults.standard.setValue("Sleep better", forKey: "reason")
                        }
                    } else if reason.title == "Just trying it out" {
                        if selected.count == 1 {
                            UserDefaults.standard.setValue("Just trying it out", forKey: "reason")
                        }
                    } else {
                        UserDefaults.standard.setValue(reason.title, forKey: "reason")
                    }
                }
            } label: {
                ZStack {
                    Rectangle()
                        .fill(selected.contains(where: { $0.id == reason.id }) ? Clr.brightGreen : Clr.darkWhite)
                    VStack(spacing: -10) {
                        Text(reason.title)
                            .font(Font.fredoka(.semiBold, size: K.isSmall() ? 16 : 20))
                            .foregroundColor(selected.contains(where: { $0.id == reason.id }) ? .white : Clr.black2)
                            .padding(.horizontal)
                            .frame(width: width * 0.375, height: height * 0.085, alignment: .top)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        reason.img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.18, alignment: .top)
                    }.padding()
                }.frame(width: width * 0.4, height: height * (K.isSmall() ? 0.18 : 0.185))
                    .cornerRadius(20)
                    .addBorder(.black, width: 1.5, cornerRadius: 20)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

            }.buttonStyle(NeumorphicPress())
        }
    }
}

enum Reason {
    case morePresent, focus, reduceStress, tryingItOut, improveMood, sleep
   
    var title: String {
        switch self {
        case .morePresent: return "Be more present"
        case .improveMood: return "Improve your mood"
        case .focus: return "Improve your focus"
        case .reduceStress: return "Reduce stress & anxiety"
        case .sleep: return "Sleep better"
        case .tryingItOut: return "Just trying it out"
        }
    }
}

struct ReasonScene_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceScene()
    }
}
