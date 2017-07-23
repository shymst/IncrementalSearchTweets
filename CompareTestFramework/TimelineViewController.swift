//
//  ViewController.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/22.
//  Copyright © 2017年 shymst. All rights reserved.
//

import UIKit
import Himotoki

class TimelineViewController: UIViewController {

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TweetTableViewCell.self))
        return tableView
    }()

    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refresh), for: .valueChanged)
        return refreshControl
    }()

    var tweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        if Keys.userID.isEmpty {
            TwitterManager().loginToTwitter { isSuccess in
                switch isSuccess {
                case false:
                    print("login failed")
                case true:
                    print("login success")
                    self.fetch()
                }
            }
        } else {
            self.fetch()
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
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: Private
extension TimelineViewController {
    fileprivate func fetch() {
        TwitterManager().getTimeline { [weak self] (data, error) in
            if let err = error {
                print(err)
            }
            self?.tweets = TimelineTranslator().translate(data: data!)
            self?.tableView.reloadData()
        }
    }

    @objc fileprivate func refresh() {
        fetch()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: UITableViewDataSource
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

// MARK: UITableViewDelegate
extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("taped cell")
    }
}
