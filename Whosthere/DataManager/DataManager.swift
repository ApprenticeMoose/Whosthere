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
    private let athletesFRC: NSFetchedResultsController<AthleteEntity>
    private let sessionsFRC: NSFetchedResultsController<SessionEntity>
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persistentStore = PersistentStore()
            self.managedObjectContext = persistentStore.context
        case .preview:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
            for i in 0..<10 {
                let newAthlete = AthleteEntity(context: managedObjectContext)
                newAthlete.firstName = "first name \(i)"
                newAthlete.lastName = "last name \(i)"
                newAthlete.birthday = Date()
                newAthlete.gender = "male"
                newAthlete.showYear = false
                newAthlete.id = UUID()
            }
            for _ in 0..<4 {
                let newSession = SessionEntity(context: managedObjectContext)
                newSession.date = Date()
                newSession.id = UUID()
            }
            try? self.managedObjectContext.save()
        case .testing:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        let athleteFR: NSFetchRequest<AthleteEntity> = AthleteEntity.fetchRequest()
        athleteFR.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: false)]
        athletesFRC = NSFetchedResultsController(fetchRequest: athleteFR,
                                              managedObjectContext: managedObjectContext,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        let sessionFR: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
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
            self.athletes = OrderedDictionary(uniqueKeysWithValues: newAthletes.map({($0.id!, Athlete(athleteEntity: $0)) } ))
        }
        
        sessionsFRC.delegate = self
        try? sessionsFRC.performFetch()
        if let newSessions = sessionsFRC.fetchedObjects {
            self.sessions = OrderedDictionary(uniqueKeysWithValues: newSessions.map({ ($0.id!, Session(sessionEntity: $0)) }))
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
        if let newAthletes = controller.fetchedObjects as? [AthleteEntity] {
            self.athletes = OrderedDictionary(uniqueKeysWithValues: newAthletes.map({ ($0.id!, Athlete(athleteEntity: $0)) }))
        } else if let newSessions = controller.fetchedObjects as? [SessionEntity] {
            print(newSessions)
            self.sessions = OrderedDictionary(uniqueKeysWithValues: newSessions.map({ ($0.id!, Session(sessionEntity: $0)) }))
        }
    }
    
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
    
    func fetchAthletes(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            athletesFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            athletesFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? athletesFRC.performFetch()
        if let newAthletes = athletesFRC.fetchedObjects {
            self.athletes = OrderedDictionary(uniqueKeysWithValues: newAthletes.map({ ($0.id!, Athlete(athleteEntity: $0)) }))
        }
    }
    
    func resetFetch() {
        athletesFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        athletesFRC.fetchRequest.predicate = nil
        try? athletesFRC.performFetch()
        if let newAthletes = athletesFRC.fetchedObjects {
            self.athletes = OrderedDictionary(uniqueKeysWithValues: newAthletes.map({ ($0.id!, Athlete(athleteEntity: $0)) }))
        }
    }

}

//MARK: - Todo Methods
extension Athlete {
    
    fileprivate init(athleteEntity: AthleteEntity) {
        self.id = athleteEntity.id ?? UUID()
        self.firstName = athleteEntity.firstName ?? ""
        self.lastName = athleteEntity.lastName ?? ""
        self.birthday = athleteEntity.birthday ?? Date()
        self.gender = athleteEntity.gender ?? ""
        self.showYear = athleteEntity.showYear
        if let sessionEntities = athleteEntity.sessionEntity as? Set<SessionEntity> {
            let sessionEntitiesArray = sessionEntities.sorted(by: {$0.date! < $1.date!})
            self.sessionIDs = sessionEntitiesArray.compactMap({$0.id})
        }
    }
}

extension DataManager {
    
