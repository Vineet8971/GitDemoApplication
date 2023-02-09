//
//  HistoryRecordTableViewCell.swift
//  SmartSecureApp
//
//  Created by Ranadheer on 23/12/2022.
//

import UIKit

class HistoryRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var lbl_audioFiles: UILabel!
    @IBOutlet weak var cell_view: UIView!
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
