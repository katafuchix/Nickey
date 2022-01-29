//
//  SettingViewController.swift
//  Nickey
//
//  Created by cano on 2016/09/16.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit
import CNPPopupController
import AKPickerView_Swift

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNPPopupControllerDelegate, AKPickerViewDataSource, AKPickerViewDelegate, birthDayPickerDelegate, prefecturePickerDelegate, timePickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var popupController:CNPPopupController?
    var picker : AKPickerView?
    var blackOutView : UIView?
    var passTextField: UITextField?
    
    // ボタン設定
    let buttonFont = UIFont(name: "HiraKakuProN-W3", size: 17)
    let buttonTitle = "SAVE"
    let buttonColor = UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0)
    let buttonCornerRadius = 4
    
    // ピッカー設定
    let pickerFont = UIFont(name: "HiraKakuProN-W3", size: 17)
    let pickerHighlightedFont = UIFont(name: "HiraKakuProN-W3", size: 17)
    
    // realm
    let realm = RealmController.getSharedRealmController()
    var config : Config = Config()
    
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loadConfigData()
        self.title = "設定"
        
        //let backButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        //self.navigationItem.backBarButtonItem = backButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //セルの境界線を消す
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tintColor = UIColor.clear
        UITableView.appearance().tintColor = UIColor.clear
        
        print("Constants.sections.count \(Constants.sections.count)")
    }
    
    // config読み込み
    func loadConfigData(){
        self.config = self.realm.getConfig()
        print(self.config)
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource Implementation
    //----------------------------------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Constants.sections.count
    }
    /*
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("Constants.sections.count \(Constants.sections.count)")
        return Constants.sections.count
    }
    */
    
    func tableView(_ _tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String?
    {
        return Constants.sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let items = Constants.items[indexPath.section]
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20.0
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate Implementation
    //----------------------------------------------------------------------------------------------
    //選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //print(indexPath)
        //showPopupTitleFontSize(popupStyle: CNPPopupStyle.actionSheet)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.showPopupPassword(popupStyle: CNPPopupStyle.actionSheet)
            case 1:
                self.showPopupPush(popupStyle: CNPPopupStyle.actionSheet)
            case 2:
                self.showPopupFreq(popupStyle: CNPPopupStyle.actionSheet)
            case 3:
                self.showTimePicker()
            default:
                break // do nothing
            }
        case 1:
            switch indexPath.row {
            case 0:
                self.showPopupSex(popupStyle: CNPPopupStyle.actionSheet)
            case 1:
                self.showBirthdayPicker()
            case 2:
                self.showPrefecturePicker()
            default:
                break // do nothing
            }
        case 2:
            switch indexPath.row {
            default:
                break // do nothing
            }
        default:
            break // do nothing
        }
    }

    // パスワード設定
    func showPopupPassword(popupStyle: CNPPopupStyle) {
        let button = CNPPopupButton.init(frame: Constants.buttonSize)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.setTitle("OK", for: UIControlState.normal)
        button.backgroundColor = UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 4;
        button.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            // パスワード利用
            self.realm.updatePassuse(self.picker!.selectedItem)
            // パスワード更新
            self.realm.updatePassword((self.passTextField?.text)!)
            self.loadConfigData()
        }
        
        picker = createPicker()
        picker!.reloadData()
        picker!.tag = 0
        if Constants.passuse.indices.contains(Int(self.config.passuse)){
            picker!.selectItem(Int(self.config.passuse), animated: true)
        }
        
        // パスワード入力欄
        passTextField = UITextField(frame:CGRect(x:0, y:0, width:UtilManager.getPopUpWidth()*0.7, height:30))
        passTextField?.borderStyle = .roundedRect
        passTextField?.text = config.password
        
        self.popupController = CNPPopupController(contents:[UIView(),picker!,UIView(),passTextField!,UIView(),button, UIView()])
        self.popupController?.theme = CNPPopupTheme.default()
        self.popupController?.theme.popupStyle = CNPPopupStyle.centered
        self.setPopupSize()
        self.popupController?.delegate = self
        self.popupController?.present(animated: true)
    }
    
    // ボタン生成
    func createButton() -> CNPPopupButton {
        let button = CNPPopupButton.init(frame: Constants.buttonSize)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.titleLabel?.font = buttonFont
        button.setTitle(buttonTitle, for: UIControlState.normal)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = CGFloat(buttonCornerRadius)
        return button
    }
    
    // ピッカー生成
    func createPicker() -> AKPickerView {
        picker = AKPickerView(frame:Constants.pickerSize)
        picker!.delegate = self
        picker!.dataSource = self
        picker!.font = pickerFont!
        picker!.highlightedFont = pickerHighlightedFont!
        picker!.pickerViewStyle = .wheel
        picker!.maskDisabled = false
        return picker!
    }
    
    // Local通知設定 on/off
    func showPopupPush(popupStyle: CNPPopupStyle) {
        let button = self.createButton()
        
        // ボタン押下時動作
        button.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            self.realm.updatePushFlag(self.picker!.selectedItem)
            
            // 通知設定を一旦削除
            self.appDelegate.deleteLocalNotificationSetting()
            // 通知用日記も削除
            self.realm.deleteArticleDraft()
            
            // ONの場合は再設定
            if self.config.push_flag == 1 {
                self.appDelegate.setLocalNotification()
            }
            self.loadConfigData()
        }
        
        picker = createPicker()
        picker!.reloadData()
        picker!.tag = 1
        //let index = 0
        if Constants.push.indices.contains(Int(self.config.push_flag)){
            picker!.selectItem(Int(self.config.push_flag), animated: true)
        }
        
        self.popupController = CNPPopupController(contents:[UIView(),picker!,UIView(),UIView(),button, UIView()])
        self.popupController?.theme = CNPPopupTheme.default()
        self.popupController?.theme.popupStyle = CNPPopupStyle.centered
        self.setPopupSize()
        self.popupController?.delegate = self
        self.popupController?.present(animated: true)
    }
    
    // 配信頻度
    func showPopupFreq(popupStyle: CNPPopupStyle) {
        let button = self.createButton()
        button.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            self.realm.updateFreq(self.picker!.selectedItem)
            self.loadConfigData()
            
            // 通知設定を一旦削除
            self.appDelegate.deleteLocalNotificationSetting()
            
            // 通知用日記も削除
            self.realm.deleteArticleDraft()
            
            // ONの場合は再設定
            if self.config.push_flag == 1 {
                self.appDelegate.setLocalNotification()
            }
        }
        
        picker = createPicker()
        picker!.reloadData()
        picker!.tag = 2
        picker!.frame = CGRect(x:0, y:0, width:260, height:50)
        if Constants.freq.indices.contains(Int(self.config.freq)){
            picker!.selectItem(Int(self.config.freq), animated: true)
        }
        
        self.popupController = CNPPopupController(contents:[UIView(),picker!,UIView(),UIView(),button, UIView()])
        self.popupController?.theme = CNPPopupTheme.default()
        self.popupController?.theme.popupStyle = CNPPopupStyle.centered
        self.setPopupSize()
        self.popupController?.delegate = self
        self.popupController?.present(animated: true)
    }
    
    // 性別
    func showPopupSex(popupStyle: CNPPopupStyle) {
        let button = self.createButton()
        button.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            self.realm.updateSex(self.picker!.selectedItem)
            self.loadConfigData()
        }
        
        picker = createPicker()
        picker!.reloadData()
        picker!.tag = 10
        picker!.frame = CGRect(x:0, y:0, width:260, height:50)
        if Constants.sex.indices.contains(Int(self.config.sex)){
            picker!.selectItem(Int(self.config.sex), animated: true)
        }
        
        self.popupController = CNPPopupController(contents:[UIView(),picker!,UIView(),UIView(),button, UIView()])
        self.popupController?.theme = CNPPopupTheme.default()
        self.popupController?.theme.popupStyle = CNPPopupStyle.centered
        self.setPopupSize()
        self.popupController?.delegate = self
        self.popupController?.present(animated: true)
    }
    
    // MARK: - CNPPopupController Delegate
    func popupController(controller: CNPPopupController, dismissWithButtonTitle title: NSString) {
        print("Dismissed with button title \(title)")
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
    func setPopupSize(){
        self.popupController?.theme.maxPopupWidth = UtilManager.getPopUpWidth()
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        switch pickerView.tag {
            case 0:
                return Constants.passuse.count
            case 1:
                return Constants.push.count
            case 2:
                return Constants.freq.count
            case 10:
                return Constants.sex.count
            default:
                return 0
        }
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        //return Constants.push[item]
        switch pickerView.tag {
            case 0:
                return Constants.passuse[item]
            case 1:
                return Constants.push[item]
            case 2:
                return Constants.freq[item]
            case 10:
                return Constants.sex[item]
            default:
                return ""
        }
    }
    /*
     func pickerView(pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
     return UIImage(named: self.titles[item])!
     }
     */
    // MARK: - AKPickerViewDelegate
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        switch pickerView.tag {
            case 0:
                print(Constants.passuse[item])
            case 1:
                print(Constants.push[item])
            case 2:
                print(Constants.freq[item])
            case 10:
                print(Constants.sex[item])
            default:
                break;
        }
    }
    
    func pickerView(_ pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.backgroundColor = UIColor(red: 210 / 255, green: 213 / 255, blue: 218 / 255, alpha: 1.0)
        label.textColor = UIColor.lightGray
        label.highlightedTextColor = UIColor.black
        switch pickerView.tag {
            case 0:
                label.text = Constants.passuse[item]
            case 1:
                label.text = Constants.push[item]
            case 2:
                label.text = Constants.freq[item]
            case 10:
                label.text = Constants.sex[item]
            default:
                break;
        }
    }
    
    func pickerView(_ pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        if pickerView.tag == 2 {
            return CGSize(width: 60, height: 20)
        }
        return CGSize(width: 40, height: 20)//CGSize(width//40, 20)
    }
    
    
    // 配信不可時間帯ピッカーを表示
    func showTimePicker(){
        
        blackOutView = UIView(frame: self.view.frame.insetBy(dx: -100, dy: -200))
        //CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
        blackOutView?.backgroundColor = UIColor.black
        blackOutView?.alpha = 0.5
        self.view.addSubview(blackOutView!)
        
        // ピッカー用のコントローラーをモーダルで表示
        let story = UIStoryboard(name: "Main", bundle: nil)
        let timePickerVC = story.instantiateViewController(withIdentifier: "TimeViewController") as? TimeViewController
        timePickerVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        timePickerVC?.delegate = self
        
        // 日付ピッカー出現時には右上の完了ボタンを無効にしておく
        //self.navigationItem.rightBarButtonItem?.enabled = false
        self.present(timePickerVC!, animated: true, completion: nil)
    }
    
    // 誕生日ピッカーを表示
    func showBirthdayPicker(){
        
        blackOutView = UIView(frame: self.view.frame.insetBy(dx: -100, dy: -200))
        //CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
        blackOutView?.backgroundColor = UIColor.black
        blackOutView?.alpha = 0.5
        self.view.addSubview(blackOutView!)
        
        // ピッカー用のコントローラーをモーダルで表示
        let story = UIStoryboard(name: "Main", bundle: nil)
        let birthPickerVC = story.instantiateViewController(withIdentifier: "BirthdayViewController") as? BirthdayViewController
        birthPickerVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        birthPickerVC?.delegate = self
        
        // 日付ピッカー出現時には右上の完了ボタンを無効にしておく
        //self.navigationItem.rightBarButtonItem?.enabled = false
        self.present(birthPickerVC!, animated: true, completion: nil)
    }
    
    // 誕生日設定の戻り
    func didSelectBirthday(_ date: Date) {
        //print(date)
        self.realm.updateBirthDay(date)
        self.didClose()
    }
    
    // 地域ピッカーを表示
    func showPrefecturePicker(){
        
        blackOutView = UIView(frame: self.view.frame.insetBy(dx: -100, dy: -200))
        //CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
        blackOutView?.backgroundColor = UIColor.black
        blackOutView?.alpha = 0.5
        self.view.addSubview(blackOutView!)
        
        // ピッカー用のコントローラーをモーダルで表示
        let story = UIStoryboard(name: "Main", bundle: nil)
        let pickerVC = story.instantiateViewController(withIdentifier: "PrefectureViewController") as? PrefectureViewController
        pickerVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pickerVC?.delegate = self
        
        // 日付ピッカー出現時には右上の完了ボタンを無効にしておく
        //self.navigationItem.rightBarButtonItem?.enabled = false
        self.present(pickerVC!, animated: true, completion: nil)
    }
    
    // 都道府県選択の戻り
    func didSelectPrefecture(_ val: Int) {
        //print(val)
        self.realm.updatePrefecture(val)
        self.didClose()
    }
    
    func didClose() {
        self.loadConfigData()
        self.blackOutView?.removeFromSuperview()
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

