//
//  TimeLineTableViewCell.swift
//  KarmaPro
//
//  Created by Macbook Pro on 11/09/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell , FloatRatingViewDelegate  {

    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var anonymousLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate       = self
        self.floatRatingView.contentMode    = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating      = 5
        self.floatRatingView.minRating      = 0
        self.floatRatingView.rating         = 2
        self.floatRatingView.editable       = false
        self.floatRatingView.halfRatings    = true
        self.floatRatingView.floatRatings   = false

    }
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //starToPostStr = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
       // starToPostStr = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
