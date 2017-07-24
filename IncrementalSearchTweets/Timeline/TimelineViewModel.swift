//
//  TimelineViewModel.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import RxSwift
import TwitterKit

class TimelineViewModel {
    private var disposeBag = DisposeBag()
    private(set) var tweets = Variable<[Tweet]>([])

    func reloadData(query: String) {
        let client = TWTRAPIClient()
        let endpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": query, "lang": "ja", "tweet_mode": "extended"]

        let request = client.rx_urlRequest(withMethod: "GET", url: endpoint, parameters: params, client: client)

        request.subscribe(
            onNext: { data in
                let tweets = TimelineTranslator().translate(data: data)
                self.tweets.value = tweets
            },
            onError: { (error) in
                print(error)
            })
            .addDisposableTo(disposeBag)
    }
}
