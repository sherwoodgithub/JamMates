//
//  SearchTracksViewController.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SearchTracksViewController : UIViewController

@property (strong, nonatomic) NSString *trackTitle;
@property (strong, nonatomic) NSString *trackURL;
@property (strong, nonatomic) AVPlayer *player;
@end
