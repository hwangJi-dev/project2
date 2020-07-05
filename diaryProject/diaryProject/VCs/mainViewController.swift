//
//  mainViewController.swift
//  diaryProject
//
//  Created by 황지은 on 2020/07/05.
//  Copyright © 2020 황지은. All rights reserved.
//

import UIKit

class mainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    private var diaryList:[diaryData] = Array()

    @IBOutlet var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           diaryList = []
           self.downloadDataFromServer()
       }
       
       
       func downloadDataFromServer() ->Void {
           
           let urlString: String = "http://condi.swu.ac.kr/student/M12/project2/friendsDiaryTable.php"
           guard let requestURL = URL(string: urlString) else { return }
           let request = URLRequest(url: requestURL)
           let session = URLSession.shared
           let task = session.dataTask(with: request) { (responseData, response, responseError) in
               guard responseError == nil else { print("Error: calling POST"); return; }
               guard let receivedData = responseData else {
                   print("Error: not receiving Data"); return;
               }
               let response = response as! HTTPURLResponse
               
           if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
           do {
           if let jsonData = try JSONSerialization.jsonObject (with: receivedData,
           options:.allowFragments) as? [[String: Any]] {
           for i in 0...jsonData.count-1 {
           var newData: diaryData = diaryData()
           var jsonElement = jsonData[i]
            
           newData.userid = jsonElement["userid"] as! String
            newData.title = jsonElement["title"] as! String //제목
           newData.diaryDetail = jsonElement["diaryDetail"] as! String
           newData.statusMsg = jsonElement["statusMsg"] as! String
            newData.userName = jsonElement["userName"] as! String
            newData.date = jsonElement["date"] as! String
            //newData.openStatus = jsonElement["openStatus"] as! Bool
           self.diaryList.append(newData)
           }
           DispatchQueue.main.async { self.mainTableView.reloadData() }
           }
           } catch { print("Error: Catch") }
           }
           task.resume()
       }
       
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainTableViewCell

        let item = diaryList[indexPath.row]
        cell.mainID.text = item.userid
        cell.mainDate.text = "\(item.date)"
       // cell.mainImg.image = UIImage(named: item.profileImg)
        cell.mainStatus.text = item.statusMsg
        cell.mainTitle.text = item.title
                  

       return cell
    }
    

}
