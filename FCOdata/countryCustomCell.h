//
//  countryCustomCell.h
//  FCOdata
//
//  Created by Edwin on 25/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface countryCustomCell : UITableViewCell {
    IBOutlet UILabel *textLabel;
    IBOutlet UIImageView *thumnail;
}
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIImageView *thumbnail;
@end
