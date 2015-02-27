//
//  User.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject

-(void)createUserFromJSON:(NSData *)jsonData;

+(User *)sharedUser;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *SCToken;
@property (strong, nonatomic) NSString *SQLtoken;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *bandName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastname;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSArray *instruments;
@property (strong, nonatomic) NSString *track1;
@property (strong, nonatomic) NSString *track2;
@property (strong, nonatomic) NSString *track3;
@property (strong, nonatomic) NSString *avatarURL;


@end
