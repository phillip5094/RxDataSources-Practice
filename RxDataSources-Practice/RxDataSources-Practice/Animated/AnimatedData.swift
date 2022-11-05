//
//  AnimatedData.swift
//  RxDataSources-Practice
//
//  Created by Philip Chung on 2022/11/05.
//

import Foundation
import RxDataSources

struct AnimatedData {
    let title: String
}

extension AnimatedData: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        return title
    }
}
