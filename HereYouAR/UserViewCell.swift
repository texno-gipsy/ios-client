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
        layoutMargins = .zero
        userView.snp.updateConstraints {
            $0.edges.equalTo(contentView.layoutMarginsGuide)
        }

        super.updateConstraints()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.bounds.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        attributes.bounds.size = size
        return attributes
    }
}
