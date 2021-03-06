//
//  DetailedViewController.swift
//  CoctailApp
//
//  Created by Инна Лаптева on 29.02.2020.
//  Copyright © 2020 Инна Лаптева. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var imageOfCoctail: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var ingridientsLabel: UILabel!
    @IBOutlet weak var alcoLabel: UILabel!
    
    
    var coctail: Coctail!
    var detailedJSON: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namelabel.text = coctail.strDrink
        detailedJSON = getDetailedJson()
        //fetchData()
        fetchImage()
        NetManager.netManager.fetchData(from: detailedJSON) { (reciveDrink) in
            DispatchQueue.main.async {
                self.coctail = reciveDrink.drinks.first
            self.instructionLabel.text = "Instruction: \(reciveDrink.drinks.first?.strInstructions ?? "not found")"
            self.alcoLabel.text = reciveDrink.drinks.first?.strAlcoholic
            self.ingridientsLabel.text = "Ingridients: \(reciveDrink.drinks.first?.ingredients ?? "not found")"
        }
       
        } }
    
    //MARK: Private methods
    private func getDetailedJson() -> String {
        
        let idDrink = coctail.idDrink
        let detailedJson = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(idDrink)"
        print(detailedJson)
        return detailedJson
        
    }
    
    private func fetchData() {
        guard let url = URL(string: detailedJSON) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let receivedDrink = try decoder.decode(Drinks.self, from: data)
                DispatchQueue.main.async {
                    self.instructionLabel.text = "Instruction: \(receivedDrink.drinks.first?.strInstructions ?? "not found")"
                    self.alcoLabel.text = receivedDrink.drinks.first?.strAlcoholic
                    self.ingridientsLabel.text = "Ingridients: \(receivedDrink.drinks.first?.ingredients ?? "not found")"
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    private func fetchImage() {
        
        guard let url = URL(string: coctail.strDrinkThumb) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error { print(error); return }
            if let response = response { print(response) }
            
            if let data = data, let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    
                    self.imageOfCoctail.image = image
                }
            }
        }.resume()
        // resume запускает задачу datatask
    }

}

