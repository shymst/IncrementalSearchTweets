//
//  SearchRequest.swift
//  IncrementalSearchTweets
//
//  Created by Shunya Yamashita on 2017/07/26.
//  Copyright © 2017年 shymst. All rights reserved.
//

import Foundation
import RxSwift
import TwitterKit

protocol SearchRequest {
    var requestState: Variable<RequestState> { get }
    func searchReqest(query: String, max_id: String)
}

class SearchRequestImpl: SearchRequest {

    private(set) var requestState = Variable<RequestState>(.stopped)

    private let disposeBag = DisposeBag()

    func searchReqest(query: String, max_id: String) {
        requestState.value = .requesting

        let client = TWTRAPIClient()
        let endpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": query, "max_id": max_id, "lang": "ja", "result_type": "recent", "tweet_mode": "extended"]

        let request = client.rx_urlRequest(withMethod: "GET", url: endpoint, parameters: params, client: client)

        request
            .subscribe(onNext: {
                self.requestState.value = max_id.isEmpty ? .response($0) : .additional($0)
            }, onError: {
                self.requestState.value = .error($0)
            })
            .addDisposableTo(disposeBag)
    }
}

