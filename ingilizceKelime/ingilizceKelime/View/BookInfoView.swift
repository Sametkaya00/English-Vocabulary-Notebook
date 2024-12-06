//
//  DenemeView.swift
//  ingilizceKelime
//
//  Created by samet kaya on 6.11.2024.
//

import UIKit
import CoreData
import AVFoundation

class BookInfoView: UIViewController{

    var rightLabel: UILabel!
    var leftLabel : UILabel!
   
    @IBOutlet weak var audioImage: UIImageView!
    
    var leftTextField : UITextField! //ingiizce kelime
    var rightTextField : UITextField! // turkce kelime
    var TextField2: UITextField!//ornek turke
    var TextField : UITextField!//ornek ingilizce
    var saveButton: UIButton!
    var scrolView: UIScrollView!
    var audioimage: UIImageView!
    var isTextFieldActive = false
    
    var chosenPaitingNamee = ""
    var chosenPaitingIdd : UUID?
    
    
    
    @IBOutlet weak var text: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = UIColor(named: "Color8")
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
                
        text.frame = CGRect(x:206 , y: 0, width: screenWidth / 1, height: screenHeight )
        text.backgroundColor = UIColor(named: "homebackgroun")
        let gesturRicognizer = UITapGestureRecognizer(target: self, action: #selector(keyboard))
        view.addGestureRecognizer(gesturRicognizer)
      
        textfieldHeader()
        textField()
        textLabel()
        sampleTextEnglishLabel()
        sampleEnglsihText()
        sampleTextTurkhisLabel()
        sampleTurkhisText()
     
        saveButtonView()
        
        
        
        if chosenPaitingNamee != ""
        {
            
            saveButton.isHidden = true
            leftTextField.isEnabled = false
            rightTextField.isEnabled = false
            TextField.isEnabled = false
            TextField2.isEnabled = false
            
            
            
            //Core dataya ulaşmak için
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Deneme")
            let idString = chosenPaitingIdd?.uuidString
            
            request.predicate = NSPredicate(format: "id = %@", idString!)
            request.returnsObjectsAsFaults = false
            
            do{
                let resalt = try context.fetch(request)
                if resalt.count > 0{
                    for resatl in resalt as! [NSManagedObject]{
                        if let englishName = resatl.value(forKey: "ingilizceKelime") as? String{
                            leftTextField.text = englishName
                           
                            
                        }
                        if let turkisAnlam = resatl.value(forKey: "turkceKelime") as? String{
                            rightTextField.text = turkisAnlam
                        }
                        if let ornekIngilizcee = resatl.value(forKey: "ornekIngilizce") as? String{
                            TextField.text = ornekIngilizcee
                        }
                        if let ornekTurkcee = resatl.value(forKey: "ornekTurkce") as? String{
                            TextField2.text = ornekTurkcee
                        }
                    }
                }
            }
            catch {
                saveButton.isHidden = false
                
                print("error")
                
            }
            
            let audioimage = UIImageView()
            audioimage.image = UIImage(systemName: "speaker.wave.3.fill")
            audioimage.tintColor = UIColor(named: "Color6")
            audioimage.translatesAutoresizingMaskIntoConstraints = false
            audioimage.contentMode = .scaleAspectFit
            view.addSubview(audioimage)
            NSLayoutConstraint.activate([
                // Sol Alt Hizalama
                audioimage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25), // Sol kenara mesafe
                audioimage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25), // Alt kenara mesafe
                audioimage.heightAnchor.constraint(equalToConstant: 32), // Yükseklik (isteğe bağlı)
                audioimage.widthAnchor.constraint(equalToConstant: 32)   // Genişlik (isteğe bağlı)
            ])
            