    func updateAndSave(athlete: Athlete) {
        let predicate = NSPredicate(format: "id = %@", athlete.id as CVarArg)
        let result = fetchFirst(AthleteEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let athleteMO = managedObject {
                update(athleteEntity: athleteMO, from: athlete)
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
        let result = fetchFirst(AthleteEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let athleteMo = managedObject {
                managedObjectContext.delete(athleteMo)
            }
        case .failure(_):
            print("Couldn't fetch AthleteEntity to save")
        }
        saveData()
    }
    
    func getAthlete(with id: UUID) -> Athlete? {
        return athletes[id]
    }
    
    private func athleteMO(from athlete: Athlete) {
        let athleteEntity = AthleteEntity(context: managedObjectContext)
        athleteEntity.id = athlete.id
        update(athleteEntity: athleteEntity, from: athlete)
    }
    
    private func update(athleteEntity: AthleteEntity, from athlete: Athlete) {
        athleteEntity.firstName = athlete.firstName
        athleteEntity.lastName = athlete.lastName
        athleteEntity.birthday = athlete.birthday
        athleteEntity.gender = athlete.gender
        athleteEntity.showYear = athlete.showYear
        let sessionEntities = athlete.sessionIDs.compactMap({getSessionEntity(from:getSession(with: $0))})
        athleteEntity.sessionEntity = NSSet(array: sessionEntities)
    }
    
    ///Get's the AthleteEntity that corresponds to the athlete. If no AthleteEntity is found, returns nil.
    private func getAthleteEntity(from athlete: Athlete?) -> AthleteEntity? {
        guard let athlete = athlete else { return nil }
        let predicate = NSPredicate(format: "id = %@", athlete.id as CVarArg)
        let result = fetchFirst(AthleteEntity.self, predicate: predicate)
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
    fileprivate init(sessionEntity: SessionEntity) {
        self.id = sessionEntity.id ?? UUID()
        self.date = sessionEntity.date ?? Date()
        if let athleteEntities = sessionEntity.athleteEntity as? Set<AthleteEntity> {
            let athleteEntitiesArray = athleteEntities.sorted(by: {$0.firstName! < $1.firstName!})
            self.athleteIDs = athleteEntitiesArray.compactMap({$0.id})
        }
    }
}

extension DataManager {
    func updateAndSave(session: Session) {
        let predicate = NSPredicate(format: "id = %@", session.id as CVarArg)
        let result = fetchFirst(SessionEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let sessionMO = managedObject {
                update(sessionEntity: sessionMO, from: session)
            } else {
                createSessionEntity(from: session)
            }
        case .failure(_):
            print("Couldn't fetch SessionEntity to save")
        }
        
        saveData()
    }
    
    func delete(session: Session) {
        let predicate = NSPredicate(format: "id = %@", session.id as CVarArg)
        let result = fetchFirst(SessionEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let sessionMo = managedObject {
                managedObjectContext.delete(sessionMo)
            }
        case .failure(_):
            print("Couldn't fetch SessionEntity to save")
        }
        saveData()
    }
    
    func getSession(with id: UUID) -> Session? {
        return sessions[id]
    }
    
    private func createSessionEntity(from session: Session) {
        let sessionEntity = SessionEntity(context: managedObjectContext)
        sessionEntity.id = session.id
        update(sessionEntity: sessionEntity, from: session)
    }
    
    private func update(sessionEntity: SessionEntity, from session: Session) {
        sessionEntity.date = session.date
        let sessionEntities = session.athleteIDs.compactMap({getAthleteEntity(from:getAthlete(with: $0))})
        sessionEntity.athleteEntity = NSSet(array: sessionEntities)
    }
    
    ///Get's the SessionEntity that corresponds to the sessoin. If no SessionEntity is found, returns nil.
    private func getSessionEntity(from session: Session? ) -> SessionEntity? {
        guard let session = session else { return nil }
        let predicate = NSPredicate(format: "id = %@", session.id as CVarArg)
        let result = fetchFirst(SessionEntity.self, predicate: predicate)
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

