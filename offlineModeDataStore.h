//
//  offlineModeDataStore.h
//  FCOdata
//
//  Created by Edwin on 23/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObjectContext;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@interface offlineModeDataStore : NSObject<NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSFetchedResultsController    *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController    *fetchedResultsControllerSearch;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSArray*)countryList;
- (void)deletecountryList;
- (void)synchronizecountryList:(NSArray*)countryList;

@end
