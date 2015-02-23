//
//  ViewController.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

- (IBAction)mainMenuButton:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _pageTitles = @[@"Page1",@"Page2",@"Page3",@"Page4",@"Page5",@"Page6"];
  _pageImages = @[@"Page1.png",@"Page2.png",@"Page3.png",@"Page4.png",@"Page5.png",@"Page6.png"]; 
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



#pragma mark PageViewController DataSource


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  
  NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
  if ((index == 0) || index == NSNotFound) {
    return nil;
  }
  index --;
  return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  
  NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
  if (index == NSNotFound) {
    return nil;
  }
  
  index++;
  if (index == [self.pageTitles count]) {
    return nil;
  }
  return [self viewControllerAtIndex:index];
}








- (IBAction)mainMenuButton:(id)sender {
}
@end








































///scroll