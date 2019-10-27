//
//  AddEventButton.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class AddEventButton: TK.View<CALayer> {

    var action: (() -> Void)!
    var button: UIButton!
    let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)

        setupSubviews()
    }

    func setupSubviews() {
        button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add-event-button-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Resources.Colors.accentColor
        button.backgroundColor = .white
        TK.apply(shadow: TK.accentShadow, to: button.layer)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.animateWhenPressed(disposeBag: disposeBag)
        addSubview(button)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        button.snp.updateConstraints {
            $0.edges.equalTo(layoutMarginsGuide)
        }

        super.updateConstraints()
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        button.layer.cornerRadius = bounds.width * 0.5
    }

    @objc func buttonTapped() {
        action()
    }
}
