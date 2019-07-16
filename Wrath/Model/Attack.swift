//
//  Attack.swift
//  Wrath
//
//  Created by Thomas Loring on 7/9/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import GameKit

class Attack {
    var attackBonus: Int
    
    var attackDie: Int
    var attackRoll: Int
    
    var confirmRoll: Int
    var confirmDie: Int
    
    
    var damageBonus: Int
    var dice: Array<Int>
    var normalDamage: Int

    var critDamageBonus: Int
    var critDice: Array<Int>
    var critDamage: Int
    
    var damage: Int
    var hit: Bool
    var crit: Bool
    
    init(attackBonus: Int, damageBonus: Int, dice: Array<Int>, critDamageBonus: Int, critDice: Array<Int>) {
        self.attackBonus = attackBonus
        self.damageBonus = damageBonus
        self.dice = dice
        self.critDamageBonus = critDamageBonus
        self.critDice = critDice
        self.attackDie = 0
        self.attackRoll = 0
        self.confirmRoll = 0
        self.confirmDie = 0
        self.normalDamage = 0
        self.critDamage = 0
        self.damage = 0
        self.hit = false
        self.crit = false
        roll()
    }
    
    func roll() {
        rerollAttack()
        rerollDamage()
    }
    
    func rerollAttack() {
        self.attackDie = ( Int(arc4random_uniform(19)) + 1 )
        self.attackRoll = attackDie + attackBonus
        
        self.confirmDie = ( Int(arc4random_uniform(19)) + 1 )
        self.confirmRoll = confirmDie + attackBonus
    }
    
    func rerollDamage() {
        print("Damage Dice:")
        var damageDiceResults = 0
        for die in dice {
            var roll = Int(arc4random_uniform(UInt32(die - 1))) + 1
            roll = roll <= 2 ? die : roll
            damageDiceResults += roll
            print("\(roll) (\(die))")
        }
        self.normalDamage = damageDiceResults + damageBonus
        
        print("Crit Dice:")
        var critDiceResults = 0
        for die in critDice {
            var roll = Int(arc4random_uniform(UInt32(die - 1))) + 1
            roll = roll <= 2 ? die : roll
            critDiceResults += roll
            print("\(roll) (\(die))")
        }
        self.critDamage = critDiceResults + critDamageBonus
    }
    
    
}








