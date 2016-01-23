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
                 NSLog(@"Error: %@", error.description);
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

- (void) viewWillAppear:(BOOL)animated
{
    [NSNotificationCenter.defaultCenter
     addObserver:self selector:@selector(updateState)
     name:HoundVoiceSearchStateChangeNotification object:nil];
    
    [NSNotificationCenter.defaultCenter
     addObserver:self selector:@selector(audioLevel:)
     name:HoundVoiceSearchAudioLevelNotification object:nil];
    
    [NSNotificationCenter.defaultCenter
     addObserver:self selector:@selector(hotPhrase)
     name:HoundVoiceSearchHotPhraseNotification object:nil];
    
    [self updateState];
}

- (void)updateState
{
    //[self removeClearButtonFromView:self.searchBar];
    
    // Update UI state based on voice search state
    
    switch (HoundVoiceSearch.instance.state)
    {
        case HoundVoiceSearchStateNone:
            
            NSLog(@"NOT READY");
            /*self.listeningButton.selected = NO;
            
            self.searchBar.text = @"Not Ready";
            
            self.searchButton.userInteractionEnabled = NO;
            
            [self.searchButton setTitle:@"" forState:UIControlStateNormal];
            
            self.searchButton.hidden = YES;
            
            self.searchBar.showsCancelButton = NO;*/
            
            break;
            
        case HoundVoiceSearchStateReady:
            
            NSLog(@"READY");
            
            /*self.searchBar.text = @"Ready";
            
            self.searchButton.userInteractionEnabled = YES;
            
            [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
            
            self.searchButton.backgroundColor = self.view.tintColor;
            self.searchButton.hidden = NO;
            
            self.searchBar.showsCancelButton = NO;*/
            
            break;
            
        case HoundVoiceSearchStateRecording:
            
            NSLog(@"RECORDING");
            /*self.searchBar.text = @"Recording";
            
            self.searchButton.userInteractionEnabled = YES;
            
            [self.searchButton setTitle:@"Stop" forState:UIControlStateNormal];
            
            self.searchButton.backgroundColor = self.view.tintColor;
            self.searchButton.hidden = NO;
            
            self.searchBar.showsCancelButton = YES;
            
            [self enableButtonInView:self.searchBar];*/
            
            break;
            
        case HoundVoiceSearchStateSearching:
            
            NSLog(@"SEARCHING");
            
            /*
            
            self.searchBar.text = @"Searching";
            
            self.searchButton.userInteractionEnabled = YES;
            
            [self.searchButton setTitle:@"Stop" forState:UIControlStateNormal];
            
            self.searchButton.backgroundColor = self.view.tintColor;
            self.searchButton.hidden = NO;
            
            self.searchBar.showsCancelButton = NO; */
            
            break;
            
        case HoundVoiceSearchStateSpeaking:
            
            /*self.searchBar.text = @"Speaking";
            
            self.searchButton.userInteractionEnabled = YES;
            
            [self.searchButton setTitle:@"Stop" forState:UIControlStateNormal];
            
            self.searchButton.backgroundColor = UIColor.redColor;
            self.searchButton.hidden = NO;
            
            self.searchBar.showsCancelButton = NO;*/
            NSLog(@"MORE THINGS");
            
            break;
    }
}

- (void)audioLevel:(NSNotification*)notification
{
    // Display current audio level
    
    float audioLevel = [notification.object floatValue];
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear
    | UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView animateWithDuration:0.05
                          delay:0.0 options:options
     
                     animations:^{
                         
                         NSLog(@"Animate");
                     }
     
                     completion:^(BOOL finished) {
                     }
     ];
}

- (void)hotPhrase
{
    // "OK Hound" detected
    
    NSLog(@"OK HOUND DETECTED");
}

- (IBAction)listeningButtonTapped
{
    //self.listeningButton.enabled = NO;

    
    [HoundVoiceSearch.instance
     
     startListeningWithCompletionHandler:^(NSError* error) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             //self.listeningButton.enabled = YES;
             //self.listeningButton.selected = YES;
             
             if (error)
             {
                 NSLog(@"ERROR: %@", error.localizedDescription);
                 //self.textView.text = error.localizedDescription;
             }
         });
     }
     ];

}

- (IBAction)searchButtonTapped
{
    // Take action based on current voice search state
    
    switch (HoundVoiceSearch.instance.state)
    {
        case HoundVoiceSearchStateNone:
            
            break;
            
        case HoundVoiceSearchStateReady:
            NSLog(@"READY FOR SEARCH");
            
            //[self startSearch];
            
            break;
            
        case HoundVoiceSearchStateRecording:
            
            [HoundVoiceSearch.instance stopSearch];
            
            break;
            
        case HoundVoiceSearchStateSearching:
            
            [HoundVoiceSearch.instance cancelSearch];
            
            break;
            
        case HoundVoiceSearchStateSpeaking:
            
            [HoundVoiceSearch.instance stopSpeaking];
            
            break;
    }
}

- (void)enableButtonInView:(UIView*)view
{
    for (UIButton* button in view.subviews)
    {
        if ([button isKindOfClass:UIButton.class])
        {
            button.enabled = YES;
        }
        
        [self enableButtonInView:button];
    }
}

- (void)removeClearButtonFromView:(UIView*)view
{
    for (UITextField* textField in view.subviews)
    {
        if ([textField isKindOfClass:UITextField.class])
        {
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            textField.textColor = UIColor.whiteColor;
        }
        
        [self removeClearButtonFromView:textField];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
{
    return NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    if (HoundVoiceSearch.instance.state == HoundVoiceSearchStateRecording)
    {
        [HoundVoiceSearch.instance cancelSearch];
    }
}



@end
