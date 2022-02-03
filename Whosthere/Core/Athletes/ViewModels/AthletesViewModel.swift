//
//  AthletesListViewModel.swift
//  Photopickertest
//
//  Created by Moose on 13.12.21.
//
import Foundation
import CoreData

class AthletesViewModel: ObservableObject {
    
    @Published var allAthletes: [AthletesModel] = []
    
    
    //Initializes the athlete when App is started/Screen is origanally loaded
    init() {
        getAthletes()
    }
    
    //loads sample athlete into Athletes model array
    func getAthletes() {
        let newAthlete = AthletesModel(firstName: "Mustafa", lastName: "Acar", birthday: .init(timeIntervalSince1970: 893796436), birthyear: 1998, gender: "male")
        allAthletes.append(newAthlete)
    }
    
    //appends athlete to Athletes Model Array
    func addAthlete(firstName: String, lastName: String, birthday: Date, birthyear: Int, gender: String) {
        let newAthlete = AthletesModel(firstName: firstName, lastName: lastName, birthday: birthday, birthyear: birthyear, gender: gender)
        allAthletes.append(newAthlete)
    }
    
}//class end

//old Coredata entity thing
/*
let container : NSPersistentContainer
@Published var savedEntities: [AthletesEntity] = []

@Published var athletes: [AthletesModel] = []

init() {
    container = NSPersistentContainer(name: "AthletesContainer")
    container.loadPersistentStores { description, error in
        if let error = error {
            print("error loading coredata: \(error)")
        }
        else {
            print("Successfully loaded core data")
        }
    }
    fetchAthletes()
}

func fetchAthletes(){
    let request = NSFetchRequest<AthletesEntity>(entityName: "AthletesEntity")
    
    do {
        savedEntities = try container.viewContext.fetch(request)
    } catch let error {
        print("Error fetching \(error)")
    }
}

func addAthlete(firstName: String, lastName: String, birthDate: Date, gender: String) {
    let newAthlete = AthletesEntity(context: container.viewContext)
    newAthlete.firstname = firstName
    newAthlete.lastname = lastName
    newAthlete.birthdate = birthDate
    newAthlete.gender = gender
    saveData()
}

func saveData() {
    do {
    try container.viewContext.save()
        fetchAthletes()
    } catch let error {
        print("Error saving. \(error)")
    }
}

func deleteAthlete(indexSet: IndexSet) {
    //adjust it so it is not always .first, incase there are more entities for example trainingsession entity later on
    guard let index = indexSet.first else {return}
    let entity = savedEntities[index]
    container.viewContext.delete(entity)
}*/
