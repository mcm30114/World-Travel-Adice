//
//  newsDetailViewController.h
//  FCOdata
//
//  Created by Edwin on 22/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>



@interface newsDetailViewController : UIViewController <UIWebViewDelegate, ADBannerViewDelegate>{
    IBOutlet UIWebView *webView;
    NSURL *url;
    NSString *gloabalHTML;  //my global var to carry contents 
    
    UIView *contentView;
    ADBannerView *banner;
}


@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) IBOutlet  UIView *contentView;
@property (nonatomic, retain) IBOutlet     ADBannerView *banner;


-(void)layoutForCurrentOrientation:(BOOL)animated;
-(void) downloadNews :(NSURL *)newsURL;
-(void) copyResponseString :(NSString *)responseHTML;
-(NSString *)stringScanner:(NSString *) stringToScan;
-(void) loadWebView;
@end
