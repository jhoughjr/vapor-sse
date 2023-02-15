//
//  EventController.swift
//  
//
//  Created by Jimmy Hough Jr on 2/15/23.
//

import Fluent
import Vapor
import EventSource

class EventController: RouteCollection {
    
    var eventSources:[String:EventSource] = [String:EventSource]()
    
    func boot(routes: RoutesBuilder) throws {
        let events = routes.grouped("events")
        events.get(use: index)
        events.post(use: create)
    }

    func index(req: Request) async throws -> String {
        var res = ""
        for es in eventSources {
            let events = es.value.events()
            res += "\(es.value.url) \(es.value.readyState) \(es.value.lastEventId)\n\(events)\n\n"
        }
        return res
    }

    func create(req: Request) async throws -> String {
        let conInfo = try req.content.decode(EventSourceConnectionRequest.self)
        if let sourceAddress = req.peerAddress?.ipAddress {
            let es = EventSource(url: conInfo.url)
                                 
            eventSources[sourceAddress] = es
            Task {
                req.logger.info("Registered \(es) for client \(sourceAddress)")
                es.onOpen {
                    req.application.logger.info("Opened \(es)")
                }
                
                es.onMessage { addr, name, value in
                    var s = "onMessage - "
                    s += addr ?? ""
                    s += ","
                    s += name ?? ""
                    s += ","
                    s += value ?? ""
                    req.application.logger.info("\(s)")
                }
                
                es.onComplete { n, b, e in
                    var s = "onComplete - "
                    s += n == nil ?  "" : "\(n!)"
                    s += ","
                    s += b == false ? "false" : "true"
                    s += ","
                    s += e?.localizedDescription ?? ""
                    req.application.logger.info("\(s)")
                }
                
                es.addEventListener("null") { id, event, data in
                    var s = "eventListener - "
                    s += id ?? ""
                    s += ","
                    s += event ?? ""
                    s += ","
                    s += data ?? ""
                    req.application.logger.info("\(s)")
                }
                
                es.addEventListener("user-connected") { id, event, data in
                    var s = "eventListener - "
                    s += id ?? ""
                    s += ","
                    s += event ?? ""
                    s += ","
                    s += data ?? ""
                    req.application.logger.info("\(s)")
                }
                es.connect()
                req.application.logger.info("Connecting to event source at \(sourceAddress)...")
            }
        }
        return "registered."
    }

    func delete(req: Request) async throws -> HTTPStatus {
        return .noContent
    }
}
