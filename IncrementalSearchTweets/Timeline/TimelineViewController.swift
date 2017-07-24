//
//  ViewController.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/22.
//  Copyright © 2017年 shymst. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TimelineViewController: UIViewController {

    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        return searchBar
    }()

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TweetTableViewCell.self))
        return tableView
    }()

    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()

    fileprivate let viewModel = TimelineViewModel()
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBind()
    }
}

// MARK: Setups
extension TimelineViewController {
    fileprivate func setupUI() {
        title = "Timeline"
        automaticallyAdjustsScrollViewInsets = false

        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    fileprivate func setupBind() {
        viewModel.tweets.asObservable()
            .subscribe(onNext: { [unowned self] tweets in
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            })
            .addDisposableTo(disposeBag)

        searchBar.rx.text
            .subscribe(onNext: { [unowned self] query in
                if let query = query, !query.isEmpty {
                    self.viewModel.reloadData(query: query)
                }
            })
            .addDisposableTo(disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] query in
                self.viewModel.reloadData(query: self.searchBar.text!)
            })
            .addDisposableTo(disposeBag)

        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [unowned self] in
                self.searchBar.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)

        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [unowned self] in
                self.searchBar.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
    }
}

// MARK: UITableViewDataSource
extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TweetTableViewCell.self), for: indexPath) as? TweetTableViewCell else {
            fatalError("TweetTableViewCell is not found.")
        }
        cell.setup(viewModel.tweets.value[indexPath.row])
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
