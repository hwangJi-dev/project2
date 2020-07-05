//
//  mainTableViewCell.swift
//  diaryProject
//
//  Created by 황지은 on 2020/07/05.
//  Copyright © 2020 황지은. All rights reserved.
//

import UIKit

class mainTableViewCell: UITableViewCell {

    @IBOutlet var mainID: UILabel!
    @IBOutlet var mainImg: UIImageView!
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var mainDate: UILabel!
    @IBOutlet var mainStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
