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

    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        return searchBar
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TweetTableViewCell.self))
        return tableView
    }()

    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()

    private let viewModel = TimelineViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBind()
    }

    private func setupUI() {
        title = "Timeline"
        automaticallyAdjustsScrollViewInsets = false

        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupBind() {
        searchBar.rx.text
            .subscribe(onNext: { [unowned self] query in
                if let query = query, !query.isEmpty {
                    self.viewModel.reloadData(query: query, max_id: "")
                }
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

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] query in
                self.viewModel.reloadData(query: self.searchBar.text!, max_id: "")
            })
            .addDisposableTo(disposeBag)

        tableView.rx.contentOffset.asObservable()
            .filter {_ in 
                return !self.viewModel.tweets.value.isEmpty  /// ViewModelで判定するべき?
            }
            .map { [unowned self] in
                $0.y + 300 >= self.tableView.contentSize.height - self.tableView.bounds.size.height
            }
            .subscribe(onNext: { [unowned self] isScrollEndComing in
                if isScrollEndComing, self.viewModel.viewState.value.fetchEnabled() { /// ViewModelで判定するべき?
                    self.viewModel.reloadData(query: self.searchBar.text!, max_id: (self.viewModel.tweets.value.last?.id)!)
                }
            })
            .addDisposableTo(disposeBag)

        viewModel.tweets.asDriver()
            .drive(onNext: { [unowned self] tweets in
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            })
            .addDisposableTo(disposeBag)

        viewModel.tweets.asDriver()
            .drive(tableView.rx.items(cellIdentifier: NSStringFromClass(TweetTableViewCell.self), cellType: TweetTableViewCell.self)) { (row, element, cell) in
                cell.setup(element, query: self.searchBar.text!)
                cell.layoutIfNeeded()
            }
            .addDisposableTo(disposeBag)
    }
}
