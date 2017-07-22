//
//  Account.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import TwitterKit

struct TwitterManager {

    static var session: TWTRSession?

    func loginToTwitter(handler: @escaping (Bool) -> Void) {
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if let session = session {
                print("signed in as \(session.userName)")
                TwitterManager.session = session
                handler(true)
            } else {
                print("error: \(error!.localizedDescription)")
                handler(false)
            }
        })
    }
}
