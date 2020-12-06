//
//  MeaningLessTableViewController.swift
//  Test3
//
//  Created by 차요셉 on 10/10/2019.
//  Copyright © 2019 차요셉. All rights reserved.
//

import UIKit

class MeaningLessTableViewController: UITableViewController {
    var MeanLess:Array<String> = ["아","이","우","어","오","야","으","에","우","아","이","아"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MeanLess.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeanLess", for: indexPath)
        cell.textLabel?.text = MeanLess[indexPath.row]
        return cell
    }
}
