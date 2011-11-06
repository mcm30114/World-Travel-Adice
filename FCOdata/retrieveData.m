//
//  retrieveData.m
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 21/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import "retrieveData.h"
#import "ASIHTTPRequest.h"
#include "SBJson.h"

@implementation retrieveData
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;
@synthesize fetchedResultsController=__fetchedResultsController;



- (NSArray*)newsList 
{
    NSMutableArray *newsList = nil;
    
    @synchronized(self) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titles" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
        
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResults == nil) {
            // Handle the error.
        }
        
        newsList = [mutableFetchResults retain];
        [mutableFetchResults release];    
        [request release];
    }
   // NSLog(@"newslist %@", newsList);
    return newsList;
}

- (void)deleteNewsList
{
    NSLog(@"news list deleted");
    @synchronized(self) {
        NSArray *news = [self newsList];
        for (News *list in news) {
            [self.managedObjectContext deleteObject:list];
        }
        
        // Commit the change.
        [self saveContext];
        
    }
}

- (void)synchronizeNewsList:(NSArray*)newsArray
{
    
    NSLog(@"retrieveNews:::synchronizecoutnrylist caled");
    NSAutoreleasePool *autoReleasePool = [[NSAutoreleasePool alloc] init];
    
    @synchronized(self) {
        [self deleteNewsList];
        
        for (NSDictionary *newsDictionary in newsArray) {
            News *newsItem = (News *)[NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:self.managedObjectContext];
            NSString *titles =[newsDictionary valueForKeyPath:@"travel_news.title"];
            [newsItem setTitles:titles];
            
            NSString *desc = [newsDictionary valueForKeyPath:@"travel_news.description"];
            [newsItem setSummary:desc];
            
            NSString *link = [newsDictionary valueForKeyPath:@"travel_news.original_url"];
            [newsItem setLink:link];
            
            NSString *article = [newsDictionary valueForKeyPath:@"travel_news.body.markup"];
            [newsItem setArticle:article];
            
            //format the date
            NSString *theDate = [newsDictionary valueForKeyPath:@"travel_news.published_on"];
            NSString *formatedDate1 = [theDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSString *formatedDate = [formatedDate1 stringByReplacingOccurrencesOfString:@"+01:00" withString:@" +0100"];
            NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
            NSDate *newsDate = [dateF dateFromString:formatedDate];
            NSLog(@"date::: %@", newsDate);

            [newsItem setPudDate:formatedDate];
        }
            //NSLog(@"oflineList %@", list);
        
        NSLog(@"retrieveData: datapopulated");
        [self saveContext];
    }
    
    //post a notification that the countryList are available...have responder update itself on the main thread
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newsDidSynchronize" 
														object:nil 
													  userInfo:nil];
    
    [autoReleasePool release];
}

- (void)saveContext
{
    NSLog(@"save context called");
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Offline" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataOffline.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}
- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
