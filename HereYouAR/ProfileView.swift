//
//  ProfileView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class ProfileView: TK.FancyView {

    // Deps:
    lazy var profileModel = AppComponents.shared.coreComponents.profileModel

    var userView: UserView!
    var tagListView: TagListView!

    func update() {
        userView.user = profileModel.user
    }

    override init() {
        super.init()

        backgroundColor = .white

        setupSubviews()
        setupBindings()
    }

    override func setupSubviews() {
        super.setupSubviews()

        userView = UserView()
        containerView.addSubview(userView)

        tagListView = TagListView()
        containerView.addSubview(tagListView)

        actionButton.isHidden = false

        setNeedsUpdateConstraints()
    }

    func setupBindings() {
        onAction = {}
        actionButton.setTitle("Back to Map", for: .normal)
        update()
    }

    override func updateConstraints() {
        containerView.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        userView.avatarImageView.snp.updateConstraints {
            $0.top.equalTo(containerView).offset(-userView.avatarImageView.image!.size.height * 0.5)
        }
        userView.snp.updateConstraints {
            $0.leading.trailing.equalTo(containerView.layoutMarginsGuide)
        }

        tagListView.snp.updateConstraints {
            $0.top.equalTo(userView.snp.bottom).offset(20.0)
            $0.height.equalTo(200)
            $0.leading.trailing.equalTo(containerView.layoutMarginsGuide)
            $0.bottom.equalTo(containerView.layoutMarginsGuide).offset(100)
        }
        
        super.updateConstraints()
    }
}
