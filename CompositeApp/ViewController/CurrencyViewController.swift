//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Admin on 2/8/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var MainLabelOutlet: UILabel!
    @IBOutlet weak var InputTextOutlet: UITextField!
    @IBOutlet weak var ConvertButtonOutlet: UIButton!
    @IBOutlet weak var ScrollViewOutlet: UIScrollView!

    let alertController = UIAlertController(
        title: "Invalid input",
        message: nil,
        preferredStyle: .alert
    )
    
    let MAX_VALUE: Double = 1_000_000_000_000_000
    let MAIN_CURRENCY_NAME = "XBT"
    let EXCHANGE_RATES: [(String, Double)] = [
        ("USD", 1_004.00),
        ("CNY", 6_820.50),
        ("EUR", 943.69),
        ("GBP", 804.21),
        ("USD", 1_004.00),
        ("CNY", 6_820.50),
        ("EUR", 943.69),
        ("GBP", 804.21),
        ("USD", 1_004.00),
        ("CNY", 6_820.50),
        ("EUR", 943.69),
        ("GBP", 804.21),
    ]
    
    let CURRENCY_LABEL_HEIGHT = 21
    let CURRENCY_LABEL_DELTA_Y = 45
    
    var currencyLabels: Array<UILabel> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        resetResults()
    }

    private func prepareView() {
        MainLabelOutlet.text = MAIN_CURRENCY_NAME + ":"
//        InputTextOutlet.keyboardType = UIKeyboardType.phonePad
        
        setKeyboardHide()
        setDefaultAlertAction()
        generateLabels(ScrollViewOutlet)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyViewController.onScreenRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    private func showScroll() {
        ScrollViewOutlet.flashScrollIndicators()
    }

    private func setKeyboardHide() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func tapGestureAction(_ sender: UITapGestureRecognizer) {
        InputTextOutlet.resignFirstResponder()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setDefaultAlertAction() {
        let defaultAlertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: {
                (alert: UIAlertAction!) in
                self.InputTextOutlet.becomeFirstResponder()
            }
        )
        alertController.addAction(defaultAlertAction)
    }
    
    private func generateLabels(_ scrollView: UIScrollView) {
        currencyLabels = []
        
        let inputX = InputTextOutlet.frame.origin.x
        let inputWidth = InputTextOutlet.frame.width
        
        let mainLabelX = MainLabelOutlet.frame.origin.x
        let labelX = Int(trunc(mainLabelX))
        let labelWidth = Int(trunc(inputX - mainLabelX + inputWidth))
        
        var currentY = 0
        for _ in 1...EXCHANGE_RATES.count {
            let newLabel = UILabel(frame: CGRect(x: labelX, y: currentY, width: labelWidth, height: CURRENCY_LABEL_HEIGHT))
            newLabel.textAlignment = .left
            newLabel.text = ""
            
            currencyLabels.append(newLabel)
            scrollView.addSubview(newLabel)
            
            currentY = currentY + CURRENCY_LABEL_DELTA_Y
        }
        
        scrollView.contentSize = CGSize(width: ScrollViewOutlet.contentSize.width, height: CGFloat(currentY))
    }
    
    private func resetResults() {
        InputTextOutlet.text = "0"
        setResults(0)
    }
    
    func keyboardWillShow(notification: NSNotification) {
//        print("keyboard will show!")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let newScrollViewHeight = ScrollViewOutlet.frame.size.height - keyboardSize.height
            updateScrollViewHeight(newScrollViewHeight)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        print("keyboard will show!")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let newScrollViewHeight = ScrollViewOutlet.frame.size.height + keyboardSize.height
            updateScrollViewHeight(newScrollViewHeight)
        }
    }
    
    private func updateScrollViewHeight(_ newHeight: CGFloat) {
        let scrollViewOrigin = ScrollViewOutlet.frame.origin
        let newScrollViewSize = CGSize(width: ScrollViewOutlet.frame.size.width, height: newHeight)
        ScrollViewOutlet.frame = CGRect(origin: scrollViewOrigin, size: newScrollViewSize)
        showScroll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onScreenRotate() {
        InputTextOutlet.resignFirstResponder()
        
        // for iPad set change manually
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape")
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait")
        }
    }
    
    @IBAction func OnConvertTap(_ sender: UIButton) {
        if let valueString = InputTextOutlet.text {
            if valueString.characters.count == 0 {
                resetResults()
                dismissKeyboard()
            } else {
                let currentValue = Double(valueString)
                if updateResults(value: currentValue) {
                    dismissKeyboard()
                }
            }
        } else {
            showErrorMessage("Input expected.")
        }
    }
    
    private func updateResults(value: Double?) -> Bool {
        var result = false
        if let _value = value {
            if _value >= 0 {
                if _value < MAX_VALUE {
                    InputTextOutlet.text = String(_value)
                    setResults(_value)
                    result = true
                } else {
                    setResults(0)
                    showErrorMessage("Value is too high.")
                }
            } else {
                setResults(0)
                showErrorMessage("Please, enter positive decimal.")
            }
        } else {
            setResults(0)
            showErrorMessage("Expected decimal, got string.")
        }
        return result
    }
    
    private func setResults(_ value: Double) {
        for (i, (currName, exchange)) in EXCHANGE_RATES.enumerated() {
            let result = value * exchange
            currencyLabels[i].text = getCurrencyText(name: currName, value: result)
        }
        showScroll()
    }
    
    private func getCurrencyText(name: String, value: Double) -> String {
        let result = name + ": " + String(value)
        return result
    }
    
    private func showErrorMessage(_ message: String) {
        self.alertController.setValue(message, forKey: "message")
        self.present(alertController, animated: true, completion: nil)
    }
}
