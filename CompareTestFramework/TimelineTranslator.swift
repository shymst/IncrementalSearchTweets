//
//  TimelineTranslator.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import Foundation

struct TimelineTranslator {
    func translate(data: Data) -> [Tweet] {
        guard
            let serializedData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary,
            let json = serializedData["statuses"] as? [Any]
            else {
                fatalError("serialized failed")
        }

        let tweets: [Tweet] = json.flatMap {
            Tweet(json: $0)
        }

        return tweets
    }
}
