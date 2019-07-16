//
//  Settings.swift
//  Wrath
//
//  Created by Thomas Loring on 7/10/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import UIKit

class Settings: UIViewController {
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var babTextField: UITextField!
    @IBOutlet weak var strengthTextField: UITextField!
    @IBOutlet weak var attackTextField: UITextField!
    @IBOutlet weak var damageTextField: UITextField!
    @IBOutlet weak var numberOfAttacksTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overCurrentContext
        
        gradientView.layer.cornerRadius = gradientView.bounds.height / 2
        gradientView.clipsToBounds = true
        
        doneButton.layer.cornerRadius = doneButton.bounds.height / 2
        doneButton.clipsToBounds = true
        
        setDelegates()
        showDefaults()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let ud = UserDefaults.standard
        
        ud.set(Int(babTextField.text ?? "") ?? 0, forKey: "bab")
        ud.set(Int(strengthTextField.text ?? "") ?? 0, forKey: "baseStrength")
        ud.set(Int(attackTextField.text ?? "") ?? 0, forKey: "miscAttackBonus")
        ud.set(Int(damageTextField.text ?? "") ?? 0, forKey: "miscDamageBonus")
        ud.set(Int(numberOfAttacksTextField.text ?? "") ?? 0, forKey: "numberOfAttacks")
        
        self.dismiss(animated: true)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        
        let ac = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let doIt = UIAlertAction(title: "Do It!", style: .destructive) { (_) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            var options = [Option]()
            do {
                try options = context.fetch(Option.fetchRequest())
            } catch {
                print("did not fetch")
            }
            
            for option in options {
                context.delete(option)
            }
            
            (UIApplication.shared.delegate as! AppDelegate).createOptions()
        }
        ac.addAction(cancel)
        ac.addAction(doIt)
        ac.view.tintColor = UIColor.init(named: "FeriKey")
        present(ac, animated: true)
    }
    
    
}

extension Settings: UITextFieldDelegate {
    
    func setDelegates() {
        babTextField.delegate = self
        babTextField.addDoneToolbar()
        strengthTextField.delegate = self
        strengthTextField.addDoneToolbar()
        attackTextField.delegate = self
        attackTextField.addDoneToolbar()
        damageTextField.delegate = self
        damageTextField.addDoneToolbar()
        numberOfAttacksTextField.delegate = self
        numberOfAttacksTextField.addDoneToolbar()
    }
    
    func showDefaults() {
        let ud = UserDefaults.standard
        
        babTextField.text = "\(ud.value(forKey: "bab") ?? "")"
        strengthTextField.text = "\(ud.value(forKey: "baseStrength") ?? "")"
        attackTextField.text = "\(ud.value(forKey: "miscAttackBonus") ?? "")"
        damageTextField.text = "\(ud.value(forKey: "miscDamageBonus") ?? "")"
        numberOfAttacksTextField.text = "\(ud.value(forKey: "numberOfAttacks") ?? "")"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let ud = UserDefaults.standard
        
        ud.set(Int(babTextField.text ?? "") ?? 0, forKey: "bab")
        ud.set(Int(strengthTextField.text ?? "") ?? 0, forKey: "baseStrength")
        ud.set(Int(attackTextField.text ?? "") ?? 0, forKey: "miscAttackBonus")
        ud.set(Int(damageTextField.text ?? "") ?? 0, forKey: "miscDamageBonus")
        ud.set(Int(numberOfAttacksTextField.text ?? "") ?? 0, forKey: "numberOfAttacks")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PCChanged"), object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
