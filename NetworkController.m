//
//  NetworkCommunicator.m
//  JamMates
//
//  Created by Stephen Sherwood on 2/24/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//
#import "NetworkController.h"
#import "User.h"
#import "Track.h"

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NetworkController ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) User *user;

@end

@implementation NetworkController

NSString* clientID = @"0c179b66c4fe77ec437daa893f8e564a";
NSString* clientSecret = @"9dab691ced74b7bc5cc50fa825d645f6";
NSString* oAuthURL = @"https://soundcloud.com/connect";
NSString* response_type = @"code";
NSString* redirectURI = @"JamMates://oauth";
NSString* grant_type = @"authorization_code";
NSString* token_url = @"https://api.soundcloud.com/oauth2/token";

+ (NetworkController *)sharedNetworkController {
  static NetworkController *sharedNetworkController = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedNetworkController = [[self alloc] init];
  });
  return sharedNetworkController;
}

-(instancetype) init
{
  self = [super init];
  if (self) {
    self.configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration: self.configuration];
  }
  return self;
}


# pragma mark - JSON download

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *))completionHandler{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
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

#pragma mark - SOUNDCLOUD

//Tuan
-(void)requestOAuthAccess {
  NSString *scope = @"non-expiring";
  NSString *loginURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=%@&scope=%@", oAuthURL, clientID, redirectURI, response_type, scope];
  NSURL *url = [NSURL URLWithString:loginURL];
  [[UIApplication sharedApplication] openURL:url];
  NSLog(@"%@", loginURL);
}

//Tuan
-(void)handleOAuthURL: (NSURL*) callbackURL {
  NSString* query = callbackURL.query;
  NSArray* component = [query componentsSeparatedByString:@"="];
  NSString* code = component[1];
  NSLog(@"%@", code);
  
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:token_url]];
  request.HTTPMethod = @"POST";
  
  NSArray *keys = [NSArray arrayWithObjects: @"client_id",@"client_secret",@"redirect_uri",@"grant_type", @"code", nil];
  NSArray *objects = [NSArray arrayWithObjects: clientID,clientSecret,redirectURI,grant_type, code, nil];
  NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
  
  NSData *jsonData;
  if ([NSJSONSerialization isValidJSONObject:jsonDictionary]) {
    NSError *error;
    jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!jsonData) {
      NSLog(@"json Data %@",error.description);
    } else {
      NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
      NSLog(@"JSON String %@",JSONString);
      [request setHTTPBody:jsonData];
    }
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [[self session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      NSHTTPURLResponse* callResponse = (NSHTTPURLResponse *)response;
      if ([callResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger responseCode = [callResponse statusCode];
        
        if (responseCode >= 200 && responseCode <= 299) {
          NSString* tokenResponse = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
          
          NSLog(@"%@", tokenResponse);
          
          NSArray* componentOne = [tokenResponse componentsSeparatedByString:@":"];
          NSArray* componentTwo = [componentOne[1] componentsSeparatedByString:@","];
          NSArray* componentThree = [componentTwo[0] componentsSeparatedByString:@"\""];
          NSString* parsedToken = componentThree[1];
          NSLog(@"%@", parsedToken);
          
          [[NSUserDefaults standardUserDefaults] setValue:parsedToken forKey:@"SCToken"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          
        }else{
          NSLog(@"%ld", (long)responseCode);
        }
      }
    }];
    [dataTask resume];
  }
}

// Tuan
-(void)fetchSoundCloudTracks: (void(^)(NSArray *resultArray, NSString *error)) completionHandler; {
  NSLog(@"\n\n\n\nfetchSoundCloudTracks\n\n\n\n");
  NSString *accessToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"OAuthToken"];
  
  NSString* urlString = [NSString stringWithFormat:@"https://api.soundcloud.com/users/80502172/favorites.json?oauth_token=%@", accessToken];
  
  NSURL* url = [[NSURL alloc]initWithString:urlString];
  
  NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSURLSessionDataTask *dataTask = [[self session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *callResponse = (NSHTTPURLResponse *)response;
    
    if ([callResponse isKindOfClass:[NSHTTPURLResponse class]]) {
      NSInteger responseCode = [callResponse statusCode];
      
      if (responseCode >= 200 && responseCode <= 299) {
        NSLog(@"FAVORITED 200");
        NSArray* resultArray = [Track parseJSONData:data];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
          completionHandler(resultArray, nil);
        }];
      }else{
        NSLog(@"%ld", (long)responseCode);
      }
    }
  }];
  [dataTask resume];
}

