//
//  newsDataAgent.h
//  FCOdata
//
//  Created by Edwin on 21/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface newsItem : NSObject {
    NSString *newsTitle;
    NSString *description;
    NSString *pubDate;
    NSString *news;
}

@property (nonatomic, retain) NSString *newsTitle;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *pubDate;
@property (nonatomic, retain) NSString *news;
@end
