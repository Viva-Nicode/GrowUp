//
//  EpisodeView.swift
//  GrowUp
//
//  Created by Nicode . on 2023/07/07.
//

import SwiftUI
import Firebase

struct EpisodeWrapper:Identifiable{
    let id = UUID()
    let episode:String
    let cut_count:String
}

struct EpisodeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var toonTitle :String
    @State private var episodeList = [EpisodeWrapper]()
    
    init(toonTitle: String) {
        self._toonTitle = State(initialValue: toonTitle)
    }
    
    var body : some View {
        Text(dictionary[toonTitle] ?? "error").font(.system(size:50)).frame(maxHeight: 150)
        Divider().background(Color.black).padding(.horizontal).frame(height: 10)
        ScrollView{
            VStack(alignment: .center, spacing: 0){
                ForEach(episodeList.sorted{(wrapper1, wrapper2) -> Bool in
                    guard let episode1 = Int(wrapper1.episode),
                          let episode2 = Int(wrapper2.episode) else { return false }
                    return episode1 > episode2
                }){
                    epiWrapper in
                    NavigationLink(destination: ToonView(toonTitle: toonTitle,
                                                         episode:epiWrapper.episode,
                                                         cut_count: epiWrapper.cut_count)) {
                        Text(epiWrapper.episode + " 화")
                            .font(.system(size:40))
                            .frame(maxWidth: 300)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    Divider().background(Color.black).padding(.horizontal).frame(height: 10)
                }
            }
        }.onAppear{
            episodeList.removeAll()
            loadEpisodes()
        }
    }
    
    private func loadEpisodes(){
        
        let db = Firestore.firestore()
        let docRef = db.collection("toons").document(toonTitle)
        
        docRef.getDocument(){ (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    for idx in 0..<data.count{
                        let res = data[String(idx)] ?? "-1:0"
                        if let stringRes = res as? String {
                            let spl = stringRes.split(separator: ":")
                            self.episodeList.append(EpisodeWrapper(episode: String(spl[0]), cut_count: String(spl[1])))
                        } else {}
                    }
                }
            }
        }
//        AF.request("http://\(ip):5000/get_episode_count/\(toonTitle)", method: .get).responseString{
//            response in
//            if let result = response.value?.split(separator: ":"){
//                if let startValue = Int(result[0]), let offsetValue = Int(result[1]) {
//                    let start = startValue
//                    let offset = offsetValue
//                    for idx in start..<start + offset {
//                        self.episodeList.append(EpisodeWrapper(episode: String(idx)))
//                    }
//                } else {}
//            }else{}
//        }
    }
}
