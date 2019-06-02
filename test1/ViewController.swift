//
//  ViewController.swift
//  test1
//
//  Created by kpugame on 2019. 6. 3..
//  Copyright © 2019년 YUM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    // Donw 버튼을 누르면 동작하는 unwind 메소드
    // 아무 동작도 하지않지만 이 메소드가 있어야 PharmacyTableViewController에서 unwind 연결이 가능함
    @IBAction func doneToPickerViewController(segue:UIStoryboardSegue){
        
    }
    
    var pickerDataSource = ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구",
                            "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구",
                            "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]
    
    // Q0 = 시
    // Q1 = 구
    // QT = 월~일요일, 공휴일 1~8
    // QN = 기관명
    // PageNo = 페이지번호
    // nomOfRows = 목록건수
    var url : String = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?serviceKey=oke9ab6Ut5h1Rd4v1PH2wxz%2BPER64u1msAK%2F5tjhvpPOg6j1zRXxFQsP8lkgX%2B1p8yHZ%2Bn5vqG36Au66Lqft0w%3D%3D&Q0="
    var sgguCd : String = "강남구"
    
    // pickerView의 컴포넌트 개수 = 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // pickerView의 각 컴포넌트에 대한 row의 개수 = pickerDataSource 배열 원소 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    // pickerView의 주어진 컴포넌트/row에 대한 데이터 = pickerDataSource 배열의 원소
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    // pickerView의 row 선택 시 sgguCd를 변경
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            sgguCd = "강남구"
        } else if row == 1 {
            sgguCd = "강동구"
        } else if row == 2 {
            sgguCd = "강북구"
        } else if row == 3 {
            sgguCd = "강서구"
        } else if row == 4 {
            sgguCd = "관악구"
        } else if row == 5 {
            sgguCd = "광진구"
        } else if row == 6 {
            sgguCd = "구로구"
        } else if row == 7 {
            sgguCd = "금천구"
        } else if row == 8 {
            sgguCd = "노원구"
        } else if row == 9 {
            sgguCd = "도봉구"
        } else if row == 10 {
            sgguCd = "동대문구"
        } else if row == 11 {
            sgguCd = "동작구"
        } else if row == 12 {
            sgguCd = "마포구"
        } else if row == 13 {
            sgguCd = "서대문구"
        } else if row == 14 {
            sgguCd = "서초구"
        } else if row == 15 {
            sgguCd = "성동구"
        } else if row == 16 {
            sgguCd = "성북구"
        } else if row == 17 {
            sgguCd = "송파구"
        } else if row == 18 {
            sgguCd = "양천구"
        } else if row == 19 {
            sgguCd = "영등포구"
        } else if row == 20 {
            sgguCd = "용산구"
        } else if row == 21 {
            sgguCd = "은평구"
        } else if row == 22 {
            sgguCd = "종로구"
        } else if row == 23 {
            sgguCd = "중구"
        } else if row == 24 {
            sgguCd = "중랑구"
        }
    }
    
    // prepare 메소드는 segue 실행될 때 호출되는 메소드
    // id를 segueToTableView로 설정
    // PharmacyTableViewController에 url정보를 전달하기 위해 먼저 UINavigationController를
    // destination으로 설정한 후 PharmacyTableViewController를 선택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let pharmacyTableViewController = navController.topViewController as? PharmacyTableViewController {
                    var url2 : String = "서울특별시&Q1=" + sgguCd
                    let escapedUrl = url2.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    pharmacyTableViewController.url = url + escapedUrl! + "&pageNo=1&numOfRows=1000"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }


}

