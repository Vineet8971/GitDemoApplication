//
//  SettingTableViewCell.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 22/12/2022.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_arrow: UIButton!
    @IBOutlet weak var switch_category: UISwitch!
    @IBOutlet weak var lbl_categoryName: UILabel!
    @IBOutlet weak var cell_view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
