//
//  TagListView.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 26.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class TagListView: TK.DefaultView {

    // Deps:
    lazy var tagCollectionModel = AppComponents.shared.coreComponents.tagCollectionModel

    var collectionView: UICollectionView!

    var tagSubscriptionDisposable: TK.Disposable.Scoped?

    init() {
        super.init(frame: .zero)

        setupSubviews()
        setupBindings()
    }

    func setupSubviews() {
        let layout = CollectionViewTagLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagViewCell.self, forCellWithReuseIdentifier: "TagViewCell")
        collectionView.backgroundColor = nil
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        addSubview(collectionView)

        setNeedsUpdateConstraints()
    }

    func setupBindings() {
        self.collectionView.reloadData()
        tagSubscriptionDisposable = tagCollectionModel.eventSender.subscribe { [weak self] event in
            guard let self = self else { return }
            guard event == .tagsUpdated else { return }
            self.collectionView.reloadData()
            self.setNeedsUpdateConstraints()
            self.setNeedsLayout()
        }.scoped()
    }

    override func updateConstraints() {
        layoutMargins = .zero
        collectionView.snp.updateConstraints {
//            let contentHeight = collectionView.contentSize.height
            let contentHeight = 150.0
            $0.height.equalTo(contentHeight)
            $0.edges.equalTo(layoutMarginsGuide)
        }

        super.updateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension TagListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TagViewCell
//        profileModel.login(credentials: UserCredentials(id: cell.userView.user!.id))
//        onLoginComplete()
    }
}

extension TagListView: UICollectionViewDelegateFlowLayout {

}

extension TagListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagCollectionModel.tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagViewCell", for: indexPath) as? TagViewCell else { TK.fatalError(.shouldNeverBeCalled(nil)) }

        cell.tagView.eventTag = tagCollectionModel.sortedTags[indexPath.item]

        return cell
    }
}
