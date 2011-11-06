//
//  countriesViewController.m
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
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
#import "offlineModeDataStore.h"
#import "OfflineList.h"

@implementation countriesViewController
@synthesize _dataItems;
@synthesize  _response;
@synthesize dataModel;
@synthesize searchBar;
@synthesize searchResults;
@synthesize  savedSearchTerm;
@synthesize reverse;
@synthesize imageURL;
@synthesize OflineModeDataStore;
@synthesize offlineList;
@synthesize contentForthisRow;
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunrise.jpg"]];
    UIImage *image = [UIImage imageNamed:@"WorldMapGlowing.png"];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:image];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = bgImage;
    self.searchDisplayController.searchResultsTableView.backgroundView = bgImage;
    //initialize offlinemodedatasource
    OflineModeDataStore = [[offlineModeDataStore alloc]init];
    _dataItems = [[OflineModeDataStore countryList]retain];
    //offlineList = [[OfflineList alloc] init];
    self.title = @"Countries";
    //self.navigationController.navigationBar.backItem.title = @"back";

    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(grabData)];
   
    
    self.navigationItem.rightBarButtonItem = refreshButton;
	
   
    [refreshButton release];   
    if (_dataItems.count ==0) {
        [self grabData];
    }
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
            [self performSelectorOnMainThread:@selector(downloadPublicData:) withObject:results waitUntilDone:YES];
            //[self downloadPublicData:results]; 
            
          
            
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
                                      initWithTitle:@"Error" message:@"Please Check Your Network and Try Again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
        }//alert
    }];
    [request startAsynchronous];
    
}
-(void) downloadPublicData :(NSMutableArray *) array{
    
    [self performSelectorInBackground:@selector(synchronizeData:) withObject:array];
    NSLog(@"process sent to background thread");
    
}
-(void)reloadTable{
    
    [_dataItems release];
    self._dataItems = [[OflineModeDataStore countryList]retain];
    [self.tableView reloadData];
    NSLog(@"table reloaded from notification");
}

//method perfomed in background thread
- (void)synchronizeData:(NSArray*)data 
{
    
    //listen for a notification with the name of the identifier
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(dataDidSynchronize:) 
                                                 name:@"countryListDidSynchronize" 
                                               object:nil];
    NSLog(@"synchronize data method called");
    
    [OflineModeDataStore synchronizecountryList:data];

}
//this is also in the background thread
- (void)dataDidSynchronize:(NSNotification*)notification 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //update the UI on the main thread
   NSLog(@"refreshUI called on main thread with notif ");
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
}


-(UIImage *)scale:(UIImage *)image toSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"scaledImage returned");
    return scaledImage;
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
    NSInteger rowNumber;
    if (fetchedObjects !=nil) {
        rowNumber = [fetchedObjects count];
    }else{
        rowNumber = [[[OflineModeDataStore countryList]valueForKey:@"name"]count];
    }
    return rowNumber;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    return 50;
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
    //[[[OflineModeDataStore countryList]valueForKey:@"name"]objectAtIndex:indexPath.row];static NSString *PlaceHolderCellIdentifier = @"placeholder";
    contentForthisRow = nil;
    NSString *urlForThumb=nil;
    if (tableView ==self.tableView) {
        
    
    offlineList = [OflineModeDataStore.fetchedResultsController objectAtIndexPath:indexPath];
    //NSLog(@"oflinelist %@", offlineList.name);
        contentForthisRow =[[_dataItems objectAtIndex:[indexPath row]] valueForKey:@"name"];
    //[contentForthisRow stringByAppendingString:[offlineList name]];
        NSString* url   =[[_dataItems objectAtIndex:[indexPath row]] valueForKey:@"thumbnail"];
        urlForThumb = url;
        if ((NSNull *)url == [NSNull null]) {
            NSLog(@"flag url is empty");
            url = @"http://bentilrden.com/images/placeholder.png";
            urlForThumb = url;
        }
    }if (tableView == self.searchDisplayController.searchResultsTableView) {
        offlineList = [OflineModeDataStore.fetchedResultsControllerSearch objectAtIndexPath:indexPath];
        
        //NSLog(@"oflinelist %@", offlineList.name);
       contentForthisRow = offlineList.name;
        NSString* url   = offlineList.thumbnail;
        urlForThumb = url;
        if ((NSNull *)url == [NSNull null]) {
            NSLog(@"flag url is empty");
            url = @"http://bentilrden.com/images/placeholder.png";
            urlForThumb = url;
        }
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
                [layer setCornerRadius:1.0];
                layer.borderWidth=0.8;
                layer.borderColor=[[UIColor blackColor] CGColor];
                break;
            }
        }
    }
    
    // Configure the cell...
        [cell.imageView setImageWithURL:[NSURL URLWithString:urlForThumb]
                       placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];

         
        //cell.textLabel.text = contentForthisRow;
        cell.textLabel.text = contentForthisRow;
        
   
    
    
    return cell;
}

#pragma mark - SearchController Delegates
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    
    return YES;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{   
    //NSLog(@"search text %@", searchText);
    NSError *error = nil;
    
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name  contains[cd] %@", searchText];
        [self.OflineModeDataStore.fetchedResultsControllerSearch.fetchRequest setPredicate:predicate];
    	
   
    if (![OflineModeDataStore.fetchedResultsControllerSearch performFetch:&error])
    {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    // this array is just used to tell the table view how many rows to show
    fetchedObjects = OflineModeDataStore.fetchedResultsControllerSearch.fetchedObjects;
    
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchbar cancel called");
    NSPredicate *predicate =[NSPredicate predicateWithFormat:nil];
    [OflineModeDataStore.fetchedResultsControllerSearch.fetchRequest setPredicate:predicate];
    fetchedObjects = nil;
    [self.tableView reloadData];
}
//not really part of the delegate but deserves to be here
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    // dismiss the search keyboard
    [searchBar resignFirstResponder];
    
    // reload the table view
    [self.tableView reloadData];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    // Navigation logic may go here. Create and push another view controller.
    NSManagedObject *theManagedObject;
    
    if (tableView == [[self searchDisplayController] searchResultsTableView]){
        theManagedObject =[self.OflineModeDataStore.fetchedResultsControllerSearch objectAtIndexPath:indexPath];
        NSLog(@"searchTableview selected with object %@",theManagedObject);

    }else{
        theManagedObject = [_dataItems objectAtIndex:indexPath.row];//[self.OflineModeDataStore.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"myTableview selected with object %@",theManagedObject);
    }
    //NSLog(@"the index path %@",[indexPath row]);

     countriesDetailView *detailViewController = [[countriesDetailView alloc] initWithItem:theManagedObject];
   
     //get the data
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];

     [detailViewController release];
    theManagedObject = nil;
}

@end
