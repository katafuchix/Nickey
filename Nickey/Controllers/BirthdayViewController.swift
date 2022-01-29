//
//  BirthdayViewController.swift
//  Nickey
//
//  Created by cano on 2016/10/09.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate : birthDayPickerDelegate?
    
    // realm
    let realm = RealmController.getSharedRealmController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clear
        
        
        let config = self.realm.getConfig()
        self.datePicker.date = config.birthday as! Date
        self.datePicker.backgroundColor = UIColor.white
        
        self.datePicker.addTarget(self, action: #selector(BirthdayViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let blackTap = UITapGestureRecognizer(target: self, action: #selector(BirthdayViewController.blackTapGesture(_:)))
        self.view?.addGestureRecognizer(blackTap)
        
    }

    @IBAction func onOK(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        if (self.delegate?.responds(to: Selector("didSelectBirthday"))) != nil {
            // 実装先のメソッドを実行
            self.delegate?.didSelectBirthday(self.datePicker.date)
        }
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        //print(sender.date)
    }
    
    func blackTapGesture(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
        if (self.delegate?.responds(to: Selector("didClose"))) != nil {
            // 実装先のメソッドを実行
            self.delegate?.didClose()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// SettingViewController で処理を行うためのデリゲート
protocol birthDayPickerDelegate : NSObjectProtocol {
    // 日付ピッカーを閉じてフォーカスを元に戻す
    func didSelectBirthday(_ date:Date)
    
    func didClose()
}
