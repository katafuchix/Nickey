//
//  FirstViewController.swift
//  Diary
//
//  Created by cano on 2016/09/05.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit
import UserNotifications
import JSQMessagesViewController
import CNPPopupController

class FirstViewController: JSQMessagesViewController, CNPPopupControllerDelegate, passwordDelegate {
    
    fileprivate var messages: [JSQMessage] = []
    fileprivate var incomingBubble: JSQMessagesBubbleImage!
    fileprivate var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var incomingAvatar: JSQMessagesAvatarImage!
    
    let realm = RealmController.getSharedRealmController()
    fileprivate var dates: [NSDate] = []
    
    // テスト用
    fileprivate let targetUser = ["senderId": "targetUser", "displayName": "passion"]
    
    var passVC : PassViewController?
    
    var popupController:CNPPopupController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.isHidden = true
        
        self.automaticallyScrollsToMostRecentMessage = true
        
        // realm
        let realm   = RealmController.getSharedRealmController()
        let config  = realm.getConfig()
        
        // パスワード利用時
        if( config.passuse == 1) {
            // ナビゲーションバーを非表示
            self.navigationController?.navigationBar.alpha = 0.0
            // ビューコントローラーを取得
            let story = UIStoryboard(name: "Main", bundle: nil)
            self.passVC = story.instantiateViewController(withIdentifier: "PassViewController") as? PassViewController
            passVC?.delegate = self
            passVC?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(passVC!, animated: true, completion: nil)
        }else{
            self.collectionView.isHidden = false
        }
        
        // タイトル日付のセット
        self.setTitle()
        
        // 設定ボタン
        let b = UIBarButtonItem(title: "設定", style: .plain, target: self, action:#selector(FirstViewController.onSetting))
        self.navigationItem.rightBarButtonItem = b
        
        // カレンダーボタン
        let lb = UIBarButtonItem(title: "カレンダー", style: .plain, target: self, action:#selector(FirstViewController.onCalendar))
        self.navigationItem.leftBarButtonItem = lb
        
        // チャット画面の初期化
        self.initialSettings()
        // 日記データのロード
        self.loadData()
        
        // LOCAL PUSH通知を受信したあとの処理
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.update), name: NSNotification.Name(rawValue: "dummy"), object: nil)
        
