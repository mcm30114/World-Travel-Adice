//
//  countriesDetailView.h
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 27/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
/*
 note to self : for the next version of this app, split up this class into two separate
 view controllers!!
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>
#import <CoreData/CoreData.h>
@interface countriesDetailView : UIViewController <UIWebViewDelegate>{
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
    UIView *secondContentView;
   
    //coredata
    NSManagedObject *managedObject;
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
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *secondContentView;
@property (nonatomic, retain) NSManagedObject *managedObject;

- (id)initWithItem:(NSManagedObject *)theItem;
-(void) swapViews;
-(void) setResponse :(NSString *) string;
-(void) returnFullDetails;
-(void) loadWebView :(NSString *) html;
-(NSString *) scanHTML :(NSString *)htmlToScan;
-(NSString *) stringScan :(NSString *)string;
-(NSString *) loadHTMLFile;


@end