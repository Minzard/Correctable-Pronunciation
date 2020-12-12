//
//  AccuracyList.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020/12/12.
//  Copyright © 2020 차요셉. All rights reserved.
//

import Foundation

struct AccuracyList: Codable {
    struct DayOfWeek: Codable {
        let accuracyArr: [Int]?
        let date: Int?
    }
    struct Month: Codable {
        let jan: [Int]?
        let feb: [Int]?
        let mar: [Int]?
        let apr: [Int]?
        let may: [Int]?
        let jun: [Int]?
        let jul: [Int]?
        let aug: [Int]?
        let sep: [Int]?
        let oct: [Int]?
        let nov: [Int]?
        let dec: [Int]?
    }
    let monday: DayOfWeek?
    let tuesday: DayOfWeek?
    let wednesday: DayOfWeek?
    let thursday: DayOfWeek?
    let friday: DayOfWeek?
    let saturday: DayOfWeek?
    let sunday: DayOfWeek?
    let month: Month?
}
