//
//  Station.swift
//  TermProject
//
//  Created by KPUGAME on 2021/05/23.
//

import Foundation
import MapKit
import Contacts // 위치와 같은 주소, 도시 또는 상태필드를 설정해야하는 경우

class Station: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }

    // subtitle은 locationName을 반환하는 computed property
    var subtitle: String? {
        return locationName
    }
    // 클래스에 추가하는 helper 메소드
    // MKPlacemark로 부터 MKMapItem을 생성
    // info button을 누르면 MKMapItem을 오픈하게됨
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
