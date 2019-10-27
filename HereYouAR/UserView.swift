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
    var stackView: UIStackView!

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

        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        setupSubviews()
    }

    func setupSubviews() {
        stackView = UIStackView()
        stackView.spacing = 8.0
        stackView.axis = .vertical
        stackView.alignment = .center
        addSubview(stackView)

        avatarImageView = UIImageView()
        stackView.addArrangedSubview(avatarImageView)

        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = Resources.Fonts.museoSans500(16)
        stackView.addArrangedSubview(nameLabel)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        stackView.snp.updateConstraints {
            $0.edges.equalTo(layoutMarginsGuide).priority(999)
        }

        super.updateConstraints()
    }
}
