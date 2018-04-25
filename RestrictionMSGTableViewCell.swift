//
//  RestrictionMSGTableViewCell.swift
//  KarmaPro
//
//  Created by Macbook Pro on 14/09/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit

class RestrictionMSGTableViewCell: UITableViewCell {
    

    @IBOutlet weak var identyLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sendCellButto: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
