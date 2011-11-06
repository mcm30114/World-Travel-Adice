//
//  SecondViewController.m
//  FCOdata
//
//  Created by denis bosire on 16/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import "SecondViewController.h"
#import "FCOdataAppDelegate.h"   //for shared add banner

@implementation SecondViewController
@synthesize contact;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contact.editable = NO;
    self.contact.dataDetectorTypes = UIDataDetectorTypeAll;
    
   
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

}


- (void)dealloc
{
    
    [super dealloc];
}
#pragma mark -

@end
