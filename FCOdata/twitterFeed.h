//
//  twitterFeed.h
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 27/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface twitterFeed : UITableViewController {
    NSArray *_items;
    dispatch_queue_t backgroundThread;
    NSMutableArray *thumbnails;
}
@property (nonatomic, retain) NSArray *_items;

-(void) dataItems:(NSArray *) theResponse;
- (void)grabURLInBackground;
- (void)threadImageDownloader;
@end
