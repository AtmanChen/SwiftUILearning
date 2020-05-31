//
//  ViewController.swift
//  HackNews(UIKit)
//
//  Created by Anderson on 2020/5/30.
//  Copyright © 2020 com.Anderson. All rights reserved.
//

import UIKit
import HackerNewsAPI
import Combine

class ViewController: UIViewController {
  
  let api = API()
  
  @IBOutlet weak var tableView: UITableView!
  
  var subscriptions: Set<AnyCancellable> = []
  
  var stories: [Story] = []
  
  private let activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    return activityIndicator
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = activityIndicator
    tableView.register(HackNewsTableViewCell.self, forCellReuseIdentifier: "HackNewsTableViewCell")
    self.activityIndicator.startAnimating()
    api.stories()
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveCompletion: { _ in
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
      })
      .catch { _ in Empty() }
      .assign(to: \.stories, on: self)
      .store(in: &subscriptions)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    stories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "HackNewsTableViewCell") as? HackNewsTableViewCell
    if cell == nil {
      cell = HackNewsTableViewCell(style: .subtitle, reuseIdentifier: "HackNewsTableViewCell")
    }
    cell!.story = stories[indexPath.row]
    return cell!
  }
}

