//
//  NearStationTableViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/21.
//

import UIKit

class NearStationTableViewController: UITableViewController {
    
    @IBOutlet var tbData: UITableView!
  
  
    var rows = 0 // default = 0
    
    // 현재 위치의 시
    var userCity : String = "" // default = 수원

    
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    // 현재 위치 근처 충전소만 담겨있는 배열
    var nearStationsArr = NSMutableArray()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.isNavigationBarHidden = true // 나중에 상세 테이블뷰로 넘어가는 세그에서 히든 풀어주기
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
 
       
        makeNearStationsArray()
    }
    // 파싱한 데이터중 위치주소의 데이터만 따로 array에 담음
    func makeNearStationsArray() {
        let arr = posts as Array
        var str : String
        for i in 0..<arr.count
        {
            str = (arr[i].value(forKey: "addr")) as! NSString as String
            //print(str)
            
            if(str.contains(userCity))
            {
                nearStationsArr.add(arr[i])
                rows += 1
            }
        }
        tbData!.reloadData()
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return rows
        //return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var subTitleStatStr : String = String("NULL")
        // Configure the cell...
//        if (((posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr") as! NSString as String).contains(userCity)) {
//            subTitleStatStr = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
//            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "statNm") as! NSString as String
   
        subTitleStatStr = (nearStationsArr.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
        cell.textLabel?.text = (nearStationsArr.object(at: indexPath.row) as AnyObject).value(forKey: "statNm") as! NSString as String
        
   
       
        //}
      
        
      
        
        
        if (subTitleStatStr == "1")
        {
            subTitleStatStr = "통신 이상"
        } else if (subTitleStatStr == "2") {
            subTitleStatStr = "충전 대기"
        } else if (subTitleStatStr == "3") {
            subTitleStatStr = "충전 중"
        } else if (subTitleStatStr == "4") {
            subTitleStatStr = "운영 중지"
        } else if (subTitleStatStr == "5") {
            subTitleStatStr = "점검 중"
        } else if (subTitleStatStr == "9") {
            subTitleStatStr = "상태 미확인"
        }
        cell.detailTextLabel?.text = subTitleStatStr
//        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToDetailView" {
            // 메인에선 네비게이션 바 없애고 메뉴 들어갔을 때만 네비게이션 바 생기도록
            if let tableController = segue.destination as? NearDetailViewController {
                tableController.userCity = userCity
                tableController.zcode = zcode
            }
    }
    

}
