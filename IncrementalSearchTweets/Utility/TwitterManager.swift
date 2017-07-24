//
//  TwitterManager.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//
//
//import TwitterKit
//import SwiftyUserDefaults
//
//struct TwitterManager {
//    func loginToTwitter(handler: @escaping (Bool) -> Void) {
//        Twitter.sharedInstance().logIn(completion: { (session, error) in
//            if let session = session {
//                print("signed in as \(session.userName)")
//                Defaults[.userID] = session.userID
//                handler(true)
//            } else {
//                print("error: \(error!.localizedDescription)")
//                handler(false)
//            }
//        })
//    }
//
//    func getTimeline(query: String, handler: @escaping (Data?, APIError?) -> Void) {
//        guard let userID = Defaults[.userID] else {
//            handler(nil, APIError.unknown(reason: "userID is not found."))
//            return
//        }
//
//        let client = TWTRAPIClient(userID: userID)
//        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
//        let params = ["q": query, "lang": "ja", "tweet_mode": "extended"]
//        var clientError : NSError?
//
//        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
//
//        client.sendTwitterRequest(request) { (response, responseData, error) -> Void in
//            if let err = error {
//                handler(nil, APIError.unknown(reason: err.localizedDescription))
//            } else {
//                handler(responseData, nil)
//            }
//        }
//    }
//}
