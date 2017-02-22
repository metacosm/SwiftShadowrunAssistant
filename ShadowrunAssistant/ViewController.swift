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
    
    @IBAction func rollAttribute(_ sender: UIButton) {
        let attribute = sender.currentTitle!;
        result.text = "Rolled \(attribute) dice"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCharacter.attributesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // retrieve attribute name for row based on order
        let attribute = currentCharacter.attributes()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.attributeCellProtoId, for: indexPath) as? CharacteristicViewCell

        // Configure the cell...
        guard ((cell?.initFrom(characteristic: attribute)) != nil) else {
            return UITableViewCell(style: .default, reuseIdentifier: ViewController.attributeCellProtoId)
        }
        cell?.initFrom(characteristic: attribute)

        return cell!
    }

    func numberOfSections(`in` tableView: UITableView) -> Int {
        return 1
    }
}

