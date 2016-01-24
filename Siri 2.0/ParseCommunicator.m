//
//  ParseCommunicator.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "ParseCommunicator.h"

@implementation ParseCommunicator

+ (NSMutableArray*) getEventsNearMe:(int)radius keyWord:(NSString *)keyWord
{
    PFQuery *query = [PFQuery queryWithClassName:@"EventItems"];
    PFGeoPoint *currentLocation = [[Constants getInstance] getGeoPoint];
    NSMutableArray *queryArray = [[NSMutableArray alloc] init];
    
    if(keyWord) {
        //attributes
        NSArray *keysToSearch = @[@"group_name", @"time", @"source_name", @"meeting_name", @"organizer", @"location_name", @"title", @"description", @"poster_name"];
        
        for(NSString *key in keysToSearch) {
            PFQuery *fieldQuery = [PFQuery queryWithClassName:@"EventItems"];
            [fieldQuery whereKey:key containsString:keyWord];
            [fieldQuery whereKey:@"location_coordinates" nearGeoPoint:currentLocation withinMiles:radius];
            [queryArray addObject:fieldQuery];
        }
    }
    else {
        PFQuery *fieldQuery = [PFQuery queryWithClassName:@"EventItems"];
        [fieldQuery whereKey:@"location_coordinates" nearGeoPoint:currentLocation withinMiles:radius];
        [queryArray addObject:fieldQuery];
    }
    
    query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithArray:queryArray]];
    [query setLimit:100];
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    return results;
}

+ (NSMutableArray*) getEventsNearMe
{
    return [self getEventsNearMe:70 keyWord:nil];
}

+ (NSMutableArray*) getEventsNearMe:(int)radius
{
    return [self getEventsNearMe:radius keyWord:nil];
}

+ (NSMutableArray*) getEventsNearMeWithKeyWord:(NSString *)keyWord
{
    return [self getEventsNearMe:70 keyWord:keyWord];
}

@end