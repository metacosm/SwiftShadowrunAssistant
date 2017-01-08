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

    func initFrom(characteristic: Characteristic) {
        nameLabel.text = characteristic.name()
        baseValueText.text = String(characteristic.value())
        modifiedValueLabel.text = "= \(characteristic.dicePoolSize())"
        modifiersLabel.text = characteristic.modifiersAsString
    }

}

extension Characteristic {
    var modifiersAsString: String {
        get {
            if let modifiers = modifiers() {
                return "\(modifiers.map({ String($0.modifierAsString) }).joined(separator: " "))"
            }

            return ""
        }
    }

    var valueAsString: String {
        get {
            return "\(value()) \(modifiersAsString)".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
}
