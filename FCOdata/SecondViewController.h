//
//  SecondViewController.h
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface SecondViewController : UIViewController<ADBannerViewDelegate> {
    UIView *contentView;
    IBOutlet UITextView *contact;
    ADBannerView *banner;
}
@property  (nonatomic, retain) UITextView *contact;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property  (nonatomic, retain) IBOutlet ADBannerView *banner;

// Layout the Ad Banner and Content View to match the current orientation.
// The ADBannerView always animates its changes, so generally you should
// pass YES for animated, but it makes sense to pass NO in certain circumstances
// such as inside of -viewDidLoad.
- (void)layoutForCurrentOrientation:(BOOL)animated;


@end
