//
//  DataManager.swift
//  Whosthere
//
//  Created by Moose on 06.09.22.
//
import Foundation
import CoreData
import OrderedCollections

enum DataManagerType {
    case normal, preview, testing
}

class DataManager: NSObject, ObservableObject {
    
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    static let testing = DataManager(type: .testing)
    
    @Published var athletes: OrderedDictionary<UUID, Athlete> = [:]
    @Published var sessions: OrderedDictionary<UUID, Session> = [:]
    
    var athletesArray: [Athlete] {
        Array(athletes.values)
    }
    
    var sessionsArray: [Session] {
        Array(sessions.values)
    }
    
    fileprivate var managedObjectContext: NSManagedObjectContext
    private let athletesFRC: NSFetchedResultsController<AthleteMO>
    private let sessionsFRC: NSFetchedResultsController<SessionMO>
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persistentStore = PersistentStore()
            self.managedObjectContext = persistentStore.context
        case .preview:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
            for i in 0..<10 {
                let newAthlete = AthleteMO(context: managedObjectContext)
                newAthlete.firstName = "first name \(i)"
                newAthlete.lastName = "last name \(i)"
                newAthlete.birthday = Date()
                newAthlete.gender = "male"
                newAthlete.showYear = false
                newAthlete.id = UUID()
            }
            for _ in 0..<4 {
                let newSession = SessionMO(context: managedObjectContext)
                newSession.date = Date()
                newSession.id = UUID()
            }
            try? self.managedObjectContext.save()
        case .testing:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        let athleteFR: NSFetchRequest<AthleteMO> = AthleteMO.fetchRequest()
        athleteFR.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        athletesFRC = NSFetchedResultsController(fetchRequest: athleteFR,
                                              managedObjectContext: managedObjectContext,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        let sessionFR: NSFetchRequest<SessionMO> = SessionMO.fetchRequest()
        sessionFR.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        sessionsFRC = NSFetchedResultsController(fetchRequest: sessionFR,
                                                 managedObjectContext: managedObjectContext,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
        
        super.init()
        
        // Initial fetch to populate athletes array
        athletesFRC.delegate = self
        try? athletesFRC.performFetch()
        if let newAthletes = athletesFRC.fetchedObjects {
            self.athletes = OrderedDictionary(uniqueKeysWithValues: newAthletes.map({($0.id!, Athlete(athleteMO: $0)) } ))
        }
        
        sessionsFRC.delegate = self
        try? sessionsFRC.performFetch()
        if let newSessions = sessionsFRC.fetchedObjects {
            self.sessions = OrderedDictionary(uniqueKeysWithValues: newSessions.map({ ($0.id!, Session(sessionMO: $0)) }))
        }
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newAthletes = controller.fetchedObjects as? [AthleteMO] {
            self.athletes = OrderedDictionary(uniqueKeysWithValues: newAthletes.map({ ($0.id!, Athlete(athleteMO: $0)) }))
        } else if let newSessions = controller.fetchedObjects as? [SessionMO] {
            self.sessions = OrderedDictionary(uniqueKeysWithValues: newSessions.map({ ($0.id!, Session(sessionMO: $0)) }))
        }
    }
    
   
    
    func fetchAthletes(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            athletesFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            athletesFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? athletesFRC.performFetch()
        if let newAthletes = athletesFRC.fetchedObjects {
            self.athletes = OrderedDictionary(uniqueKeysWithValues: newAthletes.map({ ($0.id!, Athlete(athleteMO: $0)) }))
        }
    }
    
    func fetchSessions(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            sessionsFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            sessionsFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? sessionsFRC.performFetch()
        if let newSessions = sessionsFRC.fetchedObjects {
            self.sessions = OrderedDictionary(uniqueKeysWithValues: newSessions.map({ ($0.id!, Session(sessionMO: $0)) }))
        }
    }
    //reset Fetch Function
    /*
    func resetFetch() {
        athletesFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        athletesFRC.fetchRequest.predicate = nil
        try? athletesFRC.performFetch()
        if let newAthletes = athletesFRC.fetchedObjects {
            self.athletes = OrderedDictionary(uniqueKeysWithValues: newAthletes.map({ ($0.id!, Athlete(athleteEntity: $0)) }))
        }
    }
    */
    
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    

}

//MARK: - Athlete Methods
extension Athlete {
    
    fileprivate init(athleteMO: AthleteMO) {
        self.id = athleteMO.id ?? UUID()
        self.firstName = athleteMO.firstName ?? ""
        self.lastName = athleteMO.lastName ?? ""
        self.birthday = athleteMO.birthday ?? Date()
        self.gender = athleteMO.gender ?? ""
        self.showYear = athleteMO.showYear
        self.dateAdded = athleteMO.dateAdded ?? Date()
        if let sessionMOs = athleteMO.sessionMOs as? Set<SessionMO> {
            let sessionMOsArray = sessionMOs.sorted(by: {$0.date! < $1.date!})
            self.sessionIDs = sessionMOsArray.compactMap({$0.id})
        }
    }
}

extension DataManager {
    