//
-(void) searchForTracksWithQuery: (NSString *) query withCompletionHandler: (void(^)(NSArray *resultArray, NSString *error)) completionHandler {
  NSString *scToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCToken"];
 // NSLog(@"\n\n\n\nsearchForTracksWithQuery:\n\n\n\n\n");
  if(query.length >0)
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
  
  NSString *urlString = [NSString stringWithFormat:@"%@/tracks.json?oauth_token=%@&client_id=%@&q=%@",SC_API_URL,scToken,clientID,query];
  
  NSURL *url = [[NSURL alloc] initWithString:urlString];
  
  NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSURLSessionDataTask *dataTask = [[self session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *callResponse = (NSHTTPURLResponse *)response;
    
    if ([callResponse isKindOfClass:[NSHTTPURLResponse class]]) {
      NSInteger responseCode = [callResponse statusCode];
      
      if (responseCode >= 200 && responseCode <= 299) {
        NSLog(@"FAVORITED 200");
        NSArray* resultArray = [Track parseJSONData:data];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
          completionHandler(resultArray, nil);
        }];
      }else{
        NSLog(@"%ld", (long)responseCode);
      }
    }
  }];
  [dataTask resume];
}

  
  //NSLog(@"%@",jsonString);
//  NSMutableArray *musicArray;
//  self.scTrackResultList = [[NSMutableArray alloc]init];
//  
//  NSMutableArray *returnArray = [[NSMutableArray alloc]init];
//  
//  for(int i=0; i< musicArray.count;i++)
//  {
//    NSMutableDictionary *result = [musicArray objectAtIndex:i];
//    if([[result objectForKey:@"kind" ] isEqualToString:@"track"])
//    {
//      [returnArray addObject:result];
//    }
//  }
 // NSLog(musicArray);
//  return returnArray;

/*
-(void)fetchUserImage:(NSString *)avatarURL completionHandler:(void (^) (UIImage *image))completionHandler {
  
  dispatch_queue_t imageQueue     = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
  dispatch_async(imageQueue, ^{
    
    NSURL *url                      = [NSURL URLWithString:avatarURL];
    NSData *data                    = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image                  = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      completionHandler(image);
    });//main queue
  });//image queue
}//fetch user image
*/

/*
- (void) fetchDrinkForSong:(NSString *)title withArtist: (NSString *) artist withCompletionHandler:(void (^)(NSString *, Drink *))success; {
  NSString *songTitleNoSpaces = [title stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
  NSString *songArtistNoSpaces = [artist stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
  NSString *api_key = @"FGSG5VYMGP92BYLA8";
  NSString *urlString = [NSString stringWithFormat: @"https://developer.echonest.com/api/v4/song/search?api_key=%@&artist=%@&title=%@", api_key, songArtistNoSpaces, songTitleNoSpaces];
  NSLog(@"%@", urlString);
  NSDictionary *dict = @{@"url" : urlString};
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options: NSJSONWritingPrettyPrinted error:&error];
  NSString *herokuURLString = @"https://musicholic.herokuapp.com/api";
  NSURL *url = [NSURL URLWithString:herokuURLString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  NSString *contentLengthString = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
  [request setValue:contentLengthString forHTTPHeaderField: @"Content-Length"];
  [request setValue:contentLengthString forHTTPHeaderField: @"Accept"];
  [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
  [request setHTTPBody: jsonData];
  
 //This part should be fairly universal: POST REQUESTS
 NSURLSessionDataTask *dataRequest = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if ([response isKindOfClass: [NSHTTPURLResponse class]]) {
      NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
      NSLog(@"status code is %ld",(long)[httpResponse statusCode]);
      if ([httpResponse statusCode] >= 200 && [httpResponse statusCode] <= 204 ) {
        NSLog(@"status code 200");
        
        Drink *drink = [[Drink alloc] parseJSONDataIntoDrink:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          success(nil, drink);
        }];
        
      } else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          NSLog(@"There was an error: %@",error.localizedDescription);
          success(error.localizedDescription, nil);
        }];
      }
    }
  }];
  [dataRequest resume];
}
*/
/*
// jeff
- (void) fetchImageForDrink: (Drink *)drink withCompletionHandler:(void (^)(UIImage *)) success; {
  self.imageQueue = [[NSOperationQueue alloc] init];
  [self.imageQueue addOperationWithBlock:^{
    // Make URL from Drink's urlString
    // What is a sample URL I can test?
    NSURL *url = [NSURL URLWithString: drink.imageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *drinkImageToReturn = [UIImage imageWithData:data];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      success(drinkImageToReturn);
    }];
  }];
}
*/

// request token from DB


// get track for tableview cell

// POST to SQL : username psswd track (stack exchange search)
// ^package data to JSON

// POST request & attach JSON

// pull request for users's favorites

// SC avatar image





@end

