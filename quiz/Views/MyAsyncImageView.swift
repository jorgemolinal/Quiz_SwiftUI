//
//  MyAsyncImageView.swift
//  Quiz
//
//  Created by Jorge Molina on 19/11/22.
// Me creo esto para llamar a esta vista cada vez que pongo una foto, pra no escribir todo el troncho mil veces

import SwiftUI

struct MyAsyncImageView: View {
    
    var urlQueQuieroPintar: URL?
    var body: some View {
        AsyncImage(url: urlQueQuieroPintar) { phase in
            if urlQueQuieroPintar == nil{ //Si no existe foto
                Image("noImage").resizable() //Imagen predeterminada
            } else if let image = phase.image{ //Si hay foto: pues la pongo
                image.resizable()
            } else if phase.error != nil { //Me la he pegao al descargar el URL de la imagen (Si hay foto o hay error): Lo pongo rojo
                Image("errorImage").resizable()
            } else{ProgressView()} //Placeholder (lo q sale mientras se descarga)
        }
    }
}

struct MyAsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        MyAsyncImageView()
    }
}
