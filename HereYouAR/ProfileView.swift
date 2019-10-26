//
//  ProfileView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class ProfileView: TK.View<CALayer> {

    // Deps:
    lazy var profileModel = AppComponents.shared.coreComponents.profileModel

    var userView: UserView!

    func update() {
        userView.user = profileModel.user
    }

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        setupSubviews()
        setupBindings()
    }

    func setupSubviews() {
        userView = UserView()
        addSubview(userView)

        setNeedsUpdateConstraints()
    }

    func setupBindings() {
        update()
    }

    override func updateConstraints() {
        layoutMargins = .zero
        userView.snp.updateConstraints {
            $0.top.leading.trailing.equalTo(layoutMarginsGuide)
            $0.bottom.equalTo(layoutMarginsGuide).offset(50)
        }
        
        super.updateConstraints()
    }
}