    func updateAndSave(athlete: Athlete) {
        let predicate = NSPredicate(format: "id = %@", athlete.id as CVarArg)
        let result = fetchFirst(AthleteMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let athleteMO = managedObject {
                update(athleteMO: athleteMO, from: athlete)
            } else {
                athleteMO(from: athlete)
            }
        case .failure(_):
            print("Couldn't fetch AthleteEntity to save")
        }
        
        saveData()
    }
    
    func delete(athlete: Athlete) {
        let predicate = NSPredicate(format: "id = %@", athlete.id as CVarArg)
        let result = fetchFirst(AthleteMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let athleteMo = managedObject {
                managedObjectContext.delete(athleteMo)
            }
        case .failure(_):
            print("Couldn't fetch TodoMO to save")
        }
        saveData()
    }
    
    func getAthlete(with id: UUID) -> Athlete? {
        return athletes[id]
    }
    
    private func athleteMO(from athlete: Athlete) {
        let athleteMO = AthleteMO(context: managedObjectContext)
        athleteMO.id = athlete.id
        update(athleteMO: athleteMO, from: athlete)
    }
    
    private func update(athleteMO: AthleteMO, from athlete: Athlete) {
        athleteMO.firstName = athlete.firstName
        athleteMO.lastName = athlete.lastName
        athleteMO.birthday = athlete.birthday
        athleteMO.gender = athlete.gender
        athleteMO.showYear = athlete.showYear
        athleteMO.dateAdded = athlete.dateAdded
        let sessionMOs = athlete.sessionIDs.compactMap({getSessionMO(from:getSession(with: $0))})
        athleteMO.sessionMOs = NSSet(array: sessionMOs)
    }
    
    ///Get's the AthleteEntity that corresponds to the athlete. If no AthleteEntity is found, returns nil.
    private func getAthleteMO(from athlete: Athlete?) -> AthleteMO? {
        guard let athlete = athlete else { return nil }
        let predicate = NSPredicate(format: "id = %@", athlete.id as CVarArg)
        let result = fetchFirst(AthleteMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let athleteMO = managedObject {
                return athleteMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
        
    }
    
}

//MARK: - Project Methods
extension Session {
    fileprivate init(sessionMO: SessionMO) {
        self.id = sessionMO.id ?? UUID()
        self.date = sessionMO.date ?? Date()
        if let athleteMOs = sessionMO.athleteMOs as? Set<AthleteMO> {
            let athleteMOsArray = athleteMOs.sorted(by: {$0.firstName! < $1.firstName!})
            self.athleteIDs = athleteMOsArray.compactMap({$0.id})
        }
    }
}

extension DataManager {
    func updateAndSave(session: Session) {
        let predicate = NSPredicate(format: "id = %@", session.id as CVarArg)
        let result = fetchFirst(SessionMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let sessionMO = managedObject {
                update(sessionMO: sessionMO, from: session)
            } else {
                createSessionMO(from: session)
            }
        case .failure(_):
            print("Couldn't fetch SessionEntity to save")
        }
        
        saveData()
    }
    
    func delete(session: Session) {
        let predicate = NSPredicate(format: "id = %@", session.id as CVarArg)
        let result = fetchFirst(SessionMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let sessionMo = managedObject {
                managedObjectContext.delete(sessionMo)
            }
        case .failure(_):
            print("Couldn't fetch TodoMO to save")
        }
        saveData()
    }
    
    func getSession(with id: UUID) -> Session? {
        return sessions[id]
    }
    
    private func createSessionMO(from session: Session) {
        let sessionMO = SessionMO(context: managedObjectContext)
        sessionMO.id = session.id
        update(sessionMO: sessionMO, from: session)
    }
    
    private func update(sessionMO: SessionMO, from session: Session) {
        sessionMO.date = session.date
        let sessionMOs = session.athleteIDs.compactMap({getAthleteMO(from:getAthlete(with: $0))})
        sessionMO.athleteMOs = NSSet(array: sessionMOs)
    }
    
    ///Get's the SessionEntity that corresponds to the sessoin. If no SessionEntity is found, returns nil.
    private func getSessionMO(from session: Session? ) -> SessionMO? {
        guard let session = session else { return nil }
        let predicate = NSPredicate(format: "id = %@", session.id as CVarArg)
        let result = fetchFirst(SessionMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let sessionMO = managedObject {
                return sessionMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
    }
}
