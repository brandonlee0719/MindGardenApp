//
//  PromptsTab.swift
//  MindGarden
//
//  Created by Vishal Davara on 29/06/22.
//

import SwiftUI
import Lottie
import Amplitude
import Combine
import Firebase
import FirebaseStorage

var placeholderReflection = ""
var placeholderQuestion = "What's one thing you're grateful for right now?"

struct JournalView: View, KeyboardReadable {
    @State private var text: String = placeholderReflection
    @State private var contentKeyVisible: Bool = true
    @State private var showPrompts = false
    @State private var showRecs = false
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var showtextFieldToolbar = false
    @State private var coin = 0
    @State var question = ""
    @State var recs = [-4,71,23]
    @State var divider = 1
    
    @State private  var imgUrl: String?
    var data: [String: String]?
    @State var fromProfile = false
    
    @available(iOS 15.0, *)
    @FocusState private var isFocused: Bool
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showLoading: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        LoadingView(isShowing: $showLoading) {
            ZStack(alignment:.top) {
                Clr.darkWhite.ignoresSafeArea()
                VStack(spacing:0) {
                    Spacer()
                        .frame(height:50)
                    HStack {
                        Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                            .font(Font.fredoka(.medium, size: 20))
                            .foregroundColor(Clr.blackShadow)
                            .multilineTextAlignment(.center)
                            .opacity(0.5)
                        Spacer()
                        
                        if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood" {
                            CloseButton() {
                                withAnimation {
                                    if #available(iOS 15.0, *) {
                                        isFocused = false
                                    }
                                    Analytics.shared.log(event: .journal_tapped_x)
                                    //                                placeholderReflection = "\"I write because I don’t know what I think until I read what I say.\"\n— Flannery O’Connor"
                                    placeholderQuestion = "What's one thing you're grateful for right now?"
                                    presentationMode.wrappedValue.dismiss()
                                    viewRouter.currentPage = viewRouter.previousPage
                                }
                            }.padding(.leading, 5)
                        }
                    }.padding(.leading, 5)
                    if userModel.elaboration != "" {
                        HStack {
                            Mood.getMoodImage(mood: userModel.selectedMood)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                            Text(userModel.elaboration)
                                .font(Font.fredoka(.medium, size: 14))
                                .foregroundColor(Clr.black2)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.black, lineWidth: 1.5)
                                )
                                .frame(minWidth: UIScreen.screenWidth * 0.175)
                                .padding(.leading, 10)
                        }
                        .frame(width: UIScreen.screenWidth - 60, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.vertical, 10)
                    }
                    GeometryReader { g in
                        VStack(spacing: 15) {
                            Text(question)
                                .font(Font.fredoka(.bold, size: 24))
                                .foregroundColor(Clr.black2)
                                .lineLimit(3)
                                .frame(width: UIScreen.screenWidth - 60, alignment: .leading)
                                .padding(.leading, 5)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                ZStack {
                                    VStack {
                                        Group {
                                            if #available(iOS 16.0, *) {
                                                TextEditor(text: $text)
                                                    .focused($isFocused)
                                                    .scrollContentBackground(.hidden) // <- Hide it
                                                    .background(Clr.darkWhite)
                                                    .font(Font.fredoka(.medium, size: 20))
                                                    .foregroundColor(Clr.black2)
                                            } else if #available(iOS 15.0, *) {
                                                TextEditor(text: $text)
                                                    .focused($isFocused)
                                                    .background(Clr.darkWhite)
                                                    .font(Font.fredoka(.medium, size: 20))
                                                    .foregroundColor(Clr.black2)
                                            }
                                        }
                                        .disableAutocorrection(false)
                                        .foregroundColor(Clr.black2)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -20, trailing: 0))
                                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                            withAnimation {
                                                contentKeyVisible = newIsKeyboardVisible
                                            }
                                        }.onTapGesture {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            //                                    if text == placeholderReflection {
                                            //                                        text = ""
                                            //                                    }
                                        }
                                        
                                        .frame(height: g.size.height * (question == placeholderQuestion ? 0.3 : (question.count >= 64 ? 0.225 : question.count >= 32 ? 0.275 : 0.325)))
                                        if fromProfile, let img = imgUrl, !img.isEmpty {
                                            UrlImageView(urlString: img)
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height:200)
                                        } else if let img = inputImage, let image = Image(uiImage: img) {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height:200)
                                                .padding()
                                        }
                                    }
                                }
                            }
                            .transition(.move(edge: .leading))
                        }
                    }
                }
                .frame(width: UIScreen.screenWidth - 60, alignment: .leading)
                bottomPanel
                    .padding(.bottom)
            }
            .offset(x: -5)
            .onChange(of:text) { txt in
                //                if text.contains(placeholderReflection) {
                //                    self.text = self.text.replacingOccurrences(of: placeholderReflection, with: "")
                //                }
                
                
                if text.contains(placeholderReflection) {
                    self.text = self.text.replacingOccurrences(of: placeholderReflection, with: "")
                }
                
                if text.count >= 5 && text.count < 10 {
                    coin = max(1,5/divider)
                } else if text.count >= 10 && text.count < 25 {
                    coin = max(1,10/divider)
                } else if text.count >= 25 && text.count < 50 {
                    coin = max(1,20/divider)
                } else if text.count >= 50 && text.count < 100 {
                    coin = max(1,30/divider)
                } else if text.count >= 100 && text.count < 200 {
                    coin = max(1,40/divider)
                } else if text.count >= 200 && text.count < 300 {
                    coin = max(1,50/divider)
                } else if text.count >= 300 {
                    coin = max(1,50/divider)
                } else {
                    coin = 0
                }
            }
            .onAppear {
                if !fromProfile {
                    text = ""
                } else {
                    if let journal = data?["gratitude"] {
                        if let img = data?["image"], !img.isEmpty {
                            imgUrl = img
                        }
                    }
                }
                if let gratitudes = gardenModel.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[K.defaults.journals]  as? [[String: String]] {
                    divider = gratitudes.count * 3
                }
                if #available(iOS 15.0, *) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFocused = true
                    }
                }
                recs = Meditation.getRecsFromMood(selectedMood: userModel.selectedMood, elaboration: userModel.elaboration)
                question = placeholderQuestion
                UITextView.appearance().backgroundColor = .clear
            }
            .ignoresSafeArea()
            .sheet(isPresented: $showPrompts) {
                PromptsView(question: $question)
            }
            .fullScreenCover(isPresented: $showRecs) {
                RecommendationsView(recs: $recs, coin: $coin)
            }
            .transition(.move(edge: .trailing))
            .onDisappear {
                fromProfile = false
                if #available(iOS 15.0, *) {
                    isFocused = false
                }
            }
            .onAppearAnalytics(event: .screen_load_journal)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
        }
    }
    var bottomPanel: some View {
        ZStack(alignment:.top) {
            VStack {
                Spacer()
                if !fromProfile {
                    
                    HStack(alignment: .center) {
                        if !fromProfile {
                            Text("\(coin)")
                                .font(Font.fredoka(.semiBold, size: 20))
                                .foregroundColor(.black)
                                .padding(.leading)
                            Img.coin
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height:20)
                                .foregroundColor(.black)
                                .neoShadow()
                            
                        }
                        attachmentButton
                        Spacer()
                        shuffleButton
                            .rightShadow()
                        promptButton
                            .rightShadow()
                        doneButton
                        
                    }
                    .background(
                        Capsule()
                            .fill(Clr.yellow)
                            .neoShadow()
                    )
                    .padding(.horizontal,0)
                    .padding(.bottom)
                    .KeyboardAwarePadding()
                }
                Spacer()
                    .frame(height:50)
            }
        }
        .frame(width: UIScreen.screenWidth - 60, alignment: .center)
    }
    var attachmentButton: some View {
        Button {
            if ((Auth.auth().currentUser?.email) != nil) {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showingImagePicker = true
            } else {
                fromPage = "journal"
                viewRouter.currentPage = .authentication
            }
 
        } label: {
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Clr.black1)
                .aspectRatio(contentMode: .fit)
                .frame(width:25, height: 25)
                .padding(.trailing)
        }
    }
    var shuffleButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation {
                Analytics.shared.log(event: .journal_tapped_shuffle)
                question = Journal.prompts.shuffled()[0].description
            }
        } label: {
            Image(systemName: "shuffle")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Clr.black2)
                .aspectRatio(contentMode: .fit)
                .frame(width:25, height: 25)
                .padding(.trailing, 12)
        }.disabled(fromProfile)
    }
    var promptButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation {
                if !fromProfile {
                    Analytics.shared.log(event: .journal_tapped_prompts)
                    showPrompts = true
                }
            }
        } label: {
            Image(systemName: "lightbulb")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Clr.redGradientBottom)
                .aspectRatio(contentMode: .fit)
                .frame(width:25, height: 25)
                .padding(.trailing, 12)
            //            Text("Prompts")
            //                .font(Font.fredoka(.bold, size: 20))
            //                .foregroundColor(Clr.redGradientBottom)
            //                .multilineTextAlignment(.center)
            //                .padding(.trailing)
            //                .minimumScaleFactor(0.5)
            //                .lineLimit(1)
        }.frame(height: 35)
            .neoShadow()
    }
    var doneButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if !text.isEmpty, !showLoading {
                showLoading = true
                if let img = inputImage {
                    storeImage(data: img.jpegData(compressionQuality: 0.3))
                } else {
                    updateJournelData(url:"")
                }
            }
        } label: {
            HStack {
                Text("Done")
                    .foregroundColor(.white)
                    .font(Font.fredoka(.semiBold, size: 20))
                    .padding()
            }
            .frame(width:120, height: 35)
            .background(Clr.brightGreen.neoShadow())
            .cornerRadius(24)
        }
    }
    
    private func storeImage(data:Data?) {
        guard let data = data else {
            return
        }
        if ((Auth.auth().currentUser?.email) != nil) {
            DispatchQueue.main.async {
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let id = UUID().uuidString
                let imagesRef = storageRef.child("journelImages/img_\(id).jpg")
                
                imagesRef.putData(data) { (metadata, error) in
                    guard error == nil else {
                        showLoading = false
                        print(error as Any)
                        return
                    }
                    
                    imagesRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print(error as Any)
                            updateJournelData(url:"")
                            return
                        }
                        updateJournelData(url:downloadURL.absoluteString)
                    }
                }
            }
        } else {
            let id = UUID().uuidString
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let directoryPath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = directoryPath.appendingPathComponent("journelImages/img_\(id).jpg")
            print("url : \(url)")
            do {
                try data.write(to: url)
            } catch {
                print("Unable to Write Image Data to Disk")
                print(error.localizedDescription)
                showLoading = false
            }
            updateJournelData(url:url.path)
        }
    }
    
    private func updateJournelData(url:String){
        if #available(iOS 15.0, *) {
            isFocused = false
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        var num = UserDefaults.standard.integer(forKey: "numGrads")
        num += 1
        let identify = AMPIdentify()
            .set("num_gratitudes", value: NSNumber(value: num))
        Amplitude.instance().identify(identify ?? AMPIdentify())
        if num == 30 {
            userModel.willBuyPlant = Plant.badgePlants.first(where: { $0.title == "Camellia" })
            userModel.buyPlant(unlockedStrawberry: true)
            userModel.triggerAnimation = true
        }
        gardenModel.isGratitudeDone = true
        UserDefaults(suiteName: K.widgetDefault)?.setValue((Date().toString(withFormat: "MMM dd, yyyy")), forKey: "lastJournel")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "mood" {
                UserDefaults.standard.setValue("gratitude", forKey: K.defaults.onboarding)
            }
            UserDefaults.standard.setValue(num, forKey: "numGrads")
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "mood" {
                UserDefaults.standard.setValue("gratitude", forKey: K.defaults.onboarding)
            }
            Analytics.shared.log(event: .gratitude_tapped_done)
            var journalObj = [String: String]()
            journalObj["timeStamp"] = Date.getTime()
            journalObj["gratitude"] = text
            journalObj["question"] =  question
            if !url.isEmpty {
                journalObj["image"] =  url
            }
            userModel.coins += coin
            gardenModel.save(key: K.defaults.journals, saveValue: journalObj, coins: userModel.coins)
            withAnimation {
                if moodFirst {
                    showRecs = true
                    moodFirst = false
                } else {
                    viewRouter.currentPage = .meditate
                }
                placeholderQuestion = "What's one thing you're grateful for right now?"
                showLoading = false
            }
            //                                    placeholderReflection = "\"I write because I don’t know what I think until I read what I say.\"\n— Flannery O’Connor"
            
        }
    }
}




struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height - 60 },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0)

                }
        ).eraseToAnyPublisher()
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) {
                self.keyboardHeight = $0
                if $0 == 0 {
                    print("juice")
                }
            }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}
extension UIImage {
    var base64: String? {
        guard let imageData = self.jpegData(compressionQuality: 0.3) else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
}

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
