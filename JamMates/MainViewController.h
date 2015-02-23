//
//  ViewController.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface MainViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)mainMenuButton:(id)sender;

@property (nonatomic, strong) NSArray *pageTitles;
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) UIPageViewController *pageViewController; // to hold UIPageVieController

@end

