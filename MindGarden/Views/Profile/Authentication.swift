//
//  Register.swift
//  MindGarden
//
//  Created by Dante Kim on 7/3/21.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Paywall

var fromOnboarding = false
struct Authentication: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var alertError = false
    @State private var showForgotAlert = false
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var signUpDisabled = true
    @State private var focusedText = false

    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
    }
    

    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            NavigationView {
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 0)  {
                        Text(viewModel.isSignUp ? "Sign Up." : "Sign In.")
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.bold, size: 32))
                            .padding()
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Clr.darkWhite)
                                .neoShadow()
                                .padding(20)
                            HStack {
                                TextField("Email", text: $viewModel.email, onEditingChanged: { focused in
                                    withAnimation {
                                        focusedText = focused
                                    }
                                })
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.bold, size: 20))
                                .padding(.leading, 40)
                                .padding(.trailing, 60)
                                Image(systemName: isEmailValid ? "xmark" : "checkmark")
                                    .foregroundColor(isEmailValid ? Color.red : Clr.brightGreen)
                                    .offset(x: -40)
                                    .onReceive(viewModel.validatedEmail) {
                                        self.isEmailValid = $0 == "invalid"
                                    }
                            }
                        }
                        .frame(height: 100)
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Clr.darkWhite)
                                .neoShadow()
                                .padding(.horizontal, 20)
                            HStack {
                                SecureField("Password (6+ characters)", text: $viewModel.password)
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.bold, size: 20))
                                    .padding(.leading, 40)
                                    .padding(.trailing, 60)
                                    .disableAutocorrection(true)
                                Image(systemName: isPasswordValid ? "xmark" : "checkmark")
                                    .foregroundColor(isPasswordValid ? Color.red : Clr.brightGreen)
                                    .offset(x: -40)
                                    .onReceive(viewModel.validatedPassword) {
                                        self.isPasswordValid = $0 == "invalid"
                                    }
                            }
                        }
                        .frame(height: 60)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            //                            viewModel.isLoading = true
                            if viewModel.isSignUp {
                                viewModel.signUp()
                            } else {
                                viewModel.signIn()
                            }
                        } label: {
                            ZStack(alignment: .center) {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(signUpDisabled ? Color.gray.opacity(0.5) : Clr.brightGreen)
                                    .neoShadow()
                                Text(viewModel.isSignUp ? "Register" : "Login")
                                    .foregroundColor(Color.white)
                                    .font(Font.fredoka(.bold, size: 20))
                                    .padding()
                            }
                            .padding(20)
                            .frame(maxHeight: 100)
                            .disabled(true)
                        }.disabled(signUpDisabled)
                            .onReceive(viewModel.validatedCredentials) {
                                guard let credentials = $0 else {
                                    self.signUpDisabled = true
                                    return
                                }
                                let (_, validPassword) = credentials
                                guard validPassword != "invalid"  else {
                                    self.signUpDisabled = true
                                    return
                                }
                                self.signUpDisabled = false
                            }
                        
                        VStack {
                            
                            if viewModel.isSignUp {
                                HStack {
                                    CheckBoxView(checked: $viewModel.checked)
                                        .frame(height: 45)
                                    Text("Sign me up for the MindGarden Newsletter 🗞")
                                        .font(Font.fredoka(.medium, size: 18))
                                        .foregroundColor(Clr.black2)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.5)
                                }.frame(height: 60)
                                    .padding(.horizontal, 20)
                            }
                            if !viewModel.isSignUp {
                                Text("Forgot Password?")
                                    .font(Font.fredoka(.medium, size: 18))
                                    .foregroundColor(.blue)
                                    .underline()
                                    .padding(5)
                                    .onTapGesture {
                                        Analytics.shared.log(event: .authentication_tapped_forgot_password)
                                        showForgotAlert = true
                                    }
                            }
                            Divider().padding(.bottom, 15)
                        }
                        viewModel
                            .siwa
                            .padding(20)
                            .padding(.horizontal, 20)
                            .frame(height: 100)
                            .oldShadow()
                            .disabled(viewModel.falseAppleId)
                        Img.siwg
                            .resizable()
                            .aspectRatio(contentMode: K.isPad() ? .fit : .fill)
                            .padding(40)
                            .frame(height: K.isPad() ? 250 : 70)
                            .neoShadow()
                            .onTapGesture {
                                Analytics.shared.log(event: .authentication_tapped_google)
                                viewModel.signInWithGoogle()
                            }
                        //                        Button {
                        //                            if !isSignUp {
                        //                            }
                        //                            self.isSignUp.toggle()
                        //                            viewModel.isSignUp = self.isSignUp
                        //                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        //                        } label: {
                        //                            Capsule()
                        //                                .fill(Clr.darkWhite)
                        //                                .overlay(
                        //                                    Text(isSignUp ? "Already have an account" : "Sign up for an account")
                        //                                        .foregroundColor(Clr.darkgreen)
                        //                                        .font(Font.fredoka(.bold, size: 18))
                        //                                )
                        //                        }.frame(height: 50)
                        //                            .padding(.horizontal, 40)
                        //                            .padding(.top, 20)
                        //                            .buttonStyle(NeumorphicPress())
                        
                        Spacer()
                    }
                    .background(Clr.darkWhite)
                    .alert(isPresented: $viewModel.alertError) {
                        Alert(title: Text("Something went wrong"), message:
                                Text(viewModel.alertMessage)
                              , dismissButton: .default(Text("Got it!")))
                    }
                    .alert(isPresented: $showForgotAlert, TextAlert(title: "Reset Password", action: {
                        if $0 != nil {
                            viewModel.forgotEmail = $0 ?? ""
                            viewModel.isLoading = true
                            viewModel.forgotPassword()
                        }
                    }))
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarItems(leading:
                                            Img.topBranch
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth * 0.6, height: 250)
                        .padding(.leading, -20)
                        .offset(y: -10)
                        .opacity(focusedText ? 0.1 : 1),
                                        trailing: Image(systemName: "arrow.backward")
                        .font(.system(size: 22))
                        .foregroundColor(Clr.darkgreen)
                        .edgesIgnoringSafeArea(.all)
                        .padding()
                        .onTapGesture {
                            withAnimation {
                                presentationMode.wrappedValue.dismiss()
                            }
                        })
                    .navigationBarBackButtonHidden(true)
                }
            }
        }.onDisappear {
                if tappedSignIn {
                    userModel.updateSelf()
                    gardenModel.updateSelf()
                    medModel.updateSelf()
                }
            }

            .onAppear {
                DispatchQueue.main.async {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                //                viewModel.isLoading = true
                if viewModel.isSignUp {
                    Analytics.shared.log(event: .screen_load_onboarding_signup)
                } else {
                    Analytics.shared.log(event: .screen_load_onboarding_signin)
                }
                if !tappedSignIn {
                    viewModel.falseAppleId = false
                }
            }
        }
}


//MARK: - preview
struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Authentication(viewModel: AuthenticationViewModel(userModel: UserViewModel(), viewRouter: ViewRouter()))
    }
}
