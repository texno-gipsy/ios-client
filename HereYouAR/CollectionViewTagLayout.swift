//
//  CollectionViewTagLayout.swift
//  HereYouAR
//
//  Created by Dmitry Purtov on 27.10.2019.
//  Copyright © 2019 texno-gipsy. All rights reserved.
//

import UIKit

class CollectionViewTagLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect), let firstAttribute = attributes.first else { return nil }
        var row = [firstAttribute]
        for attribute in attributes.dropFirst() {
            if attribute.frame.origin.y == row.first!.frame.origin.y {
                row.append(attribute)
            }
            else {
                rearrange(row: row)
                row = [attribute]
                continue
            }
        }
        rearrange(row: row)
        return attributes
    }

    func rearrange(row: [UICollectionViewLayoutAttributes]) {
        let (first, last) = (row.first!, row.last!)
        guard first != last else { return }

        let lastAttributesMaxX = last.center.x + last.bounds.width * 0.5

        var previousAttributes = first
        let slicedRow = row.dropFirst()

        for attributes in slicedRow {
            attributes.center.x = previousAttributes.center.x
                + previousAttributes.bounds.size.width * 0.5
                + attributes.bounds.size.width * 0.5
                + minimumInteritemSpacing

            previousAttributes = attributes
        }

        let lastAttributesMaxXAfterUpdate = last.center.x + last.bounds.width * 0.5

        let xDiff = lastAttributesMaxX - lastAttributesMaxXAfterUpdate

        for attributes in row {
            attributes.center.x += xDiff * 0.5
        }
    }
}
