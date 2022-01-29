//
//  TimeViewController.swift
//  Nickey
//
//  Created by cano on 2016/10/09.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

enum TimeEditStatus : Int {
    case from = 1
    case to   = 2
}


class TimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //@IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var picker: UIPickerView!
    
    var hours   = Array<String>()
    var minutes = Array<String>()
    
    var fromChg = false
    var toChg   = false
    
    var status : TimeEditStatus?
    
    // realm
    let realm = RealmController.getSharedRealmController()
    
    var start_index1 = 0
    var start_index2 = 0
    var end_index1 = 0
    var end_index2 = 0
    
    var delegate : timePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for i in 0 ..< 24 {
            hours.append(String(format: "%02d", i))
        }
        
        for i in 0 ..< 2 {
            minutes.append(String(format: "%02d", i * 30))
        }
        
        self.view.backgroundColor = UIColor.clear
        
        picker.backgroundColor = UIColor.white
        picker.delegate   = self
        picker.dataSource = self
        
        status = .from
        let config = self.realm.getConfig()
        
        // 配信不可開始〜終了の時分インデックスを取得して割り振る
        start_index1 = hours.index(of: config.inadvisable_time_start_hour!)!
        start_index2 = minutes.index(of: config.inadvisable_time_start_minute!)!
        
        end_index1 = hours.index(of: config.inadvisable_time_end_hour!)!
        end_index2 = minutes.index(of: config.inadvisable_time_end_minute!)!
        
        picker.selectRow(start_index1, inComponent: 0, animated: true)
        picker.selectRow(start_index2, inComponent: 1, animated: true)
        
        // 背景タップ時の処理
        let blackTap = UITapGestureRecognizer(target: self, action: #selector(BirthdayViewController.blackTapGesture(_:)))
        self.view?.addGestureRecognizer(blackTap)
    }

    @IBAction func onFrom(_ sender: AnyObject) {
        status = .from
        picker.selectRow(start_index1, inComponent: 0, animated: true)
        picker.selectRow(start_index2, inComponent: 1, animated: true)
    }
    
    @IBAction func onTo(_ sender: AnyObject) {
        status = .to
        picker.selectRow(end_index1, inComponent: 0, animated: true)
        picker.selectRow(end_index2, inComponent: 1, animated: true)
    }
    
    @IBAction func onOK(_ sender: AnyObject) {
        //print("start_index1 : \(start_index1)")
        //print("start_index2 : \(start_index2)")
        //print("end_index1 : \(end_index1)")
        //print("end_index2 : \(end_index2)")
        
        // 配信不可時間帯の更新
        self.realm.updateInadvisableTime(hours[start_index1], minutes[start_index2], hours[end_index1], minutes[end_index2])
        
        // 設定情報
        let config = self.realm.getConfig()
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // 通知設定を一旦削除
        appDelegate.deleteLocalNotificationSetting()
        
        // 通知用日記も削除
        self.realm.deleteArticleDraft()
        
        // 通知ONの場合は再設定
        if config.push_flag == 1 {
            appDelegate.setLocalNotification()
        }
        
        // ピッカーを閉じる
        self.dismiss(animated: true, completion: nil)
        if (self.delegate?.responds(to: Selector("didClose"))) != nil {
            // 実装先のメソッドを実行
            self.delegate?.didClose()
        }
    }
    
    //表示列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //表示個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        }
        return minutes.count
    }
    
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return hours[row] as String
        }
        return minutes[row] as String
    }
    
    //選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //println("列: \(row)")
        //println("値: \(salarymanArr[row])")
        if status == .from {
            if component == 0 {
                start_index1 = row
            }else{
                start_index2 = row
            }
        }else{
            if component == 0 {
                end_index1 = row
            }else{
                end_index2 = row
            }
        }
    }
    
    // ピッカーの項目の幅
    func pickerView(_ pickerView: UIPickerView, widthForComponent component:Int) -> CGFloat {
        switch component {
        case 0:
            return 80
        case 1:
            return 80
        default:
            return 30
        }
    }
    
    // 背景をタップした際にピッカー自体を閉じる
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
protocol timePickerDelegate : NSObjectProtocol {
    func didClose()
}
