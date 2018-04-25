//
//  SearchTableVCell.swift
//  ERafinaApp
//
//  Created by Ankit Nigam on 15/06/17.
//  Copyright © 2017 Arpit Trivedi. All rights reserved.
//

import UIKit

class MytableViewCell: UITableViewCell {

    
    @IBOutlet weak var myContentView: UIView!
 //   @IBOutlet weak var myTextMessageView: UITextView!
    
    @IBOutlet weak var myBobleView: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
