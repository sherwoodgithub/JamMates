//
//  SCTableViewCell.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "SCTableViewCell.h"

@implementation SCTableViewCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//  if (self) {
//    self.backgroundColor = [UIColor grayColor];
//  }
//  return self;
//}
- (void)awakeFromNib {
  self.backgroundColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
