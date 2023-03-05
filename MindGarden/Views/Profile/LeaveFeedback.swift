//
//  LeaveFeedback.swift
//  MindGarden
//
//  Created by Vishal Davara on 09/06/22.
//

import SwiftUI
import StoreKit
import FirebaseDynamicLinks
import Firebase
import MessageUI

enum FeedbackType: String, CaseIterable {
    case helpMindGarden,bugReport,subscription
    var id: String { return self.rawValue }
    var title: String {
        switch self {
        case .helpMindGarden:
            return "😊 Help us improve"
        case .bugReport:
            return "🐞 Report a Bug"
        case .subscription:
            return "🙋‍♂️ Subscription Help"
        }
    }
    var description : String {
        switch self {
        case .helpMindGarden:
            return "Thank you for supporting our small team of 4, everything here genuinely helps us keep building!"
        case .bugReport:
            return "Please describe in detail how the bug occured. Thank you for your patience & help :)"
        case .subscription:
            return "All revenue goes into supporting the building of MindGarden, and the livlihood of our small team of 4"
        }
    }
}

struct LeaveFeedback: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var userModel: UserViewModel
    @Binding var selectedFeedback:FeedbackType
    @State private var subjectLine = "" 
    @State private var showMailView = false
    @State private var mailNeedsSetup = false
    @State private var isSharePresented: Bool = false
    @State private var urlShare2 = URL(string: "https://mindgarden.io")
    
    @Binding var showFeedbackSheet : Bool
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        return dateFormatter
    }()
    var subscriptionTuples = [("I have a question about my subscription (Please don’t change subject line)", "Question about Subscription"), ("Pro features did not unlock, even though I purchased a subscription (Please don’t change subject line)", "Pro features didn't unlock"), ("I’d like to cancel my subscription or trial (Please don’t change subject line)","I want to cancel my subscription"), ("I’d like a refund on my subscription. (Don’t Change Subject Line)", "I want a refund")]
    
    var body: some View {
        ZStack {
            Clr.darkWhite
            VStack {
                Spacer()
                    .frame(height:60)
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            showFeedbackSheet = false
                        }
                    } label: {
                        ZStack {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Clr.darkgreen)
                                .padding()
                                .frame(width: 60)
                        }
                        .cornerRadius(25)
                    }
                    .buttonStyle(NeumorphicPress())
                    Spacer()
                }.frame(width:UIScreen.screenWidth*0.85)

                Spacer()
            }
            VStack {
                Spacer()
                    .frame(height:100)
                Text(selectedFeedback.title)
                    .font(Font.fredoka(.bold, size: 30))
                    .foregroundColor(Clr.darkgreen)
                    .frame(width:UIScreen.screenWidth*0.8, alignment: .leading)
                    .padding(.top)
                Text(selectedFeedback.description)
                    .font(Font.fredoka(.regular, size: 18))
                    .foregroundColor(Clr.black2)
                    .frame(width:UIScreen.screenWidth*0.8, alignment: .leading)
                    .padding(.bottom)
                VStack(alignment:.center) {
                    switch selectedFeedback {
                    case .helpMindGarden:
                        requestFeature
                        Divider()
                            .padding(.horizontal)
                        contactTeam
                        Divider()
                            .padding(.horizontal)
                        rateTheApp
                        Divider()
                            .padding(.horizontal)
                        inviteFriend
                    case .bugReport:
                        contactTeam
                        Divider()
                            .padding(.horizontal)
                    case .subscription:
                        ForEach(0..<4, id: \.self) { num in
                            subscriptionContact(title: subscriptionTuples[num].1, subject: subscriptionTuples[num].0, subjectLine: $subjectLine, showMailView: $showMailView, mailNeedsSetup: $mailNeedsSetup)
                        }
                    }
                }
                .frame(width:UIScreen.screenWidth*0.85)
                .background(
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(10)
                        .neoShadow()
                )
                
                .padding(20)
                Spacer()
            }
        }
        .sheet(isPresented: $isSharePresented) {
            ReferralView(url: $urlShare2)
        }
        .ignoresSafeArea()
        .alert(isPresented: $mailNeedsSetup) {
            Alert(title: Text("Your mail is not setup"), message: Text("Please try manually emailing team@mindgarden.io, subject should be title of button pressed. Thank you."))
        }
        .sheet(isPresented: $showMailView) {
            MailView(subject: $subjectLine)
        }
    }
    
    var requestFeature: some View {
        Button {
            Analytics.shared.log(event: .profile_tapped_roadmap)
            if let url = URL(string: "https://mindgarden.upvoty.com/") {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(alignment:.center) {
                Image(systemName: "hand.raised.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(Clr.darkgreen)
                    .padding(.trailing)
                Text("Request a Feature")
                    .font(Font.fredoka(.medium, size: 20))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    var contactTeam: some View {
        Button {
            if selectedFeedback == .bugReport {
                subjectLine = "I’d like to report a Bug (Please don’t change Subject Line)"
            } else if selectedFeedback == .helpMindGarden {
                subjectLine = "Feedback for the team! (Please don’t change subject line)"
            }
            if MFMailComposeViewController.canSendMail() {
                showMailView = true
            } else {
                mailNeedsSetup = true
            }
        } label: {
            HStack {
                Image(systemName: "envelope.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 20)
                    .foregroundColor(Clr.darkgreen)
                    .padding(.trailing)
                Text(selectedFeedback == .bugReport ? "Report a Bug" : "Give Feedback (We Read Each One)")
                    .font(Font.fredoka(.medium, size: 16))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    struct subscriptionContact: View {
        var title, subject: String
        @Binding var subjectLine: String
        @Binding var showMailView: Bool
        @Binding var mailNeedsSetup: Bool

        var body: some View {
            Button {
                subjectLine = subject
                if MFMailComposeViewController.canSendMail() {
                    showMailView = true
                } else {
                    mailNeedsSetup = true
                }
            } label: {
                HStack {
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Clr.darkgreen)
                        .padding(.trailing)
                    Text(title)
                        .font(Font.fredoka(.medium, size: 16))
                        .foregroundColor(Clr.black2)
                    Spacer()
                }
            }
            .padding()
        }
    }
    
    var rateTheApp: some View {
        Button {
           rateFunc()
        } label: {
            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(Clr.darkgreen)
                    .padding(.trailing)
                Text("Rate the app")
                    .font(Font.fredoka(.medium, size: 20))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    var inviteFriend: some View {
        Button {
            DispatchQueue.main.async {
                withAnimation {
                    sendInvite()
                }
            }
        } label: {
            HStack {
                Image(systemName: "arrowshape.turn.up.right.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 20)
                    .foregroundColor(Clr.darkgreen)
                    .padding(.trailing)
                Text("Invite a Firend")
                    .font(Font.fredoka(.medium, size: 20))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    var gettingStartedGuid: some View {
        Button {
        } label: {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 20)
                    .foregroundColor(Clr.darkgreen)
                    .padding(.trailing)
                Text("Getting Started Guide")
                    .font(Font.fredoka(.medium, size: 20))
                    .foregroundColor(Clr.black2)
                Spacer()
            }
        }
        .padding()
    }
    
    private func rateFunc() {
        Analytics.shared.log(event: .profile_tapped_rate)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
            UserDefaults.standard.setValue(true, forKey: "tappedRate")
        }
    }
    
    func sendInvite() {
        guard let uid = Auth.auth().currentUser?.email else {
            viewRouter.currentPage = .authentication
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
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let shortURL = shortURL {
                urlShare2 = shortURL
            }
            isSharePresented = true
        }
    }
}


struct LeaveFeedback_Previews: PreviewProvider {
    static var previews: some View {
        LeaveFeedback(userModel: UserViewModel(), selectedFeedback: .constant(.helpMindGarden), showFeedbackSheet: .constant(true))
    }
}
