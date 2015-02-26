//
//  EmailTableViewCell.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/26/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;

@end
