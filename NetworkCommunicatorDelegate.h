//
//  NetworkCommunicatorDelegate.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/24/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkCommunicatorDelegate <NSObject>

@property (weak, nonatomic) id<NetworkCommunicatorDelegate> delegate;

- (id)objectFromJSONObject:(id)jsonObject error:(__autoreleasing NSError **)error;

/* search for people at following location
-(void)searchMusiciansAtCoordinate:(CLLocationCoordinate2D)coordinate;
 */

@end
