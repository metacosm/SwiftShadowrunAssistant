//
//  AttributeViewCell.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 18/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import UIKit

class CharacteristicViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dicePoolRollButton: UIButton!
    @IBOutlet weak var edgeRollButton: UIButton!

    private var characteristic: Characteristic! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initFrom(characteristic: Characteristic, tag: Int) {
        self.characteristic = characteristic
        nameLabel.text = characteristic.name()

        dicePoolRollButton.setTitle("Roll \(characteristic.dicePoolSize()) die", for: .normal)
        dicePoolRollButton.tag = tag

        edgeRollButton.tag = tag
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
