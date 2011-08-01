//
//  asynchImage.m
//  FCOdata
//
//  Created by Edwin on 19/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "asynchImage.h"


@implementation asynchImage
@synthesize cellPicha;


-(UIImage *) retrieveImage :(NSURL *) imageURL{
    NSLog(@"retrieve image called");
    NSURL *myURL = imageURL;
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:myURL];
    [request setCompletionBlock:^{
        // Use when fetching text data
        if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
        [data appendData:[request responseData]];
        
        
        // NSMutableArray *allNames = [results objectForKey:@"country"];
        if (data !=nil) {
            UIImage *img = [UIImage imageWithData:data];
            cellPicha = img;
            [img release];
        }else{
            NSLog(@"there is no image, return placeholder");
            if (cellPicha !=nil) 
                cellPicha = nil;
            cellPicha = [UIImage imageNamed:@"placeholder.jpg"];
        }
       
        
    }];
    
    
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
    return cellPicha;
    
}

@end
