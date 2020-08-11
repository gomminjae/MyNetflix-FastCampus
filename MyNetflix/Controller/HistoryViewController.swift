//
//  HistoryViewController.swift
//  MyNetflix
//
//  Created by Apple on 2020/07/07.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let db = Database.database().reference().child("searchHistory")
    
    var searchTerms = [SearchTerm]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let searchHistory = snapshot.value as? [String: Any] else { return }
            let datas = Array(searchHistory.values)
            
            let data = try! JSONSerialization.data(withJSONObject: datas, options: [])
            let decoder = JSONDecoder()
            let searchTerms = try! decoder.decode([SearchTerm].self, from: data)
            
            self.searchTerms = searchTerms.sorted {$0.timeStamp > $1.timeStamp}
            self.tableView.reloadData()
            print("-->\(data)")
        }
        
    }

}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
        
        cell.searchTerm.text = searchTerms[indexPath.row].term
        
        return cell
    }
    
    
}
