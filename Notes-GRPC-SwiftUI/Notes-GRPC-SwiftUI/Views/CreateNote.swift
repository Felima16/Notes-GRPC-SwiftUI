//
//  CreateNoteAlert.swift
//  Notes-GRPC-SwiftUI
//
//  Created by Fernanda  de Lima on 31/05/21.
//

import SwiftUI

struct CreateNote: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedShow: TVShow?
    @Environment(\.presentationMode) var presentationMode
    
    let dataRepository = DataRepository.shared
    
    var body: some View {
        Spacer()
        
        VStack {
            Spacer()
            
            TextField("Titulo", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Spacer()
            
            TextField("Conteudo", text: $content)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Spacer()
            Divider()
            
            Button(action: {
                insertNote()
            }) {
                Text("Adicionar")
            }
            
            Divider()
            Spacer(minLength: 500)
            
        }
        .background(Color(white: 0.9))
        .navigationTitle("Criar uma nova Nota")
        .alert(item: $selectedShow) { show in
            Alert(title: Text(show.name),
                  message: Text(show.mensagem),
                  dismissButton: .cancel())
        }
    }
    
    func insertNote() {
        let note = Note(title: title, content: content)
        dataRepository.insertNote(note: note) { (note, error) in
            guard note != nil else {
                selectedShow = TVShow(name: "Erro",
                                      mensagem: error?.localizedDescription ?? "")
                return
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CreateNote_Previews: PreviewProvider {
    static var previews: some View {
        CreateNote()
    }
}
