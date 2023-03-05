//
//  ContentView.swift
//
//
//  Created by Vishal Davara on 28/02/22.
//

import SwiftUI
import StoreKit
import Firebase
import Amplitude

struct StreakScene: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    var title : String {
        return "\(bonusModel.streakNumber) Day Streak"
    }
    @Binding  var showStreak: Bool
    @State private var img = UIImage()
    @State private var isSharePresented: Bool = false
    @State private var showButtons = true
    @State private var triggerRating = false
    @State private var showNextSteps = false
    
    @State var replay: Bool = false
    
    var subTitle : String {
        switch bonusModel.streakNumber {
        case 1:  return "👣 A journey of a thousand miles begins with a single step - Lao Tzu"
        case 2:  return "Great Work! Let's make it \(bonusModel.streakNumber+1) in a row \ntomorrow!"
        case 3: return "3 is a magical 🦄 number, and you're on fire!"
        case 4: return "👀 Wow only 22% of our users make it this far"
        case 7: return "🎉 1 Full Week! You're killing it"
        case 10: return "Double digits!!! Only 10% of our users make it this far"
        case 14: return "🎉 2 Full Weeks!! You're a star"
        case 21: return "🎉 3 Full Weeks!! You've offially made it a habit"
        case 30: return "👏 Everyone here on the MindGarden team applauds you"
        case 50: return "🥑 We're half way to a 100!"
        case 60: return "2 Full MONTHS! You're in the 1% of MindGarden meditators"
        default: return "Great Work! Let's make it \(bonusModel.streakNumber+1) in a row \ntomorrow!"
        }
    }
    @State var timeRemaining = 2
    @State private var timer : Timer?
    
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                ZStack {
                    LottieAnimationView(filename: "flame 1", loopMode: .playOnce, isPlaying: .constant(true))
                        .frame(width: 500, height: 500, alignment: .center)
                        .opacity(timeRemaining <= 0 ? 0 : 1)
                    LottieAnimationView(filename: "flame 2", loopMode: .loop, isPlaying: .constant(true))
                        .frame(width: 500, height: 500, alignment: .center)
                        .opacity(timeRemaining <= 0 ? 1 : 0)
                }.offset(y: 75)
                Spacer()
                Text(title)
                    .streakTitleStyle()
                    .offset(y: 25)
                Text(subTitle)
                    .streakBodyStyle()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 150)
                DaysProgressBar()
                Spacer()
                if showButtons {
//                    Button {
//                        showButtons = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            img = takeStreakSceneScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
//                            isSharePresented = true
//                        }
//                    } label: {
//                        Capsule()
//                            .fill(Clr.gardenRed)
//                            .frame(width: UIScreen.main.bounds.width * 0.85 , height: 58)
//                            .overlay(
//                                Text("Share")
//                                    .font(Font.fredoka(.bold, size: 24))
//                                    .foregroundColor(.white)
//                            )
//                    }
//                    .buttonStyle(NeumorphicPress())
//                    .shadow(color: Clr.shadow.opacity(0.3), radius: 5, x: 5, y: 5)
//                    .padding(.top, 50)
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        if !SceneDelegate.profileModel.isLoggedIn && gardenModel.numMeds + gardenModel.numBreaths > 1  {
                            fromPage = "garden"
                            viewRouter.currentPage = .authentication
                        } else {
                            dismiss()
                        }
                    } label: {
                        Capsule()
                            .fill(Clr.gardenRed)
                            .frame(width: UIScreen.main.bounds.width * 0.85 , height: 58)
                            .overlay(
                                Text("Continue")
                                    .font(Font.fredoka(.bold, size: 24))
                                    .foregroundColor(.white)
                            ).addBorder(.black, width: 1.5, cornerRadius: 26)
                    }.buttonStyle(NeumorphicPress())
                    .shadow(color: Clr.shadow.opacity(0.3), radius: 5, x: 5, y: 5)
                    .padding(.top, 40)
                }
            }
            .offset(y: -145)
            if replay {
                BubbleEffectView(replay: $replay)
            }
        }

        .onChange(of: isSharePresented) { value in
            showButtons = !value
        }
        .sheet(isPresented: $isSharePresented) {
            ShareView(img:img)
        }
        .onAppearAnalytics(event: .screen_load_streak)
        .onAppear {
            if [3,7,10,14,21, 30].contains(bonusModel.streakNumber) {
                replay = true
            }
            Amplitude.instance().logEvent("streak_logged", withEventProperties: ["number": bonusModel.streakNumber])
            MGAudio.sharedInstance.stopSound()
            MGAudio.sharedInstance.playSounds(soundFileNames: ["fire_ignite.mp3","fire.mp3"])
            self.animate()
        }
        .onDisappear {
            MGAudio.sharedInstance.stopSound()
            timer?.invalidate()
        }
