//
//  HackNewsTableViewController.swift
//  HackNews(UIKit)
//
//  Created by Anderson on 2020/5/31.
//  Copyright © 2020 com.Anderson. All rights reserved.
//

import UIKit
import Combine
import HackerNewsAPI

class HackNewsTableViewController: UITableViewController {
  let api = API()
  var subscriptions: Set<AnyCancellable> = []
  var stories: [Story] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.contentOffset = CGPoint(x: 0, y: 64)
    self.tableView.tableFooterView = UIView()
    self.refreshControl = UIRefreshControl()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.refreshControl?.beginRefreshing()
    api.stories()
      .print()
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveCompletion: { _ in
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
      })
      .catch { _ in Empty() }
      .assign(to: \.stories, on: self)
      .store(in: &subscriptions)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return stories.count
  }
  
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "HackNewsTableViewCell") as? HackNewsTableViewCell
    if cell == nil {
      cell = HackNewsTableViewCell(style: .subtitle, reuseIdentifier: "HackNewsTableViewCell")
    }
    cell!.story = stories[indexPath.row]
    return cell!
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
