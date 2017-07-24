//
//  ViewState.swift
//  IncrementalSearchTweets
//
//  Created by Shunya Yamashita on 2017/07/25.
//  Copyright © 2017年 shymst. All rights reserved.
//

import Foundation

enum ViewState {
    case working
    case blank
    case requesting
    case error(Error)

    func fetchEnabled() -> Bool {
        switch self {
        case .blank, .working:
            return true
        default:
            return false
        }
    }
}
