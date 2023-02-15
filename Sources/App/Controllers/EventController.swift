//
//  EventController.swift
//  
//
//  Created by Jimmy Hough Jr on 2/15/23.
//

import Fluent
import Vapor
import EventSource

struct EventController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let events = routes.grouped("events")
        events.get(use: index)
        events.post(use: create)
    
    }

    func index(req: Request) async throws -> String {
        ""
    }

    func create(req: Request) async throws -> String {
       ""
    }

    func delete(req: Request) async throws -> HTTPStatus {
        return .noContent
    }
}
