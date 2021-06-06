//
//  NationDetailTableViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/06/06.
//

import UIKit

class NationDetailTableViewController: UITableViewController {
    @IBOutlet var tbData: UITableView!
    
    var searchedStationsArr = NSMutableArray()
    let postsname : [String] = ["충전소명", "주소", "충전기 타입", "충전량", "충전기 상태", "이용 가능 시간", "주차료 무료", "이용자 제한", "이용자 제한 사유", "충전소 안내", "운영기관명", "연락처"]
    
    var posts : [String] = ["","","","","","","","","","","",""]
    // 선택한 셀의 충전소 명
    var stationName = ""
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setPosts()
    }
    func setPosts() {
        
        let arr = searchedStationsArr as Array
        var statNmstr : String
        var statusStr : String
        var chgerTypeStr : String
       // print("arr count:\(arr.count)")
        for i in 0..<arr.count
        {
            statNmstr = (arr[i].value(forKey: "statNm")) as! NSString as String
            if(statNmstr.contains(stationName))
            {
                posts[0] = arr[i].value(forKey: "statNm") as! NSString as String
                posts[1] = arr[i].value(forKey: "addr") as! NSString as String
                chgerTypeStr = arr[i].value(forKey: "chgerType") as! NSString as String
                //print(chgerTypeStr)
                if (chgerTypeStr == "01")
                {
                    chgerTypeStr = "DC차데모"
                } else if (chgerTypeStr == "02") {
                    chgerTypeStr = "AC완속"
                } else if (chgerTypeStr == "03") {
                    chgerTypeStr = "DC차데모+AC3상"
                } else if (chgerTypeStr == "04") {
                    chgerTypeStr = "DC콤보"
                } else if (chgerTypeStr == "05") {
                    chgerTypeStr = "DC차데모+DC콤보"
                } else if (chgerTypeStr == "06") {
                    chgerTypeStr = "DC차데모+AC3상+DC콤보"
                } else if (chgerTypeStr == "07") {
                    chgerTypeStr = "AC3상"
                }
                posts[2] = chgerTypeStr
                posts[3] = arr[i].value(forKey: "powerType") as! NSString as String
                statusStr = arr[i].value(forKey: "stat") as! NSString as String
                if (statusStr == "1")
                {
                    statusStr = "통신 이상"
                } else if (statusStr == "2") {
                    statusStr = "충전 대기"
                } else if (statusStr == "3") {
                    statusStr = "충전 중"
                } else if (statusStr == "4") {
                    statusStr = "운영 중지"
                } else if (statusStr == "5") {
                    statusStr = "점검 중"
                } else if (statusStr == "9") {
                    statusStr = "상태 미확인"
                }
                posts[4] = statusStr
                posts[5] = arr[i].value(forKey: "useTime") as! NSString as String
                posts[6] = arr[i].value(forKey: "parkingFree") as! NSString as String
                posts[7] = arr[i].value(forKey: "limitYn") as! NSString as String
                posts[8] = arr[i].value(forKey: "limitDetail") as! NSString as String
                posts[9] = arr[i].value(forKey: "note") as! NSString as String
                posts[10] = arr[i].value(forKey: "busiNm") as! NSString as String
                posts[11] = arr[i].value(forKey: "busiCall") as! NSString as String

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
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NationDetailCell", for: indexPath)
        

        // Configure the cell...
        
        // Configure the cell...
//        if (((posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr") as! NSString as String).contains(userCity)) {
//            subTitleStatStr = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stat") as! NSString as String
//            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "statNm") as! NSString as String
   
        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = posts[indexPath.row]
        

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
