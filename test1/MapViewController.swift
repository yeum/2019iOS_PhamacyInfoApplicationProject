//
//  MapViewController.swift
//  test1
//
//  Created by kpugame on 2019. 6. 3..
//  Copyright © 2019년 YUM. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    
    // 이 지역은 regionRadius (5000m) 거리에 따라 남북 및 동서에 걸쳐있을 것이다.
    let regionRaduis: CLLocationDistance = 5000
    // setRegion은 region을 표시하도록 mapView에 지시
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRaduis, longitudinalMeters: regionRaduis)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // 생성하는 Pharmacy 객체들의 배열 선언
    var pharmacys : [Pharmacy] = []
    
    // 전송받은 posts 배열에서 정보를 얻어서 Pharmacy 객체를 생성하고 배열에 추가 생성
    func loadInitialData() {
        for post in posts {
            let dutyName = (post as AnyObject).value(forKey: "dutyName") as! NSString as String
            let dutyAddr = (post as AnyObject).value(forKey: "dutyAddr") as! NSString as String
            let wgs84Lat = (post as AnyObject).value(forKey: "wgs84Lat") as! NSString as String
            let wgs84Lon = (post as AnyObject).value(forKey: "wgs84Lon") as! NSString as String
            let lat = (wgs84Lat as NSString).doubleValue
            let lon = (wgs84Lon as NSString).doubleValue
            let pharmacy = Pharmacy(title: dutyName, locationName: dutyAddr, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            pharmacys.append(pharmacy)
        }
    }
    
    // 사용자가 지도 주석 마커를 탭하면 설명 선에 info button이 표시.
    // info button을 누르면 mapView(_:annotationView:calloutAccessoryControlTapped:) 메서드가 호출
    // Artwork탭에서 참조하는 객체 항목을 만들고 지도 항목을 MKMapItem을 호출하여 지도 앱을 실행합니다.
    // openInMaps(launchOptions:) 몇 가지 옵션을 지정할 수 있음. 여기는 DirectionModeKey로 Driving 설정
    // 이로 인해 지도 앱에서 사용자의 현재 위치에서 이 핀까지의 운전 경로를 표시합니다.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Pharmacy
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    // 1. mapView(_:viewFor:)는, tableView(_:cellForRowAt:)테이블보기로 작업할 때와 마찬가지로, 지도에 추가하는 모든 주석이 호출되어 각 주석에 대한 보기를 반환합니다.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2. 이 주석(annotation)이 Artwork객체 인지 확인!! 그렇지 않으면 nil지도 뷰에서 기본 주석 뷰를 사용하도록 돌아감.
        guard let annotation = annotation as? Pharmacy else {return nil}
        
        // 3. 마커가 나타나게 MKMarkerAnnotationView를 뷰를 만듦.
        //      이 자습서의 뒷부분에서는 MKAnnotationView마커 대신 이미지를 표시하는 객체를 만듭니다.
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        // 4. 코드를 새로 생성하기 전에 재사용 가능한 주석 뷰를 사용할 수 있는 지 먼저 확인
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5. MKMarkerAnnotationView 주석보기에서 대기열에서 삭제할 수 없는 경우 여기에서 새 객체를 만듭니다.
            //      Artwork클래스의 title 및 subtitle 속성을 사용하여 콜 아웃에 표시할 내용을 결정합니다.
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기위치 서울시 노원구
        let initialLocation = CLLocation(latitude: 37.654432, longitude: 127.060096)
        // 메소드 호출
        centerMapOnLocation(location: initialLocation)
        // MapViewController가 mapView의 delegate임을 설정
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(pharmacys)
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