            audioimage.isUserInteractionEnabled = true
            let gestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(audioClicked))
            audioimage.addGestureRecognizer(gestureRecognizers)
        }
     
    }
    
    @objc func audioClicked() {
       
        print("basıldı")
        
            //Core dataya ulaşmak için
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Deneme")
            let idString = chosenPaitingIdd?.uuidString
            request.predicate = NSPredicate(format: "id = %@", idString!)
            request.returnsObjectsAsFaults = false
          
            request.returnsObjectsAsFaults = false
            
            do{
                let resalt = try context.fetch(request)
                if resalt.count > 0{
                    for resatl in resalt as! [NSManagedObject]{
                        if let englishName = resatl.value(forKey: "ingilizceKelime") as? String{
                            AudioModel.shared.playPronunciation(word: englishName)
                           
                        }
                    }
                }
            }
            catch {
                saveButton.isHidden = false
                
                print("error")
            }
    }

    
    //KLAVYE YUKARI KAYMA
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        // Yalnızca TextField2 için NotificationCenter gözlemcisi ekle
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWill(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        // Gözlemcileri kaldır
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWill(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = self.view.frame.height - (saveButton.frame.origin.y + saveButton.frame.height)
            if bottomSpace < keyboardHeight {
                self.view.frame.origin.y = -(keyboardHeight - bottomSpace + 51)
            }
        }
    }

    @objc func keyboardHidden() {
        // Ekranı eski yerine getir
        self.view.frame.origin.y = 0
    }
    
    
    @objc func keyboard(){
        view.endEditing(true)
    }
    
    
    
    func textLabel(){
        
        // İki tane UILabel oluşturuyoruz
               leftLabel = UILabel()
               leftLabel.text = "İngilizce"
        leftLabel.textAlignment = .left
        leftLabel.textColor = .black
               leftLabel.translatesAutoresizingMaskIntoConstraints = false
               
                rightLabel = UILabel()
               rightLabel.text = "Türkçe"
        rightLabel.textAlignment = .right
        rightLabel.textColor = .white
               rightLabel.translatesAutoresizingMaskIntoConstraints = false
               
               // Label'leri ana görünüme ekliyoruz
               view.addSubview(leftLabel)
               view.addSubview(rightLabel)
               
               // Auto Layout ile konumlandırma
               NSLayoutConstraint.activate([
                   // Sol Label
                leftLabel.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 166),
                   leftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   leftLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
                   
                   // Sağ Label
                   rightLabel.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 166),
                   rightLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
                   rightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
               ])
    }
    
    func textfieldHeader(){
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // Attributed String ile renkli metin oluşturma
       
        label.text = "İngilizce Kelime Defteri"
        label.textColor = UIColor(named: "Color3")
        
        // Arka plan rengini gri yaparak beyaz metnin görünmesini sağlıyoruz
        
        
        // Label'i View'a ekleme
        view.addSubview(label)
        
        // Label'in ekranın üst ortasında konumlandırılması için kısıtlamalar ekliyoruz
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -8),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    func  sampleTextEnglishLabel() {
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // Attributed String ile renkli metin oluşturma
     
        label2.text = " Örnek İngilizce Cümlesi"
        label2.textColor = UIColor(named: "Color3")
        // Arka plan rengini gri yaparak beyaz metnin görünmesini sağlıyoruz
        
        
        // Label'i View'a ekleme
        view.addSubview(label2)
        
        // Label'in ekranın üst ortasında konumlandırılması için kısıtlamalar ekliyoruz
        NSLayoutConstraint.activate([
            label2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant: -160),
            label2.widthAnchor.constraint(equalToConstant: 300),
            label2.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    
   
      
    func sampleTextTurkhisLabel(){
        
      
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // Attributed String ile renkli metin oluşturma
       
        label2.text = " Türkçe Kelime Anlamı"
        label2.textColor = UIColor(named: "Color3")
        
        
        // Label'i View'a ekleme
        view.addSubview(label2)
        
        // Label'in ekranın üst ortasında konumlandırılması için kısıtlamalar ekliyoruz
        NSLayoutConstraint.activate([
            label2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant: 20),
            label2.widthAnchor.constraint(equalToConstant: 300),
            label2.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
  
    
    func textField(){
        // Sol tarafta yer alacak UITextField
    
           leftTextField = UITextField()
        leftTextField.textAlignment = .left
        
     
        
            leftTextField.borderStyle = .roundedRect
            leftTextField.backgroundColor = UIColor(named: "Color")
            leftTextField.translatesAutoresizingMaskIntoConstraints = false
            leftTextField.textColor = .white
            leftTextField.autocorrectionType = .no
           
           // Sağ tarafta yer alacak UITextField
            rightTextField = UITextField()
       
            rightTextField.borderStyle = .roundedRect
            rightTextField.backgroundColor = UIColor(named: "Color2")
            rightTextField.textAlignment = .right
            rightTextField.translatesAutoresizingMaskIntoConstraints = false
            rightTextField.textColor = .black
            rightTextField.autocorrectionType = .no
        
           // Gölgelendirme efektleri
           leftTextField.layer.shadowColor = UIColor.white.cgColor
           leftTextField.layer.shadowOffset = CGSize(width: 3, height: 3)
           leftTextField.layer.shadowOpacity = 0.8
           leftTextField.layer.shadowRadius = 4
           
           rightTextField.layer.shadowColor = UIColor.gray.cgColor
           rightTextField.layer.shadowOffset = CGSize(width: -3, height: 3)
           rightTextField.layer.shadowOpacity = 0.8
           rightTextField.layer.shadowRadius = 4
           
           // TextField'leri ana görünüme ekleyelim
           view.addSubview(leftTextField)
           view.addSubview(rightTextField)
           
           // Auto Layout ile konumlandırma
           NSLayoutConstraint.activate([
               // Sol TextField
            leftTextField.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 200),
               leftTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               leftTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
               
               // Sağ TextField
            rightTextField.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 200),
               rightTextField.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
               rightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
           ])
    }
    
    @objc func  sampleEnglsihText(){
        
        TextField = UITextField()
        TextField.textAlignment = .center
    
      
     
        
         TextField.borderStyle = .roundedRect
         TextField.backgroundColor = UIColor(named: "Color")
         TextField.translatesAutoresizingMaskIntoConstraints = false
         TextField.textColor = .white
         TextField.autocorrectionType = .no
        
        // Gölgelendirme efektleri
        TextField.layer.shadowColor = UIColor.white.cgColor
        TextField.layer.shadowOffset = CGSize(width: 3, height: 3)
        TextField.layer.shadowOpacity = 0.8
        TextField.layer.shadowRadius = 4
        
        view.addSubview(TextField)
        
        NSLayoutConstraint.activate([
            // Sol TextField
            // TextField'i ekranın ortasına hizala
            TextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               TextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -23),
               
               // Genişlik ve yükseklik ayarla (örnek olarak 200 genişlik ve 50 yükseklik verdik)
               TextField.widthAnchor.constraint(equalToConstant: 350),
               TextField.heightAnchor.constraint(equalToConstant: 42)
       
        ])
    }
    func sampleTurkhisText(){
        
       
        
        TextField2 = UITextField()
        TextField2.textAlignment = .center
        
      
        //KLAVYE YUKARI KAYMA
        TextField2.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        TextField2.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
     
     
         TextField2.borderStyle = .roundedRect
         TextField2.backgroundColor = UIColor(named: "Color")
         TextField2.translatesAutoresizingMaskIntoConstraints = false
         TextField2.textColor = .white
         TextField2.autocorrectionType = .no
        
        // Gölgelendirme efektleri
        TextField2.layer.shadowColor = UIColor.white.cgColor
        TextField2.layer.shadowOffset = CGSize(width: 3, height: 3)
        TextField2.layer.shadowOpacity = 0.8
        TextField2.layer.shadowRadius = 4
        
        view.addSubview(TextField2)
        
        NSLayoutConstraint.activate([
            // Sol TextField
            // TextField'i ekranın ortasına hizala
            TextField2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               TextField2.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 160),
               
               // Genişlik ve yükseklik ayarla (örnek olarak 200 genişlik ve 50 yükseklik verdik)
               TextField2.widthAnchor.constraint(equalToConstant: 350),
               TextField2.heightAnchor.constraint(equalToConstant: 42)
       
        ])
        
    }

    
    func saveButtonView(){
       
             saveButton = UIButton(type: .system)
      
           saveButton.translatesAutoresizingMaskIntoConstraints = false
           saveButton.setTitle("Save", for: .normal)
           saveButton.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        saveButton.backgroundColor = .purple
           saveButton.layer.cornerRadius = 10
           
           view.addSubview(saveButton)
        
        

           NSLayoutConstraint.activate([
               saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
               saveButton.widthAnchor.constraint(equalToConstant: 200),
               saveButton.heightAnchor.constraint(equalToConstant: 50)
           ])
        
    }
    
        
    @objc func saveButtonClick(){
        //core dataya ulaştık
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Ulaştığımız core data içinde Kelime adlı core dataya ulaş
        let newPatings = NSEntityDescription.insertNewObject(forEntityName: "Deneme", into: context)
        
        //Ulaştığımız Kelime entities içindeki attributelere değişkenlerimizi atatık.
        
        if (leftTextField.text == "" || rightTextField.text == ""){
            let alert = UIAlertController(title: "İlk 2 Kutu boş bırakılamaz", message: "Lütfen doldurunuz", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            newPatings.setValue(leftTextField.text, forKey: "ingilizceKelime")
            newPatings.setValue(rightTextField.text, forKey: "turkceKelime")
            newPatings.setValue(TextField2.text, forKey: "ornekTurkce")
            newPatings.setValue(TextField.text, forKey: "ornekIngilizce")
            newPatings.setValue(UUID(), forKey: "id")
           
            
              do {
                 try context.save()
                  print("save success")
                  
                                //Veri kaydolduğu zaman diğer ana ekrana göndermek için kullanıyoruz.
                  NotificationCenter.default.post(name: NSNotification.Name("update"), object: nil)
                  self.navigationController?.popViewController(animated: true)
                  
              }catch{
                  print("save error")
              }
        }
           
     
      
    }
}
    
   
   

