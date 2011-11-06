//
//  newsViewController.h
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "retrieveData.h"
#import <CoreData/CoreData.h>

@interface newsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSString *responseString;
    NSArray *titles;
    NSArray *desc;
    NSArray *url;
    NSArray *pubDate;
    NSArray *newsItems;
    retrieveData *RetrieveData;
    BOOL isLoading;
}
@property (nonatomic, retain) NSArray *newsItems;
@property (nonatomic, retain) retrieveData *RetrieveData;
-(void) grabData;
-(void)refreshData;
-(void) downloadPublicData:(NSMutableArray *) array;
-(void)reloadTable;
- (void)synchronizeData:(NSArray*)data;
- (void)dataDidSynchronize:(NSNotification*)notification;

@end
