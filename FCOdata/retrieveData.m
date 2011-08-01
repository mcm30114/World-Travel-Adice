//
//  retrieveData.m
//  FCOdata
//
//  Created by Edwin on 21/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "retrieveData.h"
#import "ASIHTTPRequest.h"
#include "SBJson.h"

@implementation retrieveData

-(void) grabData :(NSURL *)url{
   
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        
        responseString = [request responseString];
        NSMutableArray *results = [responseString JSONValue];
        NSArray *titles = [[results valueForKey:@"travel_news"] valueForKey:@"title"];
        _newsItem.newsTitle = [titles objectAtIndex:0];
        
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
@end
