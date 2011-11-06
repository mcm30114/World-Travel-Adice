//
//  newsViewController.m
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import "newsViewController.h"
#import "retrieveData.h"
#import "ASIHTTPRequest.h"
#include "SBJson.h"
#import "newsDetailViewController.h"
#import "customCell.h"
#import "retrieveData.h"

@implementation newsViewController
@synthesize newsItems;
@synthesize RetrieveData;

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
}
-(void)refreshData{
    //refresh the uitableview data
    [self.tableView reloadData];

}

-(void) grabData{
    NSURL *_myURL =[NSURL URLWithString:@"http://fco.innovate.direct.gov.uk/travel-news.json"];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:_myURL];
    [request setCompletionBlock:^{
        // Use when fetching text data
        
        responseString = [request responseString];
        NSMutableArray *results = [responseString JSONValue];
        if (results != NULL) {
            [self performSelectorOnMainThread:@selector(downloadPublicData:) withObject:results waitUntilDone:YES];
            //[self downloadPublicData:results]; 
            
            
            
        }else{
            NSLog(@"results is empty");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error" message:@"No Internet Connection, try again later" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    [request startAsynchronous];
    
}
-(void) downloadPublicData :(NSMutableArray *) array{
    
    [self performSelectorInBackground:@selector(synchronizeData:) withObject:array];
    NSLog(@"process sent to background thread");
    
}
-(void)reloadTable{
    [newsItems release];
    newsItems = [[RetrieveData newsList]retain];
    [self.tableView reloadData];
}

//method perfomed in background thread
- (void)synchronizeData:(NSArray*)data 
{
    
    //listen for a notification with the name of the identifier
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(dataDidSynchronize:) 
                                                 name:@"newsDidSynchronize" 
                                               object:nil];
    NSLog(@"synchronize data method called");
    
    [RetrieveData synchronizeNewsList:data];
    
}
//this is also in the background thread
- (void)dataDidSynchronize:(NSNotification*)notification 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //update the UI on the main thread
    NSLog(@"refreshUI called on main thread with notif ");
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
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
    //init the retrievedata class
    RetrieveData = [[retrieveData alloc] init];
    
    newsItems = [[RetrieveData newsList]retain];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self  action:@selector(grabData)];
    
    self.navigationItem.title = @"News";
    self.navigationItem.rightBarButtonItem = refreshButton;
    self.tabBarController.tabBarItem.badgeValue = nil;
    
    [refreshButton release];
    if (newsItems.count ==0) {
        [self grabData];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    //return [[RetrieveData.fetchedResultsController sections] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[RetrieveData newsList]valueForKey:@"titles"]count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    customCell *cell = nil;
    cell  = (customCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]
                                    loadNibNamed:@"customCell"
                                    owner:nil options:nil];
        for (id currentObject in  topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (customCell *)currentObject;
                break;
            }
        }
    }
    
    // Configure the cell...
    if (!newsItems) {
        cell.newsTitle.text = @"     Loading";
    }else{
    cell.newsTitle.text = [[newsItems objectAtIndex:[indexPath row]]valueForKey:@"titles"];
    //cell.newsSummary.numberOfLines = 3;
    cell.newsSummary.text = [[newsItems objectAtIndex:[indexPath row]]valueForKey:@"summary"];
        cell.dateLabel.text = [[newsItems objectAtIndex:[indexPath row]]valueForKey:@"pudDate"];
    }
  
    
    /*formate the date entry 
    NSString *theDate = [pubDate objectAtIndex:[indexPath row]];
    NSArray *trimDate = [theDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"T+"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@,%@",[trimDate objectAtIndex:0],[trimDate objectAtIndex:1]];
    
    */
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     newsDetailViewController *dvc = [[newsDetailViewController alloc] initWithNibName:@"newsDetailViewController"bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    NSString *tmpURL = [[newsItems objectAtIndex:[indexPath row]]valueForKey:@"link"];
    //NSString *jsonURL=[tmpURL stringByAppendingString:@".json"];
    //NSLog(@"jsonURL %@", jsonURL);
    dvc.url = [NSURL URLWithString:tmpURL];

     [self.navigationController pushViewController:dvc animated:YES];
     [dvc release];
     
}


@end
