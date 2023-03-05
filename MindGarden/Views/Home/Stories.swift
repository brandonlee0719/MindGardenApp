//
//  Stories.swift
//  MindGarden
//
//  Created by Dante Kim on 3/31/22.
//

import SwiftUI
import Storyly
import WidgetKit
var storySegments: Set<String> = Set<String>()
struct Stories: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Stories>) -> UIView {
        let view = UIView(frame: .zero)
        storylyViewProgrammatic.storylyInit = StorylyInit(storylyId: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU2OTgsImFwcF9pZCI6MTA2MDcsImluc19pZCI6MTEyNTV9.zW_oJyQ7FTAXHw8MXnEeP4k4oOafFrDGKylUw81pi3I", segmentation: StorylySegmentation(segments: storySegments))
        view.addSubview(storylyViewProgrammatic)
        storylyViewProgrammatic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storylyViewProgrammatic.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        storylyViewProgrammatic.storyGroupIconBorderColorNotSeen = [UIColor.systemGreen, UIColor.systemYellow]
        storylyViewProgrammatic.storyGroupTextFont = UIFont(name: "Fredoka-Medium", size: 12) ?? .systemFont(ofSize: 12)
        storylyViewProgrammatic.storyGroupTextColor = UIColor.systemGray

        storylyViewProgrammatic.storyGroupSize = "custom"
        storylyViewProgrammatic.storyGroupIconStyling = StoryGroupIconStyling(height: 55, width: 55, cornerRadius: 27.5)

        storylyViewProgrammatic.delegate = StorylyManager.shared
        storylyViewProgrammatic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        storylyViewProgrammatic.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        storylyViewProgrammatic.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        storylyViewProgrammatic.storyGroupListStyling = StoryGroupListStyling(edgePadding: 10, paddingBetweenItems: 5)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("updating \(true)")
    }
}
