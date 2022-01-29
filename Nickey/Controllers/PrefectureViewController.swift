//
//  PrefectureViewController.swift
//  Nickey
//
//  Created by cano on 2016/10/09.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class PrefectureViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var picker: UIPickerView!
    
    var prefNameArray : Array<String> = Array<String>()
    var prefValArray : Array<Int> = Array<Int>()
    
    var delegate : prefecturePickerDelegate?
    
    // realm
    let realm = RealmController.getSharedRealmController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clear
        self.picker.backgroundColor = UIColor.white
        self.picker.delegate = self
        self.picker.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let path = Bundle.main.path(forResource: "prefecture", ofType: "plist") {
                let array = NSArray(contentsOfFile: path)
                for dic in array! {
                    //print(dic)
                    if ((dic as? NSDictionary) != nil) {
                        let name = (dic as? NSDictionary)?["cityNameKey"] as? String
                        let key = (dic as? NSDictionary)?["prefectureKey"] as? String
                        self.prefNameArray.append(name!)
                        self.prefValArray.append(Int(key!)!)
                    }
                }
                self.picker.reloadAllComponents()
                
                let config = self.realm.getConfig()
                self.picker.selectRow(config.prefecture-1, inComponent: 0, animated: true)
            }
        }
        
        let blackTap = UITapGestureRecognizer(target: self, action: #selector(BirthdayViewController.blackTapGesture(_:)))
        self.view?.addGestureRecognizer(blackTap)
    }

    @IBAction func onOK(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        if (self.delegate?.responds(to: Selector("didSelectPrefecture"))) != nil {
            // 実装先のメソッドを実行
            self.delegate?.didSelectPrefecture(self.picker.selectedRow(inComponent: 0)+1)
        }
    }
    
    // コンポーネントの数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // コンポーネント内のデータ
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prefNameArray.count
    }
    
    // ホイールに表示する選択肢のタイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prefNameArray[row]
    }
    
    // コンポーネントの幅を指定
    func pickerView(_ pickerView: UIPickerView,
                    widthForComponent component: Int) -> CGFloat{
        return 300.0
    }
    // 選択肢の高さを指定
    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat{
        return 40.0
    }
    
    // 選択時の処理
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int){
        print(prefValArray[row])
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
protocol prefecturePickerDelegate : NSObjectProtocol {
    // 日付ピッカーを閉じてフォーカスを元に戻す
    func didSelectPrefecture(_ val:Int)
    
    func didClose()
}

