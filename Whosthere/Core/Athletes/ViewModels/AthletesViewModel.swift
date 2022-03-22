//
//  AthletesListViewModel.swift
//  Photopickertest
//
//  Created by Moose on 13.12.21.
//
import Foundation
import CoreData
import Combine

class AthletesViewModel: ObservableObject {
    
    @Published var allAthletes: [AthletesModel] = []
    @Published var appError: ErrorType? = nil
    var addAthlete = PassthroughSubject<AthletesModel, Never>()
    var updateAthlete = PassthroughSubject<AthletesModel, Never>()
    var deleteAthlete = PassthroughSubject<AthletesModel, Never>()
    var loadAthletes = Just(FileManager.docDirURL.appendingPathComponent(fileName))
    
    
    var subscriptions = Set<AnyCancellable>()
    
    
    //Initializes the athlete when App is started/Screen is origanally loaded
    init() {
        print(FileManager.docDirURL.path)
        addSubscription()
        
    }
    
    func addSubscription() {
        loadAthletes
            .filter { FileManager.default.fileExists(atPath: $0.path)}
            .tryMap { url in
                try Data(contentsOf: url)
            }
            .decode(type: [AthletesModel].self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("Loading")
                    athletesSubscription()
                case .failure(let error):
                    if error is AthletesError {
                        appError = ErrorType(error: error as! AthletesError)
                    } else {
                        appError = ErrorType(error: AthletesError.decodingError)
                        athletesSubscription()
                    }
                }
            } receiveValue: { (allAthletes) in
                self.allAthletes = allAthletes
            }
            .store(in: &subscriptions)

        
        addAthlete
            .sink { [unowned self] athlete in
                allAthletes.append(athlete)
                
            }
            .store(in: &subscriptions)
        
        updateAthlete
            .sink { [unowned self] athlete in
                guard let index = allAthletes.firstIndex (where: { $0.id == athlete.id }) else {return}
                allAthletes[index] = athlete
                
            }
            .store(in: &subscriptions)
        
        deleteAthlete
            .sink { [unowned self] athlete in
                self.allAthletes.removeAll { $0.id == athlete.id }
                
            }
            .store(in: &subscriptions)
    }
    
    func athletesSubscription() {
        $allAthletes
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .encode(encoder: JSONEncoder())
            .tryMap { data in
                try data.write(to: FileManager.docDirURL.appendingPathComponent(fileName))
            }
            .sink { [ unowned self ] completion in
                switch completion {
                case .finished:
                    print("Saving Completed")
                case .failure(let error):
                    if error is AthletesError {
                        appError = ErrorType(error: error as! AthletesError)
                    } else {
                        appError = ErrorType(error: AthletesError.encodingError)
                    }
                }
            } receiveValue: { _ in
                print("Saving file was succesful")
            }
            .store(in: &subscriptions)
    }
    
    //loads sample athlete into Athletes model array
//    func loadAthletes() {
//        //allAthletes = AthletesModel.sampleData
//        FileManager().readDocument(docName: fileName) { (result) in
//            switch result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//                do {
//                    allAthletes = try decoder.decode([AthletesModel].self, from: data)
//                } catch {
//                    //print(AthletesError.decodingError.localizedDescription)
//                    appError = ErrorType(error: .decodingError)
//                }
//            case .failure(let error):
//                //print(error.localizedDescription)
//                appError = ErrorType(error: error)
//            }
//        }
//    }
    
//    func saveAthletes() {
//        print("Saving athletes to file system")
//        let encoder = JSONEncoder()
//        do {
//            let data = try encoder.encode(allAthletes)
//            let jsonString = String(decoding: data, as: UTF8.self)
//            FileManager().saveDocument(contents: jsonString, docName: fileName) { (error) in
//                if let error = error {
//                    //print(error.localizedDescription)
//                    appError = ErrorType(error: error)
//                }
//            }
//        } catch {
//            //print(AthletesError.encodingError.localizedDescription)
//            appError = ErrorType(error: .encodingError)
//        }
//    }
    
}//class end
