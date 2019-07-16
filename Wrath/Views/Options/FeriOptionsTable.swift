//
//  FeriOptionsTable.swift
//  Wrath
//
//  Created by Thomas Loring on 7/9/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import UIKit

extension FeriOptions: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeriOptionCell", for: indexPath) as! FeriOptionCell
        cell.bonusHighlight.clipsToBounds = true
        cell.bonusHighlight.layer.cornerRadius = cell.bonusHighlight.bounds.height / 2
        
        let option = options[indexPath.row]
        cell.option = option
        cell.bonusLabel.text = option.name
        cell.enabledSwitch.isOn = option.enable
        return cell
    }
    
    
    
    
    
}
