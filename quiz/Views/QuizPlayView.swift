//
//  QuizPlayView.swift
//  Quiz
//
//  Created by Jorge Molina on 21/11/22.
//

import SwiftUI

struct QuizPlayView: View {
    var quizItem:QuizItem //Esta se la paso al llamar a la vista
    
    @State var answer:String = "" //Aqui voy a guardar la respuesta que le meto al input (TextField)
    @State var showAlertaComprobar:Bool = false
    
    @State var r = 0.0 //Para hacer la rotación en el double tap
    
    //Asi saco el scoreModel de donde lo he metido. Quiero una prop llamada scoresModel y su valor me lo saca del entorno
    @EnvironmentObject var scoresModel:ScoresModel
    @EnvironmentObject var quizzesModel:QuizzesModel
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack {
            HStack{
                titulo
                //Favorito
                Button {
                    quizzesModel.toggleFav(quizItemId:quizItem.id)
                } label: {
                    if(quizItem.favourite){
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                    }
                }

            }
            if verticalSizeClass == .compact{
                HStack{
                    attachment
                    VStack{
                        respuesta
                        footer
                    }
                }// No se muy bien pq pero esto lo hace cuando esta horizontal
            } else {
                respuesta
                attachment
                footer
            }
        }
        .navigationTitle("Playing")
        .navigationBarTitleDisplayMode(.inline)
    }
    private var respuesta: some View{
        VStack{
            //TextField(titulo de acceso, valor que modifico)
            TextField("Meta su respuesta", text: $answer)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)//Solo mete el espacio a los lados
                .onSubmit { //Para q funcione al hacer enter
                    showAlertaComprobar=true
                    if (answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)){
                            scoresModel.comprobar(answer: answer, quizItem: quizItem)
                    }
                }
                
            Button("Comprobar"){
                showAlertaComprobar=true
                if (answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)){
                        scoresModel.comprobar(answer: answer, quizItem: quizItem)
                    
                }
            }
            //Cuando showAlertaComprobar sea true se mostrará lo q pone en esta alerta
            .alert(isPresented: $showAlertaComprobar){
                Alert(title: Text("Resultado"),
                      message: Text(answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == quizItem.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ? "Respuesta correcta":"Respuesta incorrecta"),
                      dismissButton: .default(Text("ok"))
                )
            }
        }
    }
    
    private var titulo: some View{
        Text(quizItem.question)
            .fontWeight(.heavy)
            .font(.largeTitle)
    }
    
    //Foto del quiz
    private var attachment: some View{
        GeometryReader{geom in //Pasa la geometria del padre
            MyAsyncImageView(urlQueQuieroPintar: quizItem.attachment?.url)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.black, lineWidth: 3))
                .shadow(radius: 14)
                .frame(width: geom.size.width, height: geom.size.height) //Esto tiene la dimensiones del padre
            //RESPUESTA CORRECTA DOUBLE TAP (count: 2) //Otros: onLongPressGesture
                .rotationEffect(Angle(degrees: r))
                .onTapGesture(count: 2) { //ahora sentencias
                    withAnimation(.easeInOut(duration: 2)) {
                        answer = quizItem.answer //Respuesta correcta en &answer (textField)
                        r = r + 360 //Rotación
                       } }
        }.padding()
    }
    private var footer: some View{
        HStack{
            Text("Puntos = \(scoresModel.acertadasNoRepetidas.count)")
                .foregroundColor(.black)
                .fontWeight(.thin)
                .bold()
            Button("reset puntuación"){scoresModel.cleanAcertadas()}
                .foregroundColor(Color.red) //Color texto
                .frame(height: 1)
                .fontWeight(.thin)
            Spacer()
            //Nombre author
            Text(quizItem.author?.username ?? "Anónimo")
                .font(.callout)
                .fontWeight(.thin)
            
            //Foto author
            MyAsyncImageView(urlQueQuieroPintar: quizItem.author?.photo?.url)
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .shadow(radius: 4)
                .clipShape(Circle())
                .scaledToFill() //Si es peq hago zoom para q se rellene toda la superficie
                .contextMenu{
                    Button("Borrar respuesta"){answer=""}
                    Button("Mostrar respuesta"){answer=quizItem.answer}
                }
        }.padding(.horizontal)
    }
}


struct QuizPlayView_Previews: PreviewProvider {
    //Creo el model. El model es como un "array" con muchos quizzes dentro de él: quizModel.quizzes[el q sea]
    static var quizModelEjemplo: QuizzesModel = {
        var qm = QuizzesModel() //Creo un modelo vacío
        qm.load() //Cargo el fichero
        return qm
    }()
    //Cojo un par de quizzes del modelo para pintarlos
    static var previews: some View {
        VStack {
            QuizPlayView(quizItem: quizModelEjemplo.quizzes[0])
        }
    }
}
