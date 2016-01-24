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

@property (strong, nonatomic) UIBezierPath *audioVisualBezierPath;
@property (strong, nonatomic) CAShapeLayer *audioVisualShapeLayer;

@property BOOL microphoneIsRecognizing;

@end

@implementation MainViewController


/****************************************************************
 *
 *              Constructor + Inherited Methods
 *
*****************************************************************/

# pragma mark Constructor + Inherited Methods

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.microphoneIsRecognizing = NO;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.houndifyMicrophoneButton.alpha = 0.0f;
    self.houndifyMicrophoneButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height * 10);
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateState) name:HoundVoiceSearchStateChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(audioLevel:) name:HoundVoiceSearchAudioLevelNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hotPhrase) name:HoundVoiceSearchHotPhraseNotification object:nil];
    
    [self updateState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioVisualBezierPath = [UIBezierPath bezierPath];
    self.audioVisualShapeLayer = [CAShapeLayer layer];
    [self.view.layer addSublayer:self.audioVisualShapeLayer];

    self.houndifyMicrophoneButton.clipsToBounds = YES;
    self.houndifyMicrophoneButton.layer.cornerRadius = self.houndifyMicrophoneButton.frame.size.width / 2.0;
    
    [[HoundVoiceSearch instance] enableSpeech];
    [[HoundVoiceSearch instance] enableHotPhraseDetection];
    [[HoundVoiceSearch instance] enableEndOfSpeechDetection];
    
    [HoundVoiceSearch.instance startListeningWithCompletionHandler:^(NSError* error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"ERROR IN VIEW DID LOAD: %@", error.localizedDescription);
            }
        });
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Translates from bottom to middle of screen
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^(void) {
                         self.houndifyMicrophoneButton.alpha = 1.0f;
                         self.houndifyMicrophoneButton.frame = CGRectMake(0, 0, self.houndifyMicrophoneButton.frame.size.width * 2.0, self.houndifyMicrophoneButton.frame.size.height * 2.0);
                         self.houndifyMicrophoneButton.center = self.view.center;
                     }
                     completion:^(BOOL completed) {
                         //Translattes back down to appropriate location
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options:UIViewAnimationOptionTransitionNone
                                          animations:^(void) {
                                              self.houndifyMicrophoneButton.alpha = 1.5f;
                                              self.houndifyMicrophoneButton.frame = CGRectMake(self.view.center.x, 432, 80, 80); //0, 0, self.houndifyMicrophoneButton.frame.size.width * (2/3), self.houndifyMicrophoneButton.frame.size.height * (2/3));
                                              self.houndifyMicrophoneButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (40 + 80));
                                          }
                                          completion:^(BOOL completed) {
                                          }
                          ];
                     }
     ];
    
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
    
    [UIView animateWithDuration:1.0f delay:0
                        options:UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat
                     animations:^{
                         [UIView setAnimationRepeatCount:INT_MAX];
                         self.houndifyMicrophoneButton.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                          [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.houndifyMicrophoneButton.layer.shadowRadius = 0.0f;
                         self.houndifyMicrophoneButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         
                         //self.houndifyMicrophoneButton.frame = CGRectMake(self.view.center.x, 432, 80, 80); //0, 0, self.houndifyMicrophoneButton.frame.size.width * (2/3), self.houndifyMicrophoneButton.frame.size.height * (2/3));
                         //self.houndifyMicrophoneButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (40 + 80));
                         NSLog(@"DECREASING: %@", NSStringFromCGRect(self.houndifyMicrophoneButton.frame));
                     }
     ];
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
                                                      NSLog(@"Error at start search: %@", error.description);
                                                  }
                                                  else {
                                                      if (responseType == HoundVoiceSearchResponseTypePartialTranscription) {
                                                          
                                                          
                                                          static HoundDataPartialTranscript *oldPartialTranscript;
                                                          HoundDataPartialTranscript* partialTranscript = (HoundDataPartialTranscript*)response;
                                                          
                                                          //If it's different from what we had, send it up
                                                          if(!oldPartialTranscript || ![oldPartialTranscript.partialTranscript isEqualToString:partialTranscript.partialTranscript]) {
                                                              oldPartialTranscript = partialTranscript;
                                                              
                                                              UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                                                              textLabel.center = self.view.center;
                                                              [textLabel setText:partialTranscript.partialTranscript];
                                                              [self.textView setText:partialTranscript.partialTranscript];
                                                              //[self.view addSubview:textLabel];
                                                              [self.view layoutIfNeeded];
                                                              /*[UIView transitionWithView:textLabel
                                                                                duration:0.5f
                                                                                 options:UIViewAnimationOptionCurveEaseOut
                                                                              animations:^(void) {
                                                                                  [textLabel setCenter:CGPointZero];
                                                                              } 
                                                                              completion:^(BOOL finished) {
                                                                                  // Do nothing
                                                                              }];
                                                              
                                                              [UIView animateWithDuration:1.5 animations:^(void) {
                                                                  textLabel.frame = CGRectMake(0, 0, 50, 50);
                                                              } completion:^(BOOL completed) {
                                                                  self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, textLabel.text];
                                                                  //[textLabel setHidden:YES];
                                                           
                                                              }];*/
                                                              }
                                                          NSLog(@"PARTIAL: %@", partialTranscript.partialTranscript);
                                                      }
                                                      else if (responseType == HoundVoiceSearchResponseTypeHoundServer) {
                                                          HoundDataHoundServer *houndServer = response;
                                                          HoundDataCommandResult *commandResult = houndServer.allResults.firstObject;
                                                          NSDictionary *nativeData = commandResult[@"NativeData"];
                                                          [HoundHandler handleHoundResponse:dictionary nativeData:nativeData];
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
            NSLog(@"NOT RECORDING");
            self.microphoneIsRecognizing = NO;
            break;
            
        case HoundVoiceSearchStateReady:
            NSLog(@"READY TO RECORD");
            self.microphoneIsRecognizing = NO;
            break;
            
        case HoundVoiceSearchStateRecording:
            NSLog(@"RECORDING");
            self.microphoneIsRecognizing = YES;
            break;
            
        case HoundVoiceSearchStateSearching:
            NSLog(@"SEARCHING");
            self.microphoneIsRecognizing = NO;
            break;
            
        case HoundVoiceSearchStateSpeaking:
            NSLog(@"ITS SPEAKING TO ME");
            self.microphoneIsRecognizing = NO;
            break;
    }
}

