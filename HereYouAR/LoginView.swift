//
//  LoginView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class LoginView: TK.View<CALayer> {

    // Deps:
    lazy var profileModel = AppComponents.shared.coreComponents.profileModel
    lazy var userCollectionModel = AppComponents.shared.coreComponents.userCollectionModel

    var onLoginComplete: (() -> Void)!

    var collectionView: UICollectionView!

    var userSubscriptionDisposable: TK.Disposable.Scoped?

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        setupSubviews()
        setupBindings()
    }

    func setupSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
//        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserViewCell.self, forCellWithReuseIdentifier: "UserViewCell")
        collectionView.backgroundColor = nil
        addSubview(collectionView)

        setNeedsUpdateConstraints()
    }

    func setupBindings() {
        userCollectionModel.refresh()
        userSubscriptionDisposable = userCollectionModel.eventSender.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }.scoped()
    }


    override func updateConstraints() {
        layoutMargins = .zero
        collectionView.snp.updateConstraints {
            $0.edges.equalTo(layoutMarginsGuide)
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
        let side = collectionView.frame.size.width * 0.5
        return CGSize(width: side, height: side)
    }
}

extension LoginView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCollectionModel.users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserViewCell", for: indexPath) as? UserViewCell else { TK.fatalError(.shouldNeverBeCalled(nil)) }

        cell.userView.user = userCollectionModel.users[indexPath.item]

        return cell

//        cell.imageView.image = PriceInfoGenerator.icon(by: indexPath.item)
//
//        let color = PriceInfoGenerator.color(by: indexPath.item)
//        cell.backgroundColorView.backgroundColor = color
//        cell.backgroundColorView.layer.shadowColor = color.cgColor
//
//        if let price = info?.prices[indexPath.item] {
//            cell.titleLabel.text = String(format: Resources.Strings.UserClicks.xMonths, price.monthsCount)
//            cell.descriptionLabel.text = CurrencyFormatter.formattedString(for: Models.BalanceV2(cents: price.amount.cents, currency: price.amount.currency))
//            cell.discountLabel.model = CorneredLabel.Model(backgroundColor: .white,
//                                                                         textColor: color,
//                                                                         text: String(format: Resources.Strings.UserClicks.saveFormat, Int(price.discountPercentage)))
//            cell.discountLabel.isHidden = price.discountPercentage == 0.0
//        } else {
//            cell.titleLabel.text = nil
//            cell.descriptionLabel.text = nil
//            cell.discountLabel.model = nil
//            cell.discountLabel.isHidden = true
//        }
    }
}
