//
//  countriesDataModel.m
//  FCOdata
//
//  Created by denis bosire on 17/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "countriesDataModel.h"


@implementation countriesDataModel
//=============get/set===========
@synthesize  countryName;
@synthesize  flagURL;
@synthesize  address;
@synthesize  designation;
@synthesize  email;
@synthesize  locationName;
@synthesize  lat, lng;
@synthesize  officeHours;
@synthesize  phone;
@synthesize  url;


///=========implementation==========
-(id) init:(NSString *)_countryName :(NSString *)_flagURL :(NSString *)_address :(NSString *)_designation :(NSString *)_email :(NSString *)_locationName :(NSString *)_officeHours :(NSString *)_phone :(NSString *)_url :(NSInteger)_lat :(NSInteger)_lng {
    
    if (self == [super init]) {
        self.countryName = _countryName;
        self.flagURL = _flagURL;
        self.address = _address;
        self.designation = _designation;
        self.email = _email;
        self.locationName = _locationName;
        self.officeHours = _officeHours;
        self.phone = _phone;
        self.url = _url;
        self.lat = _lat;
        self.lng=_lng;
    }
    return self;
}
-(id)init {
	return [super init];
}


@end
