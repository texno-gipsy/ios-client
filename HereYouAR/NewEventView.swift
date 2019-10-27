//
//  NewEventView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class NewEventView: TK.FancyView {

    // Deps:
    lazy var eventCollectionModel = AppComponents.shared.coreComponents.eventCollectionModel

    override init() {
        super.init()

        setupSubviews()
        setupBindings()
    }

    override func setupSubviews() {
        super.setupSubviews()

        setNeedsUpdateConstraints()
    }

    func setupBindings() {
        titleView.titleLabel.text = "Add new event"
        titleView.isHidden = false
    }


    override func updateConstraints() {


        super.updateConstraints()
    }
}
