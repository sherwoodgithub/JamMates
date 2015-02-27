//
//  OverlayView.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//
#import "OverlayView.h"

@implementation OverlayView
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noButton"]];
        [self addSubview:imageView];
    }
    return self;
  NSLog(@"OverlayView initWithFrame ");
}

-(void)setMode:(GGOverlayViewMode)mode
{
    if (_mode == mode) {
        return;
    }
    
    _mode = mode;
    
    if(mode == GGOverlayViewModeLeft) {
        imageView.image = [UIImage imageNamed:@"noButton"];
      NSLog(@"OverlayView setMode if(mode == GGOverlayViewModeLeft");

    } else {
        imageView.image = [UIImage imageNamed:@"yesButton"];
      NSLog(@"OverlayView setMode  } else {");

    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    imageView.frame = CGRectMake(50, 50, 100, 100);
  NSLog(@"OverlayView  layoutSubviews");
}


@end
