////
////  SessionsHomeViewModel.swift
////  Whosthere
////
////  Created by Moose on 05.09.22.
////
//
//import Foundation
//import CoreData
//
//@MainActor
//class SessionsViewModel: NSObject, ObservableObject {
//    
//    @Published var sessions = [SessionViewModel]()
//    //@Published var showDetail: Bool = false
//    private let fetchResultsController: NSFetchedResultsController<SessionEntity>
//    private (set) var context: NSManagedObjectContext
//    
//    init(context: NSManagedObjectContext) {
//        
//        self.context = context
//        fetchResultsController = NSFetchedResultsController(fetchRequest: SessionEntity.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        super.init()
//        fetchResultsController.delegate = self
//        
//        do {
//            try fetchResultsController.performFetch()
//            guard let sessions = fetchResultsController.fetchedObjects else {
//                return
//            }
//            
//            self.sessions = sessions.map(SessionViewModel.init)
//        } catch {
//            print(error)
//        }
//    }
//    
//}
//
//extension SessionsViewModel: NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        guard let sessions = controller.fetchedObjects as? [SessionEntity] else {
//            return
//        }
//        
//        self.sessions = sessions.map(SessionViewModel.init)
//    }
//}
//
//class SessionViewModel: Identifiable, ObservableObject, Hashable, Equatable {
//    static func == (lhs: SessionViewModel, rhs: SessionViewModel) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//           hasher.combine(date)
//       }
//    
//    private var session: SessionEntity
//    
//    init(session: SessionEntity) {
//        self.session = session
//    }
//    
//    var id: NSManagedObjectID {
//        session.objectID
//    }
//    
//    var date: Date {
//        session.date ?? Date()
//    }
//    
//   
//}
