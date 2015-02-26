//
//  Track.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/25/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* stream_url;


+(NSMutableArray *) parseJSONData: (NSData *) JSONData;
+(NSArray *)questionsFromJSON:(NSData *)jsonData;

@end
