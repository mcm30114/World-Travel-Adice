//
//  countriesDataModel.h
//  FCOdata
//
//  Created by denis bosire on 17/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface countriesDataModel : NSObject {
    NSString *countryName;
    NSString *flagURL;
    NSString *address;
    NSString *designation;
    NSString *email;
    NSString *locationName;
    NSInteger lat, lng;
    NSString *officeHours;
    NSString *phone;
    NSString *url;
    
}
//============set/get========
@property (nonatomic, retain) NSString *countryName;
@property (nonatomic, retain) NSString *flagURL;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *designation;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, retain) NSString *officeHours;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, readwrite) NSInteger lat;
@property (nonatomic, readwrite) NSInteger lng;




@end
