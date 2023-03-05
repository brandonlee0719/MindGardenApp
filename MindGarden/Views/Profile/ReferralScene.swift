//
//  ReferralScene.swift
//  MindGarden
//
//  Created by Vishal Davara on 27/04/22.
//

import SwiftUI
import FirebaseDynamicLinks
import Firebase

struct ReferralScene: View {
    @EnvironmentObject var userModel: UserViewModel
    @State private var currentPage = 0
    let inviteContactTitle = "Invite Contacts"
    let shareLinkTitle = "🔗 Share Link"
    @Binding var numRefs: Int
    @State var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isSharePresented: Bool = false
    @State private var urlShare2 = URL(string: "https://mindgarden.io")
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        return dateFormatter
    }()
    
    var action: () -> ()
//
//    init(numRefs: Binding<Int>, action: () -> ()) {
//        UIPageControl.appearance().currentPageIndicatorTintColor = Clr.darkgreen.uiColor()
//        UIPageControl.appearance().pageIndicatorTintColor = Clr.lightGray.uiColor()
//        self.numRefs = numRefs
//        self.action = action
//    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Capsule()
                    .fill(Clr.darkWhite)
                    .padding(.horizontal)
                    .overlay(
                        HStack {
                            Img.wateringPot
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40, alignment: .center)
                            Text("\(numRefs) Referrals Sent")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.semiBold, size: 20))
                        }
                    )
                    .frame(width: UIScreen.screenWidth * 0.7, height: 50)
                    .padding(.top, 30)
                    .neoShadow()
                let cardWidth = UIScreen.screenWidth*0.75
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(referralList) { item in
                            ZStack {
                                VStack(spacing: 5) {
                                    item.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 175, height:  150, alignment: .center)
                                        .padding()
                                        .padding(.top, item.image == Img.venusBadge ? 50 : 30)
                                    VStack(spacing: -10) {
                                        Text(item.title)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.semiBold, size: 22))
                                            .frame(width: UIScreen.screenWidth * 0.5, height: 50)
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(2)
                                            .padding(20)
                                        Text(item.subTitle)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.regular, size: 16))
                                            .frame(width: UIScreen.screenWidth * 0.6, height: 75, alignment: .top)
                                            .padding([.bottom, .horizontal])
                                    }.offset(y: -25)
                           
                                }
                                .padding()
                                
                            }.frame(width: cardWidth, height:UIScreen.screenHeight*0.45)
                                .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Clr.brightGreen, lineWidth: 6)
                            )
                            .background(Clr.darkWhite)
                            .cornerRadius(30)
                            .neoShadow()
                            .padding(.vertical)
                        }
                    }
                }
                .content.offset(x: self.offset)
                    .frame(width: cardWidth, height: nil, alignment: .leading)
                    .gesture(DragGesture()
                        .onChanged({ value in
                            self.offset = value.translation.width - cardWidth * CGFloat(self.index)
                        })
                        .onEnded({ value in
                            if abs(value.predictedEndTranslation.width) >= cardWidth / 2 {
                                var nextIndex: Int = (value.predictedEndTranslation.width < 0) ? 1 : -1
                                nextIndex += self.index
                                self.index = nextIndex.keepIndexInRange(min: 0, max: referralList.count - 1)
                            }
                        withAnimation { self.offset = (-cardWidth * CGFloat(self.index)) - CGFloat((self.index * 10)) }
                        })
                    )
                HStack(alignment:.center) {
                    ForEach(0..<referralList.count) { indx in
                        Circle()
                            .fill(indx == self.index ? Clr.brightGreen : Clr.gardenGray)
                            .frame(width: 8, height: 8)
                    }
                }
                
//                Button {
//                } label: {
//                    HStack {
//                        Text(inviteContactTitle)
//                            .foregroundColor(.white)
//                            .font(Font.fredoka(.semiBold, size: 16))
//                            .padding(.trailing)
//                            .lineLimit(1)
//                            .minimumScaleFactor(0.05)
//                    }
//                    .frame(width: UIScreen.screenWidth * 0.7, height:50)
//                    .background(Clr.darkgreen)
//                    .cornerRadius(25)
//                    .onTapGesture {
//
//                    }
//                }
//                .buttonStyle(BonusPress())
                Button { } label: {
                    HStack {
                        Text(shareLinkTitle)
                            .foregroundColor(.black)
                            .font(Font.fredoka(.semiBold, size: 16))
                            .padding(.trailing)
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                    }
                    .frame(width: UIScreen.screenWidth * 0.85, height:50)
                    .background(Clr.yellow)
                    .cornerRadius(24)
                    .onTapGesture {
                        createDynamicLink()
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        action()
                    }
                    .addBorder(.black, width: 1.5, cornerRadius: 24)
                }
                .buttonStyle(BonusPress())
                .padding(.top)
                Text("The average user refers 2.3 people!")
                    .font(Font.fredoka(.regular, size: 18))
                    .foregroundColor(.black)
                    .opacity(0.4)
                Spacer()
            }
            .sheet(isPresented: $isSharePresented) {
                ReferralView(url: $urlShare2)
            }
        }
    }
    
    private func createDynamicLink() {
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
        referralLink?.socialMetaTagParameters?.descriptionText = "📱 Download the app by \(newDateString) to claim your 50 coins"
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


extension Int {
    func keepIndexInRange(min: Int, max: Int) -> Int {
        switch self {
            case ..<min: return min
            case max...: return max
            default: return self
        }
    }
}
