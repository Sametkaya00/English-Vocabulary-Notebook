//
//  RandomExampleChicModel.swift
//  ingilizceKelime
//
//  Created by samet kaya on 27.11.2024.
//

import Foundation
import CoreData
import UIKit
class RandomExampleChicModel{
    
    static let shared = RandomExampleChicModel()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetcWords() -> [String] {
        
        let fechRequest : NSFetchRequest<Deneme> = Deneme.fetchRequest()
        
        do{
           let resualt = try context.fetch(fechRequest)
            return resualt.compactMap{$0.turkceKelime}
           
        }
        catch{
            print("error")
            return[]
        }
    }
}
