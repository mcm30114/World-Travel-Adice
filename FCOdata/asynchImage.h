//
//  asynchImage.h
//  FCOdata
//
//  Created by Edwin on 19/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@interface asynchImage : UIImageView {
    
    UIImage *cellPicha;   //picha is swahili for picture/image, why swahili? coz i can!
    NSMutableData* data;
}
@property (nonatomic, retain) UIImage *cellPicha;

-(UIImage *) retrieveImage :(NSURL *) imageURL;
@end
