//
//  ViewController.swift
//  PDates
//
//  Created by Rui on 12/23/16.
//  Copyright © 2016 ivovl. All rights reserved.
//
import Foundation
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var pDatesTableView: UITableView!
    
    let recordStartPDateBtnText = "Record start Pdate"
    let recordEndPDateBtnTExt = "Record end Pdate"
    let recordBtnTextKeyInUserDefaults = "Record Button Text"
    
    var pDates: [PDate] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pDatesTableView.dataSource = self
        self.pDatesTableView.delegate = self
        
        if let recordBtnText = self.defaults.string(forKey: recordBtnTextKeyInUserDefaults) {

            self.recordBtn.setTitle(recordBtnText, for: .normal)
        } else { self.recordBtn.setTitle(self.recordStartPDateBtnText, for: .normal) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.recordBtn.setTitle(recordStartPDateBtnText, for: .normal)
        getData()
        self.pDatesTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UI Actions
    @IBAction func recordBtnClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let recordBtnText = getRecordBtnText()
        if recordBtnText == recordEndPDateBtnTExt {
            
            let date = PDate(context: context)
            date.startDate = Date() as NSDate
            self.recordBtn.setTitle(recordEndPDateBtnTExt, for: .normal)
            print("record start pdate button clicked")
        } else {
            self.recordBtn.setTitle(recordStartPDateBtnText, for: .normal)
            getData()
            let date = pDates[pDates.count-1]
            date.endDate = Date() as NSDate
            do{
                try date.managedObjectContext?.save()
            } catch {
                print("error in editing pDate when recording end pdate")
            }
            
            print("record end pdate button clicked")
        }
        
        appDelegate.saveContext()
        // reload data
        getData()
        self.pDatesTableView.reloadData()
    }

    // MARK: Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let pDate = pDates[indexPath.row]
        if let endDate = pDate.endDate {
            cell.textLabel?.text = (pDate.startDate as! Date).toString() + " - " + ((endDate as Date).toString())
        } else {
            cell.textLabel?.text = (pDate.startDate as! Date).toString()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deletePDate(pDate: pDates[indexPath.row])
            // reload the data from core data
            getData()
            tableView.reloadData()
        }
    }
    // MARK: Core Date
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            pDates = try context.fetch(PDate.fetchRequest())
        }
        catch {
            print("error in fetching data")
        }
    }
    
    func deletePDate(pDate: PDate){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(pDate)
        appDelegate.saveContext()
    }
    
    // MARK: Utility
    
    func getRecordBtnText() -> String{
        // check if it has been set
        if let recordBtnText = self.defaults.string(forKey: recordBtnTextKeyInUserDefaults) {
            // if start then set end
            if recordBtnText == self.recordStartPDateBtnText {
                self.defaults.setValue(self.recordEndPDateBtnTExt, forKey: recordBtnTextKeyInUserDefaults)
                return recordStartPDateBtnText
            }
        }
        
        self.defaults.setValue(self.recordStartPDateBtnText, forKey: recordBtnTextKeyInUserDefaults)
        return recordEndPDateBtnTExt
        
    }

    
}

