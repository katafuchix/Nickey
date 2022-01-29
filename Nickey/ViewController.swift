//
//  ViewController.swift
//  Nickey
//
//  Created by cano on 2016/09/13.
//  Copyright © 2016年 cano. All rights reserved.
//

// Calender

import UIKit
import RealmSwift
import JSQMessagesViewController

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = Date()
    var today: Date!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    let realm = RealmController.getSharedRealmController()
    
    var tableRowCount = 0
    var articles : Results<Article>? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //日本の祝祭日判定用のインスタンス
    var holidayObj: CalculateCalendarLogic = CalculateCalendarLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // カレンダーの設定
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.white
        
        let rect = CGRect(x: 0, y: 0, width: self.calenderCollectionView.frame.size.width, height: self.calenderCollectionView.frame.size.height)
        calenderCollectionView.scrollRectToVisible(rect, animated: false)
        calenderCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        // 既定は当日データ
        self.setDateLabelText(date: NSDate())
        articles = self.realm.getArticlesFromDate(date:NSDate())
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.tintColor = UIColor.clear
        //UITableView.appearance().tintColor = UIColor.clear
        
        let sb = UIBarButtonItem(title: "設定", style: .plain, target: self, action:#selector(ViewController.onSetting))
        let nb = UIBarButtonItem(title: " > ", style: .plain, target: self, action:#selector(ViewController.onNext))
        let myRightButtons = [sb, nb]
        self.navigationItem.rightBarButtonItems = myRightButtons
        
        self.navigationItem.hidesBackButton = true
        let lb1 = UIBarButtonItem(title: "Back", style: .plain, target: self, action:#selector(ViewController.onBack))
        let lb2 = UIBarButtonItem(title: " < ", style: .plain, target: self, action:#selector(ViewController.onPre))
        let myLeftButtons = [lb1, lb2]
        self.navigationItem.leftBarButtonItems = myLeftButtons
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "calendar"
        self.setTitleDate(date: selectedDate as NSDate)
    }
    
    // タイトルセット
    func setTitleDate(date: NSDate) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月"
        let selectMonth = formatter.string(from: date as Date)
        self.title = selectMonth
    }
    
    // 日付ラベル 日付セット
    func setDateLabelText(date:NSDate){
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dateLabel.text = formatter.string(from: date as Date) + "（\(DateUtil.weekday_str_jp(date: date))）"
    }
    
    // 設定画面へ
    func onSetting(sender:AnyObject){
        self.title = "Back"
        let bundle = Bundle.main
        let board = UIStoryboard(name: "Main", bundle: bundle)
        let controller = board.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onNext(sender:AnyObject){
        selectedDate = dateManager.nextMonth(date: selectedDate)
        print(selectedDate)
        calenderCollectionView.reloadData()
        self.setTitleDate(date: selectedDate as NSDate)
    }
    
    func onPre(sender:AnyObject){
        selectedDate = dateManager.prevMonth(date: selectedDate)
        print(selectedDate)
        calenderCollectionView.reloadData()
        self.setTitleDate(date: selectedDate as NSDate)
    }
    
    // 戻るボタン
    func onBack(sender:AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            return dateManager.daysAcquisition() //ここは月によって異なる(後ほど説明します)
        }
    }
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalenderCell
        
        //テキストカラー
        if ((indexPath as NSIndexPath).row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if ((indexPath as NSIndexPath).row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
            // 祝日
            if indexPath.section == 1{
                let date = dateManager.currentMonthOfDates[indexPath.row] as NSDate
                let holiday: Bool = holidayObj.judgeJapaneseHoliday(DateUtil.year(date: date), month: DateUtil.month(date: date), day: DateUtil.day(date: date))
                if holiday { cell.textLabel.textColor = UIColor.lightRed() }
            }
        } else {
            cell.textLabel.textColor = UIColor.gray
            cell.dataLabel.textColor = UIColor.gray
            // 祝日
            if indexPath.section == 1{
                let date = dateManager.currentMonthOfDates[indexPath.row] as NSDate
                let holiday: Bool = holidayObj.judgeJapaneseHoliday(DateUtil.year(date: date), month: DateUtil.month(date: date), day: DateUtil.day(date: date))
                if holiday { cell.textLabel.textColor = UIColor.lightRed() }
            }
        }
        //テキスト配置
        cell.dataLabel.text = "  "
        if (indexPath as NSIndexPath).section == 0 {
            cell.textLabel.text = " " + weekArray[(indexPath as NSIndexPath).row]
        } else {
            cell.textLabel.text = " " + dateManager.conversionDateFormat(indexPath)
            
            // 日記を取得
            //let articles = self.realm.getArticlesFromDate(date: dateManager.currentMonthOfDates[indexPath.row] as NSDate, owner:Constants.myName)
            let articles = self.realm.getArticlesFromDate(date: dateManager.currentMonthOfDates[indexPath.row] as NSDate)
            //print(dateManager.currentMonthOfDates[indexPath.row])
            //print(articles.count)
            if articles.count > 0 {
                cell.dataLabel.text = "  ●"
            }
        }
        cell.setNeedsDisplay()
        return cell
    }
    
    //セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        //let height: CGFloat = width * 1.0
        let height: CGFloat = 40.0
        return CGSize(width: width, height: height)
        
    }
    
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath)
        //print(dateManager.currentMonthOfDates[indexPath.row])
        
        // 日付更新
        let date = dateManager.currentMonthOfDates[indexPath.row] as NSDate
        self.setDateLabelText(date: date)
        
        // テーブル更新
        self.articles = self.realm.getArticlesFromDate(date:date)
        self.tableView.reloadData()
    }
    
    
    //----------------------------------------------------------------------------------------------
    // MARK: - UITableViewDataSource Implementation
    //----------------------------------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.numberOfLines = 0
        
        let article = articles?[indexPath.row]
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = " HH:mm "
        let time = formatter.string(from: article?.date as! Date)
        cell.textLabel?.text = (article?.text)! + "（\(time)）"
        //cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        cell.backgroundColor = UIColor.white
        
        if article?.owner == Constants.systemName {
            cell.textLabel?.backgroundColor  = UIColor.jsq_messageBubbleLightGray()
            //cell.contentView.backgroundColor = UIColor.jsq_messageBubbleLightGray()
            
            cell.backgroundColor = UIColor.jsq_messageBubbleLightGray()
            /*
            let cellSelectedBgView = UIView()
            cellSelectedBgView.backgroundColor = UIColor.jsq_messageBubbleLightGray()
            cell.selectedBackgroundView = cellSelectedBgView
            */
        }else{
            
            // セルの背景色はなし
            cell.backgroundColor = UIColor.white
            
            // 選択された背景色を透明に設定
            /*
            let cellSelectedBgView = UIView()
            cellSelectedBgView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = cellSelectedBgView
            */
        }
        return cell
    }
    
    /*
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20.0
    }
    */
    //----------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate Implementation
    //----------------------------------------------------------------------------------------------
    //選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //print(indexPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}
