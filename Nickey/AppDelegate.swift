//
//  AppDelegate.swift
//  Nickey
//
//  Created by cano on 2016/09/13.
//  Copyright © 2016年 cano. All rights reserved.
//
/*
 
 https://prottapp.com/p/d2674a
 
*/

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let realm = RealmController.getSharedRealmController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //DBマイグレーション処理
        RealmController.migration()
        // Config初期設定
        RealmController.getSharedRealmController().initDefaultConfig()
        
        // local 通知の可否
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge], completionHandler: {(permit, error) in
            if permit {
                print("通知が許可されました")
            }else {
                print("通知が拒否されました")
            }
        })
        
        // test通知
        //setLocalNotificationTest()
        
        // 通知登録
        self.setNotification()
        // 通知用の日記を有効にする
        self.updateArticleDraft()
        return true
    }
    
    // 通知設定のコール
    private func setNotification(){
        let realm = RealmController.getSharedRealmController()
        let config = realm.getConfig()
        // 通知設定ONの場合
        if config.push_flag == 1 {
            self.setLocalNotification()
        }
    }
    
    // 通知設定
    func setLocalNotification() {
        // local 通知の可否
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        
        // 通知登録 本日
        let realm = RealmController.getSharedRealmController()
        let qm = QuestionManager()
        let todayPushdata = realm.getPushdate(date: NSDate())
        // 登録がなければ登録する
        if todayPushdata.count == 0 {
            // PUSH通知時刻を取得
            let ret = UtilManager.getRandomTime(date:NSDate())
            for date in ret {
                let diff = date.timeIntervalSince1970 - NSDate().timeIntervalSince1970
                if diff < 0 { continue }
                //print("diff : \(diff)")
                // 質問noを取得
                let no = qm.getQuestionByTime(date:date)
                // 質問詳細を取得
                let qInfo = qm.getInfo(no)
                
                // 通知
                let content = UNMutableNotificationContent()
                content.title = "ニッキー"
                //content.subtitle = "Subtitle"
                content.body = qInfo[0]
                content.sound = UNNotificationSound.default()
                content.userInfo = ["no":no]
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: diff, repeats: false)
                let request = UNNotificationRequest(identifier: String(NSDate().timeIntervalSince1970),
                                                    content: content,
                                                    trigger: trigger)
                center.delegate = self
                center.add(request)
                
                // DBにステータス0で登録 通知受診時にstatus:1にする
                let a = self.realm.addArticleDraft(date: date, owner: Constants.systemName, text: qInfo[0])

            }
            // 通知登録済みであることをDBに登録 通知受診時にstatus:1にする
            realm.addPushdate(date: NSDate())
        }
        
        // 翌日まで登録  仮処置
        let tomorrow = NSDate(timeInterval: 60*60*24, since: NSDate() as Date)
        let tomorrowPushdata = realm.getPushdate(date: tomorrow)
        // 登録がなければ登録する
        if tomorrowPushdata.count == 0 {
            // PUSH通知時刻を取得
            let ret = UtilManager.getRandomTime(date:tomorrow)
            for date in ret {
                let diff = date.timeIntervalSince1970 - NSDate().timeIntervalSince1970
                if diff < 0 { continue }
                
                // 質問noを取得
                let no = qm.getQuestionByTime(date:date)
                // 質問詳細を取得
                let qInfo = qm.getInfo(no)
                
                // 通知
                let content = UNMutableNotificationContent()
                content.title = "ニッキー"
                //content.subtitle = "Subtitle"
                content.body = qInfo[0]
                content.sound = UNNotificationSound.default()
                content.userInfo = ["no":no]
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: diff, repeats: false)
                let request = UNNotificationRequest(identifier: String(NSDate().timeIntervalSince1970),
                                                    content: content,
                                                    trigger: trigger)
                center.delegate = self
                center.add(request)
                
                // DBにステータス0で登録 通知受診時にstatus:1にする
                let a = self.realm.addArticleDraft(date: date, owner: Constants.systemName, text: qInfo[0])
            }
            // 通知登録済みであることをDBに登録
            realm.addPushdate(date: tomorrow)
        }
    }
    
    // 通知予約の削除
    func deleteLocalNotificationSetting() {
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        // local通知予約を削除
        center.removeAllPendingNotificationRequests()
        // 本日以降の登録日付を削除しておく
        let realm = RealmController.getSharedRealmController()
        realm.deletePushdatesFromToday()
    }
    
    // 通知済みの日記を半径
    func updateArticleDraft(){
        // 通知用の日記を有効にする
        let realm = RealmController.getSharedRealmController()
        realm.updateArticleDraft()
        
        // 受診済みの通知は削除
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        //center.post(name aName: NSNotification.Name, object:self)
        /*
        let n : NSNotification = NSNotification(name: NSNotification.Name(rawValue: "dummy"), object: self, userInfo: ["value": 100])
        //通知を送る
        NotificationCenter.default.post(n as Notification)
        */
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication,
                              willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {
        return true
    }
    
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 通知用の日記を有効にする
        self.updateArticleDraft()
    }
 
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 通知用の日記を有効にする
        self.updateArticleDraft()
    }
    
    // 通知設定 テスト登録用メソッド
    func setLocalNotificationTest() {
        // local 通知の可否
        let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
        
        // 通知登録
        let qm = QuestionManager()
        let date = NSDate()
        let diff = 10
        // 質問noを取得
        let no = qm.getQuestionByTime(date:date)
        // 質問詳細を取得
        let qInfo = qm.getInfo(no)
        
        // 通知
        let content = UNMutableNotificationContent()
        content.title = "ニッキー"
        content.body = qInfo[0]
        content.sound = UNNotificationSound.default()
        content.userInfo = ["no":no]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(diff), repeats: false)
        let request = UNNotificationRequest(identifier: String(NSDate().timeIntervalSince1970),
                                            content: content,
                                            trigger: trigger)
        center.delegate = self
        center.add(request)
        
        // DBにステータス0で登録 通知受診時にstatus:1にする
        let a = self.realm.addArticleDraft(date: date, owner: Constants.systemName, text: qInfo[0])
    }
}

