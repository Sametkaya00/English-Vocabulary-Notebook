import UIKit
import CoreData

class CoreDataManager {
    // Singleton kullanımı (Tüm projede aynı örnek kullanılacak)
    static let shared = CoreDataManager()
    private init() {} // Dışarıdan başka bir örnek oluşturulmasın
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    // Veri Kaydetme
    func saveWord(word: String,entityName: String, key: String) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        newEntity.setValue(word, forKey: key)
      
        
        do {
            try context.save()
            print("Veri başarıyla kaydedildi: \(word)")
        } catch {
            print("Core Data kaydetme hatası: \(error)")
        }
    }
    
    // Veri Çekme
    func fetchWords(entityName: String, key: String) -> [String] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        var fetchedWords: [String] = []
       
       
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let word = result.value(forKey: key) as? String {
                    fetchedWords.append(word)
                }
               
                
            }
            print("Veriler başarıyla çekildi: \(fetchedWords)")
          
        } catch {
            print("Core Data'dan veri çekme hatası: \(error)")
        }
        
        return fetchedWords
    }
    
    

    
    //Veri silme
    func deleteWord(_ entityName:String,_ key:String,_ key2:String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let wordingilsh = result.value(forKey:key)as? String{
                    print("Silinecek veri: \(wordingilsh)")
                    context.delete(result)
                }
                if let wordTurkhis = result.value(forKey: key2) as? String{
                    context.delete(result)
                }
            }
            try context.save()
            print("Veri başarıyla silindi.")
        } catch {
        }
    }
}
