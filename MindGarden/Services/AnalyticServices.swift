//
//  AnalyticServices.swift
//  MindGarden
//
//  Created by Dante Kim on 10/3/21.
//

import SwiftUI
import Combine
import Firebase
import OSLog
import AppsFlyerLib
import Amplitude
import OneSignal
import Paywall

final class Analytics: ObservableObject {
    static let shared = Analytics()
    var logSubject = PassthroughSubject<AnalyticEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    /// Submit a single analytics event for logging from anywhere
    /// - Parameter event: analytics event to log
    /// This function uses the dedicated combine pipeline to submit analytics events. This allows per-event
    /// management of deduplication and anything else required and ensures that all events are treated equally
    /// whether they come in from a function call like this or through a publisher.
    func log(event: AnalyticEvent) {
        logSubject.send(event)
    }

    /// Log a single analytics event with all appropriate analytics services
    /// - Parameter event: analytics event to log
    /// Currently submits to FirebaseAnalytics in all cases and GoogleAnalytics if not running in a simulator.
    /// This function shuold only be called from within the `logSubject` Combine subject, never directly from code.
    /// To log an event from code, use the `log(event:)` function above.
    func logActual(event: AnalyticEvent) {
        #if !targetEnvironment(simulator)
         Firebase.Analytics.logEvent(event.eventName, parameters: [:])
         AppsFlyerLib.shared().logEvent(event.eventName, withValues: [AFEventParamContent: "true"])
         Amplitude.instance().logEvent(event.eventName)
         Paywall.track(name: event.eventName)
        // prepare activity report content.
        let eventInfo = ["someKey": "someValue", "otherKey": 2]
        let eventInfoStringData = try! JSONSerialization.data(withJSONObject: eventInfo, options: [])
        let eventInfoString = String(data: eventInfoStringData, encoding: .utf8)

        // send the activity report
        MWM.sendActivityReport(withKind: "example", withContent: eventInfoString)

        #endif
         print("logging, \(event.eventName)")
     }
    

    init() {
        logSubject
            .sink { [self] event in
                logActual(event: event)
            }
            .store(in: &cancellables)
    }

}

// MARK: - SwiftUI extensions
extension View {
    func onAppearAnalytics(event: AnalyticEvent?) -> some View {
        onAppear {
            guard let event = event else { return }
            Analytics.shared.log(event: event)
        }
    }
}