        // セルがない部分をタップした場合の処理
        let tap = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.handleTap))
        self.collectionView.addGestureRecognizer(tap)
    }
 
    // タップ動作の実態メソッド
    func handleTap() {
        // 入力欄のフォーカスを外す
        self.inputToolbar.contentView.textView.resignFirstResponder()
    }
    
    //関数で受け取った時のアクションを定義
    func update(notification: NSNotification)  {
        if let userInfo = notification.userInfo {
            //let result = userInfo["value"]! as! Int
            //print("受信した数値：\(result)")
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitle()
        // 入力欄の左ボタンを非表示にしておく
        self.inputToolbar.contentView.leftBarButtonItem.isHidden = true
        
        // JSQMessagesViewControllerのスクロールメソッドが機能しないのでここで行う
        // collectionViewContentSizeの高さが画面より大きい場合にスクロール
        //
        // JSQMessagesViewControllerの以下のメソッドを無効にしておくこと
        //- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
        //{
        //    return;
        
        let y = self.collectionView.collectionViewLayout.collectionViewContentSize.height - self.collectionView.bounds.height
        print("y : \(y)")
        if( y > 0 ){
            let rect = CGRect(x:0, y:y, width:self.collectionView.frame.size.width, height:self.collectionView.frame.size.height)
            self.collectionView.scrollRectToVisible(rect, animated: false)
        }
    }
    
    // データ読み込み
    func loadData() {
        //print(self.realm.getArticlesFromDateAll(date: NSDate()))
        messages = []
        let articles = self.realm.getArticlesFromDate(date: NSDate())
        if articles.count == 0 {
            //sendAutoMessage()
        }else{
            //print("articles : \(articles)")
            for article in articles {
                let message = JSQMessage(senderId: article.owner, displayName: "", text: article.text)
                messages.append(message!)
                dates.append(article.date!)
            }
            self.collectionView.reloadData()
            // 更新
            finishSendingMessage(animated: true)
        }
        // 最後までスクロール
        //scrollToBottom(animated: true)
    }
    
    // タイトルの指定
    func setTitle() {
        self.title = "\(DateUtil.year(date: NSDate()))年\(DateUtil.month(date: NSDate()))月\(DateUtil.day(date: NSDate()))日"
    }
    
    // 設定ボタン押下時
    func onSetting(sender:AnyObject){
        self.title = "Back"
        let bundle = Bundle.main
        let board = UIStoryboard(name: "Main", bundle: bundle)
        let controller = board.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // カレンダーボタン押下時の処理
    func onCalendar(sender:AnyObject){
        self.title = "Back"
        let bundle = Bundle.main
        let board = UIStoryboard(name: "Main", bundle: bundle)
        let controller = board.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // 初期設定
    fileprivate func initialSettings() {
        // 自分の情報入力
        self.senderId = Constants.myName
        self.senderDisplayName = "自分の名前"
        // 吹き出しの色設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        //self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
        // 相手の画像設定
        //self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "sample_user")!, diameter: 64)// 自分の画像を表示しない
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // コレクションビューで利用するNibファイルの登録
        self.collectionView!.register(SystemMessageCell.nib(), forCellWithReuseIdentifier: SystemMessageCell.cellReuseIdentifier())
        self.collectionView!.register(ButtonCell.nib(), forCellWithReuseIdentifier: ButtonCell.cellReuseIdentifier())
        
        self.collectionView.register(HeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderView.cellReuseIdentifier())
        
        self.collectionView.register(FooterView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FooterView.cellReuseIdentifier())
    }
    
    // 送信ボタンを押した時の挙動
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        messages.append(message!)
        
        // 投稿をテーブルに書き込む
        let a = self.realm.addArticle(date: NSDate(), owner: Constants.myName, text: text)
        dates.append(a.date!)
        
        // テストのため
        //sendAutoMessage()
        
        // 入力欄のフォーカスを外す
        self.inputToolbar.contentView.textView.resignFirstResponder()
        
        // 再ロード
        self.loadData()
        
        // ポップアップを表示
        self.showPopupComp(popupStyle: CNPPopupStyle.actionSheet)
    }
    
    // 入力完了ポップアップ
    func showPopupComp(popupStyle: CNPPopupStyle) {
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UtilManager.getPopUpWidth(), height: 30))
        titleLabel.font = UIFont(name: "HiraKakuProN-W3", size: 16)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "入力が完了しました !"
        titleLabel.textAlignment = .center
        
        let button1 = CNPPopupButton.init(frame: Constants.buttonSize)
        button1.setTitleColor(UIColor.white, for: UIControlState.normal)
        button1.setTitle("カレンダーを見る", for: UIControlState.normal)
        button1.titleLabel?.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        button1.setTitleColor(UIColor.black, for: .normal)
        button1.backgroundColor = UIColor.jsq_messageBubbleLightGray()
        button1.layer.cornerRadius = 4;
        button1.frame = CGRect(x:0,y:0,width:UtilManager.getPopUpWidth()*0.4,height:30)
        button1.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            // カレンダー画面へ
            self.onCalendar(sender:"" as AnyObject)
        }
        
        let button2 = CNPPopupButton.init(frame: Constants.buttonSize)
        button2.setTitleColor(UIColor.white, for: UIControlState.normal)
        button2.setTitle("続けて入力する", for: UIControlState.normal)
        button2.titleLabel?.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.backgroundColor = UIColor.jsq_messageBubbleLightGray()
        button2.layer.cornerRadius = 4;
        button2.frame = CGRect(x:0,y:0,width:UtilManager.getPopUpWidth()*0.4,height:30)
        button2.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            // 入力欄にフォーカス
            self.inputToolbar.contentView.textView.becomeFirstResponder()
        }
        
        let buttonBaseView = UIView(frame: CGRect(x:0, y:0, width:UtilManager.getPopUpWidth(), height:40))
        buttonBaseView.addSubview(button1)
        buttonBaseView.addSubview(button2)
        
        button1.center = CGPoint(x:UtilManager.getPopUpWidth()*0.2, y:buttonBaseView.frame.height/2)
        button2.center = CGPoint(x:UtilManager.getPopUpWidth()*0.8, y:buttonBaseView.frame.height/2)
        
        self.popupController = CNPPopupController(contents:[titleLabel,UIView(),UIView(),UIView(),buttonBaseView])
        self.popupController?.theme = CNPPopupTheme.default()
        self.popupController?.theme.popupStyle = CNPPopupStyle.centered
        self.setPopupSize()
        self.popupController?.delegate = self
        self.popupController?.present(animated: true)
    }
    
    // 無視するポップアップ
    func showPopupIgnore(popupStyle: CNPPopupStyle) {
        let button1 = CNPPopupButton.init(frame: Constants.buttonSize)
        button1.setTitleColor(UIColor.white, for: UIControlState.normal)
        button1.setTitle("カレンダーを見る", for: UIControlState.normal)
        button1.titleLabel?.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        button1.setTitleColor(UIColor.black, for: .normal)
        button1.backgroundColor = UIColor.jsq_messageBubbleLightGray()
        button1.layer.cornerRadius = 4;
        button1.frame = CGRect(x:0,y:0,width:UtilManager.getPopUpWidth()*0.4,height:30)
        button1.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            // カレンダー画面へ
            self.onCalendar(sender:"" as AnyObject)
        }
        
        let button2 = CNPPopupButton.init(frame: Constants.buttonSize)
        button2.setTitleColor(UIColor.white, for: UIControlState.normal)
        button2.setTitle("続けて入力する", for: UIControlState.normal)
        button2.titleLabel?.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.backgroundColor = UIColor.jsq_messageBubbleLightGray()
        button2.layer.cornerRadius = 4;
        button2.frame = CGRect(x:0,y:0,width:UtilManager.getPopUpWidth()*0.4,height:30)
        button2.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            // 入力欄にフォーカス
            self.inputToolbar.contentView.textView.becomeFirstResponder()
        }
        
        let buttonBaseView = UIView(frame: CGRect(x:0, y:0, width:UtilManager.getPopUpWidth(), height:40))
        buttonBaseView.addSubview(button1)
        buttonBaseView.addSubview(button2)
        
        button1.center = CGPoint(x:UtilManager.getPopUpWidth()*0.2, y:buttonBaseView.frame.height/2)
        button2.center = CGPoint(x:UtilManager.getPopUpWidth()*0.8, y:buttonBaseView.frame.height/2)
        
        self.popupController = CNPPopupController(contents:[UIView(),UIView(),UIView(),buttonBaseView])
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
    
    // 表示するメッセージの内容
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        //return self.messages[indexPath.item]
        return self.messages[indexPath.section]
    }
    
    // 表示するメッセージの背景を指定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.section].senderId == senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    // 表示するユーザーアイコンを指定。nilを指定すると画像がでない
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        if messages[indexPath.item].senderId != self.senderId {
            return incomingAvatar
        }
        return nil
    }
    
    // フッタの高さ
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20.0
    }
    
    // フッタに表示する時刻
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        // HH:mmのフォーマットを指定
        let date = self.dates[indexPath.section]
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = " HH:mm "
        return NSAttributedString(string:formatter.string(from: date as Date))
    }
    
    // メッセージの数
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }
    
    // コレクションビューの表示設定
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.cellReuseIdentifier(), for: indexPath)
            headerView.backgroundColor = UIColor.blue
            return headerView
        
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterView.cellReuseIdentifier(), for: indexPath) as! FooterView
            
            // 返信ボタン
            footerView.replyButton.addTarget(self, action: #selector(FirstViewController.replyTap), for: .touchUpInside)
            // 無視ボタン
            footerView.ignoreButton.addTarget(self, action: #selector(FirstViewController.ignoreTap), for: .touchUpInside)
            
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    // 返信ボタン押下時
    func replyTap() {
        // 入力欄にフォーカスする
        self.inputToolbar.contentView.textView.becomeFirstResponder()
    }
    
    // 無視ボタン押下時
    func ignoreTap() {
        // ポップアップ表示
        self.showPopupIgnore(popupStyle: CNPPopupStyle.actionSheet)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 0.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        // 自分以外で最後のセクションのみボタン付きのフッタを表示
        if messages[section].senderId != self.senderId && section == messages.count-1{
            return CGSize(width: self.view.frame.width, height: 40.0)
        }
        return CGSize(width: self.view.frame.width, height: 0.0)
    }
    
    // 1セクション内に表示するメッセージの件数を指定
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return messages.count
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell

        cell.textView.textColor = UIColor.black
        return cell
    }
    
    // チャット部分をタップしたら入力欄のフォーカスを外す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        // 入力欄のフォーカスを外す
        self.inputToolbar.contentView.textView.resignFirstResponder()
    }
    
    // チャット部分をタップしたら入力欄のフォーカスを外す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        // 入力欄のフォーカスを外す
        self.inputToolbar.contentView.textView.resignFirstResponder()
    }
    
    // テストでメッセージを送信するためのメソッド
    fileprivate func sendAutoMessage() {
        let message = JSQMessage(senderId: targetUser["senderId"], displayName: targetUser["displayName"], text: "日記テーマ")
        //print("message : \(message)")
        messages.append(message!)
        let a = self.realm.addArticle(date: NSDate(), owner: Constants.systemName, text: "日記テーマ")
        dates.append(a.date!)
        finishReceivingMessage(animated: true)
    }
    
    // passDelegateの戻り
    func didClose() {
        // ナビゲーションバーを表示
        self.navigationController?.navigationBar.alpha = 1.0
        self.passVC?.dismiss(animated: true, completion: nil)
        self.collectionView.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
