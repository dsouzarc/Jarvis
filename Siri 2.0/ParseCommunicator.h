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

extern const int MAX_KEY_WORDS;

@interface ParseCommunicator : NSObject

#pragma mark Events

+ (NSMutableArray*) getEventsNearMe;
+ (NSMutableArray*) getEventsNearMe:(int)radius;
+ (NSMutableArray*) getEventsNearMeWithKeyWords:(NSArray*)keyWords;
+ (NSMutableArray*) getEventsNearMe:(int)radius keyWords:(NSArray*)keyWords;


#pragma mark News Items

+ (NSMutableArray*) getNewsItemsNearMe;
+ (NSMutableArray*) getNewsItemsNearMe:(int)radius;
+ (NSMutableArray*) getNewsItemsNearMeWithKeyWords:(NSArray*)keyWords;
+ (NSMutableArray*) getNewsItemsNearMe:(int)radius keyWords:(NSArray*)keyWords;

+ (NSMutableArray*) getKindness;
+ (NSMutableArray*) getImprovement;
+ (NSMutableArray*) getFamily;
+ (NSMutableArray*) getHousing;

@end