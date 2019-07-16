//
//  FeriOptions.swift
//  Wrath
//
//  Created by Thomas Loring on 7/9/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import UIKit

class FeriOptions: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var options = [Option]()
    var strMultiplier: Double = 1
    var strength = 0
    var numberOfAttacks = 0
    var attackBonus = 0
    var d6s = 0
    var d8s = 0
    var damageBonus = 0
    var critd6s = 0
    var critd8s = 0
    var critDamageBonus = 0
    var dragonStyle = false
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var vitalStrikeButton: UIButton!
    @IBOutlet weak var flurryButton: UIButton!
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var damageButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var attacksLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOptions()
        register()
        calculate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(calculate), name:NSNotification.Name(rawValue: "PCChanged"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "PCChanged"), object: nil)
    }
    
    func register() {
        for btn in [vitalStrikeButton, flurryButton, attackButton, damageButton, settingsButton] {
            roundButton(btn!)
        }
        
        optionsTable.register(UINib(nibName: "FeriOptionCell", bundle: .main), forCellReuseIdentifier: "FeriOptionCell")
        
        gradientView.createGradientBackground(topColor: UIColor.clear, bottomColor: UIColor.white)
        
        optionsTable.delegate = self
        optionsTable.dataSource = self
    }
    
    func loadOptions() {
        do {
            try options = context.fetch(Option.fetchRequest())
        } catch {
            print("Did not fetch Options")
        }
        options = options.sorted(by: { $0.order < $1.order })
        optionsTable.reloadData()
    }
    
    func roundButton(_ btn: UIButton) {
        btn.layer.cornerRadius = btn.bounds.height / 2
        btn.clipsToBounds = true
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        let settings = Settings(nibName: "Settings", bundle: .main)
        settings.modalPresentationStyle = .overCurrentContext
        self.present(settings, animated: true, completion: nil)
    }
    
    @objc func calculate() {
        loadOptions()
        optionsTable.reloadData()
        
        attackBonus = 0
        
        d6s = 1
        d8s = 0
        damageBonus = 0
        
        critd6s = 2
        critd8s = 0
        critDamageBonus = 0
        
        let ud = UserDefaults.standard
        numberOfAttacks = ud.value(forKey: "numberOfAttacks") as! Int
        strength = ud.value(forKey: "baseStrength") as! Int
        
        attackBonus += ud.value(forKey: "bab") as! Int
        attackBonus += ud.value(forKey: "miscAttackBonus") as! Int
        damageBonus += ud.value(forKey: "miscDamageBonus") as! Int
        critDamageBonus += 2 * (ud.value(forKey: "miscDamageBonus") as! Int)
        
        strMultiplier = 1
        var firstAttack = false
        dragonStyle = false
        
        let enabledOptions = options.filter { $0.enable }
        for option in enabledOptions {
            switch option.name {
            case "First Attack" :
                firstAttack = true
                if dragonStyle {
                    strMultiplier = 2
                }
            case "Mutagen":
                d6s = 0
                critd6s = 0
                
                d8s = 1
                critd8s = 2
            case "Haste" :
                numberOfAttacks += 1
            case "Dragon Style" :
                dragonStyle = true
                if firstAttack {
                    strMultiplier = 2
                } else {
                    strMultiplier = 1.5
                }
            default:
                break
            }
            
            for bonus in option.bonuses?.array as! [Bonus] {
                switch bonus.bonusTo {
                case "Strength" :
                    strength += Int(bonus.value)
                case "Attack" :
                    attackBonus += Int(bonus.value)
                case "Damage" :
                    damageBonus += Int(bonus.value)
                    d6s += Int(bonus.variable)
                case "CritDamage" :
                    critDamageBonus += Int(bonus.value)
                    critd6s += Int(bonus.variable)
                default:
                    break
                }
            }
            
            
        }
        
        attackBonus += strength
        damageBonus += Int( strMultiplier * Double( strength ) )
        critDamageBonus += 2 * ( Int( strMultiplier * Double( strength ) ) )
        
        strengthLabel.text = "Strength: \(strength)"
        attacksLabel.text = "Attacks: \(numberOfAttacks)"
       
        attackButton.setTitle("+\(attackBonus)", for: .normal)
        
        var damageString = ""
        if d8s != 0 {
            damageString.append("\(d8s)d8")
            if d6s != 0 {
                damageString.append("+")
            }
        }
        if d6s != 0 {
            damageString.append("\(d6s)d6")
        }
        damageString.append("+\(damageBonus)")
        damageButton.setTitle(damageString, for: .normal)
        
    }
    
    @IBAction func attackTapped(_ sender: Any) {

        let attack = Attack(attackBonus: attackBonus, damageBonus: 0, dice: [], critDamageBonus: 0, critDice: [])
        
        let ac = UIAlertController(title: "\(attack.attackRoll) to hit", message: "Rolled \(attack.attackDie)\nConfirm: \(attack.confirmRoll)(\(attack.confirmDie))", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        ac.addAction(done)
        ac.view.tintColor = UIColor.init(named: "FeriKey")
        present(ac, animated: true)
    }
    
    @IBAction func damageTapped(_ sender: Any) {
        var dice = [Int]()
        if d6s > 0 {
            for _ in 1...d6s {
                dice.append(6)
            }
        }
        if d8s > 0 {
            for _ in 1...d8s {
                dice.append(8)
            }
        }
        var critDice = [Int]()
        if critd6s > 0 {
            for _ in 1...critd6s {
                critDice.append(6)
            }
        }
        if critd8s > 0 {
            for _ in 1...critd8s {
                critDice.append(8)
            }
        }
        let attack = Attack(attackBonus: attackBonus, damageBonus: damageBonus, dice: dice, critDamageBonus: critDamageBonus, critDice: critDice)
        
        let ac = UIAlertController(title: "\(attack.normalDamage) damage", message: "Crit: \(attack.critDamage)", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        ac.addAction(done)
        ac.view.tintColor = UIColor.init(named: "FeriKey")
        present(ac, animated: true)
    }
    
    @IBAction func vitalStrikeTapped(_ sender: Any) {
        
        let enabledOptions = options.filter { $0.enable && $0.vital }
        for option in enabledOptions {
            for bonus in option.bonuses?.array as! [Bonus] {
                switch bonus.bonusTo {
                case "Damage" :
                    d6s += 3 * Int(bonus.variable)
                    critd6s += 3 * Int(bonus.variable)
                default:
                    break
                }
            }
        }
        
        for option in options {
            if option.name == "Mutagen" {
                if option.enable {
                    d8s += 3
                    critd8s += 6
                } else {
                    d6s += 3
                    critd6s += 6
                }
            }
        }
        
        damageBonus = damageBonus * 4
        critDamageBonus = damageBonus * 5 / 4
        
        let vs = VitalStrike(nibName: "VitalStrike", bundle: .main)
        
        var dice = [Int]()
        if d6s > 0 {
            for _ in 1...d6s {
                dice.append(6)
            }
        }
        if d8s > 0 {
            for _ in 1...d8s {
                dice.append(8)
            }
        }
        var critDice = [Int]()
        if critd6s > 0 {
            for _ in 1...critd6s {
                critDice.append(6)
            }
        }
        if critd8s > 0 {
            for _ in 1...critd8s {
                critDice.append(8)
            }
        }
        
        vs.attack = Attack(attackBonus: attackBonus, damageBonus: damageBonus, dice: dice, critDamageBonus: critDamageBonus, critDice: critDice)
        
        print("Damage: \(d8s)d8+\(d6s)d6+\(damageBonus)")
        print("Crit: \(critd8s)d8+\(critd6s)d6+\(critDamageBonus)")
        
        calculate()
        
        vs.modalPresentationStyle = .overCurrentContext
        present(vs, animated: true)
    }
    
    @IBAction func flurryTapped(_ sender: Any) {
    }
    
}



