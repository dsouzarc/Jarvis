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
const int MAX_KEY_WORDS = 5;

@implementation ParseCommunicator


/****************************************************************
 *
 *              NEWS ITEMS
 *
*****************************************************************/

# pragma mark NEWS ITEMS

+ (NSMutableArray*) getNewsItemsNearMe:(int)radius keyWords:(NSArray*)keyWords skip:(int)skip
{
    PFQuery *query = [PFQuery queryWithClassName:@"NewsItems"];
    PFGeoPoint *currentLocation = [[Constants getInstance] getGeoPoint];
    NSMutableArray *queryArray = [[NSMutableArray alloc] init];
    
    if(keyWords) {
        //attributes
        NSArray *keysToSearch = @[@"excerpt", @"schema", @"business_name", @"location_name", @"title", @"comment", @"teacher_name"];
        
        for(NSString *key in keysToSearch) {
            PFQuery *fieldQuery = [PFQuery queryWithClassName:@"NewsItems"];
            [fieldQuery whereKey:key containedIn:keyWords];
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

+ (NSMutableArray*) removeDuplicates:(NSMutableArray*)original
{
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    
    for(int i = 0; i < original.count; i++) {
        NSDictionary *item = original[i];
        
        //If the key returns the same value as the object, it's definitely a duplicate
        if([[values objectForKey:item[@"pub_date"]] isEqualToValue:[item objectForKey:@"id"]]) {
            [original removeObjectAtIndex:i];
            i--;
        }
        else {
            [values setObject:[item objectForKey:@"id"] forKey:[item objectForKey:@"pub_date"]];
        }
    }
    return original;
}

+ (NSMutableArray*) getNewsItemsNearMe:(int)radius keyWords:(NSArray*)keyWords
{
    static int skip = 0;
    static NSArray *oldWords;
    if(!oldWords) {
        oldWords = keyWords;
    }
    else {
        if(![oldWords isEqualToArray:keyWords]) {
            skip = 0;
        }
    }
    
    NSMutableArray *results = [self getNewsItemsNearMe:radius keyWords:keyWords skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getNewsItemsNearMeWithKeyWords:(NSArray*)keyWords
{
    static int skip = 0;
    static NSArray *oldWords;
    if(!oldWords) {
        oldWords = keyWords;
    }
    else {
        if(![oldWords isEqualToArray:keyWords]) {
            skip = 0;
        }
    }
    
    
    NSMutableArray *results = [self getNewsItemsNearMe:MAX_RADIUS keyWords:keyWords skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getNewsItemsNearMe:(int)radius
{
    static int skip = 0;
    NSMutableArray *results = [self getNewsItemsNearMe:MAX_RADIUS keyWords:nil skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getNewsItemsNearMe
{
    static int skip = 0;
    NSMutableArray *results = [self getNewsItemsNearMe:MAX_RADIUS keyWords:nil skip:skip];
    skip += MAX_QUERY;
    return results;
}


/****************************************************************
 *
 *              EVENTS
 *
 *****************************************************************/

# pragma mark EVENTS

+ (NSMutableArray*) getEventsNearMe:(int)radius keyWords:(NSArray*)keyWords skip:(int)skip
{
    PFQuery *query = [PFQuery queryWithClassName:@"EventItems"];
    PFGeoPoint *currentLocation = [[Constants getInstance] getGeoPoint];
    NSMutableArray *queryArray = [[NSMutableArray alloc] init];
    
    if(keyWords) {
        //attributes
        NSArray *keysToSearch = @[@"group_name", @"time", @"source_name", @"meeting_name", @"organizer", @"location_name", @"title", @"description", @"poster_name"];
        
        for(NSString *key in keysToSearch) {
            PFQuery *fieldQuery = [PFQuery queryWithClassName:@"EventItems"];
            [fieldQuery whereKey:key containedIn:keyWords];
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

+ (NSMutableArray*) getEventsNearMe:(int)radius keyWords:(NSArray*)keyWords
{
    static int skip = 0;
    static NSArray *oldWords;
    if(!oldWords) {
        oldWords = keyWords;
    }
    else {
        if(![oldWords isEqualToArray:keyWords]) {
            skip = 0;
        }
    }
    
    NSMutableArray *results = [self getEventsNearMe:radius keyWords:keyWords skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getEventsNearMe
{
    static int skip = 0;
    NSMutableArray *results = [self getEventsNearMe:MAX_RADIUS keyWords:nil skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getEventsNearMe:(int)radius
{
    static int skip = 0;
    NSMutableArray *results = [self getEventsNearMe:radius keyWords:nil skip:skip];
    skip += MAX_QUERY;
    return results;
}

+ (NSMutableArray*) getEventsNearMeWithKeyWords:(NSArray*)keyWords
{
    static int skip = 0;
    static NSArray *oldWords;
    if(!oldWords) {
        oldWords = keyWords;
    }
    else {
        if(![oldWords isEqualToArray:keyWords]) {
            skip = 0;
        }
    }
    
    NSMutableArray *results = [self getEventsNearMe:MAX_RADIUS keyWords:keyWords skip:skip];
    skip += MAX_QUERY;
    return results;
}

@end