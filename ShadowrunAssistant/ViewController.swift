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
    private var currentCharacter: Character
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

    @IBAction func roll(_ sender: UIButton, forEvent event: UIEvent) {
        let tag = sender.tag
        let attribute = currentCharacter.attributes()[tag]
        let roll = attribute.roll(usingEdge: false)

        result.text = "\(attribute.name()) roll: \(roll.successes)/\(attribute.dicePoolSize())"
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
        return currentCharacter.attributesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // retrieve attribute name for row based on order
        let row = indexPath.row
        let attribute = currentCharacter.attributes()[row]

        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.attributeCellProtoId, for: indexPath) as? CharacteristicViewCell

        // Configure the cell...
        guard ((cell?.initFrom(characteristic: attribute, tag: row)) != nil) else {
            return UITableViewCell(style: .default, reuseIdentifier: ViewController.attributeCellProtoId)
        }
        cell?.initFrom(characteristic: attribute, tag: row)


        return cell!
    }

    func numberOfSections(`in` tableView: UITableView) -> Int {
        return 1
    }
}

