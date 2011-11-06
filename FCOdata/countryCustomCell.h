//
//  countryCustomCell.h
//  FCOdata
//
//  Created by Edwin Bosire (@edwinbosire) on 25/07/2011.
//  Copyright 2011 Elixr Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface countryCustomCell : UITableViewCell {
    IBOutlet UILabel *textLabel;
    IBOutlet UIImageView *thumnail;
}
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIImageView *thumbnail;
@end
