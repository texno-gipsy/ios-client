//
//  UserViewCell.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class UserViewCell: UICollectionViewCell {
    var userView: UserView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        userView = UserView()
        userView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        userView.layer.cornerRadius = 8.0
        contentView.addSubview(userView)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        userView.snp.updateConstraints {
            $0.edges.equalTo(contentView.layoutMarginsGuide)
        }

        super.updateConstraints()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let newLayoutAttributes = layoutAttributes
//        var newBounds = newLayoutAttributes.bounds
//        newBounds.size. = 200
        newLayoutAttributes.bounds.size.height = 200
        return newLayoutAttributes
    }
}
