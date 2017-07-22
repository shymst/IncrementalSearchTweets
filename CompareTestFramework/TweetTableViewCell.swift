//
//  TweetTableViewCell.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/23.
//  Copyright © 2017年 shymst. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()

    var screenNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    var accountIdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()

    var textContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
}

// MARK: Setups
extension TweetTableViewCell {
    fileprivate func setupUI() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.layer.masksToBounds = true

        addSubview(screenNameLabel)
        screenNameLabel.translatesAutoresizingMaskIntoConstraints = false
        screenNameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        screenNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10).isActive = true

        addSubview(accountIdLabel)
        accountIdLabel.translatesAutoresizingMaskIntoConstraints = false
        accountIdLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        accountIdLabel.leadingAnchor.constraint(equalTo: screenNameLabel.trailingAnchor, constant: 5).isActive = true
        accountIdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true

        addSubview(textContentLabel)
        textContentLabel.translatesAutoresizingMaskIntoConstraints = false
        textContentLabel.topAnchor.constraint(equalTo: accountIdLabel.bottomAnchor, constant: 5).isActive = true
        textContentLabel.leadingAnchor.constraint(equalTo: screenNameLabel.leadingAnchor).isActive = true
        textContentLabel.trailingAnchor.constraint(equalTo: accountIdLabel.trailingAnchor).isActive = true
        textContentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }

    func setup(_ tweet: Tweet) {
        _ = URLSession.shared.dataTask(with: URL(string: tweet.user.profileImageURL)!) { [weak self] data, response, error in
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                self?.iconImageView.image = UIImage(data: data!)
            }
        }.resume()

        screenNameLabel.text = tweet.user.screenName
        accountIdLabel.text = "@" + tweet.user.accountId
        textContentLabel.text = tweet.text
    }
}
