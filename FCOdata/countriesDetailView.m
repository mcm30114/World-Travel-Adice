//
//  countriesDetailView.m
//  FCOdata
//
//  Created by Edwin on 19/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "countriesDetailView.h"
#import "MyLocation.h"
#define METERS_PER_MILE 1609.344

@implementation countriesDetailView
@synthesize  countryTitle;
@synthesize location;
@synthesize designation;
@synthesize address, flagImage;
@synthesize dataSet;
@synthesize _index;
@synthesize segmentControl;
@synthesize banner;
@synthesize contentView;
@synthesize scrollView;
@synthesize isAdBannerViewVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(id) initwithName :(NSString *)_countryTitle :(NSString *)_location :(NSString *)_designation:(NSString *)_address :(UIImage *)_flagImage{
    self.countryTitle.text = _countryTitle;
    self.location.text = _location;
    self.designation.text=_designation;
    self.address.text=_address;
    self.flagImage.image=_flagImage;
    
    return self;
}

- (id)initWithItem:(NSMutableArray *)theItem :(NSUInteger)indx{
    self.dataSet = theItem;
    self._index = (NSUInteger)indx;

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
    banner.delegate = nil;
    [banner release]; banner = nil; 
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
    //set the nav bar

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
    
    //iAd integration
    banner.delegate = self;
    self.banner.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    
    [self layoutForCurrentOrientation:NO];


}
-(void) viewWillAppear:(BOOL)animated{
    animated = YES;
    [self layoutForCurrentOrientation:NO];
    NSDictionary *jsonDict;
    //jsonDict= [dataSet valueForKeyPath:@"country"];
    jsonDict= [[self.dataSet objectAtIndex:_index] objectForKey:@"country"];
    
    //======================Retrieve Elements=================================
    _name = [jsonDict valueForKey:@"name"];
    id _flagURL = [jsonDict valueForKey:@"flag_url"];
    
    NSString *checkedURL = [NSString stringWithFormat:@"%@", _flagURL];
    NSLog(@"url %@",checkedURL);
    NSArray *_address = [[[jsonDict valueForKey:@"embassies"]
                          valueForKey:@"address"]valueForKey:@"plain"];
    NSArray *_designation = [[jsonDict valueForKey:@"embassies"]
                             valueForKey:@"designation"];
    NSArray *_locationName = [[jsonDict valueForKey:@"embassies"]
                              valueForKey:@"location_name"];
    NSArray *_officeHours = [[[jsonDict valueForKey:@"embassies"]
                              valueForKey:@"office_hours"]
                             valueForKey:@"plain"];
    NSArray *_phone = [[jsonDict valueForKey:@"embassies"]
                       valueForKey:@"phone"];
    NSArray *_lat = [[jsonDict valueForKey:@"embassies"]
                     valueForKey:@"lat"];
    NSArray *_lng = [[jsonDict valueForKey:@"embassies"]
                     valueForKey:@"long"];
    if(!_designation) 
        [_designation arrayByAddingObject:@"Not Available"];
    
    
    //checking for nulls
    NSArray *_embassy = [jsonDict valueForKey:@"embassies"];
    if (_embassy.count == 0) {
        NSLog(@"no information available");
    }
    if (_designation.count == 0) {
        NSLog(@"some data missing");
        _designation = [NSArray arrayWithObject: @""];
    }if (_locationName.count == 0) {
        _locationName = [NSArray arrayWithObject: @""];
    }if (_officeHours.count == 0) {
        _officeHours= [NSArray arrayWithObject: @"Not Available"];
    }if (_address.count == 0) {
        _address = [NSArray arrayWithObject: @"Not Available"];
    }if (_phone.count == 0) {
        _phone = [NSArray arrayWithObject: @"Not Available"];
    }if ([_lng count]==0) {
        _lat = [NSArray arrayWithObject:@"0.00"];
        _lng = [NSArray arrayWithObject:@"0.00"];
    }if ((NSNull *)_flagURL == [NSNull null]) {
        NSLog(@"flag url is empty");
        _flagURL = @"http://bentilden.com/images/placeholder.png";
    }
    
    
    //====================Assign Labels=========================================
    //self.title = _name;
    countryTitle.text = _name;//[NSString stringWithFormat:@"%@",_name];
    NSString *locat = [NSString stringWithFormat:@"%@",[_locationName objectAtIndex:0]];
    NSString *desig =[NSString stringWithFormat:@"%@",[_designation objectAtIndex:0]];
    designation.text = [NSString stringWithFormat:@"%@,  %@",desig, locat];
    address.text =[NSString stringWithFormat:@"%@",[_address objectAtIndex:0]];
    NSURL *url = [NSURL URLWithString:_flagURL];
    UIImage *tmpIMG = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    flagImage.image = tmpIMG;
    
    //===================deal with mkmaps here =================================
    CLLocationCoordinate2D zoomLocation;
    NSString *latt = [NSString stringWithFormat:@"%@",[_lat objectAtIndex:0]];
    NSString *lngg = [NSString stringWithFormat:@"%@",[_lng objectAtIndex:0]];
    zoomLocation.latitude = latt.doubleValue;
    zoomLocation.longitude= lngg.doubleValue;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance
    (zoomLocation,10*METERS_PER_MILE, 10*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    
    MyLocation *annotation = [[[MyLocation alloc] initWithName:_name address:desig coordinate:zoomLocation] autorelease];
    [mapView addAnnotation:annotation];
    
    //[_address retain];
    
    

}
-(void) setResponse :(NSString *) string{
    response = [[NSString alloc] initWithString:string];
}

-(void) returnFullDetails{
    NSString *urlString = [NSString stringWithFormat:@"http://fco.innovate.direct.gov.uk/countries/%@/travel_advice_full", _name];
    
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
                                  initWithTitle:@"Error" message:@"There is a Problem" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }//alert
   /*was there a response, if so store it in a string*/
    if (data !=nil) {
        /*make a string out of this data */
        NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
    banner.delegate = nil;
	[banner removeFromSuperview];
	
	self.contentView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)bannerViewDidLoadAd:(ADBannerView *)Abanner
{   
   
        isAdBannerViewVisible = YES;
        [self layoutForCurrentOrientation:YES];
    
    
   
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd has failed");
    
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
