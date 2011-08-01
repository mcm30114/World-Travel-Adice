//
//  countriesDetailView.h
//  FCOdata
//
//  Created by Edwin on 27/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>
@interface countriesDetailView : UIViewController <UIWebViewDelegate, ADBannerViewDelegate>{
    IBOutlet UILabel *  countryTitle;
    IBOutlet UILabel * location;
    IBOutlet UILabel * designation;
    IBOutlet UILabel * address; 
    IBOutlet UIImageView* flagImage;
    IBOutlet UIWebView *webView;
    IBOutlet UIView *secondView;
    IBOutlet MKMapView *mapView;
    NSMutableArray * dataSet;
    NSUInteger  _index;
    UISegmentedControl * segmentControl;
    UIScrollView *scrollView;
    
    
    NSString *response;
    NSString *_name;
    
    UIView *contentView;
    ADBannerView *banner;
    BOOL isAdBannerViewVisible;

}
@property (nonatomic, retain) UILabel *  countryTitle;
@property (nonatomic, retain) UILabel * location;
@property (nonatomic, retain) UILabel * designation;
@property (nonatomic, retain) UILabel * address;
@property (nonatomic, retain) UIImageView *flagImage;
@property (nonatomic, retain) NSMutableArray * dataSet;
@property (nonatomic, readwrite) NSUInteger  _index;
@property (nonatomic, retain) UISegmentedControl * segmentControl;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL isAdBannerViewVisible;

- (id)initWithItem:(NSMutableArray *)theItem :(NSUInteger)indx;
-(void) swapViews;
-(void) setResponse :(NSString *) string;
-(void) returnFullDetails;
-(void) loadWebView :(NSString *) html;
-(NSString *) scanHTML :(NSString *)htmlToScan;
-(NSString *) stringScan :(NSString *)string;
-(NSString *) loadHTMLFile;

-(void)layoutForCurrentOrientation:(BOOL)animated;

@end