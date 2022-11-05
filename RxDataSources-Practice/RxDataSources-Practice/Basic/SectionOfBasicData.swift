//
//  SectionOfBasicData.swift
//  RxDataSources-Practice
//
//  Created by Philip Chung on 2022/10/03.
//

import Foundation
import RxDataSources

struct SectionOfBasicData {
    var header: String
    var items: [Item]
}

extension SectionOfBasicData: SectionModelType {
    typealias Item = BasicData

    init(original: SectionOfBasicData, items: [Item]) {
        self = original
        self.items = items
    }
}
