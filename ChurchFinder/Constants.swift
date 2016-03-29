/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 21/02/16
Modified: 25/02/16

Changelog
* Magnificent file header was authored by codereview2k16 #squad

Sources
http://stackoverflow.com/questions/26252233/global-constants-file-in-swift
*/

import Foundation
import Parse

let data = Data.sharedInstance

struct Constants {
    
    struct Parse {
        static let AppID : String = "OTXY6dM8ChkriarqrX4SPi2e2Def9v1EM0VVNoOW"
        static let ClientKey : String = "5I1Iky8vY7hheR7X9QAejEbXaw96UMFBYGzVr4h3"
        static let MasterKey : String = "bssyoWxlPb58XACkt5TqyWMr7G4bFaFC1PdlzXdD"
        static let ChurchClass : String = "Church"
    }
    
    // These default search parameters are used by ChurchData to populate itself when it's first created and also by the filters as the default selection.
    struct Defaults {
        static let Denomination : String = ""
        static let Style : String = ""
        static let Size : Int = 0 // 0 means any size
        static let Lat : Double = 41.157838
        static let Lon : Double = -80.088670
        
        static func get() -> [String:AnyObject] {
            
            var params : [String:AnyObject] = [:]
            
            params["loc"] = PFGeoPoint(latitude: Lat, longitude: Lon)
            
            return params
        }
        
        static let NumberOfResultsToPullAtOnce : Int = 10
    }
    
}
var params : [String:AnyObject] = [:]

func getDistanceString(church : Church) -> String {
    if let currentLocation = Data.sharedInstance.locationManager.location {
        let churchLoc = CLLocation(latitude: church.location.latitude, longitude: church.location.longitude)
        
        //convert to miles
        let churchDistance = (currentLocation.distanceFromLocation(churchLoc) * 0.000621371)
        
        
        //if less than ten show one decimal point
        if (churchDistance < 10.0) {
            //rounding formula http://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
            return String(round(churchDistance * 10)/10) + " mi"
        } else {
            //if greater than ten don't show any decimal points
            return String(Int(churchDistance)) + " mi"
        }
    }
    
    //if we can't get a current location, don't display anything for distance
    return ""
}

//source --- http://stackoverflow.com/questions/31661023/change-color-of-certain-pixels-in-a-uiimage
func darkenImage(inputImage: UIImage) -> UIImage {
    let inputCGImage     = inputImage.CGImage
    let colorSpace       = CGColorSpaceCreateDeviceRGB()
    let width            = CGImageGetWidth(inputCGImage)
    let height           = CGImageGetHeight(inputCGImage)
    let bytesPerPixel    = 4
    let bitsPerComponent = 8
    let bytesPerRow      = bytesPerPixel * width
    let bitmapInfo       = CGImageAlphaInfo.PremultipliedFirst.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue
    
    let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)!
    CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), inputCGImage)
    
    let pixelBuffer = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(context))
    
    var currentPixel = pixelBuffer
    
    for var i = 0; i < Int(height); i++ {
        for var j = 0; j < Int(width); j++ {
            let pixel = currentPixel.memory
            currentPixel.memory = rgba(red: red(pixel)/2, green: green(pixel)/2, blue: blue(pixel)/2, alpha: 255)
            
            currentPixel++
        }
    }
    
    let outputCGImage = CGBitmapContextCreateImage(context)
    let outputImage = UIImage(CGImage: outputCGImage!, scale: inputImage.scale, orientation: inputImage.imageOrientation)
    
    return outputImage
}

func alpha(color: UInt32) -> UInt8 {
    return UInt8((color >> 24) & 255)
}

func red(color: UInt32) -> UInt8 {
    return UInt8((color >> 16) & 255)
}

func green(color: UInt32) -> UInt8 {
    return UInt8((color >> 8) & 255)
}

func blue(color: UInt32) -> UInt8 {
    return UInt8((color >> 0) & 255)
}

func rgba(red red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
    return (UInt32(alpha) << 24) | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
}



