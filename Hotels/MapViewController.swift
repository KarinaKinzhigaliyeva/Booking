//
//  MapViewController.swift
//  Hotels
//
//  Created by Karina Kinzhigaliyeva on 13.11.2024.
//
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView2: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var userLocation = CLLocation()
    
    var followMe = false
    
    var coordinates: HotelCoordinates?
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Запрашиваем разрешение на использование местоположения пользователя
        locationManager.requestWhenInUseAuthorization()
        
        // delegate нужен для функции didUpdateLocations
        locationManager.delegate = self
        
        // Запускаем слежку за пользователем
        locationManager.startUpdatingLocation()
        
        // Настраиваем отслеживания жестов - когда двигается карта вызывается didDragMap
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap))
        mapDragRecognizer.delegate = self
        mapView2.addGestureRecognizer(mapDragRecognizer)
        
        // MKMapViewDelegate - для обработки событий карты, например нажатия на метку
        mapView2.delegate = self
        
        // followMe = true
        
        // Добавляем метку на карту
        guard let coordinates else { return }
        let coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        // Установка региона карты, чтобы метка была по центру
        let regionRadius: CLLocationDistance = 500 // Радиус отображаемого региона в метрах
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView2.setRegion(region, animated: true)
        
        // Добавление аннотации (метки) на карту
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = ""
        mapView2.addAnnotation(annotation)
        
        //        // Попробуем построить маршрут, если пользовательское местоположение уже известно
        //        if let _ = userLocation.coordinate.latitude as CLLocationDegrees?, let _ = userLocation.coordinate.longitude as CLLocationDegrees? {
        //            buildRoute(to: coordinate)
        //        }
        if userLocation.coordinate.latitude != 0 && userLocation.coordinate.longitude != 0 {
            buildRoute(to: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations[0]
        
        print(userLocation)
        
        if followMe {
            // Дельта - насколько отдалиться от координат пользователя по долготе и широте
            let latDelta: CLLocationDegrees = 0.01
            let longDelta: CLLocationDegrees = 0.01
            
            // Создаем область шириной и высотой по дельте
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            
            // Создаем регион на карте с моими координатами в центре
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            
            // Приближаем карту с анимацией в данный регион
            mapView2.setRegion(region, animated: false)//here
            
            if !mapView2.region.center.latitude.isEqual(to: userLocation.coordinate.latitude) {
                mapView2.setRegion(region, animated: true)
            }// here
        }
        
        // Построение маршрута к метке, если координаты метки известны
        if let coordinates = coordinates {
            let coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
            buildRoute(to: coordinate)
            // Проверяем, если текущий маршрут уже строился, то не строим заново
            if userLocation.distance(from: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) > 50 {
                buildRoute(to: coordinate)
            }// here
        }
    }
    
    // Метод для построения маршрута до заданных координат
    private func buildRoute(to destinationCoordinate: CLLocationCoordinate2D) {
        
        // Координаты начальной точки (пользовательское местоположение)
        let sourceLocation = userLocation.coordinate
        
        // Создаем Placemark для начальной и конечной точек
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        // Создаем MapItem для начальной и конечной точек
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // Создаем запрос на построение маршрута
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Рассчитываем маршрут
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) -> Void in
            // Если возникла ошибка, выводим её и выходим из метода
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            // Берем первый маршрут
            let route = response.routes[0]
            
            // Удаляем все существующие маршруты с карты
            self.mapView2.removeOverlays(self.mapView2.overlays)
            
            // Добавляем новый маршрут на карту
            self.mapView2.addOverlay(route.polyline, level: .aboveRoads)
            
            // Приближаем карту к маршруту
            let rect = route.polyline.boundingMapRect
            self.mapView2.setRegion(MKCoordinateRegion(rect), animated: false)
        }
    }
    
    // MARK: -  MapView delegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Настраиваем линию маршрута
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    // Вызывается, когда нажали на метку на карте
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // Получаем координаты метки
        guard let annotationCoordinate = view.annotation?.coordinate else { return }
        
        // Считаем расстояние до метки от местоположения пользователя
        let location = CLLocation(latitude: annotationCoordinate.latitude, longitude: annotationCoordinate.longitude)
        let meters = location.distance(from: userLocation)
        distanceLabel.text = String(format: "Distance: %.2f m", meters)
        
        // Построение маршрута
        buildRoute(to: annotationCoordinate)
    }
    
    // Вызывается, когда двигаем карту
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        // Как только начали двигать карту, отключаем "следить за мной"
        if gestureRecognizer.state == .changed {
            followMe = false
            print("Map drag changed")
        }
    }
    
    @IBAction func showMyLocation(_ sender: Any) {
        followMe = true
        
        // Обновляем карту, чтобы вернуться к текущему местоположению
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView2.setRegion(region, animated: true)
        
    }
    
    func getModel(value: HotelCoordinates) {
        coordinates = value
    }
}
