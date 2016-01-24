//
//  MainViewController.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIButton *houndifyMicrophoneButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property BOOL microphoneIsRecognizing;

@end

@implementation MainViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.microphoneIsRecognizing = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[HoundVoiceSearch instance] enableSpeech];
    [[HoundVoiceSearch instance] enableHotPhraseDetection];
    [[HoundVoiceSearch instance] enableEndOfSpeechDetection];
    
    [self.houndifyMicrophoneButton addTarget:self action:@selector(microphoneButtonHeldDown:) forControlEvents:UIControlEventTouchDown];
    
    self.houndifyMicrophoneButton.clipsToBounds = YES;
    self.houndifyMicrophoneButton.layer.cornerRadius = self.houndifyMicrophoneButton.frame.size.width / 2.0;
    
    [HoundVoiceSearch.instance startListeningWithCompletionHandler:^(NSError* error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"ERROR IN VIEW DID LOAD: %@", error.localizedDescription);
            }
        });
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.houndifyMicrophoneButton.alpha = 0.5f;
    self.houndifyMicrophoneButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height * 10);
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateState) name:HoundVoiceSearchStateChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(audioLevel:) name:HoundVoiceSearchAudioLevelNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hotPhrase) name:HoundVoiceSearchHotPhraseNotification object:nil];
    
    [self updateState];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Translates from bottom to middle of screen
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        self.houndifyMicrophoneButton.alpha = 1.0f;
        [self.houndifyMicrophoneButton setFrame:CGRectMake(0, 0, self.houndifyMicrophoneButton.frame.size.width * 2.0, self.houndifyMicrophoneButton.frame.size.height * 2.0)];
        self.houndifyMicrophoneButton.center = self.view.center;
    } completion:^(BOOL completed) {
        //Translattes back down to appropriate location
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^(void) {
            self.houndifyMicrophoneButton.alpha = 1.5f;
            [self.houndifyMicrophoneButton setFrame:CGRectMake(0, 0, self.houndifyMicrophoneButton.frame.size.width * (2/3), self.houndifyMicrophoneButton.frame.size.height * (2/3))];
            self.houndifyMicrophoneButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (40 + 80));
        } completion:^(BOOL completed) {
            
        }];
    }];
    
    //All while spinning
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 30 * 2.0 ];
    rotationAnimation.duration = 1.1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.timeOffset = 0.0;
    rotationAnimation.repeatCount = 1.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.houndifyMicrophoneButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    self.houndifyMicrophoneButton.layer.shadowRadius = 7.0f;
    self.houndifyMicrophoneButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.houndifyMicrophoneButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.houndifyMicrophoneButton.layer.shadowOpacity = 0.5f;
    self.houndifyMicrophoneButton.layer.masksToBounds = NO;
    
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        [UIView setAnimationRepeatCount:INT_MAX];
        self.houndifyMicrophoneButton.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        
    } completion:^(BOOL finished) {
        
        self.houndifyMicrophoneButton.layer.shadowRadius = 0.0f;
        self.houndifyMicrophoneButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
}

- (void) startSearch
{
    NSDictionary* requestInfo = @{};
    
    NSURL* endPointURL = [NSURL URLWithString:[Constants soundHoundAudioURL]];
    [HoundVoiceSearch.instance startSearchWithRequestInfo:requestInfo
                                              endPointURL:endPointURL
                                          responseHandler:^(NSError* error, HoundVoiceSearchResponseType responseType, id response, NSDictionary* dictionary) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if (error) {
                                                      NSLog(@"Error ub start search: %@", error.description);
                                                  }
                                                  else {
                                                      if (responseType == HoundVoiceSearchResponseTypePartialTranscription) {
                                                          HoundDataPartialTranscript* partialTranscript = (HoundDataPartialTranscript*)response;
                                                          NSLog(@"PARTIAL: %@", partialTranscript.partialTranscript);
                                                      }
                                                      else if (responseType == HoundVoiceSearchResponseTypeHoundServer) {
                                                          NSLog(@"HERE: %@", dictionary);
                                                          HoundDataHoundServer* houndServer = response;
                                                          HoundDataCommandResult* commandResult = houndServer.allResults.firstObject;
                                                          NSDictionary* nativeData = commandResult[@"NativeData"];
                                                          NSLog(@"NativeData: %@", nativeData);
                                                      }
                                                      else {
                                                          NSLog(@"WE GOT NOTHING: %@", response);
                                                      }
                                                  }
                                              });
                                          }];
}

- (void)updateState
{
    switch (HoundVoiceSearch.instance.state) {
        case HoundVoiceSearchStateNone:
            NSLog(@"NOT READY");
            break;
            
        case HoundVoiceSearchStateReady:
            NSLog(@"READY");
            break;
            
        case HoundVoiceSearchStateRecording:
            NSLog(@"RECORDING");
            break;
            
        case HoundVoiceSearchStateSearching:
            NSLog(@"SEARCHING");
            break;
            
        case HoundVoiceSearchStateSpeaking:
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
                         //self.view.frame.size.height - self.levelView.frame.size.height,
                         //audioLevel * self.view.frame.size.width,
                         //self.levelView.frame.size.height
                     }
     ];
}

- (void)hotPhrase
{
    //[self startSearch];
    NSLog(@"OK HOUND DETECTED");
}

- (IBAction)listeningButtonTapped
{
    NSLog(@"TAPPED HERE");
    
    [HoundVoiceSearch.instance startListeningWithCompletionHandler:^(NSError* error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (error) {
                NSLog(@"ERROR: %@", error.localizedDescription);
            }
        });
    }];
    
}

- (IBAction)searchButtonTapped
{
    [self switchHoundVoiceState];
}

- (void) switchHoundVoiceState
{
    switch (HoundVoiceSearch.instance.state) {
        case HoundVoiceSearchStateNone:
            break;
            
        case HoundVoiceSearchStateReady:
            [self startSearch];
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

- (IBAction)microphoneButtonHeldDown:(id)sender
{
    
}

- (IBAction)microphoneButtonPressed:(id)sender
{
    [self switchHoundVoiceState];
}

@end