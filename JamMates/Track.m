//
//  Track.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "Track.h"

#import <Foundation/Foundation.h>

@implementation Track

- (instancetype) initDictionary: (NSDictionary *) trackDict {
  self = [self init];
  if (self) {
    self.title = trackDict[@"title"];
    self.stream_url = trackDict[@"stream_url"];
  }
  return self;
}

+(NSMutableArray *) parseJSONData: (NSData *) JSONData {
  NSError *error;
  
  NSMutableArray* trackArray = [[NSMutableArray alloc]init];
  
  NSArray *JSONArray= [NSJSONSerialization JSONObjectWithData:JSONData options:0 error: &error];
  if ([JSONArray isKindOfClass:[NSArray class]]) {
    for (NSDictionary* trackDic in JSONArray) {
      Track* trackObject = [[Track alloc]initDictionary:trackDic];
      [trackArray addObject:trackObject];
    }
  }
  return trackArray;
}
/*
+(NSArray *)questionsFromJSON:(NSData *)jsonData {
  
  NSError *error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
  if (error) {
    
    NSLog(@"%@",error.localizedDescription);
    return nil;
  }//if error
  NSArray *items               = [jsonDictionary objectForKey:@"items"];
  NSMutableArray *temp         = [[NSMutableArray alloc] init];
  for (NSDictionary *item in items) {
    
    Track *question           = [[Track alloc] init];
    Track.title               = item[@"title"];
    NSDictionary *userInfo       = item[@"owner"];
    question.avatarURL           = userInfo[@"profile_image"];
    [temp addObject:question];
  }//for item in items
  NSArray *final               = [[NSArray alloc] initWithArray:temp];
  return final;
}//questions from json
*/
@end
