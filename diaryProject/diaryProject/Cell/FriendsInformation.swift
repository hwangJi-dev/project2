//
//  FriendsInformation.swift
//  diaryProject
//
//  Created by 황지은 on 2020/06/22.
//  Copyright © 2020 황지은. All rights reserved.
//

import Foundation

struct FreindsInformation{
    var profileImg: String?
    var profileName:String
    var statusLabel:String

    init(profileImg: String, profileName:String, statusLabel:String){
        self.profileImg = profileImg
        self.profileName = profileName
        self.statusLabel = statusLabel
    }
}
