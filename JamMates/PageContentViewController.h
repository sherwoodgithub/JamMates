//
//  PageContentViewController.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex; // stores current page index
@property NSString *titleText;
@property NSString *imageFile;

@end
