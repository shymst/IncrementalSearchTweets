//
//  User.swift
//  IncrementalSearchTweets
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    let screenName: String
    let profileImageURL: String

    init?(json: Any) {
        guard let dictionary = json as? [String: Any] else { return nil }
        guard let id = dictionary["id_str"] as? String else { return nil }
        guard let screenName = dictionary["screen_name"] as? String else { return nil }
        guard let name = dictionary["name"] as? String else { return nil }
        guard let profileImageURL = dictionary["profile_image_url_https"] as? String else { return nil }

        self.id = id
        self.screenName = screenName
        self.name = name
        self.profileImageURL = profileImageURL
    }
}
