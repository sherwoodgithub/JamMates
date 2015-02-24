//
//  Musician.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Musician : NSObject
+(NSArray *)musicianFromJSON:(NSData *)jsonData;

@property (strong, nonatomic) NSString *musicianName;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *bandName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSArray *instruments;
@property (strong, nonatomic) NSArray *trackSamples;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *image;

@end
