//
//  ParseCommunicator.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "ParseCommunicator.h"

static const int MAX_QUERY = 100;
static const int MAX_RADIUS = 70;

@implementation ParseCommunicator


/****************************************************************
 *
 *              NEWS ITEMS
 *
*****************************************************************/

# pragma mark NEWS ITEMS

+ (NSMutableArray*) getNewsItemsNearMe:(int)radius keyWord:(NSString *)keyWord skip:(int)skip
{
    PFQuery *query = [PFQuery queryWithClassName:@"NewsItems"];
    PFGeoPoint *currentLocation = [[Constants getInstance] getGeoPoint];
    NSMutableArray *queryArray = [[NSMutableArray alloc] init];
    
    if(keyWord) {
        //attributes
        NSArray *keysToSearch = @[@"excerpt", @"schema", @"business_name", @"location_name", @"title", @"comment", @"teacher_name"];
        
        for(NSString *key in keysToSearch) {
            PFQuery *fieldQuery = [PFQuery queryWithClassName:@"NewsItems"];
            [fieldQuery whereKey:key containsString:keyWord];
            [fieldQuery whereKey:@"location_coordinates" nearGeoPoint:currentLocation withinMiles:radius];
            [queryArray addObject:fieldQuery];
        }
    }
    else {
        PFQuery *fieldQuery = [PFQuery queryWithClassName:@"NewsItems"];
        [fieldQuery whereKey:@"location_coordinates" nearGeoPoint:currentLocation withinMiles:radius];
        [queryArray addObject:fieldQuery];
    }
    
    query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithArray:queryArray]];
    [query orderByAscending:@"stars"];
    [query setLimit:100];
    [query setSkip:skip];
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    return results;
}

+ (NSMutableArray*) getNewsItemsNearMe:(int)radius keyWord:(NSString *)keyWord
{
    static int skip = 0;
    static NSString *oldWord;
    if(!oldWord) {
        oldWord = keyWord;
    }
    else {
        if(![oldWord isEqualToString:keyWord]) {
            skip = 0;
        }
    }
    
    NSMutableArray *results = [self getNewsItemsNearMe:radius keyWord:keyWord skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getNewsItemsNearMeWithKeyWord:(NSString *)keyWord
{
    static int skip = 0;
    static NSString *oldWord;
    if(!oldWord) {
        oldWord = keyWord;
    }
    else {
        if(![oldWord isEqualToString:keyWord]) {
            skip = 0;
        }
    }
    
    NSMutableArray *results = [self getNewsItemsNearMe:MAX_RADIUS keyWord:keyWord skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getNewsItemsNearMe:(int)radius
{
    static int skip = 0;
    NSMutableArray *results = [self getNewsItemsNearMe:MAX_RADIUS keyWord:nil skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getNewsItemsNearMe
{
    static int skip = 0;
    NSMutableArray *results = [self getNewsItemsNearMe:MAX_RADIUS keyWord:nil skip:skip];
    skip += MAX_QUERY;
    return results;
}


/****************************************************************
 *
 *              EVENTS
 *
 *****************************************************************/

# pragma mark EVENTS

+ (NSMutableArray*) getEventsNearMe:(int)radius keyWord:(NSString *)keyWord skip:(int)skip
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
    [query orderByAscending:@"reaction_score"];
    [query setLimit:100];
    [query setSkip:skip];
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    return results;
}

+ (NSMutableArray*) getEventsNearMe:(int)radius keyWord:(NSString *)keyWord
{
    static int skip = 0;
    static NSString *oldWord;
    if(!oldWord) {
        oldWord = keyWord;
    }
    else {
        if(![oldWord isEqualToString:keyWord]) {
            skip = 0;
        }
    }
    
    NSMutableArray *results = [self getEventsNearMe:radius keyWord:keyWord skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getEventsNearMe
{
    static int skip = 0;
    NSMutableArray *results = [self getEventsNearMe:MAX_RADIUS keyWord:nil skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getEventsNearMe:(int)radius
{
    static int skip = 0;
    NSMutableArray *results = [self getEventsNearMe:radius keyWord:nil skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getEventsNearMeWithKeyWord:(NSString *)keyWord
{
    static int skip = 0;
    static NSString *oldWord;
    if(!oldWord) {
        oldWord = keyWord;
    }
    else {
        if(![oldWord isEqualToString:keyWord]) {
            skip = 0;
        }
    }
    
    NSMutableArray *results = [self getEventsNearMe:MAX_RADIUS keyWord:keyWord skip:skip];
    skip += MAX_QUERY;
    return results;
}

@end