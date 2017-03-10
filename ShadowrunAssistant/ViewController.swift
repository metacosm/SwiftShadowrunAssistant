//
//  ViewController.swift
//  ShadowrunAssistant
//
//  Created by Christophe Laprun on 14/12/2016.
//  Copyright © 2016 Christophe Laprun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    private let engine: Engine = Engine()
   private var currentCharacter: Shadowrunner
    private static let attributeCellProtoId = "AttributeCell"

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var result: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init?(coder aDecoder: NSCoder) {
        // init character
        self.currentCharacter = engine.characterRegistry().zetsubo()
        super.init(coder: aDecoder)
    }

    @IBAction func roll(_ sender: UIButton) {
        roll(sender, withEdge: false)
    }

    @IBAction func rollWithEdge(_ sender: UIButton) {
        roll(sender, withEdge: true)
    }

    func roll(_ sender: UIButton, withEdge: Bool) {
        let tag = sender.tag
        let isAttribute = tag - 100 < 0
        let row = isAttribute ? tag : tag - 100

       let characteristic = isAttribute ? currentCharacter.attributes[row] : currentCharacter.skills[row]
       let roll = engine.roll(characteristic.info, for: currentCharacter, usingEdge: withEdge)

       result.text = "\(characteristic.info.name) roll: \(roll.successes)/\(characteristic.dicePool)"
        result.textColor = .black
        if roll.isGlitch() {
            result.text!.append(" glitched")
            if roll.isCriticalGlitch() {
                result.textColor = .red
                result.text!.append(" critically!")
            } else {
                result.text!.append("!")
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return section == 0 ? currentCharacter.attributesCount : currentCharacter.skillsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // retrieve attribute name for row based on order
        let row = indexPath.row
        let section = indexPath.section

       let characteristic: Characteristic
        switch section {
        case 0:
           characteristic = currentCharacter.attributes[row]
        case 1:
           characteristic = currentCharacter.skills[row]
        default:
            characteristic = currentCharacter.attribute(Engine.edge)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.attributeCellProtoId, for: indexPath) as? CharacteristicViewCell

        let tag = 100 * section + row
        // Configure the cell...
        guard ((cell?.initFrom(characteristic: characteristic, tag: tag)) != nil) else {
            return UITableViewCell(style: .default, reuseIdentifier: ViewController.attributeCellProtoId)
        }
        cell?.initFrom(characteristic: characteristic, tag: tag)


        return cell!
    }

    func numberOfSections(`in` tableView: UITableView) -> Int {
        return 2
    }
}

