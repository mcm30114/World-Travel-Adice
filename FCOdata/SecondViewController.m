//
//  SecondViewController.m
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "FCOdataAppDelegate.h"   //for shared add banner
#import <iAd/iAd.h>

@implementation SecondViewController
@synthesize contact;
@synthesize contentView;
@synthesize banner;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contact.editable = NO;
    self.contact.dataDetectorTypes = UIDataDetectorTypeAll;
    
    banner.delegate = self;
    self.banner.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    
    [self layoutForCurrentOrientation:NO];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutForCurrentOrientation:NO];
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

 	self.contentView = nil;
    banner.delegate = nil;
    self.banner = nil;
}


- (void)dealloc
{
    
    [contentView release]; contentView = nil;
    banner.delegate = nil;
    [banner release]; banner = nil; 
    [super dealloc];
}
-(void)layoutForCurrentOrientation:(BOOL)animated
{
    CGFloat animationDuration = animated ? 0.2f : 0.0f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0f;
    
	
    self.banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    bannerHeight = self.banner.bounds.size.height;
	
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if(self.banner.bannerLoaded)
    {
        contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
    }
    else
    {
		bannerOrigin.y += bannerHeight;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         contentView.frame = contentFrame;
                         [contentView layoutIfNeeded];
                         self.banner.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y, self.banner.frame.size.width, self.banner.frame.size.height);
                     }];
}
#pragma mark -
#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutForCurrentOrientation:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutForCurrentOrientation:YES];

    
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	
}

@end
