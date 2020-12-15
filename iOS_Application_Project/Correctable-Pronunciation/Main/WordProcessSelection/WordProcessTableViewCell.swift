//
//  WordProcessTableViewCell.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020/12/12.
//  Copyright © 2020 차요셉. All rights reserved.
//

import UIKit

class WordProcessTableViewCell: UITableViewCell {
    @IBOutlet weak var wordProcessLB: UILabel!
    @IBOutlet weak var word1: UILabel!
    @IBOutlet weak var word2: UILabel!
    @IBOutlet weak var word3: UILabel!
    @IBOutlet weak var word4: UILabel!
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    func show(wordProcessText: String, wordArr: [String]) {
        wordProcessLB.text = wordProcessText
        word1.text = "# \(wordArr[0])"
        word2.text = "# \(wordArr[1])"
        word3.text = "# \(wordArr[2])"
        word4.text = "# \(wordArr[3])"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        cellHeightConstraint.constant = UIScreen.main.bounds.height / 10
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    if highlighted {
        self.contentView.backgroundColor = UIColor(red: 244/255, green: 245/255, blue: 247/255, alpha: 1)
    } else {
        self.contentView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
