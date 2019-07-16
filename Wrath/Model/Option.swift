//
//  Option.swift
//  Wrath
//
//  Created by Thomas Loring on 7/9/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import CoreData

extension Option {
    convenience init?(context: NSManagedObjectContext, name: String, Bonuses: Array<Bonus>, vital: Bool = true, order: Int16) {
        self.init(context: context)
        self.name = name
        self.bonuses = NSOrderedSet(array: Bonuses)
        self.order = order
        self.vital = vital
    }
}

extension Bonus {
    convenience init?(context: NSManagedObjectContext, bonusTo: String, value: Int16 = 0, variable: Int16 = 0) {
        self.init(context: context)
        self.bonusTo = bonusTo
        self.value = value
        self.variable = variable
    }
}


extension AppDelegate {
    func createOptions() {
        let ud = UserDefaults.standard
        
        ud.set(0, forKey: "bab")
        ud.set(0, forKey: "baseStrength")
        ud.set(0, forKey: "miscAttackBonus")
        ud.set(0, forKey: "miscDamageBonus")
        ud.set(0, forKey: "numberOfAttacks")
        
        let context = self.persistentContainer.viewContext
        
        Option(context: context,
               name: "First Attack",
               Bonuses: [],
               order: 0)
        
        Option(context: context,
               name: "Mutagen",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Strength", value: 6)!,
                         Bonus(context: context,
                               bonusTo: "Attack", value: 5)!,
                         Bonus(context: context,
                               bonusTo: "Damage", value: 6)!,
                         Bonus(context: context,
                               bonusTo: "CritDamage", value: 12)!],
               order: 1)
        
        Option(context: context,
               name: "Dragon Style",
               Bonuses: [],
               order: 2)

        Option(context: context,
               name: "Power Attack",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Attack", value: -5)!,
                         Bonus(context: context,
                               bonusTo: "Damage", value: 15)!,
                         Bonus(context: context,
                               bonusTo: "CritDamage", value: 60)!],
               order: 3)
        
        Option(context: context,
               name: "Staggering Blow",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Attack", value: -2)!],
               order: 4)

        Option(context: context,
               name: "Rage",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Strength", value: 1)!],
               order: 5)
        
        Option(context: context,
               name: "Haste",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Attack", value: 1)!],
               order: 6)
        
        Option(context: context,
               name: "Vine Strike",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Damage", variable: 1)!,
                         Bonus(context: context,
                               bonusTo: "CritDamage", variable: 2)!],
               order: 7)
        
        Option(context: context,
               name: "Heroism",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Attack", value: 2)!],
               order: 8)
        
        Option(context: context,
               name: "Sneak Attack",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Damage", variable: 10)!,
                         Bonus(context: context,
                               bonusTo: "CritDamage", variable: 10)!,],
               vital: false,
               order: 9)
        
        Option(context: context,
               name: "Evil Outsider Bane",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Attack", value: 2)!,
                         Bonus(context: context,
                               bonusTo: "Damage", value: 2)!,
                         Bonus(context: context,
                               bonusTo: "CritDamage", value: 4)!,
                         Bonus(context: context,
                               bonusTo: "Damage",  variable: 2)!,
                         Bonus(context: context,
                               bonusTo: "CritDamage", variable: 2)!],
               vital: false,
               order: 10)
        
        Option(context: context,
               name: "Axiomatic",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Damage",  variable: 2)!,
                         Bonus(context: context,
                               bonusTo: "CritDamage", variable: 2)!],
               vital: false,
               order: 11)
        
        Option(context: context,
               name: "Demonic Nemesis",
               Bonuses: [Bonus(context: context,
                               bonusTo: "Attack", value: 2)!,
                         Bonus(context: context,
                               bonusTo: "Damage", value: 2)!,
                         Bonus(context: context,
                               bonusTo: "CritDamage", value: 4)!],
               order: 12)
        
        print("saving.....")
        self.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PCChanged"), object: nil)
    }
}
