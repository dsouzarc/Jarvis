//
//  Constants.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "Constants.h"

static Constants *instance;

@interface Constants ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation Constants


/****************************************************************
 *
 *              Constructor
 *
*****************************************************************/

# pragma mark Constructor

+ (instancetype) getInstance
{
    @synchronized(self) {
        if(!instance) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

- (instancetype) init
{
    self = [super init];
    
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        [self.locationManager startUpdatingLocation];
    }
    return self;
}


/****************************************************************
 *
 *              Get location
 *
*****************************************************************/

# pragma mark Get location

- (CLLocation*) getMyLocation
{
    //TODO: Remove test location
    CLLocation *location = [[CLLocation alloc] initWithLatitude:39.950261944607128 longitude:-75.198576668218848];
    return location;
    
    return self.locationManager.location;
}

- (PFGeoPoint*) getGeoPoint
{
    return [PFGeoPoint geoPointWithLocation:[self getMyLocation]];
}

- (double) getMyLatitude
{
    return [[self getMyLocation] coordinate].latitude;
}

- (double) getMyLongitude
{
    return [[self getMyLocation] coordinate].longitude;
}


/****************************************************************
 *
 *              Get App ID information
 *
*****************************************************************/

# pragma mark Get App ID information

+ (NSString*) getParseAppId
{
    return [self getValueFromConstantsKey:@"parseAppId"];
}

+ (NSString*) getParseClientId
{
    return [self getValueFromConstantsKey:@"parseClientId"];
}

+ (NSString*) getHoundifyClientId
{
    return [self getValueFromConstantsKey:@"houndifyClientId"];
}

+ (NSString*) getHoundifyClientKey
{
    return [self getValueFromConstantsKey:@"houndifyClientKey"];
}

+ (NSString*) getValueFromConstantsKey:(NSString*)key
{
    NSDictionary *value = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"]];
    return [value objectForKey:key];
}

+ (NSString*) soundHoundAudioURL
{
    return @"https://api.houndify.com/v1/audio";
}

@end