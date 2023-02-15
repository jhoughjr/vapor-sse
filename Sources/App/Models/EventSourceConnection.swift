//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/15/23.
//

import Foundation

struct EventSourceConnectionRequest:Codable {
    let eventSourceURL:URL
    let authToken:String?
}

struct EventSourceAddListenerRequest:Codable {
    let eventSourceURL:URL
    let authToken:String?
    let add:[String]
}

struct EventSourceRemoveListenerRequest:Codable {
    let eventSourceURL:URL
    let authToken:String?
    let remove:[String]
}

