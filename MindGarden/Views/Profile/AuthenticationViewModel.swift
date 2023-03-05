//
//  AuthenticationViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/4/21.
//

import GoogleSignIn
import FirebaseAuth
import Firebase
import FirebaseFirestore
import CryptoKit
import SwiftUI
import AuthenticationServices
import Combine
import Amplitude
import OneSignal
import Purchases
import Paywall
import CryptoKit
import WidgetKit

class AuthenticationViewModel: NSObject, ObservableObject {
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var userModel: UserViewModel
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var forgotEmail: String = ""
    @Published var alertError: Bool = false
    @Published var alertMessage: String = "Please try again using a different email or method"
    @Published var isLoading: Bool = false
    @Published var isSignUp: Bool = true
    @Published var falseAppleId: Bool = false
    @Published var checked = true
    var currentNonce: String?
    var googleIsNew: Bool = true
    let db = Firestore.firestore()
    var appleAlreadySigned: Bool = false
    init(userModel: UserViewModel, viewRouter: ViewRouter) {
        self.userModel = userModel
        self.viewRouter = viewRouter
        super.init()
    }
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }()
    
    var suwa: some View {
        return SignInWithAppleButton(
            //Request
            .signUp,
            onRequest: { [self] request in
                Analytics.shared.log(event: .authentication_tapped_apple)
                request.requestedScopes = [.fullName, .email]
                let nonce = randomNonceString()
                currentNonce = nonce
                request.nonce = sha256(nonce)
            },

            //Completion
            onCompletion: { [self] result in
                isLoading = false
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        guard let nonce = currentNonce else {
                            alertError = true
                            alertMessage = "Email is already in use. Use the sign in page"
                            return
                        }
                        guard let appleIDToken = appleIDCredential.identityToken else {
                            alertError = true
                            return
                        }
                        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                            return
                        }
                        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString,rawNonce: nonce)

                        // User already signed in with this appleId once

                        if (appleIDCredential.email != nil) || UserDefaults.standard.bool(forKey: "falseAppleId")  { // new user
                            if !isSignUp { // login
                                alertError = true
                                alertMessage = "Email is already in use. Use the sign in page"
                                UserDefaults.standard.set(true, forKey: "falseAppleId")
                                isLoading = false
                                falseAppleId = true
                                return
                            } else { // sign up
                                Auth.auth().signIn(with: credential, completion: { [self] (user, error) in
                                    if (error != nil) {
                                        alertError = true
                                        alertMessage = error?.localizedDescription ?? "Email is already in use. Use the sign in page"
                                        isLoading = false
                                        return
                                    }
                                    //User never used this appleid before
                                    createUser()
                                    withAnimation {
                                        UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                                        UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                            
                                        goToHome()
                                    }
                                })
                            }
                        } else { // used this id before
                            if isSignUp {
                                alertError = true
                                alertMessage = "Please use the sign in page"
                                isLoading = false
                                return
                            } else { // login
                                Auth.auth().signIn(with: credential, completion: { [self] (user, error) in
                                    if (error != nil) {
                                        alertError = true
                                        alertMessage = error?.localizedDescription ?? "Email is already in use. Use the sign in page"
                                        isLoading = false
                                        print(error?.localizedDescription ?? "high roe")
                                        return
                                }

                                    withAnimation {
                                        UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                                        UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                                        goToHome()
                                    }
                                })
                            }
                            return
                        }
                    default:
                        break

                    }
                default:
                    break
                }
            }
        )
    }
     var siwa: some View {
        return Group {
            if #available(iOS 14.0, *) {
                SignInWithAppleButton(
                    //Request
                    .signIn,
                    onRequest: { [self] request in
                        Analytics.shared.log(event: .authentication_tapped_apple)
                        request.requestedScopes = [.fullName, .email]
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.nonce = sha256(nonce)
                    },

                    //Completion
                    onCompletion: { [self] result in
                        isLoading = false
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                guard let nonce = currentNonce else {
                                    alertError = true
                                    alertMessage = "Email not associated with an account"
                                    return
                                }
                                guard let appleIDToken = appleIDCredential.identityToken else {
                                    alertError = true
                                    return
                                }
                                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                    return
                                }
                                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString,rawNonce: nonce)

                                // User already signed in with this appleId once

                                if (appleIDCredential.email != nil) || UserDefaults.standard.bool(forKey: "falseAppleId")  { // new user
                                    if !isSignUp { // login
                                        alertError = true
                                        alertMessage = "Email is not associated with account"
                                        UserDefaults.standard.set(true, forKey: "falseAppleId")
                                        isLoading = false
                                        falseAppleId = true
                                        return
                                    } else { // sign up
                                        Auth.auth().signIn(with: credential, completion: { [self] (user, error) in
                                            if (error != nil) {
                                                alertError = true
                                                alertMessage = error?.localizedDescription ?? "Email is not associated with account"
                                                isLoading = false
                                                return
                                            }
                                            //User never used this appleid before
                                            createUser()
                                            withAnimation {
                                                UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                                                UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                                                getData()
                                            }
                                        })
                                    }
                                } else { // used this id before
                                    if isSignUp {
                                        alertError = true
                                        alertMessage = "Email is not associated with account"
                                        isLoading = false
                                        return
                                    } else { // login
                                        Auth.auth().signIn(with: credential, completion: { [self] (user, error) in
                                            if (error != nil) {
                                                alertError = true
                                                alertMessage = error?.localizedDescription ?? "Email is not associated with account"
                                                isLoading = false
                                                return
                                            }

                                            withAnimation {
                                                UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                                                UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                                                getData()
                                            }
                                        })
                                    }
                                    return
                                }
                            default:
                                break

                            }
                        default:
                            break
                        }
                    }
                )
            } else {
                // Fallback on earlier versions
            }
        }
    }

    private func goToHome() {
        OneSignal.sendTag("first_name", value: UserDefaults.standard.string(forKey: "name") ?? "")
        if isSignUp && checked {
            Analytics.shared.log(event: .authentication_signuped_newsletter)
            OneSignal.sendTag("newsletter", value: "true")
        }
        
        if isSignUp {
            let identify = AMPIdentify()
                .set("sign_up_date", value: NSString(utf8String: dateFormatter.string(from: Date())))
            Amplitude.instance().identify(identify ?? AMPIdentify())
            OneSignal.sendTag("signedUp", value: "true")
            Analytics.shared.log(event: .authentication_signup_successful)
        } else {
            Analytics.shared.log(event: .authentication_signin_successful)
            UserDefaults.standard.setValue(true, forKey: "showedChallenge")
            UserDefaults.standard.setValue(false, forKey: "newUser")
        }
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        withAnimation {
            if fromPage == "journal" {
                viewRouter.currentPage = .journal
            } else {
                if fromOnboarding {
                    viewRouter.currentPage = .garden
                    fromOnboarding = false
                } else {
                    viewRouter.currentPage = .meditate
                }
            }
         
        }
    }
    
    func checkStatus(){
            if let user = GIDSignIn.sharedInstance.currentUser {
                Auth.auth().fetchSignInMethods(forEmail: user.profile?.email ?? "", completion: { [weak self]
                    (providers, error) in
                    if let error = error {
                        self?.alertError = true
                        self?.alertMessage = error.localizedDescription
                        self?.isLoading = false
                    } else if let providers = providers {
                        if providers.count != 0 {
                            self?.googleIsNew = false
                        }
                        self?.firebaseAuthentication(withUser: user)
                    } else {
                        if let signup = self?.isSignUp, !signup {
                            self?.googleIsNew = true
                            self?.alertError = true
                            self?.alertMessage = "Email is not associated with account"
                            self?.isLoading = false
                            return
                        } else {
                            self?.firebaseAuthentication(withUser: user)
                        }
                    }
                })
            }else{
                self.isLoading = false
            }
        }
        
        func check(){
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                self.checkStatus()
            }
        }

     func signInWithGoogle() {
         isLoading = true
         guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}

         let signInConfig = GIDConfiguration.init(clientID: (FirebaseApp.app()?.options.clientID)!)
         GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController,
            callback: { [weak self] user, error in
                if let error = error {
                    self?.isLoading = false
                    print(error.localizedDescription)
                }
                self?.checkStatus()
            }
         )
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}

