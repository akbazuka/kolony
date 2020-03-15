//
//  StripeApi.swift
//  Kolony
//
//  Created by Kedlaya on 3/13/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
    
        let data = [
            "customer_id" : UserService.user.stripeId,
            "apiVersion": apiVersion
        ]
                
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
        
            if let error = error {
            debugPrint(error.localizedDescription)
            completion(nil, error)
            return
            }
        
            guard let key = result?.data as? [String: Any] else {
                completion(nil, nil)
                return
            }
        
            completion(key, nil)
        }
    }
}