- (void)audioLevel:(NSNotification*)notification
{
    // Display current audio level
    
    //Between 0 and 1
    float audioLevel = [notification.object floatValue];
    
    [self.audioVisualShapeLayer removeFromSuperlayer];
    self.audioVisualBezierPath = [UIBezierPath bezierPath];
    self.audioVisualShapeLayer = [CAShapeLayer layer];

    [self.audioVisualBezierPath moveToPoint:CGPointMake(self.houndifyMicrophoneButton.center.x, self.houndifyMicrophoneButton.center.y)];
    [self.audioVisualBezierPath addLineToPoint:CGPointMake(self.houndifyMicrophoneButton.center.x, self.houndifyMicrophoneButton.center.y - 300 * audioLevel)];
    self.audioVisualShapeLayer.path  = [self.audioVisualBezierPath CGPath];
    
    if(self.microphoneIsRecognizing) {
        self.audioVisualShapeLayer.strokeColor = [[UIColor greenColor] CGColor];
        self.audioVisualShapeLayer.fillColor = [[UIColor greenColor] CGColor];
    }
    else {
        self.audioVisualShapeLayer.strokeColor = [[UIColor redColor] CGColor];
        self.audioVisualShapeLayer.fillColor = [[UIColor redColor] CGColor];
    }
    
    [self.view.layer addSublayer:self.audioVisualShapeLayer];
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


/****************************************************************
 *
 *               Listeners
 *
*****************************************************************/

# pragma mark Listeners

- (IBAction)microphoneButtonHeldDown:(id)sender
{
    NSLog(@"HOLD DOWN");
}

- (IBAction)microphoneButtonPressed:(id)sender
{
    NSLog(@"CLICKKK");
    [self switchHoundVoiceState];
}

- (void)hotPhrase
{
    [self startSearch];
    NSLog(@"OK HOUND DETECTED");
}

@end