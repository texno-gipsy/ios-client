//
//  LoginView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class LoginView: TK.View<CALayer> {
    var collectionView: UICollectionView!

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        setupSubviews()
    }

    func setupSubviews() {
        collectionView = UICollectionView()
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        addSubview(collectionView)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.snp.updateConstraints {
            $0.edges.equalTo(layoutMarginsGuide)
        }

        super.updateConstraints()
    }
}
//
//extension LoginView: UICollectionViewDelegate {
//
//}
//
//extension LoginView: UICollectionViewDelegateFlowLayout {
//
//}
//
//extension LoginView: UICollectionViewDataSource {
//
//}
