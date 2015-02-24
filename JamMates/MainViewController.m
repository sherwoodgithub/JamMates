//
//  MainViewController.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()


@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //poor man's data model
  _pageTitles = @[@"Page1",@"Page2",@"Page3",@"Page4",@"Page5",@"Page6"];
  _pageImages = @[@"Page1.png",@"Page2.png",@"Page3.png",@"Page4.png",@"Page5.png",@"Page6.png"]; 
  
  // create page view controller
  self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
  self.pageViewController.dataSource = self;
  
  //set first page view controller
  PageContentViewController *firstViewController = [self viewControllerAtIndex:0];
  NSArray *viewControllers = @[firstViewController];
  [self.pageViewController setViewControllers:viewControllers
                                    direction:UIPageViewControllerNavigationDirectionForward
                                     animated:NO completion:nil];
  // necessary?
  self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  // this probably is... try without!
  [self addChildViewController:_pageViewController];
  [self.view addSubview:_pageViewController.view];
  [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



#pragma mark PageViewController DataSource

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
  if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
    return nil;
  }
  
  // Create a new view controller and pass suitable data.
  PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
  pageContentViewController.imageFile = self.pageImages[index];
  pageContentViewController.titleText = self.pageTitles[index];
  pageContentViewController.pageIndex = index;
  
  return pageContentViewController;
}

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

// page indicator only works with scroll transitions
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  return 0;
}

- (IBAction)mainMenuButton:(id)sender {
  PageContentViewController *firstViewController = [self viewControllerAtIndex:0];
  NSArray *viewControllers = @[firstViewController];
  [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}
@end


/*
     [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
*/
