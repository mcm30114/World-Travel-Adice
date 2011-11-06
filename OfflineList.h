//
//  OfflineList.h
//  FCOdata
//
//  Created by Edwin on 25/08/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OfflineList : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * designation;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * officeHours;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end
