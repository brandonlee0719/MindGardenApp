//
//  NameScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/23/21.
//

import SwiftUI
import OneSignal


struct NameScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @State private var name: String = ""
    @State var isFirstResponder = true
    var body: some View {
        ZStack {
                GeometryReader { g in
                    let width = g.size.width
                    ZStack {
                        Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                        VStack(spacing: -5) {
                            HStack {
                                Img.topBranch
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.screenWidth * 0.6)
                                    .padding(.leading, -20)
                                    .offset(x: -20, y: -10)
                                Spacer()
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 22))
                                    .foregroundColor(Clr.darkgreen)
                                    .padding()
                                    .onTapGesture {
                                        MGAudio.sharedInstance.playBubbleSound()
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation {
                                            arr = []
                                            viewRouter.progressValue -= 0.1
                                            viewRouter.currentPage = .reason
                                        }
                                    }
                                
                            }
                            Spacer()
                            HStack {
                                Img.foxStudy
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 100)
                                    .padding(.trailing, 15)
                                    .neoShadow()
                                VStack {
                                    Text("What's your name?")
                                        .font(Font.fredoka(.bold, size: 26))
                                        .foregroundColor(Clr.darkgreen)
                                        .multilineTextAlignment(.center)
                                        .frame(width: width * 0.55, height: 60)
                                        .minimumScaleFactor(0.05)
                                        .lineLimit(1)
                                    LegacyTextField(text: $name, isFirstResponder: $isFirstResponder)
                                        .padding(15)
                                        .background(
                                            Rectangle()
                                                .foregroundColor(Clr.darkWhite)
                                                .cornerRadius(14)
                                        )
                                        .frame(width: width * 0.55, height: 60)
                                        .oldShadow()
                                        .disableAutocorrection(true)
                                }
                            }.frame(height: 80)
                            Spacer()
                            Button {
                                MGAudio.sharedInstance.playBubbleSound()
                                Analytics.shared.log(event: .name_tapped_continue)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation(.easeOut(duration: 0.3)) {
                                    DispatchQueue.main.async {
                                        if !name.isEmpty {
                                            UserDefaults.standard.set(name, forKey: "name")
                                            viewRouter.progressValue += 0.2
                                            viewRouter.currentPage = .notification
                                            userModel.name = name
                                        }
                                    }
                                }
                            } label: {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Continue 👉")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.fredoka(.bold, size: 20))
                                    ).addBorder(Color.black, width: 1.5, cornerRadius: 24)
                            }.frame(height: 50)
                                .padding()
                                .buttonStyle(NeumorphicPress())
                                .offset(y: 100)
                        }.frame(width: width * 0.9)
                            .padding(.bottom, g.size.height * 0.15)
                    }
                }
                .onAppearAnalytics(event: .screen_load_name)
        }.transition(.move(edge: .trailing))
    }
}

struct NameScene_Previews: PreviewProvider {
    static var previews: some View {
        NameScene()
    }
}

import UIKit
struct LegacyTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String

    public var configuration = { (view: UITextField) in }

    public init(text: Binding<String>, isFirstResponder: Binding<Bool>, configuration: @escaping (UITextField) -> () = { _ in }) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder
    }

    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.autocorrectionType = .no
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        switch isFirstResponder {
        case true: uiView.becomeFirstResponder()
        case false: uiView.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>

        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }

        @objc public func textViewDidChange(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
    }
}
