//
//  HackNewsTableViewCell.swift
//  HackNews(UIKit)
//
//  Created by Anderson on 2020/5/30.
//  Copyright © 2020 com.Anderson. All rights reserved.
//

import UIKit
import HackerNewsAPI

class HackNewsTableViewCell: UITableViewCell {
  
  var story: Story? {
    didSet {
      guard let story = story else {
        return
      }
      self.textLabel?.text = story.title
      self.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
      self.textLabel?.textColor = .orange
      
      self.detailTextLabel?.textColor = UIColor.secondaryLabel
      self.detailTextLabel?.text = "By \(story.by)"
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
