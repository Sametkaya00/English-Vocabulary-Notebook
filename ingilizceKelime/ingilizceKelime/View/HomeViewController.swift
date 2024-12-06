//
//  HomeViewController.swift
//  ingilizceKelime
//
//  Created by samet kaya on 7.11.2024.
//

import UIKit
import CoreData


class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var wordWordArray = [String]()
    var wordWordTurkisArray = [String]()
    
    var stokText : UILabel!
    var tableView: UITableView!
    
    var englisWordArrayy = [String]()
    var idArrayy = [UUID]()
    
    
    var selectingPaintingIdd:UUID?
    var selectingPaintingNamee = ""
   
    let notificationCenter: NotificationCenter = NotificationCenter.default
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "homebackgroun")
    
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
       
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
       
        setupTabBar()
       
    
        wrongWordGetData()
        tableViewFulScreen()
        getData()
        
      
        
       
    }
    
 
    
   func favoriteButton(){
      
       if englisWordArrayy.count > 4{
           performSegue(withIdentifier: "ExampleDC", sender: nil)
       }
       else{
           let alert = UIAlertController(title: "Uyarı", message: "en az 5 kelime eklemeniz gerekmektedir.", preferredStyle: .alert)
           let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
           alert.addAction(action)
           present(alert, animated: true, completion: nil)
       }
      
    }
    
 //MARK: -- BU İKİ MARK ARASI wrongwordViewController işin segue işlemi, datadan veri çekme işlemi if kontrolü içindir.
    
    func wrongWordSegue(){
        print(wordWordArray)
        
       if wordWordArray.count > 1{
           
            performSegue(withIdentifier: "wrongsegue", sender: nil)
        }
        else{
            let alert = UIAlertController(title: "Uyarı", message: "Hiç hata yapmamışsınız ki. Hadi biraz hata yap :)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func wrongWordGetData(){
     
        let fetchedWords = CoreDataManager.shared.fetchWords(entityName: "Deneme", key: "wrongWord")
               print(fetchedWords)
        wordWordArray.append(contentsOf: fetchedWords)
 
    }
    
// MARK: -
    
    override func viewDidAppear(_ animated: Bool) {
        notificationCenter.addObserver(self, selector:#selector(getData), name: Notification.Name(rawValue:"update"), object: nil)
        
       
        
       
    }
   
   
        @objc func addButton(){
            selectingPaintingNamee = ""
            performSegue(withIdentifier: "segue", sender: nil)
        }
        
    
   
    func tableViewFulScreen(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 90),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100)
            
            ])
    }
    
    @objc func getData(){
        
        englisWordArrayy.removeAll(keepingCapacity: false)
        idArrayy.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Deneme") // request tut getir anlamına geliyor
        //sorgu sırasında nesneleri tamamen yüklemek yerine fault geçiri veri gösterimi olarak getiri bellek kullanımı azaltır , ihtiyac duyulduğunda tüm veriler yükler , ama biz bunu false yapark kapatıyoruz , nedeni ise hızlı bir şekilde tüm verililere ulaşmak istediğimizden kaynaklı.
        request.returnsObjectsAsFaults = false
        
        //Cekilen veriyi dizilerin içine aktardığımız kısım
        do{
            let resualt = try context.fetch(request)
            if resualt.count > 0 {
                for resalt in resualt as! [NSManagedObject] {
                    if let ingilizcekelime = resalt.value(forKey: "ingilizceKelime") as? String {
                        englisWordArrayy.append(ingilizcekelime)
                        
                   
                       
                    }
                   
                    if let id = resalt.value(forKey: "id") as? UUID {
                        idArrayy.append(id)
                        
                        
                        
                        
                    }
                    
                }
               
           
                
                self.tableView.reloadData()
            }
        }catch {
            print("data upload error")
        }
      
    }
    
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return englisWordArrayy.count
        
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var context = cell.defaultContentConfiguration()
        context.text = englisWordArrayy[indexPath.row]
        cell.contentConfiguration = context
        cell.backgroundColor = UIColor(named: "Color3")
        return cell
    }
   
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let destination = segue.destination as! BookInfoView
            destination.chosenPaitingIdd = selectingPaintingIdd
            destination.chosenPaitingNamee = selectingPaintingNamee
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectingPaintingIdd = idArrayy[indexPath.row]
        selectingPaintingNamee = englisWordArrayy[indexPath.row]
        performSegue(withIdentifier: "segue", sender: nil)
       
    }
    
    
    
    
   
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Deneme")
        
        let idStrint = idArrayy[indexPath.row].uuidString
    
        
        request.predicate = NSPredicate(format: "id = %@", idStrint)
       
        request.returnsObjectsAsFaults = false
        
        
        do{
            let resualt = try context.fetch(request)
            if resualt.count > 0{
                for resualt in resualt as! [NSManagedObject]{
                    if let id = resualt.value(forKey: "id") as? UUID{
                        if(id == idArrayy[indexPath.row]){
                            context.delete(resualt)
                            englisWordArrayy.remove(at: indexPath.row)
                            idArrayy.remove(at: indexPath.row)
                            self.tableView.reloadData()
                          
                            do{
                                try context.save()
                            }catch{
                                print("error")
                            }
                            break
                            
                        }
                    }
                    
            
                   
                  
                   
                   
                }
            }
        }catch{
            print("delete error")
        }

    }
    
    
    
   
}

