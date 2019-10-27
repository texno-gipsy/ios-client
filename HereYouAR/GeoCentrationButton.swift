//
//  GeoCentrationButton.swift
//  HereYouAR
//
//  Created by Anton Lebedev on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//


import UIKit
import SnapKit
import RxSwift

class GeoCentrationButton: TK.View<CALayer> {

    var action: (() -> Void)!
    var button: UIButton!
    let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)

        setupSubviews()
    }

    func setupSubviews() {
        button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
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

    @objc func buttonTapped() {
        action()
    }
}

