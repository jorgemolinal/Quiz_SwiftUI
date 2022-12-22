//
//  QuizzesModel.swift
//  Quiz con SwiftUI
//
//  Created by Santiago Pavón Gómez on 18/10/22 and Jorge Molina Lafuente on 15/11/22.
//  Tengo un modelo q tiene un array de quizzes

import Foundation

class QuizzesModel: ObservableObject {  //Clase de Swift que hace que la gente que se suscriba pueda ver lo que ha modificado otro. Entonces derivo de esta clase
    
    //private pq fuera de este fichero no se van a usar
    private let urlBase = "https://core.dit.upm.es"
    private let quizzesPath = "/api/quizzes/random10wa?token"
    private let TOKEN = "b181213f489ad8b25f36"
    private let favPath="/api/users/tokenOwner/favourites/"
    
    // Los datos
    @Published private(set) var quizzes = [QuizItem]()
    //array vacio de quiz items. @Published para que cuando cambie esta propiedad se entere la gente que está mirando (es decir, para que se actualice).
     
    
    
    //Método que carga/lee el fichero json (Models>Quizzes>quizzes.json de la p1)
    func load() {
        if quizzes.count != 0 { return } //Si ya lo he descargado 1 vez, no vuelvas a descargarlo otra vez más. Pa eso sirve
                //Bundle es un saco de ficheros. Bundle.main es un saco de ficheros que hay en mi aplicación. Pues pido Bandle.main que se llama quizzes y que tiene extensión json. Es decir, dame la url de este fichero. Puede q lo haya o no
        guard let jsonURL = Bundle.main.url(forResource: "quizzes", withExtension: "json")
            else { //Si no lo hay dame un error
            print("Internal error: No encuentro quizzes.json")
            return
        }
        
        do {    //do...catch es el try...catch de otro lenguaje
            let data = try Data(contentsOf: jsonURL) //una cosa llena de bites (un buffer)
            let decoder = JSONDecoder() //Convierte el buffer en un JSON

//            ----LINEAS DE DEPURACION para ver q tiene este fichero ------
//            if let str = String(data: data, encoding: String.Encoding.utf8) {
//                print("Quizzes ==>", str)
//            }
                            //Decodificame como un array de quizzes
            let quizzes = try decoder.decode([QuizItem].self, from: data)
                                                //.self = del mismo tipo
            
            self.quizzes = quizzes //Cambia el array quizzes que tiene @Published asi que se pinta y actualiza solo.

            print("Quizzes cargados")
        } catch {
            print("Algo chungo ha pasado: \(error)")
        }
    }
    
    
    
    //Método que descarga el fichero json de la url
    func download_data() {
        //El url que voy a utilizar para descargar los quizzes
        let urlDescargar = "\(urlBase)\(quizzesPath)=\(TOKEN)"
        //Quiero construir un url a partir de un string. el guard es como decir guardate de que es una URL. Es decir, si lo que le metes no es una URL no continua (m sale internal err...)
        guard let url = URL(string: urlDescargar)
            else { //Si no lo hay dame un error
            print("Internal error: formato URL incorrecto")
            return
        }
        print("Iniciando descarga: \(url)")
    
        //Se hace en un thread aparte, en una cola cualquiera (la global) con prioeidad 0 (pq no pone nada). De esta forma hago que sea fluido y que no se quede pillada la app. Mientras no se descargan las cosas puedo swguir moviendome.
        DispatchQueue.global().async {
            
            do {    //do...catch es el try...catch de otro lenguaje
                let data = try Data(contentsOf: url) //baja lo q hay en la url, que es una cosa llena de bites (un buffer)
                let decoder = JSONDecoder() //Convierte el buffer en un JSON

                        //Decodificame como un array de quizzes y guardalo en esta variable (let)
                let quizzes = try decoder.decode([QuizItem].self, from: data)
                                                    //.self = del mismo tipo
                //self.quizzes = quizzes --> No puedo tocar algo del usuario desde un thread
                DispatchQueue.main.async {
                    self.quizzes = quizzes //Lo toco desde el thread y lo mando a main (principal)
                    print("Quizzes cargados")
                }
            } catch {
                print("Algo chungo ha pasado: \(error)")
            }
        }//Las llaves del DispatchQueue
    }//Las llaves del download_data
    
    
    func endpointFav(quizId: Int)-> URL? {
        let urlServer = "\(urlBase)\(favPath)\(quizId)?token=\(TOKEN)"
        guard let url = URL(string: urlServer)
        else { //Si no lo hay dame un error
            print("Internal error: formato URL incorrecto")
            return nil
        }
        return url
    } //Devuelve la url
    
    //Otra opcion, que sea async
    func toggleFav(quizItemId: Int){
        //Busco en el array para cambiarle el Bool de favourite
        guard let posicion = (quizzes.firstIndex {qi in qi.id == quizItemId}) else { //Me devuelve en que posición se encuentra ese quiz en el array y lo asigna a la variable
            print("No encontrado en el array")
            return
        }

        //Cambio en el server el valor de favourite del quiz con ese id
        //PUT & DELETE peticiones : Poner favorito (PUT) y quitarlo (DELETE)
        guard let url = endpointFav(quizId: quizItemId) else { return }
        
        var request = URLRequest(url: url) //Request = petición
        request.httpMethod = quizzes[posicion].favourite ? "DELETE" : "PUT"
                                                        //Data()--> Es un data vacío.
        URLSession.shared.uploadTask(with: request, from: Data()){ _, response, error in
         //Si la funcion fuera async, aqui cambio await URLSession...
            guard error == nil, //Me aseguro de q el error es nulo
                let response = response as? HTTPURLResponse, //Guardo la respuesta
                response.statusCode == 200 else {  //Y que la respuesta sea 200
                    print ("Error FAV 1") //Si no pues saco este mensaje
                    return
            }
            DispatchQueue.main.async {
                //linea que cambia en el array (en los q ya tengo cambio el valor de favourite)
                self.quizzes[posicion].favourite.toggle()
            }
        }.resume() //pq es una tarea (task) y hay q arrancarla
    }
    func nuevosQuizzes(){
        quizzes = []
        download_data()
    }
    func cleanFavourites(){
        //ya lo haré.
    }
    
}
//@Published: cada vez que cambia algo lo publica
//por ejemplo publico la variable quizzes
//Con .onReceive(quizzesModel.$quizzes){hace algo cuando se publique algo de quizzes}

//Combine: entra en test, pero no en desarrollar ejs largos. Por ejemplo: te pone un código y te
//dice por qué falla no se qué. Cositas así.

//URLSession tb tiene publicadores (shared.dataTaskPublisher(for: url))
