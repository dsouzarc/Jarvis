//
//  MainViewController.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary* requestInfo = @{
                                  
                                  // insert any additional parameters
                                  };
    
    NSURL* endPointURL = [NSURL URLWithString:[Constants soundHoundAudioURL]];
    
    // Start voice search
    
    [HoundVoiceSearch.instance
     startSearchWithRequestInfo:requestInfo
     endPointURL:endPointURL
     
     responseHandler:^(NSError* error, HoundVoiceSearchResponseType responseType, id response, NSDictionary* dictionary) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error)
             {
                 // Handle error
                 NSLog(@"Error: %@", error);
             }
             else
             {
                 if (responseType == HoundVoiceSearchResponseTypePartialTranscription)
                 {
                     // Handle partial transcription
                     
                     HoundDataPartialTranscript* partialTranscript = (HoundDataPartialTranscript*)response;
                     
                     NSLog(@"PARTIAL: %@", partialTranscript.partialTranscript);
                 }
                 else if (responseType == HoundVoiceSearchResponseTypeHoundServer)
                 {
                     // Display response JSON
                     
                     NSLog(@"HERE: %@", dictionary);
                     // Any properties from the documentation can be accessed through the keyed accessors, e.g.:
                     
                     HoundDataHoundServer* houndServer = response;
                     
                     HoundDataCommandResult* commandResult = houndServer.allResults.firstObject;
                     
                     NSDictionary* nativeData = commandResult[@"NativeData"];
                     
                     NSLog(@"NativeData: %@", nativeData);
                 }
             }
         });
     }
     ];
    

}


@end
