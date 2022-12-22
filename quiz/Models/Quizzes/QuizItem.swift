//
//  QuizItem.swift
//  Quiz con SwiftUI
//
//  Created by Santiago Pavón Gómez on 18/10/22.
//

import Foundation
//creo una estructura que me ayuda a interpretar/traducir a swift lo que hay en el json descargado de internet.
//Codable: Capaz de codificar y decodificar. Si en un sitio tengo estos datos los interpreta
struct QuizItem: Codable, Identifiable {
    //Aqui meto todo lo que vemos en cada quiz del json quizzes.
    let id: Int //Cada quiz tiene un id del tipo int
    let question: String    //Cada quiz tiene una question
    let answer: String //Cada quiz tiene una respuesta
    let author: Author? //La ? pq puede que tenga author o no. Algunos tienen y otros no.
    let attachment: Attachment?
    var favourite: Bool
    
    struct Author: Codable {
        let isAdmin: Bool?
        let username: String?
        let photo: Attachment?
        let accountTypeId: Int? //Esto como no lo uso nunca podría no ponerlo.
        let profileId: Decimal? //Num entero (Int) muy gordo.
        let profileName: String?
    }
    
    struct Attachment: Codable {
        let filename: String?
        let mime: String?
        let url: URL? //todos tienen ? pq hay veces que existe el objeto (attachment) pero vacio
    }
} //Con esto ya es capaz de leer una lista con estas caracteristicas, etc
