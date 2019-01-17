//
//  LogVC.swift
//  Sprint Treads
//
//  Created by Vivek Rai on 03/11/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit

class LogVC: UIViewController {

    @IBOutlet weak var logTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logTableView.delegate = self
        logTableView.dataSource = self
        logTableView.rowHeight = 80
        logTableView.separatorStyle = .singleLine
        logTableView.separatorColor = .white
        self.logTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.logTableView.reloadData()
    }


}
extension LogVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getAllRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as? LogCell{
            guard let run = Run.getAllRuns()?[indexPath.row] else {
                return LogCell()
            }
            cell.configureRun(run: run)
            return cell
        }else{
            return LogCell()
        }
        
    }
    
    
}
