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

@interface HoundHandler : NSObject

+ (void) handleHoundResponse:(NSDictionary*)response nativeData:(NSDictionary*)nativeData;

@end