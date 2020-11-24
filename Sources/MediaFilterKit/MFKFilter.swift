//
//  MFKFilter.swift
//  MediaFilterKit
//
//  Created by James Wolfe on 19/11/2020.
//



import Foundation
import CoreImage



/// Filter to apply to media filter kit
public enum MFKFilter: Identifiable {
    
    case chrome
    case fade
    case instant
    case mono
    case noir
    case process
    case tonal
    case transfer
    case sepia
    case vignette(radius: Float = 1, intensity: Float = 0)
    case colorControl(saturation: Float = 1, brightness: Float = 0, contrast: Float = 1)
    
    
    /// An array of all MFKFilters available
    public static var all: [MFKFilter] {
        return [
            .chrome,
            .fade,
            .instant,
            .mono,
            .noir,
            .process,
            .tonal,
            .transfer,
            .sepia,
            .vignette(),
            .colorControl()
        ]
    }
    
    /// Human readable name of filter
    public var id: String { raw.name }
    
    /// Name of CIFilter
    public var raw: CIFilter {
        switch self {
        case .chrome: return CIFilter(name: "CIPhotoEffectChrome")!
            case .fade: return CIFilter(name: "CIPhotoEffectFade")!
            case .instant: return CIFilter(name: "CIPhotoEffectInstant")!
            case .mono: return CIFilter(name: "CIPhotoEffectMono")!
            case .noir: return CIFilter(name: "CIPhotoEffectNoir")!
            case .process: return CIFilter(name: "CIPhotoEffectProcess")!
            case .tonal: return CIFilter(name: "CIPhotoEffectTonal")!
            case .transfer: return CIFilter(name: "CIPhotoEffectTransfer")!
            case .sepia: return CIFilter(name: "CISepiaTone")!
            case .vignette(let radius, let intensity):
                let filter = CIFilter(name: "CIVignette")!
                filter.setValue(round(radius), forKey: "radius")
                filter.setValue(round(intensity), forKey: "intensity")
                return filter
            case .colorControl(let saturation, let brightness, let contrast):
                let filter = CIFilter(name: "CIColorControls")!
                filter.setValue(round(contrast * 10) / 10, forKey: "inputContrast")
                filter.setValue(brightness, forKey:"inputBrightness")
                filter.setValue(round(saturation * 10) / 10, forKey:"inputSaturation")
                return filter
        }
    }
    
    
    /// Human readable name of filter
    public var displayName: String {
        switch self {
            case .chrome: return "Chrome"
            case .fade: return "Fade"
            case .instant: return "Instant"
            case .mono: return "Monochrome"
            case .noir: return "Noir"
            case .process: return "Process"
            case .tonal: return "Tonal"
            case .transfer: return "Transfer"
            case .sepia: return "Sepia"
            case .vignette: return "Vignette"
            case .colorControl: return "Color Controls"
        }
    }
    
}
