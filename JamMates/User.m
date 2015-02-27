//
//  User.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *) sharedUser {
  static User *sharedUser = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedUser = [[self alloc] init];
  });
  return sharedUser;
}

+(NSArray *)userFromJSON:(NSData *)jsonData {
  NSError *error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:0
                                                                   error:&error];
  if (error) {
    NSLog(@"JSON error: %@", error.localizedDescription);
    return nil;
  }
  NSArray *items = [jsonDictionary objectForKey:@"items"];
  NSMutableArray *temp = [[NSMutableArray alloc] init];
  
  #warning do you want a for loop?
  for (NSDictionary *item in items) {
    //first name
    //last name
    //track 1
    //track 2
    //track 3
    //instruments mutable array
    User *user = [[User alloc] init];
    user.userName = item[@"user_name"];
    user.SCToken = item[@"SCToken"];
    user.SQLtoken = item[@"SQLdatabase_token"];
    user.displayName = item[@"display_name"];
    user.bandName = item[@"band_name"];
    user.location = item[@"location"];
    user.email = item[@"email"];
    user.phoneNumber = item[@"phone_number"];
    user.instruments = item[@"instruments"];
    user.track1 = item[@"track1"];
    user.track2 = item[@"track2"];
    user.track3 = item[@"track3"];
    user.avatarURL = item[@"avatar_URL"];
    [temp addObject:user];
  }
  
  NSArray *final = [[NSArray alloc] initWithArray:temp];
  NSLog(@"%@", final);
  return final;
}

@end
