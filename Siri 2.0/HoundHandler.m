//
//  HoundHandler.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/24/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "HoundHandler.h"

static HoundHandler *houndHandler;

@implementation HoundHandler

+ (instancetype) getInstance
{
    @synchronized(self) {
        if(!houndHandler) {
            houndHandler = [[self alloc] init];
        }
    }
    
    return houndHandler;
}

- (instancetype) init
{
    self = [super init];
    return self;
}

- (NSString*) getTranscription:(NSDictionary*)response
{
    
    NSDictionary *allResults = [response[@"AllResults"] firstObject];
    NSDictionary *disambiguation = response[@"Disambiguation"];
    NSDictionary *choiceData = [disambiguation[@"ChoiceData"] firstObject];
    
    NSString *commandKind = allResults[@"CommandKind"];
    NSString *writtenResponse = allResults[@"WrittenResponse"];
    NSString *transcription = choiceData[@"Transcription"];
    
    return transcription;
}

- (void) handleHoundResponse:(NSDictionary *)response nativeData:(NSDictionary *)nativeData
{
    if(nativeData) {
        NSLog(@"NATIVE DATA%@", nativeData);
    }
    
    NSDictionary *allResults = [response[@"AllResults"] firstObject];
    NSDictionary *disambiguation = response[@"Disambiguation"];
    NSDictionary *choiceData = [disambiguation[@"ChoiceData"] firstObject];
    
    NSString *commandKind = allResults[@"CommandKind"];
    NSString *writtenResponse = allResults[@"WrittenResponse"];
    NSString *transcription = choiceData[@"Transcription"];
    
    //No text
    if(!transcription || transcription.length == 0) {
        [self.delegate noResponse];
        return;
    }
    
    //Known functions - addition, times, etc. the simple stuff
    if(![commandKind isEqualToString:@"NoResultCommand"]) {
        [self.delegate commandNotSupported:commandKind transcription:transcription];
    }
    
    transcription = [transcription lowercaseString];
    
    //Community service
    NSArray *keyWords = @[@"happy", @"happiness", @"community", @"service", @"help", @"old", @"homeless", @"kind", @"caring", @"red", @"cross", @"act", @"of", @"kindness", @"soup", @"kitch", @"food", @"drive"];
    for(NSString *keyWord in keyWords) {
        if([transcription containsString:keyWord]) {
            [self.delegate wantsCommunityService];
            return;
        }
    }
    
    NSArray *eventIndicators = @[@"event", @"to do", @"thing", @"concert", @"reading", @"learn"];
    for(NSString *eventIndicator in eventIndicators) {
        if([transcription containsString:eventIndicator]) {
            [self handleEvents:transcription];
            return;
        }
    }
    
    NSArray *newsItemIndicators = @[@"restaurant", @"eat", @"place", @"to", @"food", @"fine", @"dining"];
    for(NSString *newItemIndicator in newsItemIndicators) {
        if([transcription containsString:newItemIndicator]) {
            [self handleNewsItems:transcription];
            return;
        }
    }
    
    [self handleNewsItems:transcription];
    
    //[self.delegate notUnderstandableResponse];
    
    /*NSLog(@"CommandKind: %@", commandKind);
    NSLog(@"WrittenResponse: %@", writtenResponse);
    NSLog(@"Transcription: %@", transcription);*/
}

- (void) handleNewsItems:(NSString*)transcription
{
    int distance = [self getNumberFromWords:transcription];
    NSArray *words = [self getKeyWords:transcription];
    
    //No distance and too many words
    if(distance <= 0 && words.count > MAX_KEY_WORDS) {
        [self.delegate wantsNewsItemsNearThem];
    }
    else if(distance > 0 && words.count > MAX_KEY_WORDS) {
        [self.delegate wantsNewsItemsNearThem:distance];
    }
    else if(distance > 0 && words.count <= MAX_KEY_WORDS) {
        [self.delegate wantsNewsItemsNearThem:distance keyWords:words];
    }
    else if(distance <= 0 && words.count <= MAX_KEY_WORDS) {
        [self.delegate wantsNewsItemsNearThemWithKeyWords:words];
    }
    else {
        [self.delegate wantsNewsItemsNearThem];
    }
}

- (void) handleEvents:(NSString*)transcription
{
    int distance = [self getNumberFromWords:transcription];
    NSArray *words = [self getKeyWords:transcription];
    
    //No distance and too many words
    if(distance <= 0 && words.count > MAX_KEY_WORDS) {
        [self.delegate wantsEventsNearThem];
    }
    else if(distance > 0 && words.count > MAX_KEY_WORDS) {
        [self.delegate wantsEventsNearThem:distance];
    }
    else if(distance > 0 && words.count <= MAX_KEY_WORDS) {
        [self.delegate wantsEventsNearThem:distance keyWords:words];
    }
    else if(distance <= 0 && words.count <= MAX_KEY_WORDS) {
        [self.delegate wantsEventsNearThemWithKeyWords:words];
    }
    else {
        [self.delegate wantsEventsNearThem];
    }
}

- (NSArray*) getKeyWords:(NSString*)transcription
{
    NSArray *wordsToRemove = @[@"i", @"you", @"me", @"us", @"they", @"he", @"him", @"her", @"their", @"she", @"it", @"them", @"the", @"for", @"why", @"in", @"to", @"we", @"and", @"but", @"with"];
    NSMutableArray *words = [NSMutableArray arrayWithArray:[transcription componentsSeparatedByString:@" "]];
    [words removeObjectsInArray:wordsToRemove];
    return words;
}

- (int) getNumberFromWords:(NSString*)text
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];

    //Start off with the big numbers, relatively large.
    for(int i = 100; i >= 0; i--) {
        NSString *number = [[numberFormatter stringFromNumber:@(i)] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        //Number contains (ie. one hundred and one)
        if([text containsString:number]) {

            //Same length ie. one and one
            if([text rangeOfString:number].length == number.length) {
                return i;
            }
        }
    }

    //Not found
    return -1;
}

@end