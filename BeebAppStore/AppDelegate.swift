//
//  AppDelegate.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var networkService: NetworkService!

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "BeebAppStore")
		container.loadPersistentStores { _, error in
			if let error {
				fatalError("Core Data model failed to load: \(error)")
			}
		}
		return container
	}()

	var context: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	class var shared: AppDelegate {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			fatalError("AppDelegate not found")
		}
		return appDelegate
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		networkService = NetworkServiceImpl()
		
		NetworkMonitor.shared.startMonitoring()
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
	}

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}

