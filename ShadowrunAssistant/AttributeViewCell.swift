//
//  AttributeViewCell.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import UIKit

class AttributeViewCell: UITableViewCell {

    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initFrom(attribute: Attribute) {
        name.text = attribute.name
        value.text = attribute.valueAsString
    }

}
