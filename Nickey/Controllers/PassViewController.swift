//
//  PassViewController.swift
//  Nickey
//
//  Created by cano on 2016/10/23.
//  Copyright © 2016年 cano. All rights reserved.
//

import UIKit

class PassViewController: UIViewController {

    @IBOutlet weak var passTextField: UITextField!
    
    var delegate : passwordDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onOK(_ sender: AnyObject) {
        // realm
        let realm   = RealmController.getSharedRealmController()
        let config  = realm.getConfig()
        
        // 認証NG
        if(passTextField.text != config.password){
            // UIAlertControllerを作成する.
            let alert: UIAlertController = UIAlertController(title: "", message: "パスワードが違います", preferredStyle: .alert)
            
            // OKのアクションを作成する.
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            }
            // OKのActionを追加する.
            alert.addAction(okAction)
            // UIAlertを発動する.
            present(alert, animated: true, completion: nil)
        }
        // 認証OK
        else{
            if (self.delegate?.responds(to: Selector("didClose"))) != nil {
                // 実装先のメソッドを実行
                self.delegate?.didClose()
            }
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

// FirstViewController で処理を行うためのデリゲート
protocol passwordDelegate : NSObjectProtocol {
    // 閉じる
    func didClose()
}
