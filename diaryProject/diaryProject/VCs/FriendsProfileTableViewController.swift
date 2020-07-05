//
//  FriendsProfileTableViewController.swift
//  diaryProject
//
//  Created by 황지은 on 2020/06/22.
//  Copyright © 2020 황지은. All rights reserved.
//

import UIKit

class FriendsProfileTableViewController: UITableViewController {

    
    private var profileList:[FriendsData] = Array()
    private var myList:[FreindsInformation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileList = []
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setProfileList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileList = []
        self.downloadDataFromServer()
    }
    
    
    func downloadDataFromServer() ->Void {
        
        let urlString: String = "http://condi.swu.ac.kr/student/M12/project2/favoriteTable.php"
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
        var newData: FriendsData = FriendsData()
        var jsonElement = jsonData[i]
        newData.userid = jsonElement["userid"] as! String
        newData.name = jsonElement["name"] as! String //제목
        newData.passwd = jsonElement["passwd"] as! String
        newData.profileImg = jsonElement["profileImg"] as! String
        newData.statusMsg = jsonElement["statusMsg"] as! String
        self.profileList.append(newData)
        }
        DispatchQueue.main.async { self.tableView.reloadData() }
        }
        } catch { print("Error: Catch") }
        }
        task.resume()
    }
    
    
//
    private func setProfileList(){
//
        let me = FreindsInformation(profileImg:"beauty_1585659625845.jpeg" , profileName: "황지은", statusLabel: "")

     myList = [me]
//
    }
//

    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if section == 0{
//            return myList.count
//        }
        
        return profileList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! profileTableViewCell

        
      
            let item = profileList[indexPath.row]
            cell.profileImage.image = UIImage(named: item.profileImg)
        print(item.profileImg)
            cell.profileNameLabel.text = item.name
            cell.profileStatusMsg.text = item.statusMsg
            
    
       

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "나의 친구 보기"
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
