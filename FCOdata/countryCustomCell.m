//
//  countryCustomCell.m
//  FCOdata
//
//  Created by Edwin on 25/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "countryCustomCell.h"


@implementation countryCustomCell
@synthesize textLabel;
@synthesize thumbnail;

- (void)dealloc
{
    [super dealloc];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
