//
//  countriesDetailView.m
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 19/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import "countriesDetailView.h"
#import "MyLocation.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define METERS_PER_MILE 1609.344

@implementation countriesDetailView
@synthesize  countryTitle;
@synthesize location;
@synthesize designation;
@synthesize address, flagImage;
@synthesize dataSet;
@synthesize _index;
@synthesize segmentControl;
@synthesize contentView;
@synthesize scrollView;
@synthesize secondContentView;
@synthesize managedObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (id)initWithItem:(NSManagedObject *)theObject{
    self.managedObject = theObject;
    self.hidesBottomBarWhenPushed  =YES;
    return self;   
}

//swap the views when the user taps the segment controll
-(void) swapViews{
    switch ([segmentControl selectedSegmentIndex]) {
        case 0:
        {
            NSLog(@"segment1 selected");
            
             [secondView removeFromSuperview];
        }
            break;
            case 1:
        {
            NSLog(@"segment2 selected");
           [self.view addSubview:secondView];
           [self returnFullDetails];
            if (response) {
                [self loadWebView:response];
            }
            
        }
            break;
    }
    
}

- (void)dealloc
{
    [countryTitle release];
    [location release];
    [designation release];
    [address release];
    [flagImage release];
    
    [contentView release]; contentView = nil;
    [secondContentView release]; secondContentView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set the background
    self.view.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"carbon_fibre_v2.png"]];

    /*set up the webView*/
    webView.delegate = self;
    flagImage.autoresizingMask = UIViewAutoresizingNone;
    //init the segmented control
    NSArray *items = [[[NSArray alloc] initWithObjects:@"Brief", @"Full", nil] autorelease];

    segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentControl.segmentedControlStyle = UISegmentedControlStyleBezeled;
    segmentControl.tintColor = [UIColor darkGrayColor];
    [segmentControl addTarget:self
                       action:@selector(swapViews)
             forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    segmentControl.selectedSegmentIndex=0;
    self.navigationItem.rightBarButtonItem= barItem;
    
    
    [barItem release];
    //populate Data
    countryTitle.text = [managedObject valueForKey:@"name"];
    designation.text = [managedObject valueForKey:@"designation"];
    NSLog(@"designation %@",[managedObject valueForKey:@"designation"]);
    location.text = [managedObject valueForKey:@"city"];
    address.text = [managedObject valueForKey:@"address"];
    
    
    //===================deal with mkmaps here =================================
    CLLocationCoordinate2D zoomLocation;
    NSString *lat = [managedObject valueForKey:@"latitude"];
    NSString *lng = [managedObject valueForKey:@"longitude"];
    zoomLocation.latitude = lat.doubleValue;
    zoomLocation.longitude= lng.doubleValue;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance
    (zoomLocation,10*METERS_PER_MILE, 10*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    
    MyLocation *annotation = [[[MyLocation alloc] initWithName:[managedObject valueForKey:@"name"]
                                                       address:[managedObject valueForKey:@"designation"]
                                                    coordinate:zoomLocation] autorelease];
    [mapView addAnnotation:annotation];

}
-(void) viewWillAppear:(BOOL)animated{
    CALayer *layer = flagImage.layer;
    layer.masksToBounds = YES;
    [layer setCornerRadius:1.0];
    layer.borderWidth=0.8;
    layer.borderColor=[[UIColor blackColor] CGColor];
    [flagImage setImageWithURL:[NSURL URLWithString:
                                [managedObject valueForKey:@"thumbnail"]]
              placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];

    CALayer *layer2 = mapView.layer;
    layer2.masksToBounds = YES;
    [layer2 setCornerRadius:1.0];
    layer2.borderWidth=0.8;
    layer2.borderColor=[[UIColor blackColor] CGColor];
   
    //jsonDict= [dataSet valueForKeyPath:@"country"];
    }
-(void) setResponse :(NSString *) string{
    response = [[NSString alloc] initWithString:string];
}

-(void) returnFullDetails{
    NSString *urlString = [NSString stringWithFormat:@"http://fco.innovate.direct.gov.uk/countries/%@/travel_advice_full", [managedObject valueForKey:@"name"]];
    
    //we are going to use a blocking synchronous call for this piece of data
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[request setDownloadProgressDelegate:self];
    NSError *error = nil;

    NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                         returningResponse:nil
                                                     error:&error];
    /*handle any errors*/
    if(error){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error" message:@"Sorry, The information you requested is not currently available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }//alert
   /*was there a response, if so store it in a string*/
    if (data !=nil) {
        /*make a string out of this data */
        NSString *responseData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
        [self setResponse:responseData];
        
    }
    
    
}
-(void) loadWebView :(NSString *) html{
    /*set the baseURL to bundles local directory */
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    

    
    
    /*fire up the scanner*/
    NSString *bodyHTML = [self scanHTML:html];
    NSString *HTMLStyling = [self loadHTMLFile];
    
    NSString *modedHTML = [HTMLStyling stringByAppendingFormat:@"%@",bodyHTML];
    /* load webview with modded html*/
    [webView loadHTMLString:modedHTML baseURL:baseURL];
}
-(void) webViewDidFinishLoad:(UIWebView *)webViewer{
   
     
   
}
-(NSString *) scanHTML :(NSString *)htmlToScan{
    NSString *HEADER = @"<div id=\"content\">";
    NSString *CONTENT;
    NSString *END = @"<div id=\"health\" class=\"section\">  ";
    NSScanner *theScanner =[NSScanner scannerWithString:htmlToScan];
    while (!(theScanner.isAtEnd)) {
        if ([theScanner scanUpToString:HEADER intoString:NULL]&&
            [theScanner scanUpToString:END intoString:&CONTENT]) {
        }
    }
    return CONTENT;
}
-(NSString *) stringScan :(NSString *)string{
    NSRange beginning = [string rangeOfString:@"<div id=\"content\">"];
    NSRange ending    = [string rangeOfString:@"</div>"];
    NSRange finale;
    int length = ending.location - beginning.location - ending.length;
    int loco=ending.location + ending.length;
    finale.location = loco;
    finale.length = length;
    NSString *contents = [contents substringWithRange:finale];
    
    return contents;
}
-(NSString *) loadHTMLFile{
    NSString *bundlePath = [[NSBundle mainBundle] 
                            pathForResource:@"template" ofType:@"txt"];
    NSError *error = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:&error]; 
    
    if(error){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"File Not Found!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }//alert
    return fileContents;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   
	
	self.contentView = nil;
    self.secondContentView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
