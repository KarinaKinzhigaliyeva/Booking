//
//  TableViewController.swift
//  Hotels
//
//  Created by Karina Kinzhigaliyeva on 12.11.2024.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    var arrayHotels = [AboutHotels(hotelsName: "Cupertino Historical Society and Museum ", hotelsImages: "museum", address: "10185 N Stelling Rd, Cupertino, CA 95014, United States", coordinates: HotelCoordinates(latitude: 37.32574708773483, longitude: -122.04247937514572)), AboutHotels(hotelsName: "The Fairmont San Jose", hotelsImages: "san", address: "170 S Market St, San Jose, CA 95113, United States", coordinates: HotelCoordinates(latitude: 37.3336, longitude: -121.8892)), AboutHotels(hotelsName: "Mantra", hotelsImages: "mantra", address: "10360 N Wolfe Rd, Cupertino, CA 95014, United States", coordinates: HotelCoordinates(latitude: 37.3231, longitude: -122.03272))]
    
  

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayHotels.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...

        let label = cell.viewWithTag(1002) as! UILabel
        label.text = arrayHotels[indexPath.row].hotelsName
        
        let imageView = cell.viewWithTag(1001) as! UIImageView
        if let hotelsImages = arrayHotels[indexPath.row].hotelsImages {
            imageView.image = UIImage(named: hotelsImages)
        }
        let address = cell.viewWithTag(1003) as! UILabel
        address.text = arrayHotels[indexPath.row].address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! ViewController
        vc.getModel(model2: arrayHotels[indexPath.row])
        
//        vc.hotel = arrayHotels[indexPath.row]
        
        navigationController?.show(vc, sender: self)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
