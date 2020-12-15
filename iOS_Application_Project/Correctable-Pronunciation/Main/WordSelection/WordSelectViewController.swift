//
//  WordSelectViewController.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020/12/12.
//  Copyright © 2020 차요셉. All rights reserved.
//

import UIKit

class WordSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allPracticebt: UIButton!
    var wordArr: [String?] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        allPracticebt.layer.borderWidth = 0.5
        allPracticebt.layer.borderColor = UIColor.darkGray.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        self.sizeForCollectioViewCell(width: self.view.frame.width, cellHeight: 150)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordSelectCell", for: indexPath) as? WordSelectCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.show(wordArr[indexPath.row] ?? "")
        return cell
    }
    func sizeForCollectioViewCell(width: CGFloat, cellHeight: CGFloat) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: width / 4, height: width / 4)
        flowLayout.invalidateLayout()
        self.collectionView.collectionViewLayout = flowLayout
        self.view.layoutIfNeeded()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        guard let meanLessVC = segue.destination as? MeanLessViewController else { return }
        switch segue.identifier {
        case "oneWord":
            meanLessVC.wordArr.append(wordArr[indexPath[0].item] ?? "")
            meanLessVC.currentIndex = 0
        case "allWord":
            meanLessVC.wordArr.append(contentsOf: wordArr)
            meanLessVC.currentIndex = wordArr.count - 1
        default:
            return
        }
    }
}
