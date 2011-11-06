//
//  newsDetailViewController.h
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 22/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>



@interface newsDetailViewController : UIViewController <UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
    NSURL *url;
    NSString *gloabalHTML;  //my global var to carry contents 
    
    
}


@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURL *url;



-(void) downloadNews :(NSURL *)newsURL;
-(void) copyResponseString :(NSString *)responseHTML;
-(NSString *)stringScanner:(NSString *) stringToScan;
-(void) loadWebView;
@end
