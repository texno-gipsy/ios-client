//
//  UserView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class UserView: TK.View<CALayer> {

    var avatarImageView: UIImageView!
    var nameLabel: UILabel!

    var user: User? {
        didSet {
            update()
        }
    }

    func update() {
        let avatarImage = AppComponents.shared.coreComponents.avatarCollectionModel.avatar(for: user?.id ?? -1)
        avatarImageView.image = avatarImage

        nameLabel.text = user?.name.replacingOccurrences(of: " ", with: "\n")
    }

    init() {
        super.init(frame: .zero)

        setupSubviews()
    }

    func setupSubviews() {
        avatarImageView = UIImageView()
        addSubview(avatarImageView)

        nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        addSubview(nameLabel)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        avatarImageView.snp.updateConstraints {
            let avatarSide = 80
            $0.size.equalTo(CGSize(width: avatarSide, height: avatarSide))
            $0.top.leading.trailing.equalTo(layoutMarginsGuide).priority(999)
            $0.centerX.equalTo(layoutMarginsGuide.snp.centerX)
        }

        nameLabel.snp.updateConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(layoutMarginsGuide).priority(999)
            $0.bottom.equalTo(layoutMarginsGuide).priority(999)
        }

        super.updateConstraints()
    }
}
