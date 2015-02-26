//
//  EmailTableViewCell.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/26/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
