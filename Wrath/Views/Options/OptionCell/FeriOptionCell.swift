//
//  FeriOptionCell.swift
//  Wrath
//
//  Created by Thomas Loring on 7/9/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import UIKit

class FeriOptionCell: UITableViewCell {
    
    var option: Option?
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var bonusHighlight: UIView!
    @IBOutlet weak var bonusLabel: UILabel!
    
    @IBAction func switched(_ sender: UISwitch) {
        option!.enable = sender.isOn
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PCChanged"), object: nil)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
}
