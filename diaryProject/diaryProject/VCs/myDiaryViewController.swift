//
//  myDiaryViewController.swift
//  diaryProject
//
//  Created by 황지은 on 2020/07/05.
//  Copyright © 2020 황지은. All rights reserved.
//

import UIKit
import CoreData

class myDiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet var myTableView: UITableView!
    
    var myDiary: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
    

    func getContext() -> NSManagedObjectContext {
        
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           return appDelegate.persistentContainer.viewContext
       }
       
       //View가 보여질 때 자료를 DB에서 가져오도록 한다
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
           let context = self.getContext()
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MyDiary")
        
        //로그인 아이디 별 내가 쓴 글 필터링
        let filter = appDelegate.userId
        let predicate = NSPredicate(format: "userid = %@", filter as! CVarArg)
           fetchRequest.predicate = predicate
           do{
               myDiary = try context.fetch(fetchRequest)
           } catch let error as NSError {
               print("Could not fetch. \(error), \(error.userInfo)")
           }
        self.myTableView.reloadData()
        
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
     func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return myDiary.count
       }

       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "myDiary", for: indexPath) as! myDiaryTableViewCell

           // Configure the cell...
           let myDiaries = myDiary[indexPath.row]
          
           cell.myTitle.text = myDiaries.value(forKey: "title")as? String
           cell.todaysStatus.text = myDiaries.value(forKey: "status")as? String
           

           return cell
       }
       

}
