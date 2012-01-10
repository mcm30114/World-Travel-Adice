//
//  twitterFeed.m
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 27/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import "twitterFeed.h"
#import "ASIHTTPRequest.h"
#include "SBJson.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation twitterFeed
@synthesize _items;
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

   UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(grabURLInBackground)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    self.title = @"@ForeignOffice";
    _items = [[NSArray alloc] init];
    [self grabURLInBackground];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
- (void)grabURLInBackground
{
    NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=foreignoffice"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSDictionary *results = [responseString JSONValue];
    if (responseString !=nil) {
        NSArray *allTweets = [results objectForKey:@"results"];
        [self dataItems:allTweets];
        //[self.tableView reloadData];
        [self threadImageDownloader];
    }

    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    /*handle any errors*/
    if(error){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"Please Check Your Internet!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }//alert
}

-(void) dataItems:(NSArray *) theResponse{
    
    self._items = theResponse;
    
        [self.tableView reloadData];
        NSLog(@"table reloaded");

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_items !=nil) {
        return _items.count;
    }else {
        return 1;
    };
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        
    }
    
    // Configure the cell...
    NSDictionary *aTweet = [_items objectAtIndex:[indexPath row]];
	
    cell.textLabel.text = [aTweet objectForKey:@"text"];
	//cell.textLabel.text = [[tweets objectAtIndex:indexPath.row] objectForKey:@"text"];
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14];
	cell.textLabel.minimumFontSize = 10;
	cell.textLabel.numberOfLines = 4;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	NSString *from = [aTweet objectForKey:@"from_user"];
	NSString *pubDate = [aTweet objectForKey:@"created_at"];
    /*formate the date entry */
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    NSDate *date = [formatter dateFromString:pubDate];
    [formatter setDateFormat:@"dd-MMM HH:mm"];
    NSString *trimDate = [formatter stringFromDate:date];
    NSLog(@"date %@", trimDate);
    
	NSString *detail = [NSString stringWithFormat:@"%@ :%@",from, trimDate];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	cell.detailTextLabel.text = detail;
	//cell.detailTextLabel.text =[[tweets objectAtIndex:indexPath.row] objectForKey:@"from_user"];
    if ([thumbnails count] >0) {
        [cell.imageView setImage:[thumbnails objectAtIndex:indexPath.row]];
        CALayer *layer = cell.imageView.layer;
        layer.masksToBounds = YES;
        layer.borderWidth=1.0;
        layer.borderColor=[[UIColor blackColor] CGColor];
        [layer setCornerRadius:2.0];
    }
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)threadImageDownloader{
    thumbnails = [[NSMutableArray alloc] init];
    backgroundThread = dispatch_queue_create("com.edwinb.traveladvice", NULL);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(backgroundThread, ^{
        
        for (int x=0; x<[_items count]; x++) {
            
            NSURL *url = [NSURL URLWithString:[[_items objectAtIndex:x] objectForKey:@"profile_image_url"]];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
            NSLog(@"urls %@", url);
            [thumbnails addObject:image];
        }
        dispatch_sync(main_queue, ^{
            
            [self.tableView reloadData];
        });
        
    });
    dispatch_release(backgroundThread);
    
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
