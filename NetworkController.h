//
//  NetworkCommunicator.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/24/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

#define SC_API_URL @"https://api.soundcloud.com"

@property (strong, nonatomic)  NSMutableArray *scTrackResultList; //*

+(NetworkController *) sharedNetworkController;
//-(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *))completionHandler;
-(void) searchForTracksWithQuery: (NSString *) query withCompletionHandler: (void(^)(NSArray *resultArray, NSString *error)) completionHandler;
-(void) getOtherUsers: (NSString *) SQLtoken withUserName: (NSString *)userName withCompletionHandler:(void (^)(NSArray *))completionHandler;
-(void)requestOAuthAccess;
-(void)handleOAuthURL: (NSURL*) callbackURL;
-(void) createUser: (NSString *) userName;
-(void)fetchSoundCloudTracks: (void(^)(NSArray *resultArray, NSString *error)) completionHandler;

@end

