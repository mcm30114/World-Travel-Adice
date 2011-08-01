//
//  customCell.h
//  FCOdata
//
//  Created by Edwin on 25/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface customCell : UITableViewCell {
   // IBOutlet UITableViewCell *customCellView;
    IBOutlet UILabel *newsTitle;
    IBOutlet UILabel *newsSummary;
    IBOutlet UILabel *dateLabel;
}
@property (nonatomic, retain) UILabel *newsTitle;
@property (nonatomic, retain) UILabel *newsSummary;
@property (nonatomic, retain) UILabel *dateLabel;
@end
