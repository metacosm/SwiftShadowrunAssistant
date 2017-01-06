//
//  AttributeViewCell.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import UIKit

class AttributeViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var baseValueText: UITextField!
    @IBOutlet weak var modifiersLabel: UILabel!
    @IBOutlet weak var modifiedValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initFrom(attribute: Attribute) {
        nameLabel.text = attribute.name
        baseValueText.text = String(attribute.value)
        modifiedValueLabel.text = "= \(attribute.modifiedValue)"
        var modifiersAsString = attribute.modifiersAsString
        if(modifiersAsString == nil) {
            modifiersAsString = ""
        }
        modifiersLabel.text = modifiersAsString!
    }

}
