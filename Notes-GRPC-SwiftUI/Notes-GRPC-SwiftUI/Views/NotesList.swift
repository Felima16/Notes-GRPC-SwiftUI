//
//  NoteList.swift
//  Notes-GRPC-SwiftUI
//
//  Created by Fernanda  de Lima on 31/05/21.
//

import SwiftUI

struct NotesList: View {
    @State private var selectedShow: TVShow?
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
                        if notes.count > 0 {
                            self.notes = notes
                        } else {
                            selectedShow = TVShow(
                                name: "Aviso",
                                mensagem: "Não tem nenhuma nota cadastrada")
                        }
                    }
                    if let error = error {
                        selectedShow = TVShow(
                            name: "Erro",
                            mensagem: error.localizedDescription)
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
        .alert(item: $selectedShow) { show in
            Alert(title: Text(show.name),
                  message: Text(show.mensagem),
                  dismissButton: .cancel())
        }
    }
    
    func delete(at offsets: IndexSet) {
        print("offsets \(offsets.first!)")
        if let index = offsets.first {
            let note = notes[index]
            dataRepository.delete(noteId: note.id) { (isDeleted) in
                if isDeleted {
                    notes.remove(at: index)
                } else {
                    selectedShow = TVShow(name: "Erro",
                                          mensagem: "Não foi possivel remover a nota")
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

struct TVShow: Identifiable {
    var id: String { name }
    let name: String
    let mensagem: String
}
