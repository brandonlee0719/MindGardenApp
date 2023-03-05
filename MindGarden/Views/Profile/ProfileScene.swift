//
//  ProfileScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/6/21.
//

import SwiftUI
import MessageUI
import Purchases
import FirebaseDynamicLinks
import Firebase
import StoreKit
import GTMAppAuth
import WidgetKit
import OneSignal
import Paywall

var tappedRefer = false
var mindfulNotifs = false
var tappedSignOut = false
enum settings {
    case referrals
    case settings
    case journey
}

struct ProfileScene: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var profileModel: ProfileViewModel
    @State private var selection: TopTabType = .profile
    @State private var showNotification = false
    @State private var showGarden = false
    @State private var isSignedIn = true
    @State private var tappedSignedIn = false
    @State private var showMailView = false
    @State private var mailNeedsSetup = false
    @State private var notificationOn = false
    @State private var showNotif = false
    @State private var dateTime = Date()
    @State private var restorePurchase = false
    @State private var numRefs = 0
    @State private var refDate = ""
    @State private var tappedRate = false
    @State private var showSpinner = false
    @State private var showMindful = false
    @State private var deleteAccount = false
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isSharePresented: Bool = false
    @State private var urlShare2 = URL(string: "https://mindgarden.io")
    @State private var backgroundMusicOn = false
    @State private var showFeedbackOption = false
    @State private var showFeedbackSheet = false
    @State private var selectedFeedback:FeedbackType = .helpMindGarden
    @State private var showImage = false
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        return dateFormatter
    }()

    var body: some View {
        LoadingView(isShowing: $showSpinner) {
            ZStack {
            VStack {
                if #available(iOS 14.0, *) {
                        GeometryReader { g in
                            let width = g.size.width
                            let height = g.size.height
                            ZStack {
                                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                                VStack(alignment: .center, spacing: 0) {
                                    HStack {
                                        Text(UserDefaults.standard.string(forKey: K.defaults.name) ?? "")
                                            .font(Font.fredoka(.semiBold, size: 20))
                                            .foregroundColor(Clr.black2)
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
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        }.frame(width: 30, height: 30)
                                    
                                    }.frame(width: width * 0.8)
                                    .padding()
                                    .padding(.top, 40)
                                    ProfileTab(selectedTab: $selection)
                                        .frame(width: width * 0.85)
                                    if showNotification || showGarden && selection == .settings {
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            showNotification = false
                                            showGarden = false
                                        } label: {
                                            Capsule()
                                                .fill(Clr.darkWhite)
                                                .padding(.horizontal)
                                                .overlay(
                                                    Text("Go Back")
                                                        .font(Font.fredoka(.semiBold, size: 20))
                                                        .foregroundColor(Clr.darkgreen)
                                                )
                                                .frame(width: width * 0.35, height: 30)
                                        }
                                        .buttonStyle(NeumorphicPress())
                                        .padding(.top)
                                    }

                                    if selection == .settings {
                                        if showNotification {
                                            Text("Notifications")
                                                .font(Font.fredoka(.regular, size: 20))
                                                .foregroundColor(Color.gray)
                                                .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                .padding(.bottom, 30)
                                                .padding(.top, 20)
                                            ZStack {
                                                Rectangle()
                                                    .fill(Clr.darkWhite)
                                                    .cornerRadius(12)
                                                    .neoShadow()
                                                VStack {
                                                    Row(title: "Meditation Reminders", img: Image(systemName: "bell.fill"), swtch: true, action: {
                                                        withAnimation {
                                                            showNotification = false
                                                            UserDefaults.standard.setValue(true, forKey: "notifOn")
                                                            showNotif = true
                                                        }
                                                    }, showNotif: $showNotif, showMindful: $showMindful)
                                                    .frame(height: 40)
                                                    Divider()
                                                    Row(title: "Mindful Reminders", img: Image(systemName: "bell.fill"), swtch: true, action: {
                                                        withAnimation {
                                                            UserDefaults.standard.setValue(true, forKey: "mindful")
                                                            showMindful = true
                                                        }
                                                    }, showNotif: $showNotif, showMindful: $showMindful)
                                                    .frame(height: 40)
                                                }.padding()
                                            }.frame(width: width * 0.75, height: 80)
                                                .transition(.slide)
                                                .animation(.default)
                                        } else if showGarden  {
                                            Text("Garden Settings")
                                                .font(Font.fredoka(.regular, size: 20))
                                                .foregroundColor(Color.gray)
                                                .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                .padding(.bottom, 30)
                                                .padding(.top, 20)
                                            ZStack {
                                                Rectangle()
                                                    .fill(Clr.darkWhite)
                                                    .cornerRadius(12)
                                                    .neoShadow()
                                                VStack {
                                                    Row(title: "Dates on Tile", img: Image(systemName: "bell.fill"), swtch: true, action: {
                                                        withAnimation {
//                                                            showNotif = true
                                                        }
                                                    }, showNotif: $showNotif, showMindful: $showMindful)
                                                    .frame(height: 40)
                                                    .padding()
                                                    
                                                    //TODO turn on/off Vines
//                                                    Row(title: "Mindful Reminders", img: Image(systemName: "bell.fill"), swtch: true, action: {
//                                                        withAnimation {
//                                                            UserDefaults.standard.setValue(true, forKey: "mindful")
//                                                            showMindful = true
//                                                        }
//                                                    }, showNotif: $showNotif, showMindful: $showMindful)
//                                                    .frame(height: 40)
                                                }
                                            }.frame(width: width * 0.75, height: 50)
                                                .transition(.slide)
                                                .animation(.default)
                                        } else {
                                            ScrollView(.vertical, showsIndicators: false) {
                                                VStack {
                                                    Text("Settings")
                                                        .font(Font.fredoka(.regular, size: 20))
                                                        .foregroundColor(Color.gray)
                                                        .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                        .padding(.bottom, 15)
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(Clr.darkWhite)
                                                            .cornerRadius(12)
                                                            .neoShadow()
                                                        VStack {
                                                            if !UserDefaults.standard.bool(forKey: "isPro") {
                                                                Row(title: "Unlock Pro", img: Image(systemName: "heart.fill"), action: {
                                                                    Analytics.shared.log(event: .profile_tapped_goPro)
                                                                    withAnimation {
                                                                        presentationMode.wrappedValue.dismiss()
                                                                        showProfile = true
                                                                        Analytics.shared.log(event: .pricing_from_profile)
                                                                        fromPage = "profile"
                                                                        viewRouter.currentPage = .pricing
                                                                    }
                                                                }, showNotif: $showNotif, showMindful: $showMindful)
                                                                    .frame(height: 40)
                                                                Divider()
                                                            }
                                                            VStack {
                                                                Row(title: "Background Music", img: Image(systemName: backgroundMusicOn ? "speaker.wave.2.fill" : "speaker.slash.fill"), action: {
                                                                    backgroundMusicOn.toggle()
                                                                    if let player = player {
                                                                        if player.isPlaying {
                                                                            player.pause()
                                                                            Analytics.shared.log(event: .profile_tapped_background_on)
                                                                            backgroundMusicOn = false
                                                                        } else {
                                                                            Analytics.shared.log(event: .profile_tapped_background_off)
                                                                            player.play()
                                                                            backgroundMusicOn = true
                                                                        }
                                                                    }
                                                                    UserDefaults.standard.setValue(backgroundMusicOn, forKey: "isPlayMusic")
                                                                }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                                Divider()
                                                                Row(title: "Notifications", img: Image(systemName: "bell.fill"), action: {
                                                                    showNotification = true
                                                                    Analytics.shared.log(event: .profile_tapped_notifications)
                                                                }, showNotif: $showNotif, showMindful: $showMindful)
                                                                    .frame(height: 40)
                                                                Divider()
                                                                Row(title: "Garden", img: Image(systemName: "calendar"), action: {
                                                                    showGarden = true
                                                                    Analytics.shared.log(event: .profile_tapped_garden)
                                                                }, showNotif: $showNotif, showMindful: $showMindful)
                                                                    .frame(height: 40)
                                                            }
                                                            Divider()
//                                                            Row(title: "Contact Us", img: Image(systemName: "envelope.fill"), action: {
//                                                                Analytics.shared.log(event: .profile_tapped_email)
//
//                                                            }, showNotif: $showNotif, showMindful: $showMindful)
//                                                                .frame(height: 40)
//                                                            Divider()
                                                            Row(title: "Restore Purchases", img: Image(systemName: "arrow.triangle.2.circlepath"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_restore)
                                                                Purchases.shared.restoreTransactions { (purchaserInfo, error) in
                                                                    if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
                                                                        UserDefaults.standard.setValue(true, forKey: "isPro")
                                                                        restorePurchase = true
                                                                    } else {
                                                                        UserDefaults.standard.setValue(false, forKey: "isPro")
                                                                    }
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                            Divider()
                                                            Row(title: "Contact Us", img: Image(systemName: "envelope.fill"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_feedback)
                                                                withAnimation(.spring()) {
                                                                    showFeedbackOption = true
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                            Divider()
                                                            Row(title: "Add Widget", img: Image(systemName: "gearshape.fill"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_add_widget)
                                                                withAnimation {
                                                                    presentationMode.wrappedValue.dismiss()
                                                                    profileModel.showWidget = true
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                            if let _ = Auth.auth().currentUser?.email {
                                                                Divider()
                                                                Row(title: "Delete Account", img: Image(systemName: "trash"), action: {
                                                                    deleteAccount = true
                                                                }, showNotif: $showNotif, showMindful: $showMindful)
                                                                    .frame(height: 40)
                                                            }
                                                        }.padding()
                                                    }.frame(width: width * 0.75, height: (UserDefaults.standard.bool(forKey: "isPro") ? 340 : 380) + (!SceneDelegate.profileModel.isLoggedIn ? 95 : 15))

                                                    Text("I want to help")
                                                        .font(Font.fredoka(.regular, size: 20))
                                                        .foregroundColor(Color.gray)
                                                        .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                        .padding(.bottom, 15)
                                                        .padding(.top, 50)
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(Clr.darkWhite)
                                                            .cornerRadius(12)
                                                            .neoShadow()
                                                        VStack {
                                                            Row(title: "Invite Friends", img: Image(systemName: "arrowshape.turn.up.right.fill"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_invite)
                                                                actionSheet() }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height:40)
                                                            Divider()
                                                            Row(title: "Rate the app", img: Image(systemName: "star.fill"), action: {
                                                                rateFunc()
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height:  40)
                                                            Divider()
                                                            Row(title: "Request Feature/Med", img: Image(systemName: "hand.raised.fill"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_roadmap)
                                                                if let url = URL(string: "https://mindgarden.upvoty.com/") {
                                                                    UIApplication.shared.open(url)
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                            Divider()
                                                            Row(title: "Feedback Form", img: Image(systemName: "doc.on.clipboard"), action: {
                                                                Analytics.shared.log(event: .profile_tapped_feedback)
                                                                showFeedbackOption = true
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: 40)
                                                        }.padding()
                                                    }.frame(width: width * 0.75, height: 230)
                                                    Text("Stay up to date")
                                                        .font(Font.fredoka(.regular, size: 20))
                                                        .foregroundColor(Color.gray)
                                                        .frame(width: width * 0.7, height: 20, alignment: .leading)
                                                        .padding(.bottom, 45)
                                                        .padding(.top, 50)
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(Clr.darkWhite)
                                                            .cornerRadius(12)
                                                            .neoShadow()
                                                        VStack {
                                                            Row(title: "Join the Community", img: Img.redditIcon, action: {
                                                                Analytics.shared.log(event: .profile_tapped_discord)
                                                                if let url = URL(string: "https://discord.gg/SZXnxtyBV5") {
                                                                    UIApplication.shared.open(url)
                                                                    UserDefaults.standard.setValue(true, forKey: "reddit")
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful).frame(height: 40)
                                                                .frame(height: K.isSmall() ? 30 : 40)
                                                            Divider()
                                                            Row(title: "Daily Inspiration", img: Img.instaIcon, action: {
                                                                Analytics.shared.log(event: .profile_tapped_instagram)
                                                                if let url = URL(string: "https://www.instagram.com/mindgardn/") {
                                                                    UIApplication.shared.open(url)
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: K.isSmall() ? 30 : 40)
                                                            Row(title: "Talking to Strangers", img: Img.tiktokIcon, action: {
                                                                Analytics.shared.log(event: .profile_tapped_instagram)
                                                                if let url = URL(string: "https://www.tiktok.com/@mindgardn?lang=en") {
                                                                    UIApplication.shared.open(url)
                                                                }
                                                            }, showNotif: $showNotif, showMindful: $showMindful)
                                                                .frame(height: K.isSmall() ? 30 : 40)
                                                        }.padding()
                                                    }.frame(width: width * 0.8, height: 100)
                                                } .frame(width: width * 0.8)
                                                .padding(.bottom)
                                            }
                                            .frame(width: width * 0.8, height: height * (K.isSmall() ?  0.65 : 0.7))
                                            .padding(.top, 25)
                                        }
                                    } else if selection == .profile {
                                        // Journey
                                        ProfilePage(profileModel: profileModel, width: width, height: height, totalSessions: gardenModel.totalSessions, totalMins: gardenModel.totalMins)
                                            .frame(height: height * 0.87)
                                            .padding(.top, 10)
                                    } else {
                                        ReferralScene(numRefs: $numRefs, action: {
                                            actionSheet()
                                        })
                                    }
                                    
                                    if selection == .referral {
                                 
                                    } else {
                                        Spacer()
                                        if selection == .settings {
                                            if let _ = Auth.auth().currentUser?.email {} else {
                                                Text("Save your progress")
                                                    .foregroundColor(Clr.black2).font(Font.fredoka(.semiBold, size: 20))
                                                    .padding(.top, K.isSmall() ? 0 : 15)
                                                    .padding(.bottom, 0)
                                            }
                                            
                                            Button {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                if let _ = Auth.auth().currentUser?.email {
                                                    Analytics.shared.log(event: .profile_tapped_logout)
                                                    presentationMode.wrappedValue.dismiss()
                                                    tappedSignOut = true
                                                    profileModel.signOut()
                                                    // if user signs out -> send them to meditate page
                                                    withAnimation {
                                                        viewRouter.currentPage = .onboarding
                                                    }
                                                } else {
                                                    Analytics.shared.log(event: .profile_tapped_create_account)
                                                    presentationMode.wrappedValue.dismiss()
                                                    withAnimation {
                                                        fromPage = "profile"
                                                        viewRouter.currentPage = .authentication
                                                    }
                                                }
                                                PaywallService.shared.reset()
                                            } label: {
                                                if let _ = Auth.auth().currentUser?.email {
                                                    Capsule()
                                                        .fill(Clr.redGradientBottom)
                                                        .neoShadow()
                                                        .overlay(Text("Sign Out").foregroundColor(.white).font(Font.fredoka(.bold, size: 24)))
                                                        .frame(height: 50)
                                                        .padding(.horizontal, 32)
                                                        .padding(.bottom, 20)
                                                } else {
                                                    Capsule()
                                                        .fill(Clr.darkgreen)
                                                        .neoShadow()
                                                        .overlay(
                                                            Text("Create an account").foregroundColor(.white).font(Font.fredoka(.bold, size: 24)))
                                                        .frame(height: 50)
                                                        .lineLimit(1)
                                                        .addBorder(.black, width: 1.5, cornerRadius: 24)
                                                        .minimumScaleFactor(0.05)
                                                        .padding(.horizontal, 32)
                                                        .padding(.bottom, 20)
                                                }
                                            }
                                            .frame(width:width, height: 50, alignment: .center)
                                            .padding()
                                        }
                                    }
                                    Spacer()
                                }
                                    .frame(width: width, height: height)
                                    .background(Clr.darkWhite)
 
                            }
                        }
                    .onAppear {
                        fromOnboarding = false
                        // Set the default to clear
                        UITableView.appearance().backgroundColor = .clear
                        UITableView.appearance().showsVerticalScrollIndicator = false
                        //                    UITableView.appearance().isScrollEnabled = false
                        profileModel.update(userModel: userModel, gardenModel: gardenModel)
                    }
               
                    .sheet(isPresented: $isSharePresented) {
                        ReferralView(url: $urlShare2)
                    }
                    .fullScreenCover(isPresented: $showNotif) {
                        NotificationScene(fromSettings: true)
                    }
                    .fullScreenCover(isPresented: $showMindful) {
                        MindfulScene()
                    }
                    .alert(isPresented: $restorePurchase) {
                        Alert(title: Text("Success!"), message: Text("You've restored MindGarden Pro"))
                    }
                    .alert(isPresented: $deleteAccount) {
                        Alert(
                            title: Text("Are you sure?"),
                            message: Text("All data will be deleted"),
                            primaryButton: .destructive(Text("Yes"), action: {
                                Analytics.shared.log(event: .profile_tapped_delete_account)
                                profileModel.signOut()
                                OneSignal.sendTag("deleted", value: "true")
                                // if user signs out -> send them to meditate page
                                withAnimation {
                                    viewRouter.currentPage = .onboarding
                                }
                            }),
                            secondaryButton: .default(Text("Cancel"))
                        )
                    }
                    .onAppearAnalytics(event: .screen_load_profile)
                } else {
                    // Fallback on earlier versions
                }
            }
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .ignoresSafeArea()
                        .opacity(showFeedbackOption ? 0.5 : 0.0)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showFeedbackOption = false
                            }
                        }
                VStack {
                    Spacer()
                    VStack {
                        Spacer().frame(height: 10)
                        ForEach(FeedbackType.allCases, id: \.id) { item in
                            Text(item.title)
                                .font(Font.fredoka(.regular, size: 20))
                                .foregroundColor(Clr.black2)
                                .frame(height:25)
                                .onTapGesture {
                                    selectedFeedback = item
                                    withAnimation(.spring()) {
                                        showFeedbackSheet = true
                                        showFeedbackOption = false
                                    }
                                }
                                .padding()
                            if item == .helpMindGarden || item == .bugReport {
                                Divider().padding(.horizontal)
                            }
                        }
                        Spacer()
                            .frame(height: 30)
                    }
                    .ignoresSafeArea()
                    .background(
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(14)
                    )
                }
                    .offset(y:showFeedbackOption ? 0 : 600)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
                    .ignoresSafeArea()
                
                    LeaveFeedback(userModel: userModel, selectedFeedback: $selectedFeedback, showFeedbackSheet: $showFeedbackSheet).offset(x:(showFeedbackSheet && !showFeedbackOption) ? 0 : UIScreen.screenWidth*1.1 )
                        .transition(.move(edge: .trailing))
            }
        }.onAppear {
            showImage = UserDefaults.standard.bool(forKey: "showJournalImage")
            backgroundMusicOn = UserDefaults.standard.bool(forKey: "isPlayMusic")
            //            print(dateFormatter.string(from: UserDefaults.standard.value(forKey: K.defaults.meditationReminder) as! Date), "so fast")
            if tappedRefer {
                selection = .referral
                tappedRefer = false
            } else {
                if mindfulNotifs {
                    showNotification = true
                    mindfulNotifs = false
                } else if gardenSettings {
                    selection = .settings
                    showGarden = true
                }
            }
            
            tappedRate = UserDefaults.standard.bool(forKey: "tappedRate")
            if userModel.referredStack == "" {
                if !UserDefaults.standard.bool(forKey: "isPro") {
                    refDate = "No referrals"
                } else {
                    refDate = "Pro account is active"
                }
                numRefs = 0
            } else {
                let plusIndex = userModel.referredStack.indexInt(of: "+") ?? 0
                refDate =  userModel.referredStack.substring(to: plusIndex)
                numRefs = Int(userModel.referredStack.substring(from: plusIndex + 1)) ?? 0
            }
        }.onDisappear {
            gardenSettings = false
        }
    }
 
    private func rateFunc() {
        Analytics.shared.log(event: .profile_tapped_rate)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
            UserDefaults.standard.setValue(true, forKey: "tappedRate")
            //                                                userModel.willBuyPlant = Plant.badgePlants.first(where: { p in
            //                                                    p.title == "Camellia"
            //                                                })
            //                                                userModel.buyPlant(unlockedStrawberry: true)
        }
        tappedRate = true
    }

    func actionSheet() {
        if selection == .referral {
            if !SceneDelegate.profileModel.isLoggedIn {
                tappedRefer = true
                viewRouter.currentPage = .authentication
            }
        }
        if selection == .referral {
//            showSpinner = true
            guard let uid = Auth.auth().currentUser?.email else {
                return
            }
            
            guard let link = URL(string: "https://mindgarden.io?referral=\(uid)") else { return }
            let referralLink = DynamicLinkComponents(link: link, domainURIPrefix: "https://mindgarden.page.link")


            if let myBundleId = Bundle.main.bundleIdentifier {
                referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
                referralLink?.iOSParameters?.minimumAppVersion = "1.44"
                referralLink?.iOSParameters?.appStoreID = "1588582890"
            }

            let newDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())
            let newDateString = dateFormatter.string(from: newDate ?? Date())
            referralLink?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            referralLink?.socialMetaTagParameters?.title = "\(userModel.name) has invited you to 👨‍🌾 MindGarden"
            referralLink?.socialMetaTagParameters?.descriptionText = "📱 Download the app by \(newDateString) to claim your free trial"
            guard let imgUrl = URL(string: "https://i.ibb.co/1GW6YxY/MINDGARDEN.png") else { return }
            referralLink?.socialMetaTagParameters?.imageURL = imgUrl
            referralLink?.shorten { (shortURL, warnings, error) in
                showSpinner = false
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let shortURL = shortURL {
                    urlShare2 = shortURL
                }
                isSharePresented = true
            }
        } else {
            isSharePresented = true
        }
    }


    struct Row: View {
        var title: String
        var img: Image
        var swtch: Bool = false
        var action: () -> ()
        @State var notifOn = true
        @Binding var showNotif: Bool
        @Binding var showMindful: Bool
        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                action()
            } label: {
                VStack(spacing: 20) {
                    HStack() {
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 20)
                            .offset(x: -10)
                            .foregroundColor(Clr.darkgreen)
                        Text(title)
                            .font(Font.fredoka(.medium, size: title == "Meditation Reminders" || title == "Mindful Reminders" ? 14 : 20))
                            .foregroundColor(title == "Unlock Pro" ? Clr.brightGreen : Clr.black1)
                    
                        Spacer()
                        if title == "Notifications" || title == "Garden" {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        } else if swtch {
                            if #available(iOS 14.0, *) {
                                if title == "Meditation Reminders" {
                                    Toggle("", isOn: $notifOn)
                                        .onChange(of: notifOn) { val in
                                            UserDefaults.standard.setValue(val, forKey: "notifOn")
                                            if val {
                                                Analytics.shared.log(event: .profile_tapped_toggle_on_notifs)
                                                showNotif = true
                                            } else { //turned off
                                                Analytics.shared.log(event: .profile_tapped_toggle_off_notifs)
                                                UserDefaults.standard.setValue(false, forKey: "notifOn")
                                                let center = UNUserNotificationCenter.current()
                                                center.removePendingNotificationRequests(withIdentifiers: ["1", "2", "3", "4", "5", "6", "7"]) // To remove all pending notifications which are not delivered yet but scheduled.
                                            }
                                        }.toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
                                        .frame(width: UIScreen.main.bounds.width * 0.1)
                                } else {
                                    Toggle("", isOn: $notifOn)
                                        .onChange(of: notifOn) { val in
                                            if title == "Dates on Tile" {
                                                UserDefaults.standard.setValue(val, forKey: "tileDates")
                                                if val {
                                                    Analytics.shared.log(event: .profile_tapped_garden_date_on)
                                                } else { //turned off
                                                    Analytics.shared.log(event: .profile_tapped_garden_date_off)
                                                }
                                            } else {
                                                UserDefaults.standard.setValue(val, forKey: "mindful")
                                                if val {
                                                    Analytics.shared.log(event: .profile_tapped_toggle_on_mindful)
                                                    showMindful = true
                                                } else { //turned off
                                                    NotificationHelper.deleteMindfulNotifs()
                                                    Analytics.shared.log(event: .profile_tapped_toggle_off_mindful)
                                                }
                                            }
                                        }.toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
                                        .frame(width: UIScreen.main.bounds.width * 0.1)
                                }
                            }
                        }
                    }.padding()
                }
                .listRowBackground(title == "Unlock Pro" ? Clr.yellow : Clr.darkWhite)
            }.onAppear {
                if title == "Meditation Reminders" {
                    notifOn = UserDefaults.standard.bool(forKey: "notifOn")
                } else {
                    if title == "Dates on Tile" {
                        notifOn = UserDefaults.standard.bool(forKey: "tileDates")
                    } else {
                        notifOn = UserDefaults.standard.bool(forKey: "mindful")
                    }
                }
            }
        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene(profileModel: ProfileViewModel())
    }
}



struct ReferralView: View {
    @Binding var url: URL?
    
    var body: some View {
        if let shareUrl = url {
            ActivityViewController(activityItems: [shareUrl])
        }
    }
}
