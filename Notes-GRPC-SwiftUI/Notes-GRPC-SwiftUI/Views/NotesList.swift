//
//  NoteList.swift
//  Notes-GRPC-SwiftUI
//
//  Created by Fernanda  de Lima on 31/05/21.
//

import SwiftUI

struct NotesList: View {
    @State private var showAlert = false
    @State var notes = [Note]()
    
    let dataRepository = DataRepository.shared
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes, id: \.self) { note in
                    NoteRow(note: note)
                }
                .onDelete(perform: delete(at:))
            }
            .onAppear() {
                dataRepository.listNotes { (notes, error) in
                    if let notes = notes {
                        self.notes = notes
                    }
                }
            }
            .navigationTitle("Notes gRPC")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CreateNote()) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            })
        }
    }
    
    func delete(at offsets: IndexSet) {
        print("offsets \(offsets.first!)")
        if let index = offsets.first {
            let note = notes[index]
            dataRepository.delete(noteId: note.id) { (isDeleted) in
                if isDeleted {
                    notes.remove(at: index)
                }
            }
        }
        
    }
}

struct NotesList_Previews: PreviewProvider {
    static var previews: some View {
        NotesList()
    }
}
