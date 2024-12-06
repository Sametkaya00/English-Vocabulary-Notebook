//
//  RandomExampleModel.swift
//  ingilizceKelime
//
//  Created by samet kaya on 25.11.2024.
//

import Foundation
import UIKit
import CoreData

class RandomExampleModel{
    
    static let shared = RandomExampleModel()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetcWords() -> [(ingilizce:String,turkce:String)] {
        
        let fechRequest : NSFetchRequest<Deneme> = Deneme.fetchRequest()
        
        do{
           let resualt = try context.fetch(fechRequest)
            return resualt.compactMap{
                deneme in
                guard let ingilizceKelime = deneme.ingilizceKelime,let turkceKelime = deneme.turkceKelime else{return nil}
                return(ingilizce:ingilizceKelime,turkce:turkceKelime)
            }
           
        }
        catch{
            print("error")
            return[]
        }
    }
}
   
    
    
    
/* compactMap Nasıl Çalışır?
 compactMap, her bir elemanı işleyerek, dönüştürme işlemi sırasında nil değerler çıkarsa bu değerleri diziden atar ve yalnızca geçerli değerleri içeren yeni bir dizi döndürür.

*/
