//
//  BackgroundRemoval.swift
//  OutfitGenerator
//
//  Created by Jason on 12/30/22.
//

import Foundation
import Keys

struct BackgroundRemoval {
    
    // Completion handler that returns the segmented image.
    typealias RemovalCallback = (NSData?) -> Void

    func removeBackground(for image: UIImage, onCompletion: @escaping RemovalCallback) {
        let outfitGeneratorKeys = OutfitGeneratorKeys()
        
        let url = "https://background-removal4.p.rapidapi.com/v1/results"
        
        let headers = [
            "X-RapidAPI-Key": outfitGeneratorKeys.rapidAPIKey
        ] as NSMutableDictionary

        var imageAsData = NSData()

        var httpBody: Data

        let boundary = (UUID().uuidString)
        
        // Creates a multipart form to upload the image.
        let mutableData = NSMutableData()
        mutableData.appendString("--\(boundary)\r\n")
        mutableData.appendString("Content-Disposition: form-data; name=\"image\"\r\n\r\n")
        let imageData = image.pngData()!
        mutableData.append(imageData)
        mutableData.appendString("\r\n")
        mutableData.appendString("--\(boundary)--")
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        httpBody = mutableData as Data
        
        // Prepares the request.
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String: String]
        request.httpBody = httpBody
        
        // Sends request to API to remove image background.
        let session = URLSession.shared
        let dataTask = session.dataTask(
            with: request,
            completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                do {
                    // Parses the response data as JSON.
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                    let result = (json["results"] as! [[String: Any]])[0]
                    
                    let status = result["status"] as! [String: String]
                    if status["code"] == "ok" {
                        let entity = (result["entities"] as! [[String: Any]])[0]
                        let imageAsBase64 = entity["image"] as! String
                        imageAsData = NSData(base64Encoded: imageAsBase64)!
                        
                        onCompletion(imageAsData)
                    }
                } catch {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
}

// MARK: - NSMutableData methods

extension NSMutableData {

  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
