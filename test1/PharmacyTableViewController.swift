//
//  PharmacyTableViewController.swift
//  test1
//
//  Created by kpugame on 2019. 6. 3..
//  Copyright © 2019년 YUM. All rights reserved.
//

import UIKit

class PharmacyTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var tbData: UITableView!
    
    var url : String?
    
    // xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = XMLParser()
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    // title과 date 같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    // 저장 문자열 변수
    var dutyName = NSMutableString()
    var dutyAddr = NSMutableString()
    
    // 위도 경도 좌표 변수
    var wgs84Lat = NSMutableString()
    var wgs84Lon = NSMutableString()
    
    // 약국 id
    var hpid = NSMutableString()
    
    
    var pharmacyid = ""
    
    // parser오브젝트 초기화하고 NSXMLParserDelegate로 설정하고 XML 파싱 시작
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
    }
    
    // parser가 새로운 element를 발견하면 변수를 생성한다.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            dutyName = NSMutableString()
            dutyName = ""
            dutyAddr = NSMutableString()
            dutyAddr = ""
            // 위도 경도
            wgs84Lat = NSMutableString()
            wgs84Lat = ""
            wgs84Lon = NSMutableString()
            wgs84Lon = ""
            hpid = NSMutableString()
            hpid = ""
        }
    }
    
    // 병원이름(yadmNm)과 주소(addr)을 발견하면 yadmNm과 addr에 완성한다.
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "dutyName")
        {
            dutyName.append(string)
        }
        else if element.isEqual(to: "dutyAddr")
        {
            dutyAddr.append(string)
        }
            // 위도 경도
        else if element.isEqual(to: "wgs84Lat") {
            wgs84Lat.append(string)
        } else if element.isEqual(to: "wgs84Lon") {
            wgs84Lon.append(string)
        }
        else if element.isEqual(to: "hpid") {
            hpid.append(string)
        }
    }
    
    // element의 끝에서 feed데이터를 dictionary에 저장
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if(elementName as NSString).isEqual(to: "item")
        {
            if !dutyName.isEqual(nil)
            {
                elements.setObject(dutyName, forKey: "dutyName" as NSCopying)
            }
            if !dutyAddr.isEqual(nil)
            {
                elements.setObject(dutyAddr, forKey: "dutyAddr" as NSCopying)
            }
            // 위도 경도
            if !wgs84Lat.isEqual(nil) {
                elements.setObject(wgs84Lat, forKey: "wgs84Lat" as NSCopying)
            }
            if !wgs84Lon.isEqual(nil) {
                elements.setObject(wgs84Lon, forKey: "wgs84Lon" as NSCopying)
            }
            if !hpid.isEqual(nil) {
                elements.setObject(hpid, forKey: "hpid" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    // prepare 메소드는 segue실행될 때 호출되는 메소드
    // id를 segueToMapView로 설정
    // MapViewController에 posts 정보 전달함
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapView" {
            if let mapViewController = segue.destination as? MapViewController {
                mapViewController.posts = posts
            }
        }
        
        if segue.identifier == "segueToPharmacyDetail" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                pharmacyid = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "hpid") as! NSString as String
                
                if let detailPharmacyTableViewController = segue.destination as? DetailPharmacyTableViewController {
                    detailPharmacyTableViewController.url = url! + "&HPID=" + pharmacyid
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // XML 파싱
        beginParsing()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "dutyName") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "dutyAddr") as! NSString as String

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
