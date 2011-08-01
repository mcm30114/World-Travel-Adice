//
//  countriesViewController.h
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "countriesDataModel.h"
#import "asynchImage.h"


@interface countriesViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>{
    countriesDataModel *dataModel;
    NSMutableArray      *_dataItems;
    NSString            *_response;
    asynchImage         *getImage;
    UISearchBar         *searchBar;
    NSMutableArray      *searchResults;
    NSString            *savedSearchTerm;
    NSMutableArray      *reverse;
    NSMutableArray      *imageURL;
    UISearchDisplayController *searchBarController;
}

@property (nonatomic, retain)   countriesDataModel *dataModel;
@property (nonatomic, copy)     NSMutableArray *_dataItems;
@property (nonatomic, retain)   NSString *_response;
@property (nonatomic, retain)   UISearchBar *searchBar;
@property (nonatomic, retain)   NSMutableArray *searchResults;
@property (nonatomic, retain)   NSString *savedSearchTerm;
@property (nonatomic, retain)   NSMutableArray *reverse;
@property (nonatomic, retain)   NSMutableArray *imageURL;

-(void) grabData;
-(void) downloadPublicData:(NSMutableArray *) array;

-(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
-(void) handleSearchForTerm:(NSString *)searchTerm;

@end
