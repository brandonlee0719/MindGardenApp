//
//  Play.swift
//  MindGarden
//
//  Created by Dante Kim on 6/18/21.
//

import SwiftUI
import AVKit
import UIKit
import MediaPlayer

struct Play: View {
    var progressValue: Float {
        if model.isOpenEnded {
            return 1
        } else {
            return 1 - (model.secondsRemaining/model.totalTime)
        }
    }
    @State var timerStarted: Bool = true
    @State var favorited: Bool = false
    @State var backgroundPlayer : AVAudioPlayer?
    @State var mainPlayer: AVPlayer?
    @State var data : Data = .init(count: 0)
    @State var title = ""
    @State var del = AVdelegate()
    @State var finish = false
    @State var showNatureModal = false
    @State var selectedSound: Sound? = .noSound
    @State var sliderData = SliderData()
    @State var bellSlider = SliderData()
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel

    @State var showTutorialModal = false
    @State var isTraceTimeMannual = false
    @State var timerSeconds = 0.0
    @State var isDeviceLocked = false
    @State var isSleep = false
    @State var backgroundAnimationOn = false
    private let audioSession = AVAudioSession.sharedInstance()
    
    @StateObject var envoyModel = EnvoyViewModel()
    @State private var isSharePresented = false
    @State private var giftUrl = URL(string: "https://mindgarden.io")
    @State private var showGift = false
    
    init() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    var body: some View {
            ZStack {
                if isSleep  {
                    Clr.darkMode.edgesIgnoringSafeArea(.all)
                } else if !backgroundAnimationOn {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                } else {
                    AnimatedBackground(colors:[Clr.yellow, Clr.yellow, Clr.darkWhite]).edgesIgnoringSafeArea(.all).blur(radius: 50).edgesIgnoringSafeArea(.all)
                        .animation(.default)
                }
                
                GeometryReader { g in
                    let width = g.size.width
                    let height = g.size.height
                 
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center) {
                            //Navbar
                            HStack {
                                    HStack {
                                        if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude" {
                                            backArrow
                                        }  else {
                                            EmptyView()
                                                .frame(width: 24)
                                        }
                                        heart;
                                    }
                                
                                Spacer()
                                Text(model.selectedMeditation?.title ?? "")
                                    .font(Font.fredoka(.medium, size: 12))
                                    .foregroundColor(isSleep ? Clr.brightGreen : Clr.black2)
                                    .padding(.leading, 16)
                                Spacer()
                                HStack{
                                    sound;
                                    if model.selectedMeditation?.title ?? "" != "30 Second Meditation" && !(model.selectedMeditation?.title ?? "" ).contains("Minute") {
                                        shareButton;
                                    } else {
                                        EmptyView()
                                            .frame(width: 24)
                                    }
                                }
                                    .padding(.trailing)
                            }.padding(.horizontal)
                            .padding(.top, height * 0.07)
                            HStack(alignment: .center) {
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 20.0)
                                        .foregroundColor(Clr.superLightGray)
                      
                                    Circle()
                                        .trim(from: 0.0, to: self.progressValue > 1.0 ? 1.0 : CGFloat(self.progressValue))
                                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                        .foregroundColor(Clr.brightGreen)
                                        .rotationEffect(Angle(degrees: 270.0))
                                        .animation(.linear(duration: 2), value: model.secondsRemaining)
                                    Circle()
                                        .frame(width: K.isPad() ? 480 : 230)
                                        .foregroundColor(Clr.darkWhite)
                                        .shadow(color: .black.opacity(0.35), radius: 20.0, x: 10, y: 5)
                                    if isSleep {
                                        Img.nightBackground
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 230)
                                    } else {
                                        Img.backgroundCircle
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 230)
                                    }
                           
