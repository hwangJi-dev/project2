//
//  profileTableViewCell.swift
//  diaryProject
//
//  Created by 황지은 on 2020/06/22.
//  Copyright © 2020 황지은. All rights reserved.
//

import UIKit

class profileTableViewCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileStatusMsg: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProfileInformation(profileImg:String,profileName:String,profileStatus:String){
       // friendsImg.image = UIImage(named: profileImg)
        profileNameLabel.text = profileName
        profileStatusMsg.text = profileStatus
        profileImage.image = UIImage(named: profileImg)
    }
    

}
    
