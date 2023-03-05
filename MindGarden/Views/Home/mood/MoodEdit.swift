//
//  MoodEdit.swift
//  MindGarden
//
//  Created by Vishal Davara on 21/09/22.
//

import SwiftUI

struct EditMoods: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var moodelaborate: MoodElaborateModel
    @State var mood:Mood
    @Binding var subMoodList:[MoodList]
    @State var text: String = ""
    @State private var showAlert = false
    var body: some View {
        ZStack {
            Clr.darkWhite
                .ignoresSafeArea()
            VStack {
                HStack() {
                    Spacer()
                    CloseButton() {
                        presentationMode.wrappedValue.dismiss()
                    }.padding(.trailing,20)
                }
                .frame(width: UIScreen.screenWidth)
                HStack() {
                    Text("Feelings")
                        .font(Font.fredoka(.bold, size: 20))
                        .foregroundColor(Clr.black2)
                }
                HStack {
                    TextField("Add New Feeling", text: $text)
                        .padding()
                        .frame(height:40)
                        .addBorder(.black, width: 1.5, cornerRadius: 10)
                    addNewButton
                }
                .padding(20)
                Spacer()
                if let subMoodList = subMoodList {
                    List {
                        ForEach(subMoodList) { item in
                            HStack {
                                Button {
                                    self.subMoodList.removeAll { $0.id == item.id }
                                    moodelaborate.deleteSubmood(submood: item)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .resizable()
                                        .foregroundColor(Clr.gardenRed)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 25)
                                }.buttonStyle(NeoPress())
                                
                                Text(item.subMood)
                                    .font(Font.fredoka(.bold, size: 20))
                                    .foregroundColor(Clr.black2)
//                                TextField("", text: .constant(item.subMood))
//                                    .font(Font.fredoka(.bold, size: 20))
//                                    .foregroundColor(Clr.black2)
//                                    .frame(height:30)
//                                    .padding(3)

                            }.padding()
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Already Exist!"), message: Text("Feeling you are trying to add is already available in the list!"))
        }
    }
    
    var addNewButton: some View {
        Button {
            UIApplication.shared.endEditing()
            if subMoodList.contains(where: { $0.subMood.lowercased() == text.lowercased() }) {
                showAlert = true
            } else {
                
                let submood = MoodList(date: Date().toString(), mood: mood.title, subMood: text)
                subMoodList.append(submood)
                text = ""
                moodelaborate.addSubMood(submood: submood)
            }
        } label: {
            Image(systemName: "plus.app.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:40)
                .foregroundColor(Clr.brightGreen)
                .addBorder(.black, width: 1.5, cornerRadius: 10)
        }
        .buttonStyle(NeoPress())
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
