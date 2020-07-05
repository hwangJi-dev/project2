//
//  writeViewController.swift
//  diaryProject
//
//  Created by 황지은 on 2020/07/05.
//  Copyright © 2020 황지은. All rights reserved.
//

import UIKit
import CoreData

class writeViewController: UIViewController,UITextFieldDelegate {

    
    var userId:String?
    var userName:String?
    var date:Date?
    
    @IBOutlet var diaryTitle: UITextField!
    @IBOutlet var todayStatus: UITextField!
    @IBOutlet var diaryDetail: UITextView!
    @IBOutlet var status: UILabel!
    @IBOutlet var openToggle: UISwitch!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "MyDiary", in: context)
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                   
        object.setValue(diaryTitle.text, forKey: "title")
        object.setValue(todayStatus.text, forKey: "status")
        object.setValue(diaryDetail.text, forKey: "diaryDetail")
        object.setValue(appDelegate.userId, forKey: "userid")
        
        do {
                   try context.save()
                   print("saved")
                   print(object)
               }
               catch let error as NSError
               {
                   print("Could not save \(error), \(error.userInfo)")
               }

        
        
        if diaryTitle.text == "" {
                  status.text = "제목을 입력하세요."
              }
              if todayStatus.text == "" {
                  status.text = "오늘의 기분을 입력하세요."
              }
        if diaryDetail.text == "" {
                               status.text = "일기 내용을 입력하세요."
        }
              
    
       // guard let signUpVC = self.storyboard?.instantiateViewController(identifier: "signUp") as? SignUpViewController else {return}
        
        guard let userId = self.userId else {return}
        guard let userName = self.userName else {return}

      
 
        let urlString = URL(string: "http://condi.swu.ac.kr/student/M12/project2/insertDiary.php")

            
        var request = URLRequest(url:urlString!)
        
        request.httpMethod = "POST"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myDate = formatter.string(from: Date())
        
        object.setValue(myDate, forKey: "saveDate")
        
       
        var restString:String = "userid=" + userId + "&title=" + diaryTitle.text!
        restString += "&diaryDetail=" + diaryDetail.text!
        restString += "&statusMsg=" + todayStatus.text!
        restString += "&userName=" + userName
        restString += "&date=" + myDate
        


        request.httpBody = restString.data(using: .utf8)
        executeRequest(request: request)
        print(restString)
        
    }
    
    
    func executeRequest(request: URLRequest) -> Void {
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request){ (responseData, response, responseError) in
            guard responseError == nil else {
                print ("Error: Calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error : not receiving Data")
                return
            }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.status.text = utf8Data
                    print(utf8Data)
                }
            }
        }
        task2.resume()
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



