//
//  DraggableViewBackground.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"
#import <MessageUI/MessageUI.h>

@interface DraggableViewBackground : UIView <DraggableViewDelegate>

//methods called in DraggableView
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@property (retain,nonatomic)NSArray* exampleCardLabels;
@property (retain,nonatomic)NSMutableArray* allCards;


@end
