//
//  Response.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020/12/12.
//  Copyright © 2020 차요셉. All rights reserved.
//

import Foundation

struct Pronunciation: Codable {
    let accuracy: Int?
    let colorCode: String?
    let dividedSTT: String?
    let dividedLabel: String?
    enum CodingKeys: String, CodingKey {
            case accuracy = "accuracy"
            case colorCode = "color"
            case dividedSTT = "divided_stt"
            case dividedLabel = "divided_label"
        }
}

