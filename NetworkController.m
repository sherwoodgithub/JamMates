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
    }
    else {
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
        }
        else {
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
  NSString *accessToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"SCToken"];
  
  NSString* urlString = [NSString stringWithFormat:@"https://api.soundcloud.com/users/80502172/favorites.json?oauth_token=%@", accessToken];
  
  NSURL* url = [[NSURL alloc]initWithString:urlString];
  
  NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSURLSessionDataTask *dataTask = [[self session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *callResponse = (NSHTTPURLResponse *)response;
    
    if ([callResponse isKindOfClass:[NSHTTPURLResponse class]]) {
      NSInteger responseCode = [callResponse statusCode];
      
      if (responseCode >= 200 && responseCode <= 299) {
        //NSLog(@"FAVORITED 200");
        NSArray* resultArray = [Track parseJSONData:data];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
          completionHandler(resultArray, nil);
        }];
      }else{
        NSLog(@"responseCode of fetchSoundCloudTracks %ld", (long)responseCode);
      }
    }
  }];
  [dataTask resume];
}

-(void) searchForTracksWithQuery: (NSString *) query withCompletionHandler: (void(^)(NSArray *resultArray, NSString *error)) completionHandler {
  NSString *scToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCToken"];
  NSLog(@"\n\n\n\nsearchForTracksWithQuery:\n\n\n\n\n");
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
       // NSLog(@"code 200");
        NSArray* resultArray = [Track parseJSONData:data];
        NSLog(@"\n\n\n\ndata\n\n\n\n%@", data);
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

#pragma mark - JavaScript Database
#warning createUser still relies on hard-coded userName !! NOT AUTOMATIC !!
- (void) createUser: (void (^) (NSString *token, NSString *error)) completionHandler {
  
  NSString *localToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"SQLtoken"];
  if (localToken == nil) {
    NSString *userName = @"againagain4";
    NSString *userPassword = @"password12345";
    
    NSDictionary *userDict = @{@"username" : userName, @"password" : userPassword};

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:0 error:&error];
    
    if (jsonData) {
      //NSLog(@"user dictionary = %@", jsonData.description);
    }
    else {
      NSLog(@"Unable to serialize the data %@: %@", userDict, error);
    }
    NSString *urlString = @"http://bandmates.herokuapp.com/api/user";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"could not connect %@",error.description);
        completionHandler(nil,@"Could not connect because %@");
      }
      else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = httpResponse.statusCode;
        //NSLog(@"the status code for post was %lu", statusCode);
        //NSLog(@"the response was %@", httpResponse.description);
        [[User sharedUser] createUserFromJSON:data];

        //print into human readable terms:
        NSString *aString  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n\n\n here's yer data: %@\n\n\n\n", aString);
        switch (statusCode) {
            
          case 200 ... 299: {
            break;
          }
          default:
            NSLog(@"%ld",(long)statusCode);
            break;
        }
      }
    }];//dataTask
    [dataTask resume];
  }
}

- (NSString *) getDataFrom:(NSString *)url{
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setHTTPMethod:@"GET"];
  [request setURL:[NSURL URLWithString:url]];
  
  NSError *error = [[NSError alloc] init];
  NSHTTPURLResponse *responseCode = nil;
  NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
  
  if([responseCode statusCode] != 200){
    NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
    return nil;
  }
  return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

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




// get track for tableview cell

// POST to SQL : username psswd track (stack exchange search)

// POST request & attach JSON

// pull request for users's favorites

// SC avatar image





@end

