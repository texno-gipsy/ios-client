//
//  TagViewCell.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class TagViewCell: UICollectionViewCell {

    // Deps:
    lazy var tagCollectionModel = AppComponents.shared.coreComponents.tagCollectionModel

    var tagSubscriptionDisposable: TK.Disposable.Scoped?

    var tagView: TagView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupBindings()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update() {
        guard let tag = tagView.eventTag else { return }
        if tagCollectionModel.isSelected(tag: tag) {
//            tagView.transform = .init(scaleX: 0.8, y: 0.8)
            tagView.layer.borderColor = UIColor.black.cgColor
            tagView.layer.borderWidth = 2.0
        }
        else {
//            tagView.transform = .identity
            tagView.layer.borderColor = nil
            tagView.layer.borderWidth = 0
        }
    }

    func setupBindings() {
        update()
        tagSubscriptionDisposable = tagCollectionModel.eventSender.subscribe { [weak self] event in
            guard let self = self else { return }
            guard event == .selectedTagsUpdated else { return }
            self.update()
        }.scoped()
    }

    func setupSubviews() {
        tagView = TagView()
        tagView.backgroundColor = Resources.Colors.lightGray
        tagView.layer.cornerRadius = 12.0
        contentView.addSubview(tagView)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        contentView.layoutMargins = .zero
        tagView.snp.updateConstraints {
            $0.edges.equalTo(contentView.layoutMarginsGuide)
        }

        super.updateConstraints()
    }

    override var isSelected: Bool {
        didSet {
            guard let tag = tagView.eventTag else { return }
            tagCollectionModel.set(tag: tag, selected: isSelected)
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.bounds.size)
        attributes.bounds.size = size
        return attributes
    }
}

