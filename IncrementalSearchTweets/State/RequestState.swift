//
//  RequestState.swift
//  IncrementalSearchTweets
//
//  Created by Shunya Yamashita on 2017/07/25.
//  Copyright © 2017年 shymst. All rights reserved.
//

import Foundation

enum RequestState {
    case stopped
    case requesting
    case error(Error)
    case response(Data)
    case additional(Data)
}
