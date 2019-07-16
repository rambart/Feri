//
//  VitalStrike.swift
//  Wrath
//
//  Created by Thomas Loring on 7/12/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import UIKit

class VitalStrike: UIViewController {
    
    var attack: Attack?
    
    @IBOutlet weak var popupWindow: UIView!
    
    @IBOutlet weak var rerollButton: UIButton!
    
    @IBOutlet weak var attackImage: UIImageView!
    @IBOutlet weak var attackLabel: UILabel!
    let attackDieLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        label.text = "X"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-medium", size: CGFloat(15))
        return label
    }()
    
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var confirmLabel: UILabel!
    let confirmDieLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        label.text = "X"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-medium", size: CGFloat(15))
        return label
    }()
    
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var criticalLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawViews()
        showAttack()
    }
    
    func drawViews() {
        attackImage.addSubview(attackDieLabel)
        
        confirmImage.addSubview(confirmDieLabel)
        
        popupWindow.layer.cornerRadius = 30
        popupWindow.clipsToBounds = true
        popupWindow.layer.borderWidth = 1
        popupWindow.layer.borderColor = UIColor.init(named: "FeriKey")?.cgColor
        
        rerollButton.layer.cornerRadius = rerollButton.bounds.height / 2
        rerollButton.clipsToBounds = true
        
        doneButton.layer.cornerRadius = doneButton.bounds.height / 2
        doneButton.clipsToBounds = true
    }
    
    func showAttack() {
        attackLabel.text = "\(attack!.attackRoll)"
        attackDieLabel.text = "\(attack!.attackDie)"
        
        confirmLabel.text = "\(attack!.confirmRoll)"
        confirmDieLabel.text = "\(attack!.confirmDie)"
        
        damageLabel.text = "\(attack!.normalDamage)"
        criticalLabel.text = "\(attack!.critDamage)"
    }
    
    @IBAction func rerollAttack(_ sender: Any) {
        attack!.roll()
        showAttack()
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
