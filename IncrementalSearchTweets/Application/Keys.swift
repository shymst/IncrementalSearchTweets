//
//  Keys.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import Keys
import SwiftyUserDefaults

struct Keys {
    static let twitterConsumerKey: String = IncrementalSearchTweetsKeys().twitterConsumerKey
    static let twitterConsumerSecret: String = IncrementalSearchTweetsKeys().twitterConsumerSecret
    static let userID: String = Defaults[.userID] ?? ""

    static func removeAll() {
        Defaults.removeAll()
    }
}

extension DefaultsKeys {
    static let userID = DefaultsKey<String?>("userID")
}
