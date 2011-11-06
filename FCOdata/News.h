//
//  News.h
//  FCOdata
//
//  Created by Edwin on 26/08/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface News : NSManagedObject

@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * pudDate;
@property (nonatomic, retain) NSString * article;
@property (nonatomic, retain) NSString * titles;

@end
