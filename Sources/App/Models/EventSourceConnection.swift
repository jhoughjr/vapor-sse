//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/15/23.
//

import Foundation

struct EventSourceConnectionRequest:Codable {
    let url:URL
    let authToken:String?
}