                                    //four different plant stages
                                    if model.secondsRemaining <= model.totalTime * 0.25 || (model.secondsRemaining >= 300 && model.selectedMeditation?.duration == -1) { //secoond
                                        withAnimation {
                                            model.playImage
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: model.lastSeconds ? width/3 : width/5, height: model.lastSeconds ? height/5 : height/7)
                                                .animation(.easeOut(duration: 2.0))
                                                .transition(.opacity)
                                                .offset(y: 20)
                                        }
                                } else if model.secondsRemaining <= model.totalTime * 0.5 || (model.secondsRemaining >= 200 && model.selectedMeditation?.duration == -1) {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(Animation.spring(response: 0.3, dampingFraction: 3.0))
                                            .transition(.opacity)
                                            .frame(width: width/5, height: height/7)
                                            .offset(y: 40)
                                        
                                    } else if model.secondsRemaining <= model.totalTime * 0.75 || (model.secondsRemaining >= 100 && model.selectedMeditation?.duration == -1) {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(Animation.spring(response: 0.3, dampingFraction: 3.0))
                                            .frame(width: width/6, height: height/8)
                                            .transition(.opacity)
                                            .offset(y: 70)
                                    } else {
                                        model.playImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .animation(.easeIn(duration: 1.0))
                                            .frame(width: 30, height: 30)
                                            .offset(y: 85)
                                    }
                                }
                                .frame(width: K.isPad() ? 500 : 250)
                            }.offset(y: 25)
                            Spacer()
                            Text(model.secondsToMinutesSeconds(totalSeconds: Float(timerSeconds)))
                                .foregroundColor(isSleep ? Clr.brightGreen : Clr.black1)
                                .font(Font.fredoka(.bold, size: 60))
                                .frame(width: UIScreen.screenWidth)
                                .animation(UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" ? nil : Animation.easeIn(duration: 0.5))
                                .offset(y: 50)
                            Spacer()
                            HStack(alignment: .center, spacing: 20) {
                                if model.selectedMeditation?.belongsTo != "Open-ended Meditation" {
                                    Button {
                                       backAction()
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(isSleep ? Clr.black2 : Clr.darkWhite)
                                                .frame(width: 70)
                                                .neoShadow(darkMode: isSleep)
                                            VStack {
                                                Image(systemName: "backward.fill")
                                                    .foregroundColor(Clr.brightGreen)
                                                    .font(.title)
                                                Text("15")
                                                    .font(.caption)
                                                    .foregroundColor(Clr.darkgreen)
                                            }
                                        }
                                    }
                                }
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    changeState()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(isSleep ? Clr.black2 : Clr.darkWhite)
                                            .frame(width: 90)
                                            .neoShadow(darkMode: isSleep)
                                        Image(systemName: timerStarted ? "pause.fill" : "play.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Clr.brightGreen)
                                            .frame(width: 35)
                                    }
                                }
                                if model.selectedMeditation?.belongsTo != "Open-ended Meditation" {
                                    Button {
                                        forwardAction()
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(isSleep ? Clr.black2 : Clr.darkWhite)
                                                .frame(width: 70)
                                                .neoShadow(darkMode: isSleep)
                                            VStack {
                                                Image(systemName: "forward.fill")
                                                    .foregroundColor(Clr.brightGreen)
                                                    .font(.title)
                                                Text("15")
                                                    .font(.caption)
                                                    .foregroundColor(Clr.darkgreen)
                                            }
                                        }
                                    }
                                } else {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        model.stop()
                                        withAnimation {
                                            viewRouter.currentPage = .finished
                                        }
                                    } label: {
                                        Image(systemName: "square.fill")
                                            .foregroundColor(Clr.brightGreen)
                                            .aspectRatio(contentMode: .fit)
                                            .font(.system(size: 40))
                                    }
                                }
                            }
                            Spacer()
                            Spacer()
                        }
                        Spacer()
                    }.opacity(showNatureModal ? 0.3 : 1)
                    if showNatureModal || showTutorialModal || showGift {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showGift = false
                                    showNatureModal = false
                                }
                            }
                    }
                    NatureModal(show: $showNatureModal, sound: $selectedSound, change: self.changeSound, player: backgroundPlayer, sliderData: $sliderData, bellSlider: $bellSlider, vibrationOn: .constant(true), backgroundAnimationOn: $backgroundAnimationOn)
                        .offset(y: showNatureModal ? 0 : g.size.height)
                        .animation(.default)
                    TutorialModal(show: $showTutorialModal)
                        .offset(y: showTutorialModal ? 0 : g.size.height)
                        .animation(.default)
                    BottomSheet(
                        isOpen: $showGift,
                        maxHeight: height * (K.isSmall() ? 0.75 : 0.625),
                        minHeight: 0.1,
                        trigger: { }
                    ) {
                        VStack {
                            Img.gift
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                            Text("You have \(envoyModel.userQuota) gifts left this month")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(Clr.darkgreen)
                                .padding(.bottom, -5)
                            Text("Meditations are now sharable, no app download for them required. Give the gift of mindfulness this holiday season 🙌")
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.center)
                                .frame(height: 90)
                            Button {
                                withAnimation {
                                    shareAction()
                                    showGift.toggle()
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.darkgreen)
                                    .overlay(
                                        Text("Share this meditation")
                                            .font(Font.fredoka(.bold, size: 16))
                                             .foregroundColor(.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    )
                            }.buttonStyle(NeumorphicPress())
                             .frame(height: 45)
                             .padding(.vertical, 25)
                             .opacity(envoyModel.userQuota > 0 ? 1.0 : 0.3)
                            Text("No Thanks")
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(Color.gray)
                                .onTapGesture {
                                    withAnimation {
                                        showGift.toggle()
                                    }
                                }
                                .padding(.bottom)
                        }.frame(width: width * 0.85, alignment: .center)
                        .padding()
                    }.offset(y: height * 0.1)
                }
            }
            .onAppear {
                isSleep = model.selectedMeditation?.category == .sleep
            }
            .onChange(of: model.secondsRemaining) { value in
                guard isTraceTimeMannual else { return }

                self.timerSeconds = Double(model.isOpenEnded ? model.secondsCounted : model.secondsRemaining)
//                if model.isOpenEnded {
//                    self.progressValue  = 1.0
//                } else {
//                    self.progressValue = Double(1 - (model.secondsRemaining/model.totalTime))
//                }
            }
            .onChange(of: envoyModel.url) { url in
                if !url.isEmpty {
                    self.giftUrl = URL(string: url)
                    isSharePresented = true
                }
            }
            .sheet(isPresented: $isSharePresented) {
                ReferralView(url: $giftUrl)
            }
        .animation(.easeIn)
        .onAppearAnalytics(event: .screen_load_play)
        .onChange(of: viewRouter.currentPage) { value in
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
            if viewRouter.currentPage == .finished {
                StopPlaying()
            }
        }
        
        .onAppear {          
            DispatchQueue.main.async {
                envoyModel.getGiftQuota()
            }
            
            initPlayer()
            addSound()
            
            trackProgress()
            
            setupRemoteTransportControls()
            setupNowPlaying()
        }
        .onDisappear {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
            StopPlaying()
        }
        
    }
    
    private func initPlayer(){
        if let bgAnimation = UserDefaults.standard.value(forKey: "backgroundAnimation") as? Bool {
            backgroundAnimationOn = bgAnimation
        }
        
        model.selectedBreath = nil
        if UserDefaults.standard.bool(forKey: "isPlayMusic") {
            if let player = player {
                player.stop()
            }
        }
        model.forwardCounter = 0
        if model.selectedMeditation?.id != 22 {
            showTutorialModal = !UserDefaults.standard.bool(forKey: "playTutorialModal")
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
           try AVAudioSession.sharedInstance().setActive(true)
         } catch {
           print(error)
         }
    }
    
    private func addSound(){
        model.selectedPlant = userModel.selectedPlant
        model.checkIfFavorited()
        favorited = model.isFavorited
        model.setup(viewRouter)
        if let defaultSound = UserDefaults.standard.string(forKey: "sound") {
            if defaultSound != "noSound"  {
                selectedSound = Sound.getSound(str: defaultSound)
                if let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3") {
                    backgroundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                    backgroundPlayer?.delegate = self.del
                    backgroundPlayer?.prepareToPlay()
                    if let vol = UserDefaults.standard.value(forKey: "backgroundVolume") as? Float {
                        backgroundPlayer?.volume = vol
                        sliderData.sliderValue = vol
                    } else {
                        backgroundPlayer?.volume = 0.3
                        sliderData.sliderValue = 0.3
                    }
                    if let bgPlayer = self.backgroundPlayer {
                        sliderData.setPlayer(player: bgPlayer)
                    }
                    backgroundPlayer?.numberOfLoops = -1
                    backgroundPlayer?.play()
                }
            } else {
                if let url = Bundle.main.path(forResource: "", ofType: "mp3") {
                    backgroundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                }
            }
        }

        //bell at the end of a session
        if let url = Bundle.main.path(forResource: "bell", ofType: "mp3") {
            model.bellPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            model.bellPlayer?.delegate = self.del
        }

        if let bellVolume = UserDefaults.standard.value(forKey: "bellVolume") as? Float {
            model.bellPlayer?.volume = bellVolume
            bellSlider.sliderValue = bellVolume
        } else {
            model.bellPlayer?.volume = 0.5
            bellSlider.sliderValue = 0.5
        }
        
        if let bplayer = model.bellPlayer {
            bellSlider.setPlayer(player:bplayer)
        }
        
        if model.selectedMeditation?.url != "" {
            if  let url = URL(string: model.selectedMeditation?.url ?? "") {
                let playerItem = AVPlayerItem(url: url)
                self.mainPlayer = AVPlayer(playerItem: playerItem)
                mainPlayer?.volume = 5.0
                mainPlayer?.play()
                model.startCountdown()
            }
        } else if model.selectedMeditation?.belongsTo != "Timed Meditation" && model.selectedMeditation?.belongsTo != "Open-ended Meditation"  {
            if let url = Bundle.main.path(forResource: model.selectedMeditation?.title ?? "", ofType: "mp3") {
                self.mainPlayer = AVPlayer(url: URL(fileURLWithPath: url))
                mainPlayer?.volume = 5.0
                mainPlayer?.play()
                model.startCountdown()
            }
        } else {
            isTraceTimeMannual = true
            model.startCountdown()
            
        }
    }
    
    private func trackProgress() {
        timerSeconds = Double(model.totalTime)
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        mainPlayer?.addPeriodicTimeObserver(forInterval: time, queue: .main) { time in
            guard let item = self.mainPlayer?.currentItem, !item.duration.seconds.isNaN else {
                return
            }
            
            self.timerSeconds = Double(item.duration.seconds - time.seconds)
            if self.timerSeconds < 1 {
                model.secondsRemaining = -1
            }
            //                withAnimation(.linear) {
            //                    self.progressValue = timer < 0.001 ? 0.001 : timer
            //                }
        }
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
            try self.audioSession.setActive(true)
        } catch {
            print("failed to setup audio session category")
        }
    }
    
    private func shareAction() {
        var media: Media
        let poster = "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/newImages%2Fmindgarden-Beach_large.jpg?alt=media&token=b42ea140-baff-4a46-abf9-69b815a5b510"
        let title = model.selectedMeditation?.title ?? "Intro to Meditation"
        let description = model.selectedMeditation?.description ?? "Intro to Meditation"
        if let audiourl = model.selectedMeditation?.url  {
             media = Media(source: audiourl, sourceIsRedirect: false, poster: poster)
        } else {
             media = Media(source: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8", sourceIsRedirect: false, poster: poster)
        }
        let common = Common(media: media)
        let contentConfig = ContentConfig(contentType: "AUDIO", contentName: title, contentDescription: description, contentID: String(model.selectedMeditation?.id ?? 1), common: common)
        let envoyData = EnvoyData(userID: userModel.getUserID() ?? "1", contentConfig: contentConfig)
        envoyModel.generateLink(body: envoyData)
    }
    
    private func forwardAction() {
        model.forwardCounter += 1
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if model.selectedMeditation?.belongsTo != "Timed Meditation" {
            goForward()
        }
        if model.secondsRemaining >= 15 {
            model.secondsRemaining -= model.selectedMeditation?.url != "" ? 14 : 15
        } else {
            model.secondsRemaining = 0
        }
    }
     
    private func backAction() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if model.selectedMeditation?.belongsTo != "Timed Meditation" {
            goBackward()
        }
        if model.secondsRemaining + 15 <= model.selectedMeditation?.duration ?? 0.0 {
            model.secondsRemaining += model.selectedMeditation?.url != "" ? 15 : 15
        } else {
            model.secondsRemaining = model.selectedMeditation?.duration ?? 0.0
        }
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
            changeState()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { event in
            changeState()
            return .success
        }
        
        commandCenter.skipForwardCommand.addTarget { event in
            forwardAction()
            return .success
        }
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [NSNumber(value: 15)]

        commandCenter.skipBackwardCommand.addTarget { event in
            backAction()
            return .success
        }
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [NSNumber(value: 15)]
        
    }
    
    func setupNowPlaying() {
        if let mainPlayer = mainPlayer {
            // Define Now Playing Info
            var nowPlayingInfo = [String : Any]()
            nowPlayingInfo[MPMediaItemPropertyTitle] = model.selectedMeditation?.title ?? "Mind Garden"
            if let image = UIImage(named: "meditateIcon") {
                nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
                }
            }
            let isMainPlayer = model.selectedMeditation?.belongsTo != "Timed Meditation" && model.selectedMeditation?.belongsTo != "Open-ended Meditation"
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Int(Double((mainPlayer.currentTime().seconds)) )
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = isMainPlayer ? mainPlayer.currentTime : backgroundPlayer?.currentTime ?? 0.0
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = model.secondsRemaining
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isMainPlayer ? mainPlayer.rate : backgroundPlayer?.rate ?? 0.0
            
            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    private func StopPlaying(){
//        self.progressValue = 1.0
        if backgroundPlayer?.isPlaying ?? false {
            backgroundPlayer?.stop()
        }
        if model.selectedMeditation?.belongsTo != "Timed Meditation" && model.selectedMeditation?.belongsTo != "Open-ended Meditation"  {
            if (mainPlayer?.rate != 0 && mainPlayer?.error == nil) {
                self.mainPlayer?.rate = 0
            }
        }
    }
    
    func goForward() {
        let playerCurrentTime = CMTimeGetSeconds(mainPlayer?.currentTime() ?? CMTime.zero)
        let newTime = playerCurrentTime + 15
        
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        self.mainPlayer?.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { _ in
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Int(Double((self.mainPlayer?.currentTime().seconds) ?? 0))
        }
    }

    func goBackward() {
        let playerCurrentTime = CMTimeGetSeconds(mainPlayer?.currentTime() ?? CMTime.zero)
            var newTime = playerCurrentTime - 15

            if newTime < 0 {
                newTime = 0
            }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        mainPlayer?.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) {_ in
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Int(Double((self.mainPlayer?.currentTime().seconds) ?? 0))
        }
    }
    
    private func changeState(){
        if isDeviceLocked {
            isDeviceLocked = false
            return
        }
        if model.selectedMeditation?.belongsTo != "Timed Meditation" && model.selectedMeditation?.belongsTo != "Open-ended Meditation"  {
            if (mainPlayer?.rate != 0 && mainPlayer?.error == nil) {
                self.mainPlayer?.rate = 0
            } else {
                mainPlayer?.play()
            }
        }

        if backgroundPlayer?.isPlaying ?? false {
            backgroundPlayer?.pause()
        } else {
            backgroundPlayer?.play()
        }

        if timerStarted {
            model.stop()
        } else {
            model.startCountdown()
        }

        timerStarted.toggle()
    }


    //MARK: - nav
    var shareButton: some View {
        ZStack {
            Img.gift
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
                .foregroundColor(Clr.gardenGreen)
            ZStack {
                Circle().frame(width:12,height: 12)
                    .foregroundColor(Clr.redGradientBottom)
                    .overlay(Capsule().stroke(.black, lineWidth: 1))
                Text("\(envoyModel.userQuota)")
                    .font(Font.fredoka(.medium, size: 10))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(width: 10)
            } .offset(x: 10, y: -5)
        }
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation {
                showGift.toggle()
            }
        }
    }
    var backArrow: some View {
        Image(systemName: "arrow.backward")
            .font(.system(size: 24))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                    if let player = player {
                        player.play()
                    }
                }
                
                withAnimation {
                    StopPlaying()
                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude" {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        Analytics.shared.log(event: .play_tapped_back)
                        model.stop()
                        viewRouter.currentPage = .meditate
                    }
                }
            }
    }
    var sound: some View {
        Image(systemName: "music.note.list")
            .font(.system(size: 24))
            .foregroundColor(Clr.lightGray)
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    Analytics.shared.log(event: .play_tapped_sound)
                    showNatureModal = true
                }
            }
    }
    
    var heart: some View {
        ZStack {
            if model.isFavoritedLoaded {
                LikeButton(isLiked: model.isFavorited, size:25.0) {
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
        Analytics.shared.log(event: .play_tapped_favorite)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let med = model.selectedMeditation {
//                    Analytics.shared.log(event: "favorited_\(med.returnEventName())")
            model.favorite(id: med.id)
        }
        favorited.toggle()
    }

    //MARK: - tutorial modal
    struct TutorialModal: View {
        @Binding var show: Bool

        var body: some View {
           GeometryReader { g in
                VStack(spacing: 10) {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            HStack {
                                Spacer()
                                Text("🔔 New: change background sounds")
                                    .font(Font.fredoka(.bold, size: 28))
                                    .foregroundColor(Clr.black2)
                                    .frame(height: g.size.height * 0.06)
                                Spacer()
                            }.padding([.top, .horizontal], 40)
                            Img.tutorialImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size.width * 0.85 * 0.9, height: g.size.height * 0.55 * 0.65)
                            Spacer()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    show = false
                                    UserDefaults.standard.setValue(true, forKey: "playTutorialModal")
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.brightGreen)
                                    .overlay(
                                        Text("Got it!")
                                            .font(Font.fredoka(.bold, size: 18))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    )
                                    .frame(width: g.size.width * 0.7 * 0.5, height: g.size.height * 0.05)
                            }.buttonStyle(NeumorphicPress())
                                .padding()
                            Spacer()
                        }
                        .font(Font.fredoka(.regular, size: 18))
                        .frame(width: g.size.width * 0.85, height: g.size.height * (K.hasNotch() ? 0.60 : 0.65), alignment: .center)
                        .minimumScaleFactor(0.05)
                        .background(Clr.darkWhite)
                        .neoShadow()
                        .cornerRadius(12)
                        .offset(y: -50)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }


     func changeSound() {
         backgroundPlayer?.stop()
         if let url = Bundle.main.path(forResource: selectedSound?.title, ofType: "mp3") {
             backgroundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
             backgroundPlayer?.delegate = self.del
             backgroundPlayer?.numberOfLoops = -1
             backgroundPlayer?.volume = sliderData.sliderValue
             
             self.data = .init(count: 0)
             if let backgroundPlayer = backgroundPlayer {
                 backgroundPlayer.prepareToPlay()
                 backgroundPlayer.play()
                 self.sliderData.setPlayer(player: backgroundPlayer)
             }
         }
    }
}

import Combine

final class SliderData: ObservableObject {
  let didChange = PassthroughSubject<SliderData,Never>()
    var player: AVAudioPlayer?

    var sliderValue: Float = 0 {
        willSet {
            updateVolume(vol: newValue)
            didChange.send(self)
        }
    }

    func updateVolume(vol: Float) {
        self.player?.volume = vol
    }

    func setPlayer(player: AVAudioPlayer) {
        self.player = player
    }
}
struct SoundButton: View {
    var type: Sound?
    @Binding var selectedType: Sound?
    var change: () -> Void
    var player: AVAudioPlayer?
    @Binding var sliderData: SliderData

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation {
                if selectedType == type {
                    Analytics.shared.log(event: .play_tapped_sound_noSound)
                    selectedType = .noSound
                    player?.pause()
                } else {
                    Analytics.shared.log(event: AnalyticEvent.getSound(sound: type ?? .rain))
                    selectedType = type
                    change()
                }
                UserDefaults.standard.setValue(selectedType?.title, forKey: "sound")
            }
        } label: {
            ZStack {
                Rectangle()
                    .fill(selectedType == type ? Clr.darkgreen : Color.gray.opacity(0.5))
                    .aspectRatio(1.0, contentMode: .fit)
                    .cornerRadius(12)
                type?.img
                    .resizable()
                    .renderingMode(.template)
                    .padding(type == .fourThirtyTwo ? 0 :  type == .flute ? 5 : 10)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
//                    Rectangle()
//                        .fill(Color.white)
//                        .frame(width: type != selectedType ? 40 : 0, height: 3)
//                        .opacity(0.9)
//                        .rotationEffect(.degrees(-45))
            }.frame(width: 50, height: 50)
        }.buttonStyle(NeumorphicPress())
    }
}

//MARK: - nature modal
struct NatureModal: View {
    @State private var volume: Double = 0.0
    @Binding var show: Bool
    @Binding var sound: Sound?
    var change: () -> Void
    var player: AVAudioPlayer?
    @Binding var sliderData: SliderData
    @Binding var bellSlider: SliderData
    @Binding var vibrationOn:Bool
    @Binding var backgroundAnimationOn:Bool

    var  body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 15) {
                        HStack {
                            ZStack{}.frame(width: 30, height: 30)
                            Spacer()
                            Text("Ambient Sounds")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.bold, size: 20))
                                .multilineTextAlignment(.center)
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Clr.darkWhite)
                                    .neoShadow()
                                Image(systemName: "xmark")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.gray)
                                    .onTapGesture {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation { show = false}
                                    }
                            }.frame(width: 30, height: 30)
                        }.padding(20)
                        .offset(y: 20)
                        Spacer()
                        SoundView
                        Spacer()
                        BellVolumeView
                        VibrationView
                        BackgroundAnimation
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                show = false
                            }
                            UserDefaults.standard.setValue(sliderData.sliderValue, forKey: "backgroundVolume")
                            UserDefaults.standard.setValue(bellSlider.sliderValue, forKey: "bellVolume")
                            UserDefaults.standard.set(vibrationOn, forKey: "vibrationMode")
                            UserDefaults.standard.set(backgroundAnimationOn, forKey: "backgroundAnimation")
                        } label: {
                            ZStack {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Save")
                                            .font(Font.fredoka(.bold, size: 20))
                                            .foregroundColor(Clr.black2)
                                            .background(Clr.yellow)
                                    ).addBorder(.black, width: 1, cornerRadius: 20)
                            }.frame(height: 40)
                            .padding(15)
                        }
                        .neoShadow()
                        .animation(.default)
                        .padding(15)
                        .offset(y: -10)
                    }.frame(width: g.size.width * 0.85, height: g.size.height * 0.75, alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(32)
                    Spacer()
                }
                Spacer()
            }
            .onAppear {
                if let vibration = UserDefaults.standard.value(forKey: "vibrationMode") as? Bool {
                    vibrationOn = vibration
                }
                
                if let bgAnimation = UserDefaults.standard.value(forKey: "backgroundAnimation") as? Bool {
                    backgroundAnimationOn = bgAnimation
                }
            }
        }
    }
    
    var  SoundView: some View {
        VStack {
            HStack {
                SoundButton(type: .nature, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .rain, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .night, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .beach, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .fire, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
            }
            HStack {
                SoundButton(type: .music, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .flute, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .guitar, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .piano1, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .piano2, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
            }
            HStack {
                SoundButton(type: .fourThirtyTwo, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .theta, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .beta, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
                SoundButton(type: .alpha, selectedType: $sound, change: self.change, player: player, sliderData: $sliderData)
            }
        }
    }
    
    var  BellVolumeView: some View {
        VStack {
            GeometryReader { geometry in
                Slider(value: self.$sliderData.sliderValue, in: 0.0...3.0, step: 0.03)
                    .accentColor(Clr.darkgreen)
            }.frame(height: 30)
                .padding(.horizontal, 30)
                .padding(.top)
            Spacer()
            Text("Bell Volume")
                .foregroundColor(Clr.black2)
                .font(Font.fredoka(.semiBold, size: 20))
                .multilineTextAlignment(.center)
                .padding(.top)
            GeometryReader { geometry in
                Slider(value: self.$bellSlider.sliderValue, in: 0.0...1.0, step: 0.01)
                    .accentColor(Clr.darkgreen)
            }.frame(height: 30)
                .padding(.horizontal, 30)
                .padding(.top, 10)
        }
    }
    
    var  VibrationView: some View {
        HStack {
            Text("Vibration")
                .font(Font.fredoka(.bold, size: 18))
                .foregroundColor(Clr.black2)
            Spacer()
            Toggle("", isOn: $vibrationOn)
                .toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
        }
            .padding(.horizontal,20)
    }
    
    var  BackgroundAnimation: some View {
        HStack {
            Text("Background Animation")
                .font(Font.fredoka(.bold, size: 18))
                .foregroundColor(Clr.black2)
            Spacer()
            Toggle("", isOn: $backgroundAnimationOn)
                .toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
        }
            .padding(.horizontal,20)
    }
}


class AVdelegate : NSObject,AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}


struct Play_Previews: PreviewProvider {
    static var previews: some View {
        Play()
            .environmentObject(MeditationViewModel())
    }
}
