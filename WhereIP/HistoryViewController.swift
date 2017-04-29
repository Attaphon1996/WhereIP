//
//  HistoryViewController.swift
//  WhereIP
//
//  Created by Pandora on 4/29/2560 BE.
//  Copyright © 2560 Pandora. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    var IPh:[String] = [""]
    override func viewDidLoad() {
        getdata()
        super.viewDidLoad()
        table.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IPh.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "label", for: indexPath)
        cell.textLabel?.text = IPh[indexPath.row]
        return cell
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    func getdata(){
        let defaults = UserDefaults.standard
        if let SIP = defaults.stringArray(forKey: "IP"){
            print(SIP)
            IPh = SIP
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        defaults.set(IPh[indexPath.row], forKey: "select")
        defaults.set(true, forKey: "selected")
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
