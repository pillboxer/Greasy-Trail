//
//  TableDisplayModel.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import Foundation

struct TableDisplayModel: Identifiable {

    let column1Value: String
    let column2Value: Double

    var id: String {
        column1Value + String(column2Value)
    }

}
