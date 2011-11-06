//
//  offlineModeDataStore.m
//  FCOdata
//
//  Created by Edwin on 23/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "offlineModeDataStore.h"
#import "OfflineList.h"

@implementation offlineModeDataStore

@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize fetchedResultsControllerSearch = __fetchedResultsControllerSearch;
- (NSArray*)countryList 
{
    NSMutableArray *countryList = nil;
    
    @synchronized(self) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"OfflineList" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
        
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResults == nil) {
            // Handle the error.
        }
        
        countryList = [mutableFetchResults retain];
        [mutableFetchResults release];    
        [request release];
    }
    
    return countryList;
}

- (void)deletecountryList
{
    NSLog(@"county list deleted");
    @synchronized(self) {
        NSArray *countryList = [self countryList];
        for (OfflineList *list in countryList) {
            [self.managedObjectContext deleteObject:list];
        }
        
        // Commit the change.
        [self saveContext];
       /*
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }*/
    }
}

- (void)synchronizecountryList:(NSArray*)countryList
{
   
    NSLog(@"offlinemodedatastore:::synchronizecoutnrylist caled");
    NSAutoreleasePool *autoReleasePool = [[NSAutoreleasePool alloc] init];
    
    @synchronized(self) {
        [self deletecountryList];
        
        for (NSDictionary *countryDictionary in countryList) {
            OfflineList *list = (OfflineList *)[NSEntityDescription insertNewObjectForEntityForName:@"OfflineList" inManagedObjectContext:self.managedObjectContext];
            
            //============================save the name============================
            NSString *name = [[countryDictionary objectForKey:@"country"]objectForKey:@"name"];
            [list setName:name];
            
            //============================save the thumbnail url============================
            NSString *thumb =  [NSString stringWithFormat:@"%@",[[countryDictionary objectForKey:@"country"]objectForKey:@"flag_url"]];
            [list setThumbnail:thumb];
            
            //=============================save the address============================
            NSArray *addArray =[[countryDictionary objectForKey:@"country"]
                                                                  valueForKeyPath:@"embassies.address.plain"];
            //check for nulls, big headache if omitted!!
            if (addArray.count ==0) {
                NSString *address = @"Not Available";                        
                [list setAddress:address];
            }else{
            NSString *address = [addArray objectAtIndex:0];                        
            [list setAddress:address];
            }
            //============================save the latitude============================
            NSArray *latArray =[[countryDictionary objectForKey:@"country"]
                                  valueForKeyPath:@"embassies.lat"];
            //check for nulls, big headache if omitted!!
            if (latArray.count ==0) {
                NSString *lat = @"0.0000";                        
                [list setLatitude:[NSNumber numberWithDouble:[lat doubleValue]]];
            }else{
                NSString *lat = [latArray objectAtIndex:0];
               
                [list setLatitude:[NSNumber numberWithDouble:[lat doubleValue]]];
            }
            
            //============================save the longitude============================
            NSArray *longArray =[[countryDictionary objectForKey:@"country"]
                                valueForKeyPath:@"embassies.long"];
            //check for nulls, big headache if omitted!!
            if (longArray.count ==0) {
                NSString *lng = @"0.0000";                        
                [list setLongitude:[NSNumber numberWithDouble:[lng doubleValue]]];
            }else{
                NSString *lng = [longArray objectAtIndex:0];
                
                [list setLongitude:[NSNumber numberWithDouble:[lng doubleValue]]];
            }
            
            
            //============================save the officeHours============================
            
            NSArray *hoursArray =[[countryDictionary objectForKey:@"country"]
                                valueForKeyPath:@"embassies.office_hours.plain"];
            //check for nulls, big headache if omitted!!
            if (hoursArray.count ==0) {
                NSString *officeHours = @"Mon - Fri";                        
                [list setOfficeHours:officeHours];
            }else{
                NSString *officeHours = [hoursArray objectAtIndex:0];                        
                [list setOfficeHours:officeHours];
            }

            //============================save the officehours============================
            
            
            //============================save the phone number============================
            NSArray *phoneArray =[[countryDictionary objectForKey:@"country"]
                                valueForKeyPath:@"embassies.phone"];
            //check for nulls, big headache if omitted!!
            if (phoneArray.count ==0) {
                NSString *address = @"Not Available";                        
                [list setPhone:address];
            }else{
                NSString *phone = [phoneArray objectAtIndex:0];
                //also check for empty fields and treat them appropriately
                if (phone.length==0) {
                    phone = @"Not Available";
                }
                [list setPhone:phone];
            }
            
            //============================save the city============================
            NSArray *cityArray =[[countryDictionary objectForKey:@"country"]
                                 valueForKeyPath:@"embassies.location_name"];
            
            
            //check for nulls, big headache if omitted!!
            if(cityArray.count ==0){
                NSString *city=@"Not Available";
                [list setCity:city];
            }else {
                NSString *city = [cityArray objectAtIndex:0];
                //this is a tricky bastard, another error to check for is an NSNull type being passed!
                if ((NSNull *)city ==[NSNull null]) {
                    city = @"Not available";
                }
                [list setCity:city];
            }

            //============================save the designation============================
            NSArray *designationArray =[[countryDictionary objectForKey:@"country"]
                                 valueForKeyPath:@"embassies.designation"];
                                
                              
            //check for nulls, big headache if omitted!!
            if(designationArray.count ==0){
               NSString *designaiton=@"Not Available";
                [list setDesignation:designaiton];
            }else {
                NSString *designation = [designationArray objectAtIndex:0];
                //this is a tricky bastard, another error to check for is an NSNull type being passed!
                if ((NSNull *)designation ==[NSNull null]) {
                    designation = @"Not available";
                }
                [list setDesignation:designation];
            }
            //NSLog(@"oflineList %@", list);
        }
        NSLog(@"offflinemodedatastore: datapopulated");
        [self saveContext];
    }
    
    //post a notification that the countryList are available...have responder update itself on the main thread
    [[NSNotificationCenter defaultCenter] postNotificationName:@"countryListDidSynchronize" 
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OfflineList" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
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
- (NSFetchedResultsController *)fetchedResultsControllerSearch
{
    if (__fetchedResultsControllerSearch != nil)
    {
        return __fetchedResultsControllerSearch;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OfflineList" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsControllerSearch = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsControllerSearch performFetch:&error])
    {
	   
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsControllerSearch;
}    

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)dealloc
{
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [__fetchedResultsController release];
    [super dealloc];
}

@end
