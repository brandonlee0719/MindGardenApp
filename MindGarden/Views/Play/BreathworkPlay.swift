//
//  MeditationPlayAnimation.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/06/22.
//

import SwiftUI
import AVKit
import MediaPlayer
import AudioToolbox
import CoreHaptics

struct BreathworkPlay : View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var userModel: MeditationViewModel
    @State private var bgAnimation = false
    @State private var fadeAnimation = false
    @State private var title = ""

    @State private var durationCounter = 1
    @State private var sequenceCounter = 0
    @State private var noOfSequence = 0
    @State private var size = 300.0
    @State private var showPanel = true
    @State private var timerCount:TimeInterval = 0.0
    @Binding var totalTime: Int
    @State private var progress = 0.0

    
    // Background Settings
    @State private var backgroundPlayer : AVAudioPlayer?
    @State private var del = AVdelegate()
    @State private var showNatureModal = false
    @State private var selectedSound: Sound? = .noSound
    @State private var sliderData = SliderData()
    @State private var bellSlider = SliderData()
    @State private var data : Data = .init(count: 0)
    @State private var isFavorited: Bool = false

    let panelHideDelay = 2.0
    
    @State var isPaused = false
    @Binding var showPlay:Bool
    
    let breathWork: Breathwork?
    
    @State var timer: Timer?
    @State var durationTimer: Timer?
    
    @State private var scale = 0.0
    @State private var duration: TimeInterval = 0
    private let startScale = 1.0
    private let endScale = 2.0
    @State var callerTimer: Timer?
    @State private var engine: CHHapticEngine?
    @State var playVibration = false
    @State var backgroundAnimationOn = false

    private var remainingDuration: RemainingDurationProvider<Double> {
        { currentScale in
            let remainingDuration = duration * (1 - (currentScale - startScale) / (endScale - startScale))
            playAnimation(timeRemain: title == "Hold" ? Double(durationCounter) : remainingDuration)
           return remainingDuration
        }
      }
    
    private let animation: AnimationWithDurationProvider = { duration in
        .linear(duration: duration)
      }
    
    var body: some View {
        ZStack(alignment:.top) {
            if medModel.selectedBreath?.color == .sleep {
                Clr.darkMode.edgesIgnoringSafeArea(.all)
            } else if !backgroundAnimationOn {
                Clr.darkWhite
            } else {
                AnimatedBackground(colors:[Clr.yellow, breathWork?.color.secondary ?? Clr.calmsSecondary, Clr.darkWhite]).edgesIgnoringSafeArea(.all).blur(radius: 50).edgesIgnoringSafeArea(.all)
            }
            VStack {
                Spacer()
                    .frame(height: K.hasNotch() ? 50 : 25)
                HStack {
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                            if let player = player {
                                player.play()
                            }
                        }
                        
                        withAnimation(.linear) {
                            viewRouter.currentPage = viewRouter.previousPage
                        }
                        
                    } label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Clr.darkWhite)
                            .aspectRatio(contentMode: .fit)
                            .frame(height:40)
                            .background(Circle().foregroundColor(Clr.black2).padding(1))
                    }.buttonStyle(ScalePress())
                    Spacer()
                    HStack{
                        sound
                        heart
                    }
                }
                .frame(width: UIScreen.screenWidth * 0.85)
                .padding([.top, .horizontal])
                .opacity(showPanel ? 1 : 0)
                .disabled(!showPanel)
                ZStack {
                    Circle()
                        .foregroundColor(breathWork?.color.primary)
                        .addBorder(.black, width: 2, cornerRadius: size/2)
                        .frame(width:size, height: size)
                    Circle()
                        .fill(breathWork?.color.secondary.opacity(0.4) ?? Clr.calmsSecondary)
                        .frame(width:size/2)
                        .clipShape(Circle())
                        .scaleEffect(scale)
                        .pausableAnimation(binding: $scale,
                                                     targetValue: endScale,
                                                     remainingDuration: remainingDuration,
                                                     animation: animation,
                                                     paused: $isPaused)
                    
                    ZStack {
                        Circle()
                            .foregroundColor(breathWork?.color.secondary)
                            .addBorder(.black, width: 2, cornerRadius: size/2)
                            .frame(width:size/2, height: size/2)
                        VStack {
                            Spacer()
                            Text(title)
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.1)
                            Text("  \(durationCounter > 0 ? durationCounter : 1)  ")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(.white)
                                .opacity(fadeAnimation ? 0 : 1)
                            Spacer()
                        }
                    }
                }.frame(height:size)
                
                VStack {
                    VStack(spacing:0) {
                        Img.grass
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: UIScreen.screenWidth * 0.8, minHeight: 100)
                            .overlay(
                                plantView
                            ).background(
                                ZStack {
                                    if progress < 0.50 && progress >= 0.24 {
                                        userModel.selectedPlant?.one
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height:60)
                                            .animation(Animation.spring(response: 0.3, dampingFraction: 3.0))
                                            .transition(.opacity)
                                            .offset(y:-30)
                                    } else if progress > 0.5 && progress < 0.75 {
                                       userModel.selectedPlant?.two
                                           .resizable()
                                           .aspectRatio(contentMode: .fit)
                                           .frame(height:100)
                                           .animation(Animation
                                                       .spring(response: 0.3, dampingFraction: 3.0))
                                           .transition(.opacity)
                                           .offset(y:-55)
                                    } else if  progress >= 0.75 {
                                        userModel.selectedPlant?.coverImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height:160)
                                            .offset(y:-80)
                                            .animation(Animation
                                                        .spring(response: 0.3, dampingFraction: 3.0))
                                            .transition(.opacity)
                                    } else {
                                        EmptyView()
                                    }
                                }
                            )
                        ZStack {
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(Clr.darkGray)
                                    .frame(width:geometry.size.width, height:15)
                                    .cornerRadius(25,corners: [.bottomLeft, .bottomRight])
                                Rectangle()
                                    .fill(breathWork?.color.secondary ?? Clr.calmsSecondary)
                                    .frame(width:geometry.size.width*progress, height:15)
                                    .cornerRadius(25,corners: [.bottomLeft, .bottomRight])
                            }
                        }.frame(height:15, alignment: .top)
                        .offset(y: -3)
                    }
                    .padding(.top, UIScreen.screenHeight * (K.isSmall() ? 0.1 : 0.2))
                    VStack {
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                isPaused.toggle()
                                if isPaused {
                                    engine?.stop()
                                    durationTimer?.invalidate()
                                    callerTimer?.invalidate()
                                }
                            }
                        } label : {
                            ZStack {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text(isPaused ? "Play" : "Pause")
                                            .font(Font.fredoka(.medium, size: 20))
                                            .foregroundColor(Clr.black2)
                                    ).addBorder(.black, width: 1, cornerRadius: 30)
                            }
                        }
                        .frame(height:50)
                        .buttonStyle(ScalePress())
