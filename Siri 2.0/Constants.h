//
//  Constants.h
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Constants : NSObject

+ (instancetype) getInstance;

+ (NSString*) getParseAppId;
+ (NSString*) getParseClientId;

+ (NSString*) getHoundifyClientKey;
+ (NSString*) getHoundifyClientId;

+ (NSString*) soundHoundAudioURL;

- (double) getMyLongitude;
- (double) getMyLatitude;

@end