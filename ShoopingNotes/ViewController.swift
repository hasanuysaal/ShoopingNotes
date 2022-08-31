//
//  ViewController.swift
//  ShoopingNotes
//
//  Created by Hasan Uysal on 31.08.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtn))
        
    }

    @objc func addBtn(){
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
}

