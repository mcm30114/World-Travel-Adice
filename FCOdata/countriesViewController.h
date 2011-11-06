//
//  countriesViewController.h
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "countriesDataModel.h"
#import "asynchImage.h"
#import <CoreData/CoreData.h>
#import "offlineModeDataStore.h"
#import "OfflineList.h"
@interface countriesViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>{
    countriesDataModel *dataModel;
    NSArray      *_dataItems;
    NSString            *_response;
    asynchImage         *getImage;
    UISearchBar         *searchBar;
    NSMutableArray      *searchResults;
    NSString            *savedSearchTerm;
    NSMutableArray      *reverse;
    NSMutableArray      *imageURL;
    UISearchDisplayController *searchBarController;
    offlineModeDataStore *OflineModeDataStore;
    OfflineList  *offlineList;
    NSArray *fetchedObjects;
    NSString *contentForthisRow;
}

@property (nonatomic, retain)   countriesDataModel *dataModel;
@property (nonatomic, retain)   NSArray *_dataItems;
@property (nonatomic, retain)   NSString *_response;
@property (nonatomic, retain)   UISearchBar *searchBar;
@property (nonatomic, retain)   NSMutableArray *searchResults;
@property (nonatomic, retain)   NSString *savedSearchTerm;
@property (nonatomic, retain)   NSMutableArray *reverse;
@property (nonatomic, retain)   NSMutableArray *imageURL;
@property (nonatomic, retain)   NSString *contentForthisRow;
@property (nonatomic, retain)   offlineModeDataStore *OflineModeDataStore;
@property (nonatomic, retain)   OfflineList  *offlineList;

-(void) grabData;
-(void) downloadPublicData:(NSMutableArray *) array;

-(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
-(void) handleSearchForTerm:(NSString *)searchTerm;
//====methods to handle caching
-(void)reloadTable;
-(void)dataDidSynchronize:(NSNotification*)notification; 
-(void)synchronizeData:(NSArray*)data;

@end
