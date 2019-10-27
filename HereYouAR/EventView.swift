//
//  EventView.swift
//  HereYouAR
//
//  Created by Anton Lebedev on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class EventView: TK.View<CALayer> {
    
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    var event: Event? {
        didSet {
            update()
        }
    }

    func update() {
        titleLabel.text = event?.title
        descriptionLabel.text = event?.description
    }

    init() {
        super.init(frame: .zero)

        backgroundColor = .white
        
        setupSubviews()
    }

    func setupSubviews() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        addSubview(descriptionLabel)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        titleLabel.snp.updateConstraints {
            $0.top.equalTo(layoutMarginsGuide.snp.top).offset(-700)
            $0.leading.trailing.equalTo(layoutMarginsGuide).priority(999)
            $0.bottom.equalTo(layoutMarginsGuide).priority(999)
        }

        descriptionLabel.snp.updateConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(-500.0)
            $0.leading.trailing.equalTo(layoutMarginsGuide).priority(999)
            $0.bottom.equalTo(layoutMarginsGuide).priority(999)
        }

        super.updateConstraints()
    }
}
