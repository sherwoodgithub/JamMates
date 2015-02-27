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
    for (NSDictionary *trackDictionary in JSONArray) {
      Track *trackObject = [[Track alloc]initDictionary: trackDictionary];
      trackObject.title = trackDictionary[@"title"];
      trackObject.stream_url = trackDictionary[@"stream_url"];
      NSLog(@"\n\n\ntrackTitle: %@, \n\n\ntrackStreamURL: %@", trackObject.title, trackObject.stream_url);
      [trackArray addObject:trackObject];
    }
  }
  return trackArray;
}

+(NSArray *)tracksFromJSON:(NSData *)jsonData {
  
  NSError *error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
  if (error) {
    
    NSLog(@"%@",error.localizedDescription);
    return nil;
  }
  NSArray *items = [jsonDictionary objectForKey:@"items"];
  NSMutableArray *temp = [[NSMutableArray alloc] init];
  for (NSDictionary *item in items) {
    Track *track = [[Track alloc] init];
    track.title = item[@"title"];
    track.stream_url = item[@"stream_url"];
    [temp addObject:track];
  }
  NSArray *final = [[NSArray alloc] initWithArray:temp];
  return final;
}

@end
