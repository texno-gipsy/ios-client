//
//  LoginView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class LoginView: TK.FancyView {

    // Deps:
    lazy var profileModel = AppComponents.shared.coreComponents.profileModel
    lazy var userCollectionModel = AppComponents.shared.coreComponents.userCollectionModel

    var onLoginComplete: (() -> Void)!

    var collectionView: UICollectionView!

    var userSubscriptionDisposable: TK.Disposable.Scoped?

    override init() {
        super.init()

        backgroundColor = .white

        setupSubviews()
        setupBindings()
    }

    override func setupSubviews() {
        super.setupSubviews()

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserViewCell.self, forCellWithReuseIdentifier: "UserViewCell")
        collectionView.backgroundColor = nil
        containerView.addSubview(collectionView)

        setNeedsUpdateConstraints()
    }

    func setupBindings() {
        titleView.titleLabel.text = "Login"
        titleView.isHidden = false
        userCollectionModel.refresh()
        userSubscriptionDisposable = userCollectionModel.eventSender.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }.scoped()
    }


    override func updateConstraints() {
        containerView.layoutMargins = .zero
        collectionView.snp.updateConstraints {
            $0.edges.equalTo(containerView.layoutMarginsGuide)
        }

        super.updateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension LoginView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! UserViewCell
        profileModel.login(credentials: UserCredentials(id: cell.userView.user!.id))
        onLoginComplete()
    }
}

extension LoginView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.frame.size.width * 0.45
        return CGSize(width: side, height: side)
    }
}

extension LoginView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCollectionModel.usersWithCredentials.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserViewCell", for: indexPath) as? UserViewCell else { TK.fatalError(.shouldNeverBeCalled(nil)) }

        cell.userView.user = userCollectionModel.usersWithCredentials[indexPath.item]

        return cell
    }
}
