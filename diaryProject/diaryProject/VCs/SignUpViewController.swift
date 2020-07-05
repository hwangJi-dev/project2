//
//  SignUpViewController.swift
//  diaryProject
//
//  Created by 황지은 on 2020/06/22.
//  Copyright © 2020 황지은. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var textID: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textName: UITextField!
    @IBOutlet var textStatus: UITextField!
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var textImgUrl: UILabel!
    @IBOutlet var buttonCamera: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !(UIImagePickerController.isSourceTypeAvailable(.camera)){
            let alert = UIAlertController(title: "Error!", message: "카메라가 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            buttonCamera.isEnabled = false //카메라 버튼 사용 금지시킴
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = image
            print(imageView.image!)
        }
         self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textID {
            textField.resignFirstResponder()
            self.textPassword.becomeFirstResponder()
        }
        else if textField == self.textPassword {
            textField.resignFirstResponder()
            self.textName.becomeFirstResponder()
        }
        else if textField == self.textName {
            textName.resignFirstResponder()
            self.textStatus.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func takePicture() {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self
        myPicker.allowsEditing = true
        myPicker.sourceType = .camera
        self.present(myPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func selectFromAlbum() {
        let mypicker = UIImagePickerController()
        mypicker.delegate = self
        mypicker.sourceType = .photoLibrary
        self.present(mypicker, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    @IBAction func doSignUpBtn() {
        if textID.text == "" {
            labelStatus.text = "ID를 입력하세요."
        }
        else if textPassword.text == "" {
            labelStatus.text = "Password를 입력하세요."
        }
        else if textName.text == "" {
            labelStatus.text = "사용자 이름을 입력하세요."
        }
        else if textStatus.text == "" {
            labelStatus.text = "상태메시지를 입력하세요."
        }
        
        guard let myImage = imageView.image else {
            let alert = UIAlertController(title: "이미지를 선택하세요", message: "Save Failed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        
        let myUrl = URL (string: "http://condi.swu.ac.kr/student/M12/project2/upload.php")

        
        var request = URLRequest(url:myUrl!);
               
               request.httpMethod = "POST";
               
               let boundary = "Boundary-\(NSUUID().uuidString)"
               
               request.setValue("multipart/form-data; boundary=\(boundary)",
                   forHTTPHeaderField: "Content-Type")
               
               guard let imageData = myImage.jpegData(compressionQuality:1) else {
                return }
               
               var body = Data()
               var dataString = "--\(boundary)\r\n"
               dataString += "Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"
               dataString += "Content-Type: application/octet-stream\r\n\r\n"
               if let data = dataString.data(using: .utf8) { body.append(data) }
               
               // imageData 위 아래로 boundary 정보 추가
               body.append(imageData)
               dataString = "\r\n"
               dataString += "--\(boundary)--\r\n"
               
               if let data = dataString.data(using: .utf8) { body.append(data) }
               
               request.httpBody = body
               
               var imageFileName: String = ""
               let semaphore = DispatchSemaphore(value: 0)
               let session = URLSession.shared
               let task = session.dataTask(with: request) { (responseData, response, responseError) in
                   guard responseError == nil else { print("Error: calling POST"); return; }
                   guard let receivedData = responseData else {
                       print("Error: not receiving Data")
                       return;
                   }
                   if let utf8Data = String(data: receivedData, encoding: .utf8) {
                       // 서버에 저장한 이미지 파일 이름
                       imageFileName = utf8Data
                       print(imageFileName)
                       semaphore.signal()
                   }
               }
               task.resume()
        // 이미지 파일 이름을 서버로 부터 받은 후 해당 이름을 DB에 저장하기 위해 wait()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        


        let urlString: String = "http://condi.swu.ac.kr/student/M12/project2/insertUser.php"

        guard let mrequestURL = URL(string: urlString) else {
            return
        }
        request = URLRequest(url: mrequestURL)
        request.httpMethod = "POST"
        let restString:String = "id=" + textID.text! + "&password=" + textPassword.text! + "&name=" + textName.text! + "&profileImg=" + imageFileName + "&statusMsg=" + textStatus.text!

        request.httpBody = restString.data(using: .utf8)

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
                    self.labelStatus.text = utf8Data
                    print(utf8Data)
                }
            }
        }
        task2.resume()
        
         guard let writeVC = self.storyboard?.instantiateViewController(identifier: "write") as? writeViewController else {return}
        writeVC.userId = textID.text
        writeVC.userName = textName.text
        
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
                    self.labelStatus.text = utf8Data
                    print(utf8Data)
                }
            }
        }
        task2.resume()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
