//
//  MFKAsset.swift
//  MediaFilterKit
//
//  Created by James Wolfe on 19/11/2020.
//



import Foundation
import AVKit
import UIKit



/// Export quality of an AVAsset
public enum AssetExportQuality: String {
    
    case preset640x480
    case preset960x540
    case preset1280x720
    case preset3840x2160
    case presetPassthrough
    case presetLowQuality
    case presetMediumQuality
    case presetHighestQuality
    case presetAppleM4A
    
    public var raw: String {
        switch self {
        case .preset640x480: return AVAssetExportPreset640x480
        case .preset960x540: return AVAssetExportPreset960x540
        case .preset1280x720: return AVAssetExportPreset1280x720
        case .preset3840x2160: return AVAssetExportPreset3840x2160
        case .presetPassthrough: return AVAssetExportPresetPassthrough
        case .presetLowQuality: return AVAssetExportPresetLowQuality
        case .presetMediumQuality: return AVAssetExportPresetMediumQuality
        case .presetHighestQuality: return AVAssetExportPresetHighestQuality
        case .presetAppleM4A: return AVAssetExportPresetAppleM4A
        }
    }
    
}



/// Audiovisual asset that can have filters applied to it using media filter kit
public class MFKAsset {
    
    // MARK: - Variables
    
    private let asset: AVAsset
    
    /// Placeholder representation of the video - contains first frame of the video
    public var placeholder: MFKImage?  {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let image = try? MFKImage(cgImage: generator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
        return image
    }
    
    
    
    // MARK: - Initializers
    
    public init(url: URL) {
        asset = AVAsset(url: url)
    }
    
    
    public init(asset: AVAsset) {
        self.asset = asset
    }
    
    
    
    // MARK: - Utilities
    
    private func getTempDirectory() -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        return URL(fileURLWithPath: "\(path)/\(UUID().uuidString).mov")
    }
    
    
    
    // MARK: - Actions
    
    /// Asyncronously applies filters to a video
    /// - Parameters:
    ///   - filters: Filters to be applied to the video
    ///   - quality: Requested export quality of the video
    ///   - completion: Code to be ran upon completion of the video filtering
    public func applying(filters: [MFKFilter], with quality: AssetExportQuality? = .presetHighestQuality, completion: @escaping (AVAsset?) -> Void) {
        guard filters.count > 0 else { completion(asset); return }
        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            var image: CIImage?
            for filter in filters {
                let filter = filter.raw
                image = image != nil ? image : request.sourceImage.clampedToExtent()
                filter.setValue(image, forKey: kCIInputImageKey)
                if let output = filter.outputImage?.cropped(to: request.sourceImage.extent) {
                    image = output
                }
            }
            
            request.finish(with: image!, context: nil)
        })
        
        guard let quality = quality, let export = AVAssetExportSession(asset: asset, presetName: quality.raw) else { completion(nil); return }
        export.outputFileType = AVFileType.mov
        export.outputURL = getTempDirectory()
        export.videoComposition = composition

        export.exportAsynchronously {
            guard let url = export.outputURL else { completion(nil); return }
            completion(AVAsset(url: url))
        }
    }
    
}
