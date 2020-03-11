//
//  StripeClient.swift
//  Kolony
//
//  Created by Kedlaya on 3/9/20.
//  Copyright © 2020 Kedlaya. All rights reserved.
//

import Foundation
import Stripe

enum Result {
  case success
  case failure(Error)
}

final class StripeClient {
  
  static let shared = StripeClient()
  
  private init() {
    // private
  }
  
  private lazy var baseURL: URL = {
    guard let url = URL(string: "") else {
      fatalError("Invalid URL")
    }
    return url
  }()

    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result) -> Void) {
      /*// First, append the charge method path to the baseURL, in order to invoke the charge API available in your back end.
      let url = baseURL.appendingPathComponent("charge")
      // Next, build a dictionary containing the parameters needed for the charge API. token, amount and currency are mandatory fields.
      let params: [String: Any] = [
        "token": token.tokenId,
        "amount": amount,
        "currency": "usd",
        "description": "Purchase made from Kolony"
      ]
      // Finally, make a network request using Alamofire to perform the charge. When the request completes, it invokes a completion closure with the result of the request.
        //Alamofire.request is now AF
      AF.request(url, method: .post, parameters: params)
        .validate(statusCode: 200..<300)
        .responseString { response in
          switch response.result {
          case .success:
            completion(Result.success)
          case .failure(let error):
            completion(Result.failure(error))
          }
      }*/
    }
}
