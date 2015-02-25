//
//  NetworkCommunicator.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/24/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import <CoreLocation/CoreLocation.h>

#import "NetworkController.h"
//#import "NetworkCommunicatorDelegate.h"

@implementation NetworkController

static NetworkController *sharedNetworkController = nil;

+(NetworkController *) sharedNetworkController {
  if (sharedNetworkController == nil) {
    sharedNetworkController = [[super allocWithZone:NULL] init];
  }
  return sharedNetworkController;
}

# pragma mark - JSON download

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *))completionHandler{
  // instantiate a session configuration object
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  // instantiate a session object
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
  // create a data task object to perform the data downloading
  NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
    
    if (error != nil) {
      NSLog(@"%@",[error localizedDescription]);
    }
    else {
      NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
#warning correct logic?
      if (HTTPStatusCode <= 200 || HTTPStatusCode >= 299) {
        NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
      }
      // call to completion handler w/ returned data -> main thread
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        completionHandler(data);
      }];
    }
  }];
  [task resume];
}

// requestOAuthAccess

// fetchTracks

// POST to SQL : username psswd track (stack exchange search)
// ^package data to JSON

// POST request & attach JSON

// get track for tableview cell

// pull request for photos url?



@end

