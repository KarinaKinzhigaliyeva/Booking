//
//  ViewController.swift
//  Hotels
//
//  Created by Karina Kinzhigaliyeva on 12.11.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    private var model: AboutHotels?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    @IBAction func touchedButton(_ sender: Any) {
        // Ваш код здесь
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        if let coordinates = model?.coordinates {
            vc.getModel(value: coordinates)
        }
        
        navigationController?.show(vc, sender: self)
        
    }
    
    // Удаляем кастомный инициализатор
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = model else {
            // Обработайте ситуацию, когда модель не установлена
            return
        }
        
        if let hotelsImages = model.hotelsImages {
            imageView.image = UIImage(named: hotelsImages)
        }
        
        nameLabel.text = model.hotelsName
        addressLabel.text = model.address
        
        let coordinate = CLLocationCoordinate2D(latitude: model.coordinates.latitude, longitude: model.coordinates.longitude)
        
        // Установка региона карты, чтобы метка была по центру
        let regionRadius: CLLocationDistance = 500 // Радиус отображаемого региона в метрах
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        // Добавление аннотации (метки) на карту
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = model.hotelsName
        mapView.addAnnotation(annotation)
    }
    
    func getModel(model2: AboutHotels) {
        
        self.model = model2
        
    }
}
