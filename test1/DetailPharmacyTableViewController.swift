//
//  DetailPharmacyTableViewController.swift
//  test1
//
//  Created by kpugame on 2019. 6. 17..
//  Copyright © 2019년 YUM. All rights reserved.
//

import UIKit

class DetailPharmacyTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var detailTableView: UITableView!
    
    // HospitalTableViewController로부터 segue를 통해 전달받은 OpenAPI url주소
    var url : String?
    
    // xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    // feed 데이터를 저장하는 mutable array : 병원이 1개 이므로 itemdl 1ro
    // 11개 정보를 저장하는 array
    let postsname : [String] = ["약국명", "주소", "전화번호", "홈페이지", "상세정보", "진료시간(월)", "진료시간(화)", "진료시간(수)", "진료시간(목)", "진료시간(금)", "진료시간(토)", "진료시간(일)", "진료시간(공휴일)"]
    var posts : [String] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
    // dictionary는 사용하지 않음
    // var elements = NSMutableDictionary()
    var element = NSString()
    // 저장 문자열 변수
    var dutyName = NSMutableString()
    var dutyAddr = NSMutableString()
    var dutyTel1 = NSMutableString()
    var dutyUrl = NSMutableString()
    var dutyInf = NSMutableString()
    var dutyTime1 = NSMutableString()
    var dutyTime1c = NSMutableString()
    var dutyTime2 = NSMutableString()
    var dutyTime2c = NSMutableString()
    var dutyTime3 = NSMutableString()
    var dutyTime3c = NSMutableString()
    var dutyTime4 = NSMutableString()
    var dutyTime4c = NSMutableString()
    var dutyTime5 = NSMutableString()
    var dutyTime5c = NSMutableString()
    var dutyTime6 = NSMutableString()
    var dutyTime6c = NSMutableString()
    var dutyTime7 = NSMutableString()
    var dutyTime7c = NSMutableString()
    var dutyTime8 = NSMutableString()
    var dutyTime8c = NSMutableString()
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        detailTableView!.reloadData()
    }
    
    // parser가 새로운 element를 발견하면 변수를 생성한다.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            // element = NSMutableDictionary()
            // element = [:]
            // 새로운 item(병원)이 발견될 때 마다 posts를 초기화함
            posts = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
            
            dutyName = NSMutableString()
            dutyName = ""
            dutyAddr = NSMutableString()
            dutyAddr = ""
            
            dutyTel1 = NSMutableString()
            dutyTel1 = ""
            dutyUrl = NSMutableString()
            dutyUrl = ""
            dutyInf = NSMutableString()
            dutyInf = ""
            dutyTime1 = NSMutableString()
            dutyTime1 = ""
            dutyTime1c = NSMutableString()
            dutyTime1c = ""
            dutyTime2 = NSMutableString()
            dutyTime2 = ""
            dutyTime2c = NSMutableString()
            dutyTime2c = ""
            dutyTime3 = NSMutableString()
            dutyTime3 = ""
            dutyTime3c = NSMutableString()
            dutyTime3c = ""
            dutyTime4 = NSMutableString()
            dutyTime4 = ""
            dutyTime4c = NSMutableString()
            dutyTime4c = ""
            dutyTime5 = NSMutableString()
            dutyTime5 = ""
            dutyTime5c = NSMutableString()
            dutyTime5c = ""
            dutyTime6 = NSMutableString()
            dutyTime6 = ""
            dutyTime6c = NSMutableString()
            dutyTime6c = ""
            dutyTime7 = NSMutableString()
            dutyTime7 = ""
            dutyTime7c = NSMutableString()
            dutyTime7c = ""
            dutyTime8 = NSMutableString()
            dutyTime8 = ""
            dutyTime8c = NSMutableString()
            dutyTime8c = ""
        }
    }
    
    // 약국 정보 11개를 완성 이름(yadmNm)과 주소(addr) 등
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "dutyName") {
            dutyName.append(string)
        } else if element.isEqual(to: "dutyAddr") {
            dutyAddr.append(string)
        } else if element.isEqual(to: "dutyTel1") {
            dutyTel1.append(string)
        } else if element.isEqual(to: "dutyUrl") {
            dutyUrl.append(string)
        } else if element.isEqual(to: "dutyInf") {
            dutyInf.append(string)
        } else if element.isEqual(to: "dutyTime1s") {
            dutyTime1.append(string+"~"+(dutyTime1c as String))
        } else if element.isEqual(to: "dutyTime1c") {
            dutyTime1c.append(string)
        } else if element.isEqual(to: "dutyTime2s") {
            dutyTime2.append(string+"~"+(dutyTime2c as String))
        } else if element.isEqual(to: "dutyTime2c") {
            dutyTime2c.append(string)
        } else if element.isEqual(to: "dutyTime3s") {
            dutyTime3.append(string+"~"+(dutyTime3c as String))
        } else if element.isEqual(to: "dutyTime3c") {
            dutyTime3c.append(string)
        } else if element.isEqual(to: "dutyTime4s") {
            dutyTime4.append(string+"~"+(dutyTime4c as String))
        } else if element.isEqual(to: "dutyTime4c") {
            dutyTime4c.append(string)
        } else if element.isEqual(to: "dutyTime5s") {
            dutyTime5.append(string+"~"+(dutyTime5c as String))
        } else if element.isEqual(to: "dutyTime5c") {
            dutyTime5c.append(string)
        } else if element.isEqual(to: "dutyTime6s") {
            dutyTime6.append(string+"~"+(dutyTime6c as String))
        } else if element.isEqual(to: "dutyTime6c") {
            dutyTime6c.append(string)
        } else if element.isEqual(to: "dutyTime7s") {
            dutyTime7.append(string+"~"+(dutyTime7c as String))
        } else if element.isEqual(to: "dutyTime7c") {
            dutyTime7c.append(string)
        } else if element.isEqual(to: "dutyTime8s") {
            dutyTime8.append(string+"~"+(dutyTime8c as String))
        } else if element.isEqual(to: "dutyTime8c") {
            dutyTime8c.append(string)
        }
    }
    
    // item의 끝에서 13개 정보를 posts 배열에 차례로 삽입함
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !dutyName.isEqual(nil) {
                posts[0] = dutyName as String
            }
            if !dutyAddr.isEqual(nil) {
                posts[1] = dutyAddr as String
            }
            if !dutyTel1.isEqual(nil) {
                posts[2] = dutyTel1 as String
            }
            if !dutyUrl.isEqual(nil) {
                posts[3] = dutyUrl as String
            }
            if !dutyInf.isEqual(nil) {
                posts[4] = dutyInf as String
            }
            if !dutyTime1.isEqual(nil) {
                posts[5] = dutyTime1 as String
            }
            if !dutyTime2.isEqual(nil) {
                posts[6] = dutyTime2 as String
            }
            if !dutyTime3.isEqual(nil) {
                posts[7] = dutyTime3 as String
            }
            if !dutyTime4.isEqual(nil) {
                posts[8] = dutyTime4 as String
            }
            if !dutyTime5.isEqual(nil) {
                posts[9] = dutyTime5 as String
            }
            if !dutyTime6.isEqual(nil) {
                posts[10] = dutyTime6 as String
            }
            if !dutyTime7.isEqual(nil) {
                posts[11] = dutyTime7 as String
            }
            if !dutyTime8.isEqual(nil) {
                posts[12] = dutyTime8 as String
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCell", for: indexPath)
        cell.textLabel?.text = postsname[indexPath.row] // 13개 정보 타이틀
        cell.detailTextLabel?.text = posts[indexPath.row] // 13개 정보 값
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
