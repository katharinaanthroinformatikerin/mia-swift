//
//  StationTableViewController.swift
//  moapk
//
//  Created by Client5 on 17.11.17.
//  Copyright © 2017 Client5. All rights reserved.
//

import UIKit

class StationTableViewController: UITableViewController, StationDelegate {
    
    
    //MARK: Properties
    
    var stations = [Station]()
    var stationService : StationService? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sample data.
        //loadSampleStations()
        stationService = StationService(delegate: self)
        stationService!.load()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @objc func refresh(sender: Any){
        stationService?.load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "StationListTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StationListTableViewCell else {
            fatalError("The dequeued cell is not an instance of StationTableViewCell.")
        }
        
        //Fetches the appropriate station for the data source layout.
        
        let station = stations[indexPath.row]
        

        cell.nameLabel.text = "\(indexPath.row) \(station.name)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier?.compare("showStationDetails") != nil){
            guard let stationViewController = segue.destination as? StationViewController else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            guard let selectedStationCell = sender as? StationListTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
                fatalError("The selected cell is not displayed in the table.")
            }
            let selectedStation = stations[indexPath.row]
            stationViewController.station = selectedStation
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleStations() {
        
        for _ in 0...29{
            let station = Station(name: "Station", location: Location(latitude: 48.134861, longitude: 16.283298), lines: ["A31","A32", "A33"])
            stations.append(station)
        }
    }
    
    //StationDelegate:
    func dataLoadingFinished(_ data: [Station]) {
        
        stations = data
        DispatchQueue.main.async{
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
}
