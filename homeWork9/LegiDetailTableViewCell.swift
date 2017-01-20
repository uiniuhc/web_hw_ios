//
//  LegiDetailTableViewCell.swift
//  homeWork9
//
//  Created by Zhang.Hanqiu on 11/28/16.
//  Copyright © 2016 hanqiu_have_fun. All rights reserved.
//

import UIKit

class LegiDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var legiDetailLabel: UILabel!
    @IBOutlet weak var legiDetaiContent: UILabel!
    @IBOutlet weak var legiDetailButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
