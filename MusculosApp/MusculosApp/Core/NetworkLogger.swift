//
//  NetworkLogger.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.06.2023.
//

import Foundation

public class NetworkLogger {
    public static func logRequest(_ request: URLRequest) {
        if let data = request.httpBody {
            print("ℹ️--- NetworkLogger: \(data.asDictionary) ---ℹ️")
        }
    }
    
    private func makeInfoEmojiString(_ text: String) -> String {
        return "ℹ️--- NetworkLogger: \(text) ---ℹ️"
    }
}
