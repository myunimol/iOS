//
//  LoadSentences.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 05/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation

class LoadSentences {
    
    static let sentences: [String] =  [
        "L'equinozio? Un cavallo fannullone?",
        "Ma la lana di vetro si fa con le pecore di Murano???",
        "San Remo? Il protettore dei fratelli Abbagnale?",
        "Le guardie forestali quando muoiono vanno al Gran Paradiso?",
        "La storia di Adamo ed Eva fu il primo melo-dramma?",
        "L'insalata russa e il pomodoro non dorme...",
        "\"Ieri ho vomitato tutto il giorno\". \"Vedi di rimetterti.\"",
        "Perché i Kamikaze portano un casco???",
        "Cosa faceva uno sputo su una scala? Saliva.",
        "\"Non so se mi spiego...\" disse il paracadute.",
        "\"Non so se mi spiedo...\" disse un pollo sul girarrosto.",
        "Il marinaio spiegò le vele al vento, ma il vento non capì",
        "Misticismodi uno Streptococcus termophilus: \"Ecce Yomo.\"",
        "Ragazzo scoppia di salute: 9 morti e 3 feriti.",
        "\"Mi hanno messo in cinta!\", disse una fibbia.",
        "La mela al verme: \"Non parlare, bacami !\".",
        "Arrestato un concorso che era stato bandito...",
        "Perché le tende piangono? Perché sono da sole.",
        "\"Che vitaccia!\" disse il cacciavite...",
        "\"Wonder Woman sei spacciata!\";\"Lo so, sono un'eroina...\"",
        "Come si prende un pollo per amazzarlo? Vivo.",
        "Perché in America fa freddo? Perché è stata scoperta.",
        "Papa Leone visse anni ruggenti?",
        "No: il contrario di \"melodia\" non è \"Se-lo-tenga\"...",
        "Aperta a Cattolica chiesa protestante...",
        "Nuova lavatrice lanciata sul mercato: 10 morti e 6 feriti...",
        "Elettricista impazzito dà alla luce un figlio...",
        "Bimbo scoppia di salute: i genitori in prognosi riservata...",
        "Disegnatore fa cadere mina per terra: 22 morti...",
        "Cosa nasce tra un elettricista ed una domestica? Un elettrodomestico...",
        "Catastrofi del secolo scorso: Hiroshima 45, Cernobyl 86, Windows 95...",
        "Le uniche cose che girano sotto Windows 95 sono le palle.",
        "Lo stitico quando muore va in purgatorio?",
        "\"Gestante\": participio presente o preservativo imperfetto?"
    ]
    
    static let HIGH: Double = 27
    static let LOW: Double = 23
    
    static let high: [String : String] = ["Hai una media invidiabile" : "wtf",
                                          "Ottima carriera universitaria" : "swag",
                                          "Palà e che voti!" : "wtf",
                                          "Fai brutto!" : "swag",
                                          "Ué che secchio!":"sad",
                                          "Palà che media!": "wtf"]
    
    static let medium: [String : String] = ["Continua così..." : "swag",
                                            "Keep on pushin'" : "swag",
                                            "Vai alla grande!":"swag"]
    
    static let low: [String: String] = ["Impegnati di più" : "sad",
                                        "Che fai stasera?" : "swag",
                                        "Eh jamm ja!":"sad"]
    
    /// Returns a random loading sentence
    static func getSentence() -> String {
        return self.sentences.randomItem()
    }
    
    /// Gets a random home greating and an icon to display, based on the average
    static func getRandomHomeSentence(_ average: Double) -> [String : String] {
        switch average {
        case _ where average > HIGH:
            return self.high.randomItem()
        case _ where average > LOW && average < HIGH:
            return self.medium.randomItem()
        case _ where average < LOW:
            return self.low.randomItem()
        default:
            return ["Ma che razzi di voti hai?!": "wtf"]
        }
    }
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Dictionary {
    func randomItem() -> Dictionary {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        let key = Array(self.keys)[index]
        let value = self[key]
        return [key : value!]
    }
}
