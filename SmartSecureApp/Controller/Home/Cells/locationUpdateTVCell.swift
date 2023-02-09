//
//  locationUpdateTVCell.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 02/01/2023.
//

import UIKit

class locationUpdateTVCell: UITableViewCell {
    
    @IBOutlet weak var cell_view: UIView!
    @IBOutlet weak var lbl_lat: UILabel!
    
    @IBOutlet weak var lbl_long: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
