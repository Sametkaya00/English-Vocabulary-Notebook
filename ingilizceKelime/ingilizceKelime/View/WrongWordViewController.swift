//
//  WrongWordViewController.swift
//  ingilizceKelime
//
//  Created by samet kaya on 30.11.2024.
//

import UIKit
import CoreData

class WrongWordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    var wordWrongArray = [String]()
    var wordWrongTurkisArray = [String]()
   

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
      
       
        tableView.delegate = self
        tableView.dataSource = self
        
       
        wrongWordGetData()
        
    }
  
    
    func wrongWordGetData(){
     
        let fetchedWords = CoreDataManager.shared.fetchWords(entityName: "Deneme", key: "wrongWord")
               print(fetchedWords)
       
        wordWrongArray.append(contentsOf: fetchedWords)
        
        let fetchedWordsTurkis = CoreDataManager.shared.fetchWords(entityName: "Deneme", key: "wrongWordTurkce")
        print(fetchedWordsTurkis)
        
        wordWrongTurkisArray.append(contentsOf: fetchedWordsTurkis)

    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordWrongTurkisArray.count
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
           
           // Sol taraf için bir etiket (wordWrongArray)
           let leftLabel = UILabel()
           leftLabel.text = wordWrongArray[indexPath.row]
           leftLabel.font = UIFont.systemFont(ofSize: 17)
        leftLabel.textColor = UIColor(named: "Color6")
           leftLabel.translatesAutoresizingMaskIntoConstraints = false
           cell.contentView.addSubview(leftLabel)
           
           // Sağ taraf için bir etiket (wordWrongTurkisArray)
           let rightLabel = UILabel()
           rightLabel.text = wordWrongTurkisArray[indexPath.row]
           rightLabel.font = UIFont.systemFont(ofSize: 17)
           rightLabel.textColor = .gray
           rightLabel.translatesAutoresizingMaskIntoConstraints = false
           cell.contentView.addSubview(rightLabel)
           
           // Etiketler için otomatik yerleşim
           NSLayoutConstraint.activate([
               // Sol etiketin hizalaması
               leftLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
               leftLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
               
               // Sağ etiketin hizalaması
               rightLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
               rightLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
               
               // Sol etiketin sağ etikete göre boşluk bırakması (opsiyonel)
               leftLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightLabel.leadingAnchor, constant: -8)
           ])
           
           cell.backgroundColor = UIColor(named: "Color3")
           return cell
    }
    
    
    
    //Veri silme
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // AppDelegate ve Context alma
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            // Silinecek kelimeyi belirleme
            let wordToDelete = wordWrongArray[indexPath.row]
          

            // Sorgu oluşturma
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Deneme")
            request.predicate = NSPredicate(format: "wrongWord == %@", wordToDelete)
            
            
            
            request.returnsObjectsAsFaults = false

            do {
                let results = try context.fetch(request)
                if let objectToDelete = results.first as? NSManagedObject {
                    // Core Data'dan sil
                    context.delete(objectToDelete)
                    
                    // Diziden sil
                    wordWrongArray.remove(at: indexPath.row)
                    
                    
                    // Güncellenen tabloyu yeniden yükle
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    // Değişiklikleri kaydet
                    try context.save()
                    self.tableView.reloadData()
                    print("Silindi")
                }
            } catch {
                print("Veri silinemedi: \(error.localizedDescription)")
            }
        }
    }

}
