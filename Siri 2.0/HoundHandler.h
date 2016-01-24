//
//  HoundHandler.h
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/24/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HoundSDK/HoundSDK.h>
#import <Parse/Parse.h>

#import "Constants.h"
#import "ParseCommunicator.h"

@class HoundHandler;

@protocol HoundHandlerDelegate <NSObject>

- (void) noResponse;
- (void) notUnderstandableResponse;
- (void) commandNotSupported:(NSString*)commandKind transcription:(NSString*)transcription;

- (void) wantsEventsNearThem;
- (void) wantsEventsNearThem:(int)radius;
- (void) wantsEventsNearThemWithKeyWords:(NSArray*)keyWords;
- (void) wantsEventsNearThem:(int)radius keyWords:(NSArray*)keyWords;

- (void) wantsNewsItemsNearThem;
- (void) wantsNewsItemsNearThem:(int)radius;
- (void) wantsNewsItemsNearThemWithKeyWords:(NSArray*)keyWords;
- (void) wantsNewsItemsNearThem:(int)radius keyWords:(NSArray*)keyWords;

@end

@interface HoundHandler : NSObject

@property (weak, nonatomic) id<HoundHandlerDelegate> delegate;

+ (instancetype) getInstance;

- (void) handleHoundResponse:(NSDictionary*)response nativeData:(NSDictionary*)nativeData;

@end