//                        Button {
//                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                            withAnimation {
//                                withAnimation {
//                                    viewRouter.currentPage  = .finished
//                                }
//                            }
//                        } label: {
//                            Text("I'm Done")
//                                .font(Font.fredoka(.medium, size: 20))
//                                .foregroundColor(Clr.black2)
//                                .underline()
//                        }.padding(.top)
                    }
                    .padding(K.isSmall() ? .bottom : .vertical)
                    .disabled(!showPanel)
                    .opacity(showPanel ? 1.0 : 0.0)
                }.padding(.horizontal,30)
            }
            if showNatureModal  {
                Color.black
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
            }
            if let backgroundPlayer = backgroundPlayer {
                NatureModal(show: $showNatureModal, sound: $selectedSound, change: self.changeSound, player: backgroundPlayer, sliderData: $sliderData, bellSlider: $bellSlider, vibrationOn: $playVibration, backgroundAnimationOn:$backgroundAnimationOn)
                    .offset(y: showNatureModal ? 0 : UIScreen.screenHeight)
                    .animation(.default)
            }
        }
        .onAppear {
            
            if let vibration = UserDefaults.standard.value(forKey: "vibrationMode") as? Bool {
                playVibration = vibration
            }
            
            if let bgAnimation = UserDefaults.standard.value(forKey: "backgroundAnimation") as? Bool {
                backgroundAnimationOn = bgAnimation
            }
            
            do {
                engine = try CHHapticEngine()
            } catch let error {
                print(error)
            }
            
            if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                if let player = player {
                    player.stop()
                }
            }
            
            if let defaultSound = UserDefaults.standard.string(forKey: "sound") {
                if defaultSound != "noSound"  {
                    selectedSound = Sound.getSound(str: defaultSound)
                    if let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3") {
                        backgroundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                        backgroundPlayer?.delegate = self.del
                        backgroundPlayer?.prepareToPlay()
                    }
                    if let vol = UserDefaults.standard.value(forKey: "backgroundVolume") as? Float {
                        backgroundPlayer?.volume = vol
                        sliderData.sliderValue = vol
                    } else {
                        backgroundPlayer?.volume = 0.3
                        sliderData.sliderValue = 0.3
                    }
                    if let backgroundPlayer = backgroundPlayer {
                        sliderData.setPlayer(player: backgroundPlayer)
                    }
                    backgroundPlayer?.numberOfLoops = -1
                    backgroundPlayer?.play()
                } else {
                    if let url = Bundle.main.path(forResource: "", ofType: "mp3") {
                        backgroundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                    }
                }
            }

            
            medModel.checkIfFavorited()
            if let plantTitle = UserDefaults.standard.string(forKey: K.defaults.selectedPlant) {
                userModel.selectedPlant = Plant.allPlants.first(where: { plant in
                    return plant.title == plantTitle
                })
            }
            
            let singleTime = breathWork?.sequence.map { $0.0 }.reduce(0, +)
            noOfSequence = Int(Double(totalTime)/Double(singleTime ?? 0))
            totalTime = noOfSequence*(singleTime ?? 0)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if !isPaused {
                    if timerCount < Double(totalTime) {
                        timerCount += 1
                        DispatchQueue.main.async {
                            withAnimation(.linear(duration: 0.95)) {
                                progress = timerCount/Double(totalTime)
                            }
                        }
                    } else {
                        timer.invalidate()
                    }
                }
            }
            DispatchQueue.main.async {
                playAnimation()
                toggleControllPanel()
            }


        }
        .onDisappear() {
            timer?.invalidate()
            durationTimer?.invalidate()
            callerTimer?.invalidate()
        }
        .onTapGesture {
            toggleControllPanel()
        }
        
    }
    private func playSound(){
            AudioServicesPlaySystemSoundWithCompletion(1011){
                playSound()
            }
        }
    
    private func playAnimation(timeRemain:Double = 0.0) {
        guard !isPaused  else { return }
        if noOfSequence > 0 {
            let time =  timeRemain>0 ? timeRemain : Double(breathWork?.sequence[sequenceCounter].0 ?? 0)
            let status = breathWork?.sequence[sequenceCounter].1 ?? "I"
            setBreath(status: status, time: Double(time), isResumed:timeRemain>0)
            callerTimer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { timer in
                checkSequence()
                playAnimation()
            }
            
            if time > 0 {
                setupCoountDown(time: time)
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                viewRouter.currentPage = .finished
            }
        }
    }
     
    private func setBreath(status:String, time:Double, isResumed:Bool) {
        switch status.lowercased() {
        case "i" :
            title = "Inhale"
            duration = Double(time)
            if !isResumed {
                scale =  startScale
                withAnimation(.linear(duration: time)) {
                    scale = 2.0
                }
            }
            if playVibration {
                do {
                    try playHapticContinuousWithParameters(time: TimeInterval(time))
                } catch let error {
                    print(error)
                }
            }
        case "h":
            title = time > 0 ? "Hold" : ""
        case "e":
            title = "Exhale"
            duration = time
            if !isResumed {
                scale = endScale
                withAnimation(.linear(duration: time)) {
                    scale = 1.0
                }
            }
        default: break
        }
    }
    
    private func playHapticContinuousWithParameters(time:TimeInterval) throws {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: time)
        
        let pattern = try CHHapticPattern(events: [event], parameters: [])
        let player = try engine?.makePlayer(with: pattern)
        
        try engine?.start()
        try player?.start(atTime: 0)
    }
    
    private func setupCoountDown(time:Double){
        guard !isPaused  else { return }
        durationTimer = nil
        if time > 0 {
            fadeAnimation = true
            withAnimation(.linear(duration: 0.5)) {
                fadeAnimation = false
                durationCounter =  Int(floor(time))
            }
            durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.isPaused {
                    timer.invalidate()
                    return
                }
                fadeAnimation = true
                withAnimation(.linear(duration: 0.5)) {
                    fadeAnimation = false
                    durationCounter -= 1
                    if title == "Hold", playVibration {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    }
                }
                if durationCounter<=1 {
                    timer.invalidate()
                }
            }
        }
    }
    
    private func checkSequence() {
        guard !isPaused  else { return }
        if sequenceCounter < (breathWork?.sequence.count ?? 0)-1 {
            sequenceCounter += 1
        } else {
            sequenceCounter = 0
            medModel.totalBreaths += 1
            noOfSequence -= 1
        }
    }
    
    func changeSound() {
        backgroundPlayer?.stop()
        if let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3") {
            backgroundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
        }
        backgroundPlayer?.delegate = self.del
        backgroundPlayer?.numberOfLoops = -1
        backgroundPlayer?.volume = sliderData.sliderValue
       self.data = .init(count: 0)
        backgroundPlayer?.prepareToPlay()
       self.backgroundPlayer?.play()
        if let backgroundPlayer = backgroundPlayer {
            self.sliderData.setPlayer(player: backgroundPlayer)
        }
   }
    
    var plantView: some View {
        ZStack {
            if progress < 0.25 {
                Img.seed
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:30)
                    .animation(Animation
                                .spring(response: 0.3, dampingFraction: 3.0))
                    .transition(.opacity)
                    .offset(y: -20)
            } else {
                EmptyView()
            }
        }
    }
    var sound: some View {
        Image(systemName: "gearshape.fill")
            .font(.system(size: 32))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                withAnimation {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showNatureModal = true
                }
            }
    }
    
    var heart: some View {
        ZStack {
            if medModel.isFavoritedLoaded {
                LikeButton(isLiked: medModel.isFavorited) {
                    likeAction()
                }
            } else {
                LikeButton(isLiked: false) {
                    likeAction()
                }
            }
        }
    }
    
    private func likeAction(){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        medModel.favorite(id: breathWork?.id ?? 0)
        isFavorited.toggle()
    }
    
    private func toggleControllPanel() {
        withAnimation {
            showPanel = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + panelHideDelay) {
            withAnimation {
                showPanel = false
            }
        }
    }
}


struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    @State var duration = 6.0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
    @State var colors:[Color]
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: duration).repeatForever())
            .onReceive(timer, perform: { _ in
                self.start = UnitPoint(x: 4, y: 0)
                self.end = UnitPoint(x: 0, y: 2)
                self.start = UnitPoint(x: -4, y: 20)
                self.start = UnitPoint(x: 4, y: 0)
            })
    }
}
