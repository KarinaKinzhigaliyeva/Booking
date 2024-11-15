//
//  Hotels.swift
//  Hotels
//
//  Created by Karina Kinzhigaliyeva on 12.11.2024.
//

import Foundation

struct AboutHotels {
    
    var hotelsName, hotelsImages, address: String?
    
    var coordinates: HotelCoordinates
    
}


struct HotelCoordinates {
    
    var latitude: Double
    
    var longitude: Double
}
