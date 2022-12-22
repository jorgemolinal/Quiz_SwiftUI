//  ScoreModel.swift
//  Quiz
//
//  Created by Jorge Molina on 21/11/22.
//  Voy a escribir aquí los puntos que voy haciendo: 1,2,3,4...
import Foundation

class ScoresModel: ObservableObject{
    
    @Published private(set) var acertadasNoRepetidas : Set<Int>=[]
    //Private: Es privado para los de fuera, no pueden verla
    //Private(set): Sólo es privado el set, pero desde fuera puedo ver por ejemplo el count
    @Published private(set) var recordAcertadas : Set<Int>=[]
    
    private let defaults = UserDefaults.standard //Proporciona una instancia compartida y le doy el nombre defaults para poder llamarla. Lo q guardas está relacionado con una clave.
    
    init(){ //Con defaults.objetct descargo el objeto de la instancia compartida que se corresponda con la clave forKey. Tb hay integer y bool
        if let recordCompartido = defaults.object(forKey: "record") as? [Int] {
            recordAcertadas = Set(recordCompartido)
        }
    }
    func comprobar(answer: String, quizItem:QuizItem){
        //Si la respuesta está bien me la añade al conjunto acertadasNoRepetidas
        if (answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)){
            //Al ser un Set no se añaden repetidas.
            acertadasNoRepetidas.insert(quizItem.id)
            recordAcertadas.insert(quizItem.id)
            
            //Con set guardo recordAcertadas en la instancia compartida bajo la clave "record".
            defaults.set(Array(recordAcertadas), forKey: "record")
            defaults.synchronize()
        } 
    }
    
    func cleanAcertadas(){
        acertadasNoRepetidas = []
    }
    func cleanRecord(){
        recordAcertadas = []
        defaults.set(Array(recordAcertadas), forKey: "record")
        defaults.synchronize()
    }
    
}
