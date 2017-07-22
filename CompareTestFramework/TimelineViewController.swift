//
//  ViewController.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/22.
//  Copyright © 2017年 shymst. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TweetTableViewCell.self))
        return tableView
    }()

    let tweets: [Tweet] = [
            Tweet(id: "", text: "ああああああああああああああああああああああ", user: User(id: "", accountId: "shunya_ma", screenName: "Shunyama", profileImageURL: "https://pbs.twimg.com/profile_images/787258973032370180/fAYbhA1t_400x400.jpg")),
            Tweet(id: "", text: "ああああああああああああああああああああああ", user: User(id: "", accountId: "shunya_ma", screenName: "Shunyama", profileImageURL: "https://pbs.twimg.com/profile_images/787258973032370180/fAYbhA1t_400x400.jpg")),
            Tweet(id: "", text: "ああああああああああああああああああああああ", user: User(id: "", accountId: "shunya_ma", screenName: "Shunyama", profileImageURL: "https://pbs.twimg.com/profile_images/787258973032370180/fAYbhA1t_400x400.jpg"))
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        TwitterManager().loginToTwitter { isSuccess in
            switch isSuccess {
            case false:
                print("login failed")
            case true:
                print("login success")
            }
        }
    }
}


// MARK: Setups
extension TimelineViewController {
    fileprivate func setupUI() {
        title = "Timeline"
        automaticallyAdjustsScrollViewInsets = false

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TweetTableViewCell.self), for: indexPath) as? TweetTableViewCell else {
            fatalError("TweetTableViewCell is not found.")
        }
        cell.setup(tweets[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("taped cell")
    }
}
