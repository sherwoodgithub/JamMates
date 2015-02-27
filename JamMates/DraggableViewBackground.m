//
//  DraggableViewBackground.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//
#import "MusicianViewController.h"
#import "SCTableViewCell.h"
#import "NetworkController.h"
#import "User.h"
#import "DraggableViewBackground.h"
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex; //index of card last loaded in loadedCards array
    NSMutableArray *loadedCards; //array of cards loaded (change max_buffer_size to > || < # cards held
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
}
//only 2 cards @ time
static const int MAX_BUFFER_SIZE = 2; // max # cards, >= 1
static const float CARD_HEIGHT = 386; //height of the draggable card
static const float CARD_WIDTH = 290; //width of the draggable card

@synthesize exampleCardLabels; //per example, change before demo
@synthesize allCards;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
#warning this array of objects == musicians
        exampleCardLabels = [[NSArray alloc]initWithObjects:@"first",@"second",@"third",@"fourth",@"last", nil]; //placeholder for card-specific information
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
        [self loadCards];
    }
  NSLog(@"DraggableViewBackground  initWithFrame ");
    return self;
}

//buttons on screen
-(void)setupView
{
#warning customize all of this.  These are just place holders to make it look pretty
    self.backgroundColor = [UIColor clearColor];
    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 485, 59, 59)];
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
  
    [self addSubview:menuButton];
    [self addSubview:messageButton];
    [self addSubview:xButton];
    [self addSubview:checkButton];
  NSLog(@"DraggableViewBackground   setupView");

}

#warning include own card customization here!
//creates a card and returns it. Customize!! "index" == where information to be pulled from. Eschewable.
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    draggableView.information.text = [exampleCardLabels objectAtIndex:index]; //placeholder for card-specific information
    draggableView.delegate = self;
  NSLog(@"DraggableViewBackground  createDraggableViewWithDataAtIndex ");

    return draggableView;

}

//loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([exampleCardLabels count] > 0) {
        NSInteger numLoadedCardsCap =(([exampleCardLabels count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[exampleCardLabels count]);
        //NOTE: if buffer size > data size, then array error
      NSLog(@"DraggableViewBackground  loadCards if([exampleCardLabels count] > 0) ");
#warning remove exampleCardLabels
        //creates cards for each label by looping through the exampleCardsLabels array. Remove "exampleCardLabels" with your own array of data to customize
        for (int i = 0; i<[exampleCardLabels count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
          NSLog(@"DraggableViewBackground  loadCards if([exampleCardLabels count] > 0)  or (int i = 0; i<[exampleCardLabels count]");

            if (i<numLoadedCardsCap) {
                //adds un poquito # cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //displays small # cards (MAX_BUFFER_SIZE) for performance
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
              NSLog(@"DraggableViewBackground   ");

            } else {
              NSLog(@"DraggableViewBackground   ");

                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++;
        }
    }
  NSLog(@"DraggableViewBackground   ");

}

#warning include own action here!
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with swiped card
    //    DraggableView *c = (DraggableView *)card;
  NSLog(@"DraggableViewBackground  cardSwipedLeft ");

    [loadedCards removeObjectAtIndex:0]; //swiped card no longer a loaded card
    
    if (cardsLoadedIndex < [allCards count]) { //if (!end), put another into the loaded cards
      NSLog(@"DraggableViewBackground cardSwipedLeft  if (cardsLoadedIndex < [allCards count])");

        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

#warning include own action here!
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with swiped card
    //    DraggableView *c = (DraggableView *)card;
  NSLog(@"DraggableViewBackground  cardSwipedRight ");

    [loadedCards removeObjectAtIndex:0]; //swiped card no longer a loaded card
    
    if (cardsLoadedIndex < [allCards count]) { //if (!end), put another into the loaded cards
      NSLog(@"DraggableViewBackground cardSwipedRight   if (cardsLoadedIndex < [allCards count])");

        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }

}

//right button calls this & substitutes the swipe
-(void)swipeRight
{
  NSLog(@"DraggableViewBackground  swipeRight ");

    DraggableView *dragView = [loadedCards firstObject];
//    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
//        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//left button calls this & substitutes the swipe
-(void)swipeLeft
{
  NSLog(@"DraggableViewBackground  swipeLeft ");

    DraggableView *dragView = [loadedCards firstObject];
//    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
//        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