//        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { theValue in
//            print("-----> The Value is \(theValue)") // <--- this will be executed
//            if timeRemaining > 0 {
//                timeRemaining -= 1
//            }
//        }

        .background(Clr.darkWhite)

    }
    
    private func dismiss() {
        withAnimation {
//            viewRouter.previousPage = .garden
//            viewRouter.currentPage = .pricing
            let launchNum = UserDefaults.standard.integer(forKey: "dailyLaunchNumber")
            if launchNum % 3 == 0 && launchNum != 1 {
                fromPage = "streak"
                viewRouter.previousPage = .garden
                if !UserDefaults.standard.bool(forKey: "isPro") {
                    viewRouter.currentPage = .pricing
                } else {
                    viewRouter.currentPage = .garden
                }
            } else {
                    viewRouter.previousPage = .garden
                    viewRouter.currentPage = .garden
            }
        }
    }
    
    private func animate() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct StreakScene_Previews: PreviewProvider {
    static var previews: some View {
        StreakScene(showStreak: .constant(true))
            .environmentObject(BonusViewModel(userModel: UserViewModel(), gardenModel: GardenViewModel()))
    }
}

struct ShareView: View {
    @State var img: UIImage?
    var body: some View {
        if let shareImg = img {
            ActivityViewController(activityItems: [shareImg])
        }
    }
}

extension View {
    func takeStreakSceneScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self
                                            .environmentObject(SceneDelegate.userModel)
                                            .environmentObject(SceneDelegate.bonusModel)
                                            .environmentObject(SceneDelegate.gardenModel)
        )
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}


struct BubbleEffectView: View {
    @StateObject var viewModel: BubbleEffectViewModel = BubbleEffectViewModel()
    @Binding var replay: Bool
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                //Show bubble views for each bubble
                ForEach(viewModel.bubbles){bubble in
                    BubbleView(bubble: bubble)
                }
            }.onChange(of: replay, perform: { _ in
                viewModel.addBubbles(frameSize: geo.size)
            })
            
            .onAppear(){
                //Set the initial position from frame size
                viewModel.viewBottom = geo.size.height
                viewModel.addBubbles(frameSize: geo.size)
            }
        }
    }
}
class BubbleEffectViewModel: ObservableObject{
    @Published var viewBottom: CGFloat = CGFloat.zero
    @Published var bubbles: [BubbleViewModel] = []
    private var timer: Timer?
    private var timerCount: Int = 0
    @Published var bubbleCount: Int = 50
    
    func addBubbles(frameSize: CGSize){
        let lifetime: TimeInterval = 2
        //Start timer
        timerCount = 0
        if timer != nil{
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (timer) in
            let bubble = BubbleViewModel(height: 50, width: 50, x: frameSize.width/2, y: self?.viewBottom ?? 0.0, color: .white, lifetime: lifetime)
            //Add to array
            self?.bubbles.append(bubble)
            //Get rid if the bubble at the end of its lifetime
            Timer.scheduledTimer(withTimeInterval: bubble.lifetime, repeats: false, block: {  _ in
                self?.bubbles.removeAll(where: {
                    $0.id == bubble.id
                })
            })
            if self?.timerCount ?? 0 >= self?.bubbleCount ?? 0 {
                //Stop when the bubbles will get cut off by screen
                timer.invalidate()
                self?.timer = nil
            }else{
                self?.timerCount += 1
            }
        }
    }
}
struct BubbleView: View {
    //If you want to change the bubble's variables you need to observe it
    @ObservedObject var bubble: BubbleViewModel
    @State var opacity: Double = 0
    var body: some View {
        Text("🔥")
            .frame(width: 50, height: 50)
            .position(x: CGFloat.random(in:40...UIScreen.screenWidth), y: bubble.y)
            .onAppear {
                
                withAnimation(.linear(duration: bubble.lifetime)){
                    //Go up
                    self.bubble.y = -bubble.height
                    //Go sideways
                    self.bubble.x += bubble.xFinalValue()
                    //Change size
                    let width = bubble.yFinalValue()
                    self.bubble.width = width
                    self.bubble.height = width
                }
                //Change the opacity faded to full to faded
                //It is separate because it is half the duration
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.linear(duration: bubble.lifetime/2).repeatForever()) {
                        self.opacity = 1
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(Animation.linear(duration: bubble.lifetime/4).repeatForever()) {
                        //Go sideways
                        //bubble.x += bubble.xFinalValue()
                    }
                }
            }
    }
}
class BubbleViewModel: Identifiable, ObservableObject{
    let id: UUID = UUID()
    @Published var x: CGFloat
    @Published var y: CGFloat
    @Published var color: Color
    @Published var width: CGFloat
    @Published var height: CGFloat
    @Published var lifetime: TimeInterval = 0
    init(height: CGFloat, width: CGFloat, x: CGFloat, y: CGFloat, color: Color, lifetime: TimeInterval){
        self.height = height
        self.width = width
        self.color = color
        self.x = x
        self.y = y
        self.lifetime = lifetime
    }
    func xFinalValue() -> CGFloat {
        return CGFloat.random(in:-width*CGFloat(lifetime*2.5)...width*CGFloat(lifetime*2.5))
    }
    func yFinalValue() -> CGFloat {
        return CGFloat.random(in:0...width*CGFloat(lifetime*2.5))
    }
    
}
