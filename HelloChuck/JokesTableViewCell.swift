//
//  JokesTableViewCell.swift
//  FoodTracker
//
//  Created by HAN LI on 6/16/16.
//  Copyright © 2016 HAN LI. All rights reserved.
//

import UIKit

class JokeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var jokeText: UILabel!
    @IBOutlet weak var index: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
