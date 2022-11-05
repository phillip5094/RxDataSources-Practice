//
//  SectionOfAnimatedData.swift
//  RxDataSources-Practice
//
//  Created by Philip Chung on 2022/11/05.
//

import Foundation
import RxDataSources

struct SectionOfAnimatedData {
    var header: String
    var items: [Item]
}

extension SectionOfAnimatedData: AnimatableSectionModelType {
    typealias Item = AnimatedData
    typealias Identity = String

    var identity: String {
        return header
    }

    init(original: SectionOfAnimatedData, items: [Item]) {
        self = original
        self.items = items
    }
}
