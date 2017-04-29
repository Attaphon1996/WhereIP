//
//  LoginedViewController.swift
//  WhereIP
//
//  Created by Pandora on 4/28/2560 BE.
//  Copyright © 2560 Pandora. All rights reserved.
//
import MapKit
import UIKit
import Foundation
class LoginedViewController: UIViewController{
    
    @IBOutlet weak var inputip: UITextField!
    @IBOutlet weak var labelci: UILabel!
    @IBOutlet weak var labelco: UILabel!
    @IBOutlet weak var labella: UILabel!
    @IBOutlet weak var labello: UILabel!
    let regionRadius: CLLocationDistance = 1000
    var ip = ""
    var statusj = ""
    var IPh:[String] = [""]
    var selectHis:String = ""
    var getLatitude:Double = 0.0
    var getLongitude:Double = 0.0
    var getCity:String = "aa"
    var getCountry:String = "aa"
    //var name : String!
    @IBOutlet weak var Nav: UINavigationBar!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Nav.topItem?.title = "WhereIP"
        getdata()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getdata(){
        let defaults = UserDefaults.standard
        if let SIP = defaults.stringArray(forKey: "IP"){
            print(SIP)
            IPh = SIP
        }
        defaults.set(false, forKey: "selected")
        defaults.set("", forKey: "select")
    }
    func savedata(a : String){
        IPh.append(a)
        let defaults = UserDefaults.standard
        defaults.set(IPh, forKey: "IP")
        defaults.set(getLongitude, forKey: a+"Lon")
        defaults.set(getLatitude, forKey: a+"Lat")
        defaults.set(getCity, forKey: a+"City")
        defaults.set(getCountry, forKey: a+"Coun")
    }
    
    @IBAction func history(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "History") as? HistoryViewController
        
        //vc?.name = self.loadname
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    @IBAction func Sr(_ sender: Any) {
        if inputip.text != "" {
            ip = inputip.text!
            
            getJson2()
        }
        else {
            
            let alertController = UIAlertController(title: "Error", message: "Enter you IP or Hostname", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
   
    
    func getJson2(){
        
        let urls = "http://ip-api.com/json/"+ip
        let url = URL(string: urls)
        var errors = 0
        for i in ip.characters{
            if i.description == " " {
                errors = 1
            }
        }
        if errors != 1 {
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil
                {
                    print ("ERROR")
                }
                else
                {
                    if let content = data
                    {
                        do
                        {
                            //Array
                            let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            //print(myJson)
                            let statusjs = myJson["status"]
                            if statusjs as! String == "success" {
                                self.statusj = statusjs as! String
                                if let latitudes = myJson["lat"]
                                {
                                    self.getLatitude = (latitudes as! Double)
                                    print (self.getLatitude )
                                    
                                }
                                if let longitudes = myJson["lon"]
                                {
                                    self.getLongitude = (longitudes as! Double)
                                    print (self.getLongitude )
                                    
                                }
                                if let city = myJson["city"]
                                {
                                    self.getCity = city as! String
                                    print (self.getCity)
                                    
                                }
                                if let country = myJson["country"]
                                {
                                    self.getCountry = country as! String
                                    print (self.getCountry)
                                    
                                }
                            }
                            else {
                                print("error ----------- xx --------")
                            }
                            
                        }
                        catch
                        {
                            
                        }
                    }
                }
            }
            task.resume()
            let when = DispatchTime.now() + 6 // change 2 to desired number of seconds
            self.labelco.text = "Country : Searching..."
            self.labelci.text = "City : Searching..."
            self.labello.text = "Longitude : Searching..."
            self.labella.text = "Latitude : Searching..."
            DispatchQueue.main.asyncAfter(deadline: when) {
                if self.statusj  == "success" {
                    self.labelco.text = "Country : "+String(self.getCountry)
                    self.labelci.text = "City : "+String(self.getCity)
                    self.labello.text = "Longitude : "+String(self.getLongitude)
                    self.labella.text = "Latitude : "+String(self.getLatitude)
                    let initialLocation = CLLocation(latitude: self.getLatitude, longitude: self.getLongitude)
                    self.centerMapOnLocation(location: initialLocation)
                    self.addAn()
                    self.savedata(a: self.inputip.text!)
                    self.getdata()
                    
                }
                else{
                    self.labelco.text = "Country : Notfind"
                    self.labelci.text = "City : Notfind"
                    self.labello.text = "Longitude : Notfind"
                    self.labella.text = "Latitude : Notfind"
                    print("Plase renew URL")
                    self.inputip.text = ""
                    let alertController = UIAlertController(title: "Error", message: "Not have this IP or Hostname Find", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        else{
            print("Plase renew URL")
            self.inputip.text = ""
            let alertController = UIAlertController(title: "Error", message: "Should Don't have space in IP or Hostname", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
        
    }
    func addAn(){
        struct Location {
            let title: String
            let latitude: Double
            let longitude: Double
        }
        let location = Location(title: inputip.text!,latitude: getLatitude,longitude: getLongitude)
        let annotation = MKPointAnnotation()
        annotation.title = location.title
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        map.addAnnotation(annotation)
    }
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        selectHis = defaults.string(forKey: "select")!
        let status =  defaults.bool(forKey:"selected")
        print(status)
        print(selectHis)
        if selectHis != "" && status {
            inputip.text = selectHis
            getLatitude =  defaults.double(forKey: selectHis+"Lat")
            getLongitude = defaults.double(forKey: selectHis+"Lon")
            getCity = defaults.string(forKey: selectHis+"City")!
            getCountry = defaults.string(forKey: selectHis+"Coun")!
            labelci.text = "City : "+getCity
            labelco.text = "Country : "+getCountry
            labella.text = "Latitude : "+String(getLatitude)
            labello.text = "Longitude :"+String(getLongitude)
            let initialLocation = CLLocation(latitude: getLatitude, longitude: getLongitude)
            centerMapOnLocation(location: initialLocation)
            addAn()
        }
        else {
            print("donselect")
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
