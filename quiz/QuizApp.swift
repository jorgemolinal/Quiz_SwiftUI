//
//  QuizApp.swift
//  Quiz
//
//  Created by Jorge Molina on 17/11/22.
//

import SwiftUI

@main //Pto de entrada donde comienza la ejecucion de la app
struct QuizApp: App {
    //Creo una propiedad aqui (en el programa principal). Con @StateObject creo una variable de estado de un objeto que no es tipo valor. Ahora puedo usar el objeto en todas las vistas que hay por abajo.
    @StateObject var quizzesModel:QuizzesModel = QuizzesModel()
    @StateObject var scoresModel:ScoresModel = ScoresModel()
                //variable NOMBRE: TIPO = VALOR CON EL QUE INICIALIZO.
    
    var body: some Scene {
        WindowGroup { //tipo de Scene, gestiona la ventana donde se pintan las views
            QuizzesView()
                .environmentObject(quizzesModel)
                .environmentObject(scoresModel)
                //con esto, meto la variable en el entorno y ya está disponible para esta vista y las que van por debajo de esta.
        }
    }
}
