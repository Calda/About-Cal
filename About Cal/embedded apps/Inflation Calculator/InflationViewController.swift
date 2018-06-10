//
//  ViewController.swift
//  Inflation Calculator
//
//  Created by Cal on 10/4/14.
//  Copyright (c) 2015 Cal. All rights reserved.
//

import UIKit

class InflationViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet var leftYearLabel: UILabel!
    @IBOutlet var leftYearButton: UIButton!
    @IBOutlet var rightYearLabel: UILabel!
    @IBOutlet var rightYearButton: UIButton!
    
    @IBOutlet var datePicker: UIPickerView!
    @IBOutlet var leftAmountLabel: UILabel!
    @IBOutlet var leftAmountButton: UIButton!
    @IBOutlet var rightAmountLabel: UILabel!
    @IBOutlet var rightAmountButton: UIButton!
    @IBOutlet var yearPicker: UIPickerView!
    @IBOutlet var clearButton: UIButton!
    
    @IBOutlet weak var titleLabel: UIButton!
    @IBOutlet weak var greenBarLabel: UILabel!
    
    var activeLabel : UILabel? = nil
    var CPI : Array<Double> = []
    
    var leftAmount : Double = 0
    var rightAmount : Double = 0
    var leftTemp : Double = 0
    var rightTemp : Double = 0
    
    var leftDecimal : Bool = false
    var rightDecimal : Bool = false
    var leftHasOneDecimal : Bool = false
    var rightHasOneDecimal : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aspectRatio = Double(self.view.bounds.size.height / self.view.bounds.size.width)
        
        if(aspectRatio < 1.7){
            leftYearLabel.isHidden = true
            rightYearLabel.isHidden = true
            leftYearButton.isHidden = true
            rightYearButton.isHidden = true
            
            let constraint = NSLayoutConstraint(item: yearPicker, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: clearButton, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)
            self.view.addConstraint(constraint)
            
        } else {
            let constraint = NSLayoutConstraint(item: yearPicker, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: rightYearLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 25)
            self.view.addConstraint(constraint)
        }
        
        
        if(self.view.bounds.height < 667){ //4S, 5, 5S
            let constraint = NSLayoutConstraint(item: yearPicker, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: yearPicker, attribute: NSLayoutAttribute.height, multiplier: 1.90531, constant: 1) //1.97531
            self.view.addConstraint(constraint)
            titleLabel.isHidden = true
            greenBarLabel.isHidden = true
        }
        else if(self.view.bounds.height > 730){ //6Plus
            let constraint = NSLayoutConstraint(item: yearPicker, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: yearPicker, attribute: NSLayoutAttribute.height, multiplier: 1.59, constant: 1)
            self.view.addConstraint(constraint)
            titleLabel.isHidden = true
            greenBarLabel.isHidden = true
        } else {
            self.title = ""
        }
        
        //load CPI data
        let bundle = Bundle.main
        let path = bundle.path(forResource: "CPIdata", ofType: "txt")
        var err: NSError? = nil
        let content: String?
        do {
            content = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            err = error
            content = nil
            print(err ?? "")
        }
        let strings = content?.components(separatedBy: "\n")
        for s in strings!{
            CPI.append(NSString(string: s).doubleValue)
        }
        
        activeLabel = leftAmountLabel
        datePicker.delegate = self
        datePicker.selectRow(35, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        var currentValue : Double
        var hasDecimal : Bool
        var hasOneDecimal : Bool
        
        if(activeLabel == leftAmountLabel){
            currentValue = leftAmount
            hasDecimal = leftDecimal
            hasOneDecimal = leftHasOneDecimal
            rightDecimal = true
            rightHasOneDecimal = true
            leftTemp = 0
            rightTemp = 0
        } else {
            currentValue = rightAmount
            hasDecimal = rightDecimal
            hasOneDecimal = rightHasOneDecimal
            leftDecimal = true
            leftHasOneDecimal = true
            leftTemp = 0
            rightTemp = 0
        }
        
        if(currentValue >= 999999999999 && !(hasDecimal)){
            return;
        }
        
        if(hasDecimal){
            if(hasOneDecimal){
                if(String(NSString(format: "%.02f", currentValue)).hasSuffix("0")){
                   currentValue += Double(Int(sender.titleLabel!.text!)!) / 100
                }
            }else{
                currentValue += Double(Int(sender.titleLabel!.text!)!) / 10
                if(activeLabel == leftAmountLabel){
                    leftHasOneDecimal = true
                } else {
                    rightHasOneDecimal = true
                }
            }
        }
        
        else{
            print(currentValue, terminator: "")
            currentValue *= 10
            currentValue += Double(Int(sender.titleLabel!.text!)!)
        }
        
        if(activeLabel == leftAmountLabel){
           leftAmount = currentValue
        } else {
            rightAmount = currentValue
        }
        
        self.updateAmounts()
    }
    
    @IBAction func pointButtonPressed(_ sender: UIButton) {
        if(activeLabel == leftAmountLabel && !(leftDecimal)){
            leftDecimal = true
            leftHasOneDecimal = false
        } else if (activeLabel == rightAmountLabel && !(rightDecimal)){
            rightDecimal = true
            rightHasOneDecimal = false
        }
        updateAmounts()
    }
    
    func updateAmounts() {
        var activeAmount : Double
        var inactiveLabel : UILabel
        var activeYear : Int
        var inactiveYear : Int
        var activeHasDecimal : Bool
        if(activeLabel == leftAmountLabel){
            activeAmount = leftAmount
            activeHasDecimal = leftDecimal
            activeYear = Int(leftYearLabel.text!)!
            inactiveLabel = rightAmountLabel
            inactiveYear = Int(rightYearLabel.text!)!
        } else {
            activeAmount = rightAmount
            activeHasDecimal = rightDecimal
            activeYear = Int(rightYearLabel.text!)!
            inactiveLabel = leftAmountLabel
            inactiveYear = Int(leftYearLabel.text!)!
        }
        
        let activeCPI = CPI[CPI.count - (2016 - activeYear)]
        let inactiveCPI = CPI[CPI.count - (2016 - inactiveYear)]
        
        let inactiveAmount : Double = activeAmount * (inactiveCPI / activeCPI)
        
        if(activeLabel == leftAmountLabel){
            rightAmount = inactiveAmount
        }else{
            leftAmount = inactiveAmount
        }
        
        inactiveLabel.text = formatAmount(inactiveAmount, hasDecimal: true)
        activeLabel!.text = formatAmount(activeAmount, hasDecimal: activeHasDecimal)
    }
    
    func formatAmount(_ amount:Double, hasDecimal:Bool) -> String {
        let floatRounded = String(NSString(format: "%.02f", amount))
        
        let range = (floatRounded.startIndex ..< floatRounded.index(before: floatRounded.index(before: floatRounded.index(before: floatRounded.endIndex))))
        var withoutDecimal = floatRounded[range]
        
        
        var pieces : Array<String> = []
        while(withoutDecimal.count > 3){
            let index = withoutDecimal.index(before: withoutDecimal.index(before: withoutDecimal.index(before: withoutDecimal.endIndex)))
            pieces.append(String(withoutDecimal[index...]))
            withoutDecimal = withoutDecimal[..<index]
        }
        pieces.append(String(withoutDecimal))
        
        pieces = Array(pieces.reversed())
        var moneyFormatted = pieces[0]
        if(pieces.count > 1){
            for i in 1...(pieces.count - 1){
                moneyFormatted += ",\(pieces[i])"
            }
        }
        
        if(hasDecimal){
            moneyFormatted += floatRounded[range.upperBound...]
        }
        
        return "$\(moneyFormatted)"
    }
    
    @IBAction func amountButtonPressed(_ sender: UIButton) {
        if(sender.tag == 1){ //left button
            activeLabel = leftAmountLabel
            rightAmountButton.backgroundColor = UIColor(red: 40/255, green: 154/255, blue: 100/255, alpha: 1)
            leftAmountButton.backgroundColor = UIColor(red: 14/255, green: 105/255, blue: 56/255, alpha: 1)
            rightYearButton.backgroundColor = UIColor(red: 40/255, green: 154/255, blue: 100/255, alpha: 1)
            leftYearButton.backgroundColor = UIColor(red: 17/255, green: 131/255, blue: 76/255, alpha: 1)
            leftHasOneDecimal = false
            leftDecimal = false
            leftTemp = (leftTemp != 0 ? leftTemp : leftAmount)
            leftAmount = 0
        }
        else{ //right button
            activeLabel = rightAmountLabel
            leftAmountButton.backgroundColor = UIColor(red: 40/255, green: 154/255, blue: 100/255, alpha: 1)
            rightAmountButton.backgroundColor = UIColor(red: 14/255, green: 105/255, blue: 56/255, alpha: 1)
            leftYearButton.backgroundColor = UIColor(red: 40/255, green: 154/255, blue: 100/255, alpha: 1)
            rightYearButton.backgroundColor = UIColor(red: 17/255, green: 131/255, blue: 76/255, alpha: 1)
            rightHasOneDecimal = false
            rightDecimal = false
            rightTemp = (rightTemp != 0 ? rightTemp : rightAmount)
            rightAmount = 0
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        leftAmount = 0
        rightAmount = 0
        leftDecimal = false
        rightDecimal = false
        self.updateAmounts()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return (2015 - 1799)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //let attributedString = NSAttributedString(string: "\(2016 - row)", attributes: [NSForegroundColorAttributeName : UIColor(red: 57/255, green: 150/255, blue: 86/255, alpha: 1)])
        let attributedString = NSAttributedString(string: "\(2015 - row)", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            leftYearLabel.text = String(2015 - row)
            updateWithTemps()
            
        }else{
            rightYearLabel.text = String(2015 - row)
            updateWithTemps()
        }
    }
    
    func updateWithTemps(){
        if(leftTemp != 0){
            leftAmount = leftTemp
            leftDecimal = true
        }
        if(rightTemp != 0){
            rightAmount = rightTemp
            rightDecimal = true
        }
            updateAmounts()
        if(leftTemp != 0){
            leftDecimal = false
            leftAmount = 0
        }
        if(rightTemp != 0){
            rightDecimal = false
            rightAmount = 0
        }
        
    }
    
    @IBAction func returned (_ segue: UIStoryboardSegue){
        return;
    }
    
}

