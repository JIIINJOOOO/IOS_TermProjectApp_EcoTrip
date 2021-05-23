//
//  NearMapViewController.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/23.
//

import UIKit
import MapKit

class NearMapViewController: UIViewController, MKMapViewDelegate {

    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
