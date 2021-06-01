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
    
    func listNotes(completion: @escaping([Note]?, Error?) -> Void) {
        do {
            let list = client.list(Empty())
            list.response.whenSuccess { (notes) in
                DispatchQueue.main.async {
                    completion(notes.notes, nil)
                }
            }
            
            list.response.whenFailure { (error) in
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            let detailsStatus = try list.status.wait()
            print("Staus:::\(detailsStatus) \n \(detailsStatus.code)")
        } catch {
            print("Error for get Request:\(error)")
        }
    }
    
    func insertNote(note: Note, completion: @escaping(Note?, Error?) -> Void) {
        do {
            let insert = client.insert(note)
            
            insert.response.whenSuccess { (note) in
                DispatchQueue.main.async {
                    completion(note, nil)
                }
            }
            
            insert.response.whenFailure { (error) in
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            let detailsStatus = try insert.status.wait()
            print("Staus:::\(detailsStatus) \n \(detailsStatus.code)")
        } catch {
            print("Error for get Request:\(error)")
        }
    }
}

extension Note {
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
