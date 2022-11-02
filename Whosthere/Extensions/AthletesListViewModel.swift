//
//  ListViewModel.swift
//  Whosthere
//
//  Created by Moose on 28.07.22.
//

import Foundation
import CoreData

@MainActor
class AthletesListViewModel: NSObject, ObservableObject {
    
    @Published var athletes = [AthleteViewModel]()
    @Published var showDetail: Bool = false
    private let fetchResultsController: NSFetchedResultsController<AthleteMO>
    private (set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        
        self.context = context
        fetchResultsController = NSFetchedResultsController(fetchRequest: AthleteMO.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
            guard let athletes = fetchResultsController.fetchedObjects else {
                return
            }
            
            self.athletes = athletes.map(AthleteViewModel.init)
        } catch {
            print(error)
        }
    }
    
}

extension AthletesListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let athletes = controller.fetchedObjects as? [AthleteMO] else {
            return
        }
        
        self.athletes = athletes.map(AthleteViewModel.init)
    }
}

class AthleteViewModel: Identifiable, ObservableObject, Hashable, Equatable {
    static func == (lhs: AthleteViewModel, rhs: AthleteViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(firstName)
       }
    
    private var athlete: AthleteMO
    
    init(athlete: AthleteMO) {
        self.athlete = athlete
    }
    
    var id: NSManagedObjectID {
        athlete.objectID
    }
    
    var firstName: String {
        athlete.firstName ?? ""
    }
    
    var lastName: String {
        athlete.lastName ?? ""
    }
    
    var birthday: Date {
        athlete.birthday ?? Date()
    }
    
    var gender: String {
        athlete.gender ?? ""
    }
    
    var showYear: Bool {
        athlete.showYear
    }
}
