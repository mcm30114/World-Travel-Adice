//
//  retrieveData.h
//  FCOdata
//
//  Created by Edwin on 21/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "newsItem.h"
@interface retrieveData : NSObject {
    NSString *responseString;
    newsItem *_newsItem;
}
-(void)grabData :(NSURL*)url;


@end