extension AuthenticationViewModel {
    private func firebaseAuthentication(withUser user: GIDGoogleUser) {
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken ?? "", accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] (_, error) in
            self?.isLoading = false
            UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
            if let _ = error {
                self?.alertError = true
                self?.alertMessage = error?.localizedDescription ?? "Email not associated with an account"
            } else {
                if self?.googleIsNew ?? false {
                    self?.createUser()
                    self?.goToHome()
                } else {
                    self?.getData()
                }
                withAnimation {
                    UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                }
                self?.alertError = false
            }
        }
    }
}

//MARK: - regular sign up
extension AuthenticationViewModel {
    var validatedPassword: AnyPublisher<String?, Never> {
        return $password
            .map { $0.count < 6 ? "invalid" : $0 }
            .eraseToAnyPublisher()
    }

    var validatedEmail: AnyPublisher<String?, Never> {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return $email
            .map { !emailPredicate.evaluate(with: $0) ? "invalid"  : $0}
            .eraseToAnyPublisher()
    }

    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        validatedEmail.combineLatest(validatedPassword) { email, password in
            guard let mail = email, let pwd = password else { return nil }
            return (mail, pwd)
        }
        .eraseToAnyPublisher()
    }

    func signUp() {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { [self] result,error in
            isLoading = false
            if error != nil  {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Please use the sign in page"
                return
            }
            createUser()
            alertError = false
            withAnimation {
                UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                goToHome()
            }
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
//            isLoading = false
            if error != nil {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Email not associated with an account, try Sign In With Apple"
                return
            }
            alertError = false
            withAnimation {
                UserDefaults.standard.setValue(true, forKey: K.defaults.loggedIn)
                if isSignUp {
                    
                } else {
                    getData()
                    UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)

                }
                UserDefaults.standard.setValue("432hz", forKey: "sound")
            }
        }
    }

    func forgotPassword() {
        Auth.auth().sendPasswordReset(withEmail: forgotEmail) { [self] error in
            isLoading = false
            if error != nil {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
            } else {
                alertError = false
            }
        }
    }

    func createUser() {
        if let email = Auth.auth().currentUser?.email {
            OneSignal.setEmail(email)
            OneSignal.setExternalUserId(email)
//            if let onesignalId = OneSignal.getUserID() {
//                Purchases.shared.setOnesignalID(onesignalId)
//            }
            if let onesignalId = OneSignal.getDeviceState().userId {
                   Purchases.shared.setOnesignalID(onesignalId)
            }
            Amplitude.instance().setUserId(email)
            Purchases.shared.logIn(email) { info, bool, error in }
            Paywall.identify(userId: email)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        var date = dateFormatter.string(from: Date())
        if UserDefaults.standard.string(forKey: K.defaults.referred) != "" && UserDefaults.standard.string(forKey: K.defaults.referred) != nil  {
            // create user session
            let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: 2, to: Date())
            date = dateFormatter.string(from: newDate ?? Date())
        }
        
        if let referredEmail = UserDefaults.standard.string(forKey: K.defaults.referred) {
            if referredEmail != "" {
                var refDate = ""
                var refStack = 0
                //update referred stack for user that referred
                db.collection(K.userPreferences).document(referredEmail).getDocument { [self] (snapshot, error) in
                    if let document = snapshot, document.exists {
                        if let stack = document["referredStack"] as? String {
                            let plusIndex = stack.indexInt(of: "+") ?? 0
                            refDate = stack.substring(to: plusIndex)
                            refStack = Int(stack.substring(from: plusIndex + 1)) ?? 0
                        }
                        var coins = 0
                        if let fbCoins = document["coins"] as? Int {
                            coins = fbCoins
                        }
                        var dte = dateFormatter.date(from: refDate == "" ? dateFormatter.string(from: Date()) : refDate)
                        if dte ?? Date() < Date() {
                            dte = Date()
                        }
                        let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: 2, to: dte ?? Date())
                        let newDateString = dateFormatter.string(from: newDate ?? Date())
                        refStack += 1
                        coins += 500
                        let referredStack = newDateString+"+"+String(refStack)
                        db.collection(K.userPreferences).document(referredEmail)
                            .updateData([
                                "referredStack": referredStack,
                                "coins": coins
                        ])
                    }
                }

//                var dte = dateFormatter.date(from: refDate == "" ? dateFormatter.string(from: Date()) : refDate)
//                if dte ?? Date() < Date() {
//                    dte = Date()
//                }
//                let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: 2, to: dte ?? Date())
//                let newDateString = dateFormatter.string(from: newDate ?? Date())
//                refStack += 1
//                let referredStack = newDateString+"+"+String(refStack)
//                db.collection(K.userPreferences).document(referredEmail)
//                    .updateData([
//                        "referredStack": referredStack
//                ])
            }
        }
        var thisGrid = [String: [String:[String:[String:Any]]]]()
        if let gridd = UserDefaults.standard.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
            thisGrid = gridd
        }
        var favs = [Int]()
        if let favorites = UserDefaults.standard.array(forKey: K.defaults.favorites) as? [Int] {
            favs = favorites
        }
        var uniquePlants = ["White Daisy", "Red Tulip"]
        if let plantArr = UserDefaults.standard.array(forKey: K.defaults.plants) as? [String]{
             uniquePlants = Array<String>(Set(plantArr))
        }
        var compMeds = [""]
        if let comMeds = UserDefaults.standard.array(forKey: K.defaults.completedMeditations)  as? [String] {
            compMeds = comMeds
        }
        
        var storySegs = [""]
        if let storySegments = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
            storySegs = storySegments
        }
        
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).setData([
                "name": UserDefaults.standard.string(forKey: "name") ?? "Name",
                "coins": UserDefaults.standard.integer(forKey: "coins"),
                "joinDate": UserDefaults.standard.string(forKey: "joinDate") ?? "",
                "totalSessions": UserDefaults.standard.integer(forKey: "allTimeSessions"),
                "totalMins": UserDefaults.standard.integer(forKey: "allTimeMinutes"),
                "gardenGrid": thisGrid,
                "plants": uniquePlants,
                "completedMeditations": compMeds,
                "experience": UserDefaults.standard.string(forKey: "experience") ?? "",
                K.defaults.lastStreakDate: UserDefaults.standard.string(forKey: K.defaults.lastStreakDate) ?? "",
                "streak": UserDefaults.standard.string(forKey: "streak") ?? "",
                K.defaults.seven: UserDefaults.standard.integer(forKey: K.defaults.seven),
                K.defaults.thirty: UserDefaults.standard.integer(forKey: K.defaults.thirty),
                K.defaults.dailyBonus: UserDefaults.standard.string(forKey: K.defaults.dailyBonus) ?? "",
                "referredStack": "\(date)+0",
                "isPro": UserDefaults.standard.bool(forKey: "isPro"),
                "favorited": favs,
                "storySegments": storySegs,
                K.defaults.userCoinCollectedLevel: UserDefaults.standard.integer(forKey: K.defaults.userCoinCollectedLevel)
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    UserDefaults.standard.setValue("432hz", forKey: "sound")
                    self.userModel.getSelectedPlant()
                    self.userModel.name = UserDefaults.standard.string(forKey: "name") ?? ""
                }
            }
        }
        
        userModel.name = UserDefaults.standard.string(forKey: "name") ?? "name"
        userModel.joinDate = formatter.string(from: Date())
        userModel.referredStack = "\(date)+0"
    }

    func getData() {
        UserDefaults.standard.setValue(true, forKey: "day7")
        UserDefaults.standard.setValue(true, forKey: "showWidget")
        UserDefaults.standard.setValue(true, forKey: "signedIn")
        UserDefaults.standard.setValue(UUID().uuidString, forKey: K.defaults.giftQuotaId)
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let name = document[K.defaults.name] {
                        UserDefaults.standard.setValue(name, forKey: K.defaults.name)
                    }
                    if let fbFav = document[K.defaults.favorites] {
                        UserDefaults.standard.setValue(fbFav, forKey: K.defaults.favorites)
                    }
                    if let fbRecents = document[K.defaults.completedMeditations] {
                        UserDefaults.standard.setValue(fbRecents, forKey: K.defaults.completedMeditations)
                    }
                    
                    if let joinDate = document[K.defaults.joinDate] {
                        UserDefaults.standard.setValue(joinDate, forKey: K.defaults.joinDate)
                    }
                    
                    if let isPro = document["isPro"] {
                        UserDefaults.standard.setValue(isPro, forKey: "isPro")
                    }
                    
                    if let experience = document["experience"] {
                        UserDefaults.standard.setValue(experience, forKey: "experience")
                    }
                    
                    if let storySegs = document["storySegments"] as? [String] {
                        storySegments = Set(storySegs)
                        StorylyManager.refresh()
                        UserDefaults.standard.setValue(storySegs, forKey: "oldSegments")
                        UserDefaults.standard.setValue(storySegs, forKey: "storySegments")
                    }
                    
                    if let stack = document["referredStack"] as? String {
                        let plusIndex = stack.indexInt(of: "+") ?? 0
                        let numRefs = Int(stack.substring(from: plusIndex + 1)) ?? 0
                        
                        if numRefs > UserDefaults.standard.integer(forKey: "numRefs") {
                            UserDefaults.standard.setValue(numRefs, forKey: "numRefs")
                        }
                    }
                    Purchases.configure(withAPIKey: "wuPOzKiCUvKWUtiHEFRRPJoksAdxJMLG", appUserID: email)
                    UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                    UserDefaults.standard.setValue("432hz", forKey: "sound")
                    DispatchQueue.main.async {
                        Purchases.shared.logIn(email) { info, bool, error in
                            if info?.entitlements.all["isPro"]?.isActive == true {
                                UserDefaults.standard.setValue(true, forKey: "isPro")
                                UserDefaults(suiteName: K.widgetDefault)?.setValue(true, forKey: "isPro")
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                            self.userModel.updateSelf()
                            SceneDelegate.gardenModel.updateSelf()
                            SceneDelegate.bonusModel.updateBonus()
                            SceneDelegate.medModel.updateSelf()
                            self.goToHome()
                        }
                    }
                }
            }
        }
 
    }
}

extension AuthenticationViewModel {
    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}
