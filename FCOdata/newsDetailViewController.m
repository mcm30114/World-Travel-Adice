//
//  newsDetailViewController.m
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 22/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import "newsDetailViewController.h"
#import "ASIHTTPRequest.h"

@implementation newsDetailViewController
@synthesize url;
@synthesize webView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{


    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"News";
    

}
-(void) viewWillAppear:(BOOL)animated{
    [self downloadNews:url];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
 

}


                 /*my tailored methods */
#pragma mark - html template
/* download the news item synchronously, there shouldnt be a perfomance hit
 //change of mind, synchronous is BAD! implementing synchronous calls*/
-(void) downloadNews :(NSURL *)newsURL{
    //create a request
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:newsURL];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{

    // Use when fetching binary data
    NSData *data = [request responseData];
    //instantiate a string type and populate appropriately only if data is downloaded
    if (data !=nil) {
        /*make a string out of this data */
        NSString *responseData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
        //call copyResponseString and pass the response string as parameter
        
        [self copyResponseString:responseData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    //check for errors, if none progress
    if(error){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"There is a Problem" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }//alert

}
/*copy the response to the global variable to be accenssible throughout the program*/
-(void) copyResponseString :(NSString *)responseHTML{
    gloabalHTML = [NSString stringWithString:responseHTML];
    [gloabalHTML retain];
   //once that is done, call loadwebview
    [self loadWebView];
}

/*extract the exact information needed, discard the rest of the page, return 
 "parsed" string containg this information*/
-(NSString *)stringScanner:(NSString *) stringToScan{

    
    NSString *HEADER = @"<div id=\"Main\">";
    NSString *CONTENT;
    NSString *END = @"<h3>Further information</h3>";
    NSScanner *theScanner =[NSScanner scannerWithString:stringToScan];
    while (!(theScanner.isAtEnd)) {
        if ([theScanner scanUpToString:HEADER intoString:NULL]&&
            [theScanner scanUpToString:END intoString:&CONTENT]) {
            
        }
    }//NSLog(@"no header %@",CONTENT);
    return CONTENT;
}

/* load the webview, but first set the bundlePath, retrieve html template and then 
 append these to one string which is loaded onto uiwebview*/
-(void) loadWebView{
    
    /*call stringScanner
    call the stringScanner and pass this variable
    i understand that it is a glabal variable, but by assuming that it wont
    be a nil when stringScanner was fired introduced some bugs
     */
    
    NSString *cleanHTML = [self stringScanner:gloabalHTML];
    
    //set the path for the bundle
    NSString *bundlePath = [[NSBundle mainBundle] 
                            pathForResource:@"newsTemplate" ofType:@"txt"];
    NSError *error = nil;
    
    //retrieve html template as a string
    NSString *fileContents = [[NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:&error]autorelease]; 
    [fileContents retain];
    //usual error mechanism
    if(error){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" 
                              message:@"File Not Found!" 
                              delegate:self 
                              cancelButtonTitle:@"Cancel" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }//alert

    
    
    //concatenate template + parsed information
    NSString *fullHTML = [fileContents stringByAppendingString:cleanHTML];
    //load uiwebview
    /*set the baseURL to bundles local directory */
    /* when baseURL set, images on from the site dont load, bad code, very bad code!!
     NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    */
     [webView loadHTMLString:fullHTML baseURL:[NSURL URLWithString:@"http://www.fco.gov.uk/"]];
}


@end
