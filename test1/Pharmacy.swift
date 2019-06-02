//
//  Pharmacy.swift
//  test1
//
//  Created by kpugame on 2019. 6. 3..
//  Copyright © 2019년 YUM. All rights reserved.
//

import Foundation
import MapKit
// 위치와 같은 주소, 도시 또는 상태 필드를 설정해야하는 경우
// CNPostalAddressStreetKey와 같은 사전 키 상수가 포함
import Contacts

class Pharmacy: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
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
