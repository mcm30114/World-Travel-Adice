//
//  SecondViewController.h
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface SecondViewController : UIViewController {
    IBOutlet UITextView *contact;
}
@property  (nonatomic, retain) UITextView *contact;

// Layout the Ad Banner and Content View to match the current orientation.
// The ADBannerView always animates its changes, so generally you should
// pass YES for animated, but it makes sense to pass NO in certain circumstances
// such as inside of -viewDidLoad.


@end
