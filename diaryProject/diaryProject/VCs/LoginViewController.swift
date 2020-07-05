//
//  LoginViewController.swift
//  diaryProject
//
//  Created by 황지은 on 2020/06/22.
//  Copyright © 2020 황지은. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var loginUserid: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var loginStatusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginUserid {
            textField.resignFirstResponder()
            self.loginPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func loginBtn() {
        
        if loginUserid.text == "" {
            loginStatusLabel.text = "ID를 입력하세요."
        }
        if loginPassword.text == "" {
            loginStatusLabel.text = "비밀번호를 입력하세요."
        }
        
        let urlString: String = "http://condi.swu.ac.kr/student/M12/project2/loginUser.php"
        guard let requestURL = URL(string: urlString) else {return}
        self.loginStatusLabel.text = ""
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString:String = "id=" + loginUserid.text! + "&password=" + loginPassword.text!
        
        request.httpBody = restString.data(using: .utf8)
        
        
        let session = URLSession.shared
               let task = session.dataTask(with: request){ (responseData, response, responseError) in
                   guard responseError == nil else {
                       print ("Error: Calling POST")
                       return
                   }
                   guard let receivedData = responseData else {
                       print("Error : not receiving Data")
                       return
                   }
                do {
                    let response = response as! HTTPURLResponse
                    if !(200...299 ~= response.statusCode){
                        print("HTTP Error!")
                        return
                    }
                    guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options: .allowFragments) as?  [String:Any] else {
                        print("JSON Serialization Error!")
                        return
                    }
                    guard let success = jsonData["success"] as? String else{
                        print("Error:PHP failure(success)")
                        return
                    }
                    if success == "YES" {

                        
                        DispatchQueue.main.async {
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userId = self.loginUserid.text
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabView = storyboard.instantiateViewController(identifier: "tabView")
                            tabView.modalPresentationStyle = .fullScreen
                            self.present(tabView, animated: true, completion: nil)
                        }
                       
                       
                    }
                    else {
                        if let errMessage = jsonData["error"] as? String {
                            DispatchQueue.main.async {
                                self.loginStatusLabel.text = errMessage
                            }
                        }
                    }
                }
                catch{
                    print("Error: \(error)")
                }
        }
        task.resume()
    }

        
        
    
    
}
