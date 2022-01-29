//
//  RealmController.swift
//  Nickey
//
//  Created by cano on 2016/09/19.
//  Copyright © 2016年 cano. All rights reserved.
//

import RealmSwift

class RealmController {
    var realm: Realm?
    
    private static var realmController: RealmController? = nil
    private static let SCHEMA_VERSION: UInt64 = 1
    
    public static func getSharedRealmController() -> RealmController {
        if realmController == nil {
            realmController = RealmController()
        }
        return realmController!
    }
    
    //コンストラクタ
    init () {
        
        //Realmインスタンス初期化
        do {
            realm = try Realm()
        } catch let error as NSError {
            // handle error
            print("Realm init error" + error.description)
        }
    }
    
    //DBマイグレーション処理
    public static func migration() {
        print("------ migration ------")
        //Realmのマイグレーションの処理
        let config = Realm.Configuration(
            // 新しいスキーマバージョンを設定します。以前のバージョンより大きくなければなりません。
            // （スキーマバージョンを設定したことがなければ、最初は0が設定されています）
            schemaVersion: RealmController.SCHEMA_VERSION,
            
            // マイグレーション処理を記述します。古いスキーマバージョンのRealmを開こうとすると
            // 自動的にマイグレーションが実行されます。
            migrationBlock: { migration, oldSchemaVersion in
                print("------ migrationBlock oldSchemaVersion=\(oldSchemaVersion)  ------")
                // 最初のマイグレーションの場合、`oldSchemaVersion`は0です
                /*if (oldSchemaVersion < 2) {
                    // enumerate(_:_:)メソッドで保存されているすべてのオブジェクトを列挙します
                     migration.enumerateObjects(ofType: Config.className()) { oldObject, newObject in
                        let id = oldObject!["id"] as! Int
                        newObject!["name"] = "test"
                     }
                }*/
        })
        
        // デフォルトRealmに新しい設定を適用します
        Realm.Configuration.defaultConfiguration = config
        
        // Realmファイルを開こうとしたときスキーマバージョンが異なれば、
        // 自動的にマイグレーションが実行されます
        try! Realm()
    }
    
