//
//  ExtinationTabbar.swift
//  ingilizceKelime
//
//  Created by samet kaya on 10.11.2024.
//

import Foundation
import UIKit


extension UIViewController{
    
 
func setupTabBar() {
    
    let aa = HomeViewController()
    let bb = WrongWordViewController()
   
    
      // Ana tab bar görünümü
      let tabBarView = UIView()

    tabBarView.backgroundColor = .white
      tabBarView.layer.cornerRadius = 15
      tabBarView.layer.masksToBounds = true
      tabBarView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(tabBarView)
      
      // Tab bar görünümü için yerleşim
      NSLayoutConstraint.activate([
          tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
          tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
          tabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
          tabBarView.heightAnchor.constraint(equalToConstant: 30)
      ])

      // Ortadaki simgeyi vurgulayan yükseltilmiş görünüm
      let middleButton = UIButton()
    middleButton.backgroundColor = UIColor(named: "tabbar")
      middleButton.layer.cornerRadius = 30 // Yuvarlak şekil için
      middleButton.layer.shadowColor = UIColor.black.cgColor
      middleButton.layer.shadowOpacity = 0.3
      middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
      middleButton.layer.shadowRadius = 10
      middleButton.setImage(UIImage(systemName: "plus"), for: .normal)
      middleButton.tintColor = .white
      middleButton.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(middleButton)
    
    //Tıklanıldığığında ne olacağı
    middleButton.addTarget(self, action: #selector(aa.addButton), for: .touchUpInside)
    
      
      // Ortadaki simge için yerleşim
      NSLayoutConstraint.activate([
          middleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          middleButton.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor, constant:-10),
          middleButton.widthAnchor.constraint(equalToConstant: 60),
          middleButton.heightAnchor.constraint(equalToConstant: 60)
      ])

      // Diğer simgeler
      let icons = ["pencil.and.list.clipboard", "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90"]
      var buttons: [UIButton] = []
    
      for icon in icons {
          let button = UIButton()
          let largeConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .bold, scale: .large)
          let image = UIImage(systemName: icon, withConfiguration: largeConfig) // Konfigürasyonu uygulayın
             button.setImage(image, for: .normal)
             
          button.setImage(UIImage(systemName: icon), for: .normal)
          
          button.tintColor = UIColor(named: "tabbar")
          button.translatesAutoresizingMaskIntoConstraints = false
          buttons.append(button)
          tabBarView.addSubview(button)
          
          if icon == "pencil.and.list.clipboard" {
      
              
              button.addAction(UIAction(handler: { action in
                  if let home = self as? HomeViewController{
                      home.favoriteButton()
                  }
              }), for: .touchUpInside)
        
      
                
        }
          if icon == "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90" {
     
              button.addAction(UIAction(handler: { action in
                 
                  if let home = self as? HomeViewController{
                      home.wrongWordSegue()
                  }
                  
                
                 
              }), for: .touchUpInside)
          }
             
            
      }
       
   
   
      // Simge yerleşimi için StackView kullanımı
      let stackView = UIStackView(arrangedSubviews: buttons)
      stackView.axis = .horizontal
      stackView.distribution = .equalSpacing
      stackView.alignment = .center
      stackView.translatesAutoresizingMaskIntoConstraints = false
      tabBarView.addSubview(stackView)
    
    

      // StackView için yerleşim
      NSLayoutConstraint.activate([
          stackView.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor, constant: 50),
          stackView.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor, constant: -50),
          stackView.centerYAnchor.constraint(equalTo: tabBarView.centerYAnchor)
      ])
    
    
   
    
    
  }
    
   
    
   
    
}

