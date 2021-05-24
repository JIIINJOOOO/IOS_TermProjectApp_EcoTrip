//
//  ViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // 충전소 찾기 뷰에서 X 버튼 누르면 동작하는 unwind 메소드
    @IBAction func doneToMainViewController(segue:UIStoryboardSegue) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToNearView" {
            // 메인에선 네비게이션 바 없애고 메뉴 들어갔을 때만 네비게이션 바 생기도록
            self.navigationController?.isNavigationBarHidden = false
            if let tabController = segue.destination as? UITabBarController {
//                if let nearTableViewController = tabController.navigationController?.topViewController as?
                
                    //tabController.url = url +
                
            }
        }
        if segue.identifier == "segueToNationView" {
            // 메인에선 네비게이션 바 없애고 메뉴 들어갔을 때만 네비게이션 바 생기도록
            self.navigationController?.isNavigationBarHidden = false
            if let tabController = segue.destination as? UITabBarController {
//                if let nearTableViewController = tabController.navigationController?.topViewController as?
                
                    //tabController.url = url +
                
            }
        }
    }
    
}

