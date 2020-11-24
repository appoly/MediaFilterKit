//
//  MFKImage.swift
//  MediaFilterKit
//
//  Created by James Wolfe on 22/11/2020.
//



import Foundation
import UIKit



/// Audiovisual asset that can have filters applied to it using media filter kit
public class MFKImage: UIImage {
    
    // MARK: - Variables
    
    private let dispatch = DispatchQueue.global(qos: .userInteractive)
    private let queue = OperationQueue()
    
    
    
    // MARK: - Intializers
    
    public convenience init?(uiImage: UIImage) {
        guard let data = uiImage.pngData() else { return nil }
        self.init(data: data)
        queue.maxConcurrentOperationCount = 1
    }
    
    
    
    // MARK: - Utilities
    
    /// Asyncronously applies filters to an Image
    /// - Parameters:
    ///   - filters: Filters to be applied to the video
    ///   - completion: Code to be ran upon completion of the image filtering
    public func applying(filters: [MFKFilter], completion: @escaping (MFKImage?) -> Void) {
        queue.cancelAllOperations()
        queue.addOperation(getApplyFiltersOperation(for: filters, completion: completion))
    }
    
    
    private func getApplyFiltersOperation(for filters: [MFKFilter], completion: @escaping (MFKImage?) -> Void) -> Operation {
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak self] in
            self?.dispatch.async { [weak self] in
                if var image = self {
                    for filter in filters.map({ $0.raw }) {
                        if(operation.isCancelled) {
                            completion(nil); return
                        }
                        let ciInput = CIImage(image: image)
                        filter.setValue(ciInput, forKey: "inputImage")
                        
                        guard let ciOutput = filter.outputImage else {
                            completion(nil); return
                        }
                        let ciContext = CIContext()
                        let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent)
                        
                        image = MFKImage(cgImage: cgImage!)
                    }
                    
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            }
        }
        return operation
    }
    
}
