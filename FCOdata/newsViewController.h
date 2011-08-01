//
//  newsViewController.h
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface newsViewController : UITableViewController {
    NSString *responseString;
    NSArray *titles;
    NSArray *desc;
    NSArray *url;
    NSArray *pubDate;
    
    UIView *contentView;
    ADBannerView *banner;
    
}



-(void) grabData :(NSURL *)_myURL;
-(void)refreshData;

@end
