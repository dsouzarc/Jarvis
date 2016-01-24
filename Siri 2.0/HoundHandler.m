//
//  HoundHandler.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/24/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "HoundHandler.h"

@implementation HoundHandler

+ (void) handleHoundResponse:(NSDictionary *)response nativeData:(NSDictionary *)nativeData
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
    
    NSLog(@"CommandKind: %@", commandKind);
    NSLog(@"WrittenResponse: %@", writtenResponse);
    NSLog(@"Transcription: %@", transcription);
}

@end