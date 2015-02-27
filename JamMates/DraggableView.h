//
//  DraggableView.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@end

@interface DraggableView : UIView

@property (weak) id <DraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)OverlayView *overlayView;
@property (nonatomic,strong)UILabel* information; //placeholder for any card-specific information

-(void)leftClickAction;
-(void)rightClickAction;

@end
