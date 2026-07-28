//
//  URL+ImageAssets.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//

import UIKit

/// Retrieves (or creates should it be necessary) a temporary image's local URL on cache directory for testing purposes
/// - Parameter named: image name retrieved from asset catalog
/// - Parameter extension: Image type. Defaults to `.jpg` kind
/// - Returns: Resulting URL for named image
///
extension URL {
    static func convertAssetImage(named name: String,
                                  extension: String = "jpg") -> URL? {
        let fileManager = FileManager.default
        
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let url = cacheDirectory.appendingPathComponent("\(name).\(`extension`)")
        
        guard !fileManager.fileExists(atPath: url.path) else {
            return url
        }
        
        guard let image = UIImage(named: name),
              let data = image.jpegData(compressionQuality: 1) else {
            return nil
        }
        
        fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
        return url
    }
}

