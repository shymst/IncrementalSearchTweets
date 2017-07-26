//
//  TimelineViewModel.swift
//  IncrementalSearchTweets
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import RxSwift
import TwitterKit

protocol TimelineViewModel {
    var tweets: Variable<[Tweet]>{ get }
    var viewState: Variable<ViewState>{ get }
    func reloadData(query: String, max_id: String?)
    func subscribeState(state: RequestState)
}

class TimelineViewModelImpl : TimelineViewModel {

    private(set) var tweets = Variable<[Tweet]>([])
    private(set) var viewState = Variable<ViewState>(.blank)

    private let reqeust: SearchRequest?
    private var disposeBag = DisposeBag()

    init(reqeust: SearchRequest) {
        self.reqeust = reqeust

        reqeust.requestState.asObservable()
            .subscribe(onNext: {
                self.subscribeState(state: $0)
            })
            .addDisposableTo(disposeBag)
    }

    func reloadData(query: String, max_id: String? = nil) {
        if !query.isEmpty && viewState.value.fetchEnabled() {
            reqeust?.searchReqest(query: query, max_id: max_id ?? "")
        }
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
            let tweets = TimelineTranslator().translate(data: data)
            self.tweets.value = tweets
        case .additional(let data):
            self.viewState.value = .working
            var tweets = TimelineTranslator().translate(data: data)
            tweets.removeFirst()
            self.tweets.value += tweets
        }
    }
}
