//
//  LegiTableViewCell.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit

class LegiTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var legiImage: UIImageView!
    @IBOutlet weak var legiState: UILabel!
    @IBOutlet weak var legiName: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