    //デフォルトのconfigの作成
    public func initDefaultConfig() {
        let cs = self.realm!.objects(Config.self)
        //print(cs)
        if cs.count > 0 {
            //すでにジャンルが登録済みの状態ではなにもしない
            return
        }
        let c = Config()
        c.id = 1
        c.push_flag = 0
        
        c.passuse = 0   // デフォルトでは使用しない
        c.password = ""
        
        // 配信頻度
        c.freq = 0
        
        // 配信不可時間帯
        c.inadvisable_time_start_hour   = "00"
        c.inadvisable_time_start_minute = "00"
        c.inadvisable_time_end_hour     = "00"
        c.inadvisable_time_end_minute   = "00"
        
        // 性別
        c.sex = 0
        
        // 誕生日
        let date_formatter:DateFormatter = DateFormatter()
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let startstr = String(format: "1990-01-01 00:00:00")
        c.birthday = date_formatter.date(from:startstr) as NSDate?
        
        c.prefecture = 1
        
        // トランザクションを開始して、オブジェクトをRealmに追加する
        do {
            try self.realm!.write {
                self.realm!.add(c)
            }
            print("Realm add Title complete. id=\(c.id)")
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }
    
    open func updatePushFlag(_ val:Int) {
        let c = self.realm!.objects(Config.self).filter("id = 1")
        do{
            try self.realm!.write {
                c[0].push_flag = Int64(val)
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }
    
    open func updatePassuse(_ val:Int) {
        let c = self.realm!.objects(Config.self).filter("id = 1")
        do{
            try self.realm!.write {
                c[0].passuse = Int64(val)
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }
    
    open func updatePassword(_ val:String) {
        let c = self.realm!.objects(Config.self).filter("id = 1")
        do{
            try self.realm!.write {
                c[0].password = val
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }
    
    open func updateFreq(_ val:Int) {
        let c = self.realm!.objects(Config.self).filter("id = 1")
        do{
            try self.realm!.write {
                c[0].freq = Int64(val)
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }
    
    open func updateSex(_ val:Int) {
        let c = self.realm!.objects(Config.self).filter("id = 1")
        do{
            try self.realm!.write {
                c[0].sex = Int64(val)
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }
    
    open func updateBirthDay(_ val:Date) {
        let c = self.realm!.objects(Config.self).filter("id = 1")
        do{
            try self.realm!.write {
                c[0].birthday = val as NSDate?
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }
    
    open func updatePrefecture(_ val:Int) {
        let c = self.realm!.objects(Config.self).filter("id = 1")
        do{
            try self.realm!.write {
                c[0].prefecture = Int64(val)
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }
    
    open func updateInadvisableTime(_ val1:String, _ val2:String, _ val3:String, _ val4:String) {
        let c = self.realm!.objects(Config.self).filter("id = 1")
        do{
            try self.realm!.write {
                c[0].inadvisable_time_start_hour   = val1
                c[0].inadvisable_time_start_minute = val2
                c[0].inadvisable_time_end_hour     = val3
                c[0].inadvisable_time_end_minute   = val4
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }

    
    //Configの取得
    func getConfig() -> Config {
        let cs = self.realm!.objects(Config.self).filter("id = 1")
        //print(cs)
        if cs.count > 0 {
            return cs[0]
        } else {
            return Config()
        }
    }
    
    // realmにautoincrementの仕組みがないので、max id + 1する
    public func getNextArtocleId() -> Int64 {
        var id: Int64 = 0
        let max = self.realm!.objects(Article.self).sorted(byProperty: "id",ascending:false)
        if max.count > 0 {
            id = max[0].id
        }
        id += 1
        return id
    }
    
    // 日記を追加する
    public func addArticle(date: NSDate, owner: String, text: String) -> Article {
        let id: Int64 = getNextArtocleId()
        return addArticle(id: id, date: date, owner: owner, text: text, status:1)
    }
    
    public func addArticle(id: Int64, date: NSDate, owner: String, text: String, status:Int) -> Article {
        // Articleオブジェクトを作成する
        let s = Article()
        s.id = id
        s.date = date
        s.owner = owner
        s.text = text
        s.status = Int64(status)
        
        // トランザクションを開始して、オブジェクトをRealmに追加する
        do {
            try self.realm!.write {
                self.realm!.add(s)
            }
            print("Realm add Article complete. id=\(s.id) genre=\(s.owner) price=\(s.text) date=\(s.date)")
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
        return s
    }
    
    // 日記を追加する 有効でないデータ
    public func addArticleDraft(date: NSDate, owner: String, text: String) -> Article {
        let id: Int64 = getNextArtocleId()
        return addArticle(id: id, date: date, owner: owner, text: text, status:0)
    }
    
    // 対象日に合致する日記を返す
    public func getArticlesFromDate(date: NSDate,status:Int=1) -> Results<Article> {
        let year = DateUtil.year(date: date)
        let month = DateUtil.month(date: date)
        let day = DateUtil.day(date: date)
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let startstr = String(format: "%04d-%02d-%02d 00:00:00", year,month,day)
        let start: NSDate? = date_formatter.date(from: startstr) as NSDate?
        let endstr = String(format: "%04d-%02d-%02d 23:59:59", year,month,day)
        
        //ここでは対象日に関するものだけ取得する
        let end: NSDate? = date_formatter.date(from: endstr) as NSDate?
        
        // SQL
        let format = " text != nil AND "
            + "(date >= %@ and date <= %@) AND status = %d" //対象日内の予定
        let predicate = NSPredicate(format: format,
                                    start!, end!, status)
        //print("predicate : \(predicate)")
        let sortProperties = [SortDescriptor(property: "date", ascending: true)]
        let articles = self.realm!.objects(Article.self).filter(predicate).sorted(by: sortProperties)
        return articles
    }
    
    // 全ての日記を取得
    public func getArticlesFromDateAll(date: NSDate) -> Results<Article> {
        let year = DateUtil.year(date: date)
        let month = DateUtil.month(date: date)
        let day = DateUtil.day(date: date)
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let startstr = String(format: "%04d-%02d-%02d 00:00:00", year,month,day)
        let start: NSDate? = date_formatter.date(from: startstr) as NSDate?
        let endstr = String(format: "%04d-%02d-%02d 23:59:59", year,month,day)
        
        //ここでは対象日に関するものだけ取得する
        let end: NSDate? = date_formatter.date(from: endstr) as NSDate?
        
        // SQL
        let format = " text != nil AND "
            + "(date >= %@ and date <= %@) " //対象日内の予定
        let predicate = NSPredicate(format: format,
                                    start!, end!
        )
        //print("predicate : \(predicate)")
        let sortProperties = [SortDescriptor(property: "date", ascending: true)]
        let articles = self.realm!.objects(Article.self).filter(predicate).sorted(by: sortProperties)
        return articles
    }
    
    // 対象日に合致する日記を返す オーナー指定
    public func getArticlesFromDate(date: NSDate, owner: String) -> Results<Article> {
        let year = DateUtil.year(date: date)
        let month = DateUtil.month(date: date)
        let day = DateUtil.day(date: date)
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let startstr = String(format: "%04d-%02d-%02d 00:00:00", year,month,day)
        let start: NSDate? = date_formatter.date(from: startstr) as NSDate?
        let endstr = String(format: "%04d-%02d-%02d 23:59:59", year,month,day)
        
        //ここでは対象日に関するものだけ取得する
        let end: NSDate? = date_formatter.date(from: endstr) as NSDate?
        
        // SQL
        let format = " text != nil AND "
            + "(date >= %@ and date <= %@) AND owner = %@ AND status = %d" //対象日内の予定
        let predicate = NSPredicate(format: format,
                                    start!, end!, owner, 1
        )
        //print("predicate : \(predicate)")
        let sortProperties = [SortDescriptor(property: "date", ascending: true)]
        let articles = self.realm!.objects(Article.self).filter(predicate).sorted(by: sortProperties)
        return articles
    }
    
    // status : 0 の日記を削除
    public func deleteArticleDraft(){
        
        // SQL 現在以降のstatus:0の日記を削除
        let format = " date >= %@ AND status = %d"
        let predicate = NSPredicate(format: format,
                                    NSDate(), 0)
        //print("predicate : \(predicate)")
        let sortProperties = [SortDescriptor(property: "id", ascending: true)]
        let articles = self.realm!.objects(Article.self).filter(predicate).sorted(by: sortProperties)
        
        for article in articles {
            // トランザクションを開始してオブジェクトを削除
            do {
                try self.realm!.write {
                    self.realm!.delete(article)
                }
            } catch let error as NSError {
                print("Realm init error" + error.description)
            }
        }
    }
    
    // 通知からの起動 status:0の日記をstatus1に変更する
    public func updateArticleDraft(){
        // SQL 現在以前のstatus:0の日記を取得
        let format = " date <= %@ AND status = %d"
        let predicate = NSPredicate(format: format,
                                    NSDate(), 0)
        //print("predicate : \(predicate)")
        let sortProperties = [SortDescriptor(property: "date", ascending: true)]
        let articles = self.realm!.objects(Article.self).filter(predicate).sorted(by: sortProperties)
        
        for article in articles {
            // トランザクションを開始してオブジェクトを更新
            do {
                try self.realm!.write {
                    article.status = 1
                }
            } catch let error as NSError {
                print("Realm init error" + error.description)
            }
        }
    }
    
    // 通知設定済み年月日を登録
    public func addPushdate(date: NSDate) -> Pushdate {
        // 日時を 00:00:00に合わせる
        let year = DateUtil.year(date: date)
        let month = DateUtil.month(date: date)
        let day = DateUtil.day(date: date)
        
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let startstr = String(format: "%04d-%02d-%02d 00:00:00", year,month,day)
        let registDate: NSDate? = date_formatter.date(from: startstr) as NSDate?
        
        
        // Pushdateブジェクトを作成する
        let s = Pushdate()
        s.date = registDate
        
        // トランザクションを開始して、オブジェクトをRealmに追加する
        do {
            try self.realm!.write {
                self.realm!.add(s)
            }
            print("Realm add Pushdate complete. date=\(s.date) ")
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
        return s
    }
    
    // 削除
    public func deletePushdate(date: NSDate) {
        // 日時を 00:00:00に合わせる
        let year = DateUtil.year(date: date)
        let month = DateUtil.month(date: date)
        let day = DateUtil.day(date: date)
        
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let startstr = String(format: "%04d-%02d-%02d 00:00:00", year,month,day)
        let deleteDate: NSDate? = date_formatter.date(from: startstr) as NSDate?
        
        // Pushdateブジェクトを削除する
        let p = self.realm!.objects(Pushdate.self).filter("date = \(deleteDate)")
        // トランザクションを開始してオブジェクトを削除します
        do {
            try self.realm!.write {
                self.realm!.delete(p)
            }
        } catch let error as NSError {
            print("Realm init error" + error.description)
        }
    }

    // 本日以降のデータを削除
    public func deletePushdatesFromToday(){
        let date = NSDate(timeIntervalSinceNow: -1*24*60*60)
        // SQL
        let format = "date >= %@ " //対象日
        let predicate = NSPredicate(format: format,date)
        let sortProperties = [SortDescriptor(property: "date", ascending: true)]
        let results = self.realm!.objects(Pushdate.self).filter(predicate).sorted(by: sortProperties)
        // 削除
        for d in results{
            do {
                try self.realm!.write {
                    self.realm!.delete(d)
                }
            } catch let error as NSError {
                print("Realm init error" + error.description)
            }
        }
    }
    
    public func getPushdate(date: NSDate) -> Results<Pushdate> {
        let year = DateUtil.year(date: date)
        let month = DateUtil.month(date: date)
        let day = DateUtil.day(date: date)
        let date_formatter: DateFormatter = DateFormatter()
        //date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.locale     = NSLocale(localeIdentifier: NSLocale.Key.languageCode.rawValue) as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let startstr = String(format: "%04d-%02d-%02d 00:00:00", year,month,day)
        let start: NSDate? = date_formatter.date(from: startstr) as NSDate?
        
        // SQL
        let format = " date = %@" //対象日内の予定
        let predicate = NSPredicate(format: format, start!)
        //print("predicate : \(predicate)")
        let sortProperties = [SortDescriptor(property: "date", ascending: true)]
        let pushdates = self.realm!.objects(Pushdate.self).filter(predicate).sorted(by: sortProperties)
        return pushdates
    }
    
    public func getMaxPushdate() -> NSDate {
        
        //let p = Pushdate.allObjects()
        let p = self.realm!.objects(Pushdate.self).sorted(byProperty: "date", ascending: false)
        // 最大値
        if(p.count>1){
            return p[0].date!
        }
        return NSDate()
    }
}

extension Results{
    var allObjects:[Element]{
        return self.map{$0}
    }
}
