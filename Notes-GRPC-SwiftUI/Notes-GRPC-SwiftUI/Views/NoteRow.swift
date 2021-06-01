//
//  NoteView.swift
//  Notes-GRPC-SwiftUI
//
//  Created by Fernanda  de Lima on 31/05/21.
//

import SwiftUI
import GRPC

struct NoteRow: View {
    var note: Note
    
    var body: some View {
        VStack{
            Text(note.title)
                .font(.title)
                .fontWeight(.bold)
            Text(note.content)
                .font(.body)
        }
    }
}

struct NoteRow_Previews: PreviewProvider {
    static var previews: some View {
        NoteRow(note: Note())
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
