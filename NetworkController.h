//
//  NetworkCommunicator.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/24/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *))completionHandler;

@end

