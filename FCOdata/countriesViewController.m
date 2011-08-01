//
//  countriesViewController.m
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "countriesViewController.h"

#import "ASIHTTPRequest.h"
#include "SBJson.h"
#import "asyncimageview.h"
#import "countriesDetailView.h"
#import "UIImageView+WebCache.h"
#import "UIImageCategories.h"
#import "countryCustomCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomNavigationBar.h"
#import "UINavigationBarCategory.h"


@implementation countriesViewController
@synthesize _dataItems;
@synthesize  _response;
@synthesize dataModel;
@synthesize searchBar;
@synthesize searchResults;
@synthesize  savedSearchTerm;
@synthesize reverse;
@synthesize imageURL;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [dataModel release];
    [_dataItems release];
    [_response release];
    [searchBar release];
    [searchResults release];
    [savedSearchTerm release];
     [  reverse release];
     [  imageURL release];
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
    //customize the navigation bar
    // Get our custom nav bar
   // CustomNavigationBar* customNavigationBar = (CustomNavigationBar*)self.navigationController.navigationBar;
    
    // Set the nav bar's background
    //UIImage *background = [UIImage imageNamed:@"BarBackground.png"];
    //[customNavigationBar setBackgroundWith:background];
    

    // Instead of a custom back button, use the standard back button with a dark gray tint
    //customNavigationBar.tintColor = [UIColor darkGrayColor];
    self.title = @"Countries";
    //self.navigationController.navigationBar.backItem.title = @"back";

    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(grabData)];
   
    
    self.navigationItem.rightBarButtonItem = refreshButton;
  
    // Restore search term
	if ([self savedSearchTerm])
	{   
        
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
    [self grabData];
    [refreshButton release];   
}

+(NSString *) dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    return [docDirectory stringByAppendingFormat:@"cache.txt"];
}
-(void) grabData{
    NSURL *url = [NSURL URLWithString:@"http://fco.innovate.direct.gov.uk/countries.json"];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        
        NSString * responseString = [request responseString];
        NSMutableArray *results = [responseString JSONValue];
        
        // NSMutableArray *allNames = [results objectForKey:@"country"];
        if (results != NULL) {
            [self downloadPublicData:results]; 
            
            for (int ndx=0; ndx <[results count]; ndx++) {
                NSDictionary *jsonDict= [_dataItems objectAtIndex:ndx];
                dataModel.countryName= [[jsonDict objectForKey:@"country"]objectForKey:@"name"];
                dataModel.flagURL = [[jsonDict objectForKey:@"country"]objectForKey:@"flag_url"];
            }
            
        }else{
            NSLog(@"results is empty");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error" message:@"No information available, try again later" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        

    }];
    //[self.tableView reloadData];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if(error){
            UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error" message:@"There is a Problem" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
        }//alert
    }];
    [request startAsynchronous];
    
}
-(void) downloadPublicData :(NSMutableArray *) array{
    self._dataItems = array;
    //releod table with fresh data
    [self.tableView reloadData];

    
    
}
-(UIImage *)scale:(UIImage *)image toSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"scaledImage returned");
    return scaledImage;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[self setSavedSearchTerm:searchTerm];
	
	if ([self searchResults] == nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
        //[self setReverse:array];
		[array release], array = nil;
	}
	
	[[self searchResults] removeAllObjects];
    if ([self reverse] == nil){
        NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setReverse:array];
        //[self setReverse:array];
		[array release], array = nil;
        
    }else {
    [[self reverse] removeAllObjects];
	}
    if ([self imageURL] == nil){
        NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setImageURL:array];
        //[self setReverse:array];
		[array release], array = nil;
        
    }else {
        [[self imageURL ] removeAllObjects];
	}
    
	if ([[self savedSearchTerm] length] != 0)
	{   
       		for (NSDictionary *dict in  _dataItems)
		{   
            NSString *currentString = [[dict objectForKey:@"country"]objectForKey:@"name"];
            NSString *thumb = [[dict objectForKey:@"country"] objectForKey:@"flag_url"];

			if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[[self searchResults] addObject:currentString];
                [[self reverse] addObject:dict];
                [[self imageURL] addObject:thumb];
               // NSLog(@"reverse %@",reverse);
			}
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    if (_dataItems.count >0){ 
        rows = [_dataItems count]; 
    }
    if (tableView ==[[self searchDisplayController] searchResultsTableView]){
        rows = [[self searchResults] count];
    }if (_dataItems.count ==0) {
        rows=1;
    } { 
        
    }
    NSLog(@"rows is: %d", rows);
    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    return 83;
}/*
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray *index = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",
                      @"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",
                      @"V",@"W",@"X",@"Y",@"Z", nil];
    return index;
}
  */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *PlaceHolderCellIdentifier = @"placeholder";
    
    //add a placeholder cell as we await data
    int nodeCount = [self._dataItems count];
    if (nodeCount == 0 && indexPath.row ==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceHolderCellIdentifier ];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceHolderCellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        
        cell.textLabel.text = @"                  Loading.....";
        
        return cell;
    }
    NSString *contentForthisRow =nil;
    NSString *urlForThumb = nil;
    NSInteger row = [indexPath row];
    NSDictionary *jsonDict= [_dataItems objectAtIndex:[indexPath row]];
    contentForthisRow = [[jsonDict objectForKey:@"country"]objectForKey:@"name"];
    NSString* url   = [NSString stringWithFormat:@"%@",[[jsonDict objectForKey:@"country"]objectForKey:@"flag_url"]];
    if ((NSNull *)url == [NSNull null]) {
        NSLog(@"flag url is empty");
        url = @"http://bentilrden.com/images/placeholder.png";
    }
    
        
    countryCustomCell *cell = nil;
    
    cell  = (countryCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]
                                    loadNibNamed:@"countryCustomCell"
                                    owner:nil options:nil];
        for (id currentObject in  topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (countryCustomCell *)currentObject;
                CALayer *layer = cell.imageView.layer;
                layer.masksToBounds = YES;
                [layer setCornerRadius:8.0];
                layer.borderWidth=1.5;
                layer.borderColor=[[UIColor grayColor] CGColor];
                break;
            }
        }
    }
    
    // Configure the cell...
    if ((tableView == [[self searchDisplayController] searchResultsTableView])&
    (searchResults !=nil)){
        contentForthisRow = [[self searchResults] objectAtIndex:row];
        urlForThumb = [[self imageURL] objectAtIndex:row];
        if ((NSNull *)urlForThumb == [NSNull null]) {
            NSLog(@"flag url is empty");
            urlForThumb = @"http://bentilden.com/images/placeholder.png";
        }else{
        url = urlForThumb;
        }
    }if (_dataItems !=nil){
     

        [cell.imageView setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];

         
        cell.textLabel.text = contentForthisRow;
    } else {
        cell.textLabel.text = @"    Loading...";
    }
    
    return cell;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self handleSearchForTerm:searchString];
    return YES;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [self.tableView reloadData];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSMutableArray *items;
    
    if ((tableView == [[self searchDisplayController] searchResultsTableView])&
        (searchResults !=nil)){
               items = [[[NSMutableArray alloc] initWithArray:reverse]autorelease ];

    }else{
        items = [[NSMutableArray alloc] initWithArray:_dataItems];
        
    }
    //NSLog(@"the index path %@",[indexPath row]);

     countriesDetailView *detailViewController = [[countriesDetailView alloc] initWithItem:items :[indexPath row]];
   
     //get the data
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];

     [detailViewController release];
     
}

@end
