//
//  RadioButtonController.swift
//  Math Racing Go
//
//  Created by Quan Tran on 4/18/21.
//  Copyright © 2021 QuanTran. All rights reserved.
//

import UIKit

class RadioButtonController: NSObject {
    
    // MARK: Properties
    
    // set element in button array
    var buttonArray: [UIButton] = [] {
        didSet {
            for btn in buttonArray {
                btn.setImage(UIImage(named: "Uncheckradio"), for: .normal)
                btn.setImage(UIImage(named: "Checkradio"), for: .selected)
            }
        }
    }
    
    var selectedButton: UIButton?
    
    // defaul element radio
    var defaulButton: UIButton = UIButton() {
        didSet {
            buttonArrayUpdated(buttonSelected: self.defaulButton)
        }
    }
    
    // MARK: functions
    
    // function update radio when there is a new option
    func buttonArrayUpdated(buttonSelected: UIButton) {
        for btn in buttonArray {
            if btn == buttonSelected {
                selectedButton = btn
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
    }
    
}
