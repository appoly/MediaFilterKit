//
//  MFKImageView.swift
//  MediaFilterKit
//
//  Created by James Wolfe on 21/11/2020.
//



import Foundation
import UIKit



/// An imageview that can have filters applied to it using media filter kit
public class FKImageView: UIView {
    
    // MARK: - Variables
    
    private let dispatch = DispatchQueue.global(qos: .userInteractive)
    private let queue = OperationQueue()
    private var imageView: UIImageView
    private var initialized: Bool = false
    
    /// Filters applied to image displayed
    public var filters: [MFKFilter] {
        didSet {
            guard initialized else { return }
            apply(filters: filters, to: image, with: contentMode)
        }
    }
    
    /// Image displayed
    public var image: UIImage {
        didSet {
            guard initialized else { return }
            apply(filters: filters, to: image, with: contentMode)
        }
    }
    
    
    
    // MARK: - Initializers
    
    public init(frame: CGRect, image: UIImage, contentMode: UIImageView.ContentMode, filters: [MFKFilter]? = nil) {
        self.imageView = UIImageView(image: image)
        self.image = image
        self.filters = filters ?? []
        super.init(frame: frame)
        self.initialized = true
        self.apply(filters: filters ?? [], to: image, with: contentMode)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - View Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        queue.maxConcurrentOperationCount = 1
        imageView.frame = frame
        addSubview(imageView)
    }
    
    
    
    // MARK: - Utilities
    
    private func apply(filters: [MFKFilter], to image: UIImage, with contentMode: UIImageView.ContentMode) {
        self.imageView.contentMode = contentMode
        
        queue.cancelAllOperations()
        queue.addOperation(getApplyFiltersOperation(for: image, and: filters))
    }
    
    
    private func getApplyFiltersOperation(for image: UIImage, and filters: [MFKFilter]) -> Operation {
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak operation, weak self] in
            if let self = self {
                var image = image
                for filter in filters.map({ $0.raw }) {
                    if(operation?.isCancelled ?? true) { return }
                    let ciInput = CIImage(image: image)
                    filter.setValue(ciInput, forKey: "inputImage")
                    
                    guard let ciOutput = filter.outputImage else { return }
                    let ciContext = CIContext()
                    let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent)
                    
                    image = UIImage(cgImage: cgImage!)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        }
        
        return operation
    }
    
}
