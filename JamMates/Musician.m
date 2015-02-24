//
//  Musician.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/23/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import "Musician.h"

@implementation Musician
+(NSArray *)musicianFromJSON:(NSData *)jsonData {
  NSError *error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:0
                                                                   error:&error];
  if (error) {
    NSLog(@"%@", error.localizedDescription);
    return nil;
  }
  NSArray *items = [jsonDictionary objectForKey:@"items"];
  NSMutableArray *temp = [[NSMutableArray alloc] init];
  
  for (NSDictionary *item in items) {
    Musician *musician = [[Musician alloc] init];
    musician.musicianName = item[@"musician_name"];
    musician.token = item[@"musician_token"];
    musician.displayName = item[@"display_name"];
    musician.bandName = item[@"band_name"];
    musician.location = item[@"location"];
    musician.email = item[@"email"];
    musician.phoneNumber = item[@"phone_number"];
    musician.instruments = item[@"instruments"];
    musician.trackSamples = item[@"track_samples"];
    musician.avatarURL = item[@"avatar_URL"];
    [temp addObject:musician];
  }
  
  NSArray *final = [[NSArray alloc] initWithArray:temp];
  NSLog(@"%@", final);
  return final;
}
@end
