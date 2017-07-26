//
//  TwitterKit-Rx.swift
//  IncrementalSearchTweets
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import RxSwift
import TwitterKit

extension TWTRAPIClient {
    public func rx_urlRequest(withMethod method: String, url: String, parameters: [AnyHashable: Any]?, client: TWTRAPIClient) -> Observable<Data> {
        return Observable.create { observer in
            let request = client.urlRequest(withMethod: method, url: url, parameters: parameters, error: nil)
            client.sendTwitterRequest(request, completion: { (response, data, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(data!)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
