//
//  CategoryTableViewController.swift
//  Weekly
//
//  Created by Matthew Turk on 1/25/20.
//  Copyright © 2020 Francis W. Parker School. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var category: [WPPost]?
    var id: Int?
    let web = WPWeb(url: "https://weekly.fwparker.org")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let id = id {
            load(id: id)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryDetailTableViewCell

        // Configure the cell...
        cell.titleLabel.text = category?[indexPath.row].title.rendered.clean() ?? ""
        cell.summaryLabel.text = category?[indexPath.row].excerpt.rendered.clean() ?? ""
        cell.featuredImage.setImage(from: category?[indexPath.row].better_featured_image?.source, placeholder: UIImage(named: "placeholder"))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        vc?.post = category?[indexPath.item]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func load(id: Int) {
        WPPost.getPosts(web: web, numberOfPosts: 30, after: nil, categories: [id]) { (posts) in
            DispatchQueue.main.async {
                self.category = posts
                self.tableView.reloadData()

            }
        }
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
