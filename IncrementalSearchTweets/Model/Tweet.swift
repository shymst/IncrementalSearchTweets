//
//  Tweet.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import Foundation

struct Tweet {
    let id: String
    let text: String
    let user: User

    init?(json: Any) {
        guard let dictionary = json as? [String: Any] else { return nil }
        guard let id = dictionary["id_str"] as? String else { return nil }
        guard let text = dictionary["full_text"] as? String else { return nil }
        guard let userJSON = dictionary["user"] else { return nil }
        guard let user = User(json: userJSON) else { return nil }

        self.id = id
        self.text = text
        self.user = user
    }
}
