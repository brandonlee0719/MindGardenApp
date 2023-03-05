//
//  PaywallManager.swift
//  MindGarden
//
//  Created by Dante Kim on 2/26/22.
//

import Paywall
import StoreKit
import Purchases // This example uses RevenueCat
import AppsFlyerLib
import Amplitude
import Firebase

final class PaywallService: PaywallDelegate {
    static let apiKey = "pk_2b80d8c8e83cefc53bea6b7a998504fde03f88a8da975b87"
    static var shared = PaywallService()
    

    
    static func initPaywall() {
      let options = PaywallOptions()
      // Uncomment to show debug logs
       options.logging.level = .debug
        // configures the SDK
      Paywall.configure(
        apiKey: apiKey,
        delegate: shared,
        options: options
      )
    }
    
    func purchase(product: SKProduct) {
        // TODO: Purchase the product. Below example uses RevenueCat
        
            Purchases.shared.purchaseProduct(product) { transaction, purchaserInfo, error, userCanceled in
                // check purchaserInfo and unlock the app if the user is paying.
                // no need to handle any errors or dismiss the paywall, Superwall does this for you automatically
            }
    }
    static func setUser(reasons: String) {
        if let id =  UserDefaults.standard.string(forKey: K.defaults.giftQuotaId) {
            let attributes: [String: Any] = [
            "name": "test",
            "id":  id,
            "reason": reasons,
            "testing": "simulator"
          ]
            Paywall.setUserAttributes(attributes)
        }
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        
    // TODO: Restore Purchases. Below example uses RevenueCat.
    
    // Call `completion(false)` if the restore fails, `completion(true)` if it succeeds
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in

            if let purchaserInfo = purchaserInfo {
                if let entitlement = purchaserInfo.entitlements["membership"] {
                    if entitlement.isActive {
                        completion(true)
                        return
                    }
                }
            }
            
            completion(false)

        }
    }
    
    func isUserSubscribed() -> Bool {
        // TODO: Return true if the user is subscribed, otherwise return false
          if UserDefaults.standard.bool(forKey: "isPro") {
              return true
          } else {
              return false
          }
    }
    
    
    func reset() {
        Paywall.reset()
    }
    
    
    func shouldTrack(event: String, params: [String : Any]) {}
    

}



