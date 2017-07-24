//
//  TimelineViewModel.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import RxSwift
import TwitterKit

struct TimelineViewModel {
    private var disposeBag = DisposeBag()
    internal let tweets = Variable<[Tweet]>([])
    internal let scrollEndComing = Variable(false)
    internal let viewState = Variable(ViewState.blank)
    internal let requestState = Variable(RequestState.stopped)

    func reloadData(query: String, max_id: String) {
        self.subscribeState(state: .requesting)

        let client = TWTRAPIClient()
        let endpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": query, "max_id": max_id, "lang": "ja", "result_type": "recent", "tweet_mode": "extended"]

        let request = client.rx_urlRequest(withMethod: "GET", url: endpoint, parameters: params, client: client)

        request
            .subscribe(onNext: { data in
                max_id.isEmpty ? self.subscribeState(state: .response(data)) : self.subscribeState(state: .additional(data))
            }, onError: { (error) in
                self.subscribeState(state: .error(error))
            })
            .addDisposableTo(disposeBag)
    }

    func subscribeState(state: RequestState) {
        switch state {
        case .stopped:
            self.viewState.value = .blank
        case .requesting:
            self.viewState.value = .requesting
        case .error(let error):
            self.viewState.value = .error(error)
        case .response(let data):
            self.viewState.value = .working
            self.scrollEndComing.value = false
            let tweets = TimelineTranslator().translate(data: data)
            self.tweets.value = tweets
        case .additional(let data):
            self.viewState.value = .working
            self.scrollEndComing.value = false
            let tweets = TimelineTranslator().translate(data: data)
            tweets.removeFirst()
            self.tweets.value += tweets
        }
    }
}
