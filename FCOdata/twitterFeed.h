//
//  twitterFeed.h
//  FCOdata
//
//  Created by Edwin on 27/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface twitterFeed : UITableViewController {
    NSArray *_items;
}
@property (nonatomic, retain) NSArray *_items;

-(void) dataItems:(NSArray *) theResponse;
- (void)grabURLInBackground;
@end
