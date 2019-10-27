//
//  TagView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class TagView: TK.View<CALayer> {

    var nameLabel: UILabel!

    var eventTag: Tag? {
        didSet {
            update()
        }
    }

    func update() {
        nameLabel.text = eventTag?.name
    }

    init() {
        super.init(frame: .zero)

        setupSubviews()
    }

    func setupSubviews() {
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = Resources.Fonts.museoSans700(14)
        addSubview(nameLabel)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        nameLabel.snp.updateConstraints {
            $0.edges.equalTo(layoutMarginsGuide)
        }

        super.updateConstraints()
    }
}

