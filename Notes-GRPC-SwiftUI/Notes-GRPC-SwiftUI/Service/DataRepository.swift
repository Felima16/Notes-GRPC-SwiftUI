//
//  DataRepository.swift
//  Notes-GRPC-SwiftUI
//
//  Created by Fernanda  de Lima on 31/05/21.
//

import Foundation
import GRPC
import NIO

class DataRepository {
    static let shared = DataRepository()
    
    let hostName = "127.0.0.1"
    let port = 50051
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    
    lazy var client: NoteServiceClient = {
        let channel = ClientConnection.insecure(group: group)
            .connect(host: hostName, port: port)
        let client = NoteServiceClient(channel: channel)
        return client
    }()
    
    private init() {}
    
    deinit {
        try? group.syncShutdownGracefully()
    }
    
    // MARK: - Handle functions
    
    func listNotes(completion: @escaping([Note]) -> Void) {
        do {
            let list = client.list(Empty())
            list.response.whenSuccess { (notes) in
                completion(notes.notes)
            }
            
            let detailsStatus = try list.status.wait()
            print("Staus:::\(detailsStatus) \n \(detailsStatus.code)")
        } catch {
            print("Error for get Request:\(error)")
        }
    }
}
