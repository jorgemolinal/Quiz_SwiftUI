//
//  QuizRowView.swift
//  Quiz
//
//  Created by Jorge Molina on 18/11/22.
//  Me pinta cada fila (cada quiz)

import SwiftUI

struct QuizRowView: View {
    
    var quizItem:QuizItem //Esta se la paso al llamar a la vista
    @EnvironmentObject var quizzesModel:QuizzesModel
    
    var body: some View{
        //Si en QuizItem el attachment?.url fuera tipo string tendriamos que convertirlo aqui en URL
        HStack {
            //Foto del quiz
            MyAsyncImageView(urlQueQuieroPintar: quizItem.attachment?.url)
                .frame(width: 80, height: 80)
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .shadow(radius: 7)
                .clipShape(Circle())
                .scaledToFill() //Si es peq hago zoom para q se rellene toda la superficie
            VStack {
                HStack{
                    Text(quizItem.question)
                        .fontWeight(/*@START_MENU_TOKEN@*/.light/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                HStack{
                    //Favorito
                    if(quizItem.favourite){
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                    }
                    //Image(qi.favourite ? "star_yellow" : "star_grey")
                    Spacer()
                    //Nombre author
                    Text(quizItem.author?.username ?? "Anónimo")
                        .font(.callout)
                        .fontWeight(.thin)
                    
                    //Foto author
                    MyAsyncImageView(urlQueQuieroPintar: quizItem.author?.photo?.url)
                        .frame(width: 30, height: 30)
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        .clipShape(Circle())
                        .scaledToFill() //Si es peq hago zoom para q se rellene toda la superficie
                }
                
            }
        }
    }
}

struct QuizRowView_Previews: PreviewProvider {
    //Creo el model. El model es como un "array" con muchos quizzes dentro de él: quizModel.quizzes[el q sea]
    static var quizModelEjemplo: QuizzesModel = {
        var qm = QuizzesModel() //Creo un modelo vacío
        qm.load() //Cargo el fichero
        return qm
    }()
    //Cojo un par de quizzes del modelo para pintarlos
    static var previews: some View {
        VStack {
            QuizRowView(quizItem: quizModelEjemplo.quizzes[0])
            QuizRowView(quizItem: quizModelEjemplo.quizzes[1])
        }
    }
}
