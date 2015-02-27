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

-(void)createUserFromJSON:(NSData *)jsonData {
  NSError *error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
  if (error) {
    NSLog(@"JSON error: %@", error.localizedDescription);
  }
    User *user = [User sharedUser];
    user.SQLtoken = jsonDictionary[@"eat"];
}

-(void)postApprovalJSON:(NSData *)jsonData {
  NSError *error;
  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
  if (error) {
    NSLog(@"JSON error: %@", error.localizedDescription);
  }
  User *user = [User sharedUser];
#warning approval needs anything from DB?
  user.userName = dictionary[@" "];
}

@end
