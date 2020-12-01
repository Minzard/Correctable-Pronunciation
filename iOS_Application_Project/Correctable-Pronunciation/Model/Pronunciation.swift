//
//  Response.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020/12/01.
//  Copyright © 2020 차요셉. All rights reserved.
//

import Foundation

struct Pronunciation: Codable {
    let accuracy: Int?
    let colorCode: String?
    let dividedSTT: String?
    enum CodingKeys: String, CodingKey {
            case accuracy = "accuracy"
            case colorCode = "color"
            case dividedSTT = "dividedSTT"
        }
}

