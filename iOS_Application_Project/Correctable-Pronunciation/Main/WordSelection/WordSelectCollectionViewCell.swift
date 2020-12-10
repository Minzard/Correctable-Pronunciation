//
//  WordSelectCollectionViewCell.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020/12/12.
//  Copyright © 2020 차요셉. All rights reserved.
//

import UIKit

class WordSelectCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var wordLB: UILabel!
    func show(_ wordlbText: String) {
        self.wordLB.text = wordlbText
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.wordLB.layer.borderWidth = 0.5
        self.wordLB.layer.borderColor = UIColor.darkGray.cgColor
    }
}
