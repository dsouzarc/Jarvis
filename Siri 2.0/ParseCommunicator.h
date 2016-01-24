//
//  ParseCommunicator.h
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import <Parse/Parse.h>

@interface ParseCommunicator : NSObject

#pragma mark Events

+ (NSMutableArray*) getEventsNearMe;
+ (NSMutableArray*) getEventsNearMe:(int)radius;
+ (NSMutableArray*) getEventsNearMeWithKeyWord:(NSString*)keyWord;
+ (NSMutableArray*) getEventsNearMe:(int)radius keyWord:(NSString*)keyWord;


#pragma mark News Items

+ (NSMutableArray*) getNewsItemsNearMe;
+ (NSMutableArray*) getNewsItemsNearMe:(int)radius;
+ (NSMutableArray*) getNewsItemsNearMeWithKeyWord:(NSString*)keyWord;
+ (NSMutableArray*) getNewsItemsNearMe:(int)radius keyWord:(NSString*)keyWord;

@end
