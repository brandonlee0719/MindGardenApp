//
//  SceneDelegate.swift
//  MindGarden
//
//  Created by Dante Kim on 5/25/21.
//

import UIKit
import SwiftUI
import AppsFlyerLib
import FirebaseDynamicLinks
import Firebase
import Foundation
import OneSignal
import Storyly
import AVFoundation
import MWMPublishingSDK


var numberOfMeds = 0
var storylyViewProgrammatic = StorylyView()
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    static let userModel = UserViewModel()
    static let gardenModel = GardenViewModel()
    static let medModel = MeditationViewModel()
    static let profileModel = ProfileViewModel()
    static let bonusModel = BonusViewModel(userModel: userModel, gardenModel: gardenModel)
    let router = ViewRouter()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return formatter
    }()
    var playOnActive = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (seef `application:configurationForConnectingSceneSession` instead).
        // Create the SwiftUI view that provides the window contents.
//        UserDefaults.standard.setValue(false, forKey: "tappedRate")
        
        let launchNum = UserDefaults.standard.integer(forKey: "launchNumber")
//        UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
//        UserDefaults.standard.setValue(["Bijan 8", "Quote 1", "Tale 2", "New Users"], forKey: "oldSegments")
        Analytics.shared.log(event: .launchedApp)
        playSound(soundName: "background")

        if launchNum == 0 {
            let randomInt = Int.random(in: 0..<2)
            UserDefaults.standard.setValue(randomInt, forKey: "abTest")
            UserDefaults.standard.setValue(true, forKey: "isPlayMusic")
            playSound(soundName: "background")
            UserDefaults.standard.setValue(UUID().uuidString, forKey: K.defaults.giftQuotaId)
            UserDefaults.standard.setValue(["New Users", "Intro/Day 1", "Tip New Users", "trees for the future"], forKey: "oldSegments")
            UserDefaults.standard.setValue(["New Users", "Intro/Day 1", "Tip New Users", "trees for the future"], forKey: "storySegments")
            UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "userDate")
            UserDefaults.standard.setValue(["White Daisy", "Red Tulip"], forKey: K.defaults.plants)
            UserDefaults.standard.setValue("White Daisy", forKey: K.defaults.selectedPlant)
            UserDefaults.standard.setValue("432hz", forKey: "sound")
            UserDefaults.standard.setValue(50, forKey: "coins")
            UserDefaults.standard.setValue(2, forKey: "frequency")
            UserDefaults.standard.setValue(["gratitude", "smiling", "loving", "breathing", "present"], forKey: "notifTypes")
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "joinDate")
            UserDefaults.standard.setValue(true, forKey: "newUser")
            UserDefaults.standard.setValue(1, forKey: "launchNumber")
            UserDefaults.standard.setValue(1, forKey: "dailyLaunchNumber")
        }
        
        UserDefaults.standard.removeObject(forKey: K.defaults.referred)

        
        let authModel =  AuthenticationViewModel(userModel:  SceneDelegate.userModel, viewRouter: router)
        let firebaseAPI = FirebaseAPI(medModel: SceneDelegate.medModel)
        
        let _ = Auth.auth().addStateDidChangeListener { auth, user in
            if let _ = user?.email {
                print("goshard")
                SceneDelegate.profileModel.isLoggedIn = true
                SceneDelegate.userModel.updateSelf()
                firebaseAPI.fetchMeditations(meditationModel: SceneDelegate.medModel)
                firebaseAPI.fetchCourses()
                SceneDelegate.medModel.updateSelf()
            } else {
                print("yumah")
                SceneDelegate.profileModel.isLoggedIn = false
                SceneDelegate.userModel.updateSelf()
                firebaseAPI.fetchMeditations(meditationModel: SceneDelegate.medModel)
                firebaseAPI.fetchCourses()
            }
        }
        


        if let onBoarding = UserDefaults.standard.string(forKey: K.defaults.onboarding), onBoarding != "done" {
            SceneDelegate.bonusModel.totalBonuses = 1
            SceneDelegate.bonusModel.sevenDayProgress = 0.1
            SceneDelegate.bonusModel.thirtyDayProgress = 0.08
        }

        let contentView = ContentView(bonusModel:  SceneDelegate.bonusModel, profileModel: SceneDelegate.profileModel, authModel: authModel)
        

        // Use a UIHostingController as window root view controller.
        let rootHost = UIHostingController(rootView: contentView
                                            .environmentObject(router)
                                            .environmentObject(SceneDelegate.medModel)
                                            .environmentObject(SceneDelegate.userModel)
                                            .environmentObject(SceneDelegate.gardenModel))
        
