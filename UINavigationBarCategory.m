//
//  UINavigationBarCategory.m
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 29/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import "UINavigationBarCategory.h"


@implementation UINavigationBar(CustomImage) 

-(void) drawRect:(CGRect)rect {
    
    UIImage *image = [UIImage imageNamed: @"BarBackground.png"];
    [image drawInRect:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
}
@end
