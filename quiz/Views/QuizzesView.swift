//
//  QuizzesView.swift
//  Quiz
//
//  Created by Jorge Molina on 17/11/22.
//

import SwiftUI

//Es ContentView pero le cambio el nombre pq esta feo
struct QuizzesView: View {
    //Quiero sacar la variable del entorno
    @EnvironmentObject var quizzesModel:QuizzesModel
    @EnvironmentObject var scoresModel:ScoresModel
    
    @State var verAcertados: Bool = false //Toggle acertados
    @State var verFavoritos: Bool = false //Toggle favoritos
    
    var body: some View {
        NavigationStack{
            //Para hacer una lista puedo utilizar o List o ForEach(recorre un modelo), los 2 explicados en diapositivisas tema 6 iOS
            VStack{
                HStack{
                    Text("Record: \(scoresModel.recordAcertadas.count)")
                    Button("reset"){scoresModel.cleanRecord()}
                    //.foregroundColor(Color.red) //Color texto
                        .backgroundStyle(.clear)
                        .frame(height: 1)
                        .fontWeight(.thin)
                    Spacer()
                    Button("10 nuevos quizzes"){quizzesModel.nuevosQuizzes()}
                        .fontWeight(.thin)
                        .frame(height: 10)
                }.padding(10) //10 de separacion alrededor de él y para separarlo del borde
            }
            List{
                Toggle("Ver acertados", isOn: $verAcertados) //Botón acertados
                Toggle("Ver favoritos", isOn: $verFavoritos) //Botón acertados
                //Recorro la propiedad quizzes dentro de quizzesModel, esto son un monton de contenidos.
                ForEach(quizzesModel.quizzes){ quizItem in //A partir de aqui ya va viendo todo 1 a 1
                    //Si verAcertados es false (veo todos) ó Si el quiz lo he acertado lo muestro siempre.
                    if !verAcertados || scoresModel.acertadasNoRepetidas.contains(quizItem.id) {
                        //Cada fila quiero que sea un enlace (NavigationLink{destino}label:{boton}
                        if !verFavoritos || quizItem.favourite{
                            NavigationLink{
                                QuizPlayView(quizItem: quizItem)
                            } label:{   //Cada boton es una fila entera
                                QuizRowView(quizItem: quizItem) //Vista(nombre variable: valor que le paso)
                            }
                        }
                    }
                }
            }
            .navigationTitle("P4 Quizzes")
            .navigationBarItems(leading: Text("Record= \(scoresModel.recordAcertadas.count)"), trailing:  Button("Borrar Favs"){quizzesModel.cleanFavourites()}) //Otra opción
       //P1     .onAppear{quizzesModel.load()}//onAppear hace lo q digas cuando carge eso. Por ejemplo aqui al cargar lista pues hace el método load
            .onAppear{
                if quizzesModel.quizzes.count == 0 { //Si no existe el array de quizzes (es decir, no lo he descargado todavía) pues descargalo.
                    quizzesModel.download_data()
                }
            }
            .listStyle(.plain)
            .refreshable{ quizzesModel.nuevosQuizzes()} //Cuando refrescas hace {esto}
            //.toolbar{
              //  ToolbarItemGroup{
                //    VStack{
                  //      Button("actualizar"){quizzesModel.nuevosQuizzes()}
                    //        .fontWeight(.ultraLight)
                    //}
               // }
            //}
        }
    }
}
    
struct QuizzesView_Previews: PreviewProvider {
    static var quizModelEjemplo: QuizzesModel = {
        var qm = QuizzesModel() //Creo un modelo vacío
        qm.load() //Cargo el fichero
        return qm
    }()
    static var previews: some View {
        QuizzesView()
        //Quiero meter en el entorno el objeto que he creado
            .environmentObject(quizModelEjemplo)
    }
}