//        NewAuthentication(viewModel: AuthenticationViewModel(userModel: UserViewModel(), viewRouter: ViewRouter())).environmentObject(ViewRouter())
        if let windowScene = scene as? UIWindowScene {             let window = UIWindow(windowScene: windowScene)
            MWM.showOnboardingIfNeeded(withPlacementKey: MWMModel.DynamicScreenPlacement.onboarding.rawValue,
                                               on: window,
                                               loaderViewController: nil) { _, _ in
                        self.window?.rootViewController = rootHost
                    }

            storylyViewProgrammatic.rootViewController = rootHost
//            window.rootViewController = rootHost
            self.window = window
            window.makeKeyAndVisible()
        }
        // Get URL components from the incoming user activity.
            if let userActivity = connectionOptions.userActivities.first {
                  processUserActivity(userActivity)
            }
        
        setNotificationStatus()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.


        numberOfMeds = Int.random(in: 1085..<1111)
        launchedApp = true
        Analytics.shared.log(event: .sceneDidBecomeActive)
        SceneDelegate.bonusModel.updateBonus()
        SceneDelegate.userModel.updateSelf()

        if let player = player, playOnActive {
            if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                player.play()
            }
        }
        setNotificationStatus()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        if let player = player, player.isPlaying {
            player.pause()
            playOnActive = true
        } else {
            playOnActive = false
        }
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        SceneDelegate.gardenModel.updateSelf()

        var launchNum = UserDefaults.standard.integer(forKey: "launchNumber")
        launchNum += 1
        UserDefaults.standard.setValue(launchNum, forKey: "launchNumber")
        
        if UserDefaults.standard.bool(forKey: "reddit") && !UserDefaults.standard.bool(forKey: "redditOne") {
            SceneDelegate.userModel.willBuyPlant = Plant.badgePlants.first(where: { p in
                p.title == "Apples"
            })
            SceneDelegate.userModel.buyPlant(unlockedStrawberry: true)
            SceneDelegate.userModel.showPlantAnimation = true
            UserDefaults.standard.setValue(true, forKey: "redditOne")
        }

        
        StorylyManager.updateStories()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        if let player = player, player.isPlaying {
            player.pause()
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // use this to add friends
        // Get URL components from the incoming user activity.
        processUserActivity(userActivity)
 
        if let incomingUrl = userActivity.webpageURL {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl) { (dynamicLink, error) in
                guard error == nil else {
                    print("Found an error \(String(describing: error?.localizedDescription))")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handlIncomingDynamicLink(dynamicLink)
                }
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            if context.url.scheme == "christmas" {
                UserDefaults.standard.setValue(true, forKey: "christmasLink")
            } else if context.url.scheme == "intro" || context.url.host == "intro"  {
                UserDefaults.standard.setValue(true, forKey: "introLink")
            } else if context.url.scheme == "happiness" || context.url.host == "happiness" {
                UserDefaults.standard.setValue(true, forKey: "happinessLink")
            } else if context.url.scheme == "gratitude" || context.url.host == "gratitude" {
                NotificationCenter.default.post(name: Notification.Name("gratitude"), object: nil)
            } else if context.url.scheme == "meditate" || context.url.host == "meditate" {
                NotificationCenter.default.post(name: Notification.Name("meditate"), object: nil)
            } else if context.url.scheme == "mood" || context.url.host == "mood" {
                NotificationCenter.default.post(name: Notification.Name("mood"), object: nil)
            } else if context.url.scheme == "breathwork" || context.url.host == "breathwork" {
                NotificationCenter.default.post(name: Notification.Name("breathwork"), object: nil)
            } else if context.url.scheme == "pro" || context.url.host == "pro" {
                NotificationCenter.default.post(name: Notification.Name("pro"), object: nil)
            } else if context.url.scheme == "garden" || context.url.host == "garden" {
                NotificationCenter.default.post(name: Notification.Name("garden"), object: nil)
            }
        }
        if let url = URLContexts.first?.url {
            AppsFlyerLib.shared().handleOpen(url, options: nil)
        }
    }

    func handlIncomingDynamicLink(_ dynamicLink: DynamicLink?) {
      guard let dynamicLink = dynamicLink else { return }
      guard let deepLink = dynamicLink.url else { return }
      let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
      let invitedBy = queryItems?.filter({(item) in item.name == "referral"}).first?.value
      let user = Auth.auth().currentUser
      // If the user isn't signed in and the app was opened via an invitation
      // link, sign in the user anonymously and record the referrer UID in the
      // user's RTDB record.
      if user == nil && invitedBy != nil {
          Analytics.shared.log(event: .onboarding_came_from_referral)
          UserDefaults.standard.setValue(invitedBy, forKey: K.defaults.referred)
          if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden" && UserDefaults.standard.bool(forKey: K.defaults.loggedIn) {
                        self.router.currentPage = .authentication
          }
      }
    }
    
    private func setNotificationStatus() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                UserDefaults.standard.setValue(true, forKey: "isNotifOn")
            case .denied:
                UserDefaults.standard.setValue(false, forKey: "isNotifOn")
            case .notDetermined:
                UserDefaults.standard.setValue(false, forKey: "isNotifOn")
            default:
                print("Unknow Status")
            }
        })
    }
}

extension URL {
 func valueOf(_ queryParamaterName: String) -> String? {
 guard let url = URLComponents(string: self.absoluteString) else { return nil }
 return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value?.removingPercentEncoding?.removingPercentEncoding
 }
}


extension SceneDelegate {
    private func processUserActivity(_ userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let urlToOpen = userActivity.webpageURL else {
                  return
              }
        
        print("Universal Link: \(urlToOpen)")
            processUniversalLinkData(
                pathComponents: getUniversalLinkPathComponentsAndParams(urlToOpen).0,
                queryParams: getUniversalLinkPathComponentsAndParams(urlToOpen).1
            )
        
    }
    
    private func getUniversalLinkPathComponentsAndParams(_ url: URL) -> (
        [String],
        [String: String]
    ){
        let pathComponents = url.pathComponents.filter { component in
            component != "/"
        }
        
        var queryParams = [String: String]()
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let queryItems = urlComponents?.queryItems {
            for queryItem in queryItems {
                if let val = queryItem.value {
                    queryParams[queryItem.name] = val
                }
            }
        }
        
        return (pathComponents, queryParams)
    }

    private func processUniversalLinkData(
        pathComponents: [String],
        queryParams: [String: String]
    ) {
        // Process the data
        print(pathComponents, "pathComponents")
        print(queryParams, "queryParams")
    }
    
    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player?.volume = 0.04
            player?.numberOfLoops = -1
            
            guard let player = player else { return }
            if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                player.play()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
