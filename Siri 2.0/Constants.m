//
//  Constants.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (NSString*) getParseAppId
{
    return [self getValueFromConstantsKey:@"parseAppId"];
}

+ (NSString*) getParseClientId
{
    return [self getValueFromConstantsKey:@"parseClientId"];
}

+ (NSString*) getValueFromConstantsKey:(NSString*)key
{
    NSDictionary *value = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"]];
    return [value objectForKey:key];
}

@end