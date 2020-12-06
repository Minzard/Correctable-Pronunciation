//
//  WordProcessSelectViewController.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020/12/06.
//  Copyright © 2020 차요셉. All rights reserved.
//

import UIKit

class WordProcessSelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var wordProcess: [(wordPrcess: String, wordArr: [String])] = [("무의미음절",["아","이","우","어","오","야","으","에","우","아","이","아"]),("최소대립쌍",["예","얘","여","유","요","야","위","웨","워","와","의","예","워","유","야"]),("의미있는 단어",["사과","오이","우유","의자","소설","문학","음악","신호","그릇","숙제","부얶","리본","신발","음악","수락","치마","기린","판사"]),("이중모음",["짐","김","물","불","술","솔","발","날","밖","밥","밤","담","논","돈","쌤","햄","시다","치다","바다","파다","거울","너울","정지","정리","포도","보도","가루","자루","구조","수조","마루","머루","쉬리","소리","사람","사랑","구실","구슬","장미","장비","보수","고수","상자","상가","배구","배추","찬물","단물","보리","꼬리","짜다","사다","가다","타다","배구","배추","머리","거리","포수","조수"])]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return wordProcess.count
        } else {
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WordProcessTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WordProcessCell", for: indexPath) as? WordProcessTableViewCell else { return UITableViewCell()}
        cell.show(wordProcessText: wordProcess[indexPath.row].wordPrcess, wordArr: wordProcess[indexPath.row].wordArr)
        return cell
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
