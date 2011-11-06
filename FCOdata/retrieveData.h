//
//  retrieveData.h
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 21/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "News.h"

@class NSManagedObjectContext;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;

@interface retrieveData : NSObject <NSFetchedResultsControllerDelegate> {
    NSString *responseString;
    
    
}
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSFetchedResultsController    *fetchedResultsController;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSArray*)newsList;
- (void)deleteNewsList;
- (void)synchronizeNewsList:(NSArray*)newsList;


@end
