//
//  MainViewController.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/23/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "MainViewController.h"

@interface VisualizerLineView : UIView

@property int counter;
- (instancetype) initWithFrame:(CGRect)frame audioLevel:(float)audioLevel;

@end

@interface VisualizerLineView ()

@property CGPoint startPoint;
@property CGPoint endPoint;

@property float audioLevel;

@end

@implementation VisualizerLineView

- (instancetype) initWithFrame:(CGRect)frame audioLevel:(float)audioLevel
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.audioLevel = audioLevel;
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect
{
    UIBezierPath *audioVisualBezierPath = [UIBezierPath bezierPath];
    CAShapeLayer *audioVisualShapeLayer = [CAShapeLayer layer];
    
    self.startPoint = CGPointMake(0, 0);
    self.endPoint = CGPointMake(0, self.frame.size.height);
    
    [audioVisualBezierPath moveToPoint:self.startPoint];
    [audioVisualBezierPath addLineToPoint:self.endPoint];
    audioVisualShapeLayer.path  = [audioVisualBezierPath CGPath];
    [audioVisualShapeLayer setStrokeColor:[[UIColor blueColor] CGColor]];
    audioVisualShapeLayer.lineWidth = 1.0f;
    
    [self.layer addSublayer:audioVisualShapeLayer];
}

@end

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIButton *houndifyMicrophoneButton;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) UIBezierPath *audioVisualBezierPath;
@property (strong, nonatomic) CAShapeLayer *audioVisualShapeLayer;
@property (strong, nonatomic) PQFBouncingBalls *loadingAnimation;

@property (strong, nonatomic) HoundHandler *houndHandler;

@property BOOL microphoneIsRecognizing;

@end

@implementation MainViewController


- (void)audioLevel:(NSNotification*)notification
{
    static int lastCalledTime = -1;
    
    if(lastCalledTime == -1) {
        lastCalledTime = (int) CACurrentMediaTime();
    }
    else if(lastCalledTime == (int)CACurrentMediaTime()) {
        //return;
    }
    else {
        lastCalledTime = (int) CACurrentMediaTime();
    }
    
    
    if((int)CACurrentMediaTime() % 2 == 0) {
        NSLog(@"IS EVEN\t%f\t%f", CACurrentMediaTime(), [notification.object floatValue]);
    }
    else {
        NSLog(@"IS ODD\t%f\t%f", CACurrentMediaTime(), [notification.object floatValue]);
    }
    
    // Display current audio level
    
    //Between 0 and 1
    float audioLevel = [notification.object floatValue];

    CGPoint startPoint = CGPointMake(0, self.view.frame.size.height);
    CGPoint endPoint = CGPointMake(0, self.view.frame.size.height - (audioLevel * 100.0));
    
    static int counter = 0;
    
    if(audioLevel > 0.5) {
        //NSLog(@"AUDIO LEVEL UPPER\t%f", audioLevel);
    }
    else {
        //NSLog(@"AUDIO LEVEL UPPER\t%f", audioLevel);
    }
    
    //NSLog(@"%f\t%f\t%f", self.view.frame.size.height, audioLevel, endPoint.y);
    
    //VisualizerLineView *lineView = [[VisualizerLineView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - (audioLevel * 300.0), 10, audioLevel * 300.0) startPoint:startPoint endPoint:endPoint];
    VisualizerLineView *lineView = [[VisualizerLineView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - (audioLevel * 100.0), 1, audioLevel * 100.0) audioLevel:audioLevel];
    lineView.counter = counter;
    counter++;
    [self.view addSubview:lineView];
    [UIView animateWithDuration:5
                     animations:^(void) {
                         lineView.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height - (audioLevel * 100.0), 1, audioLevel * 100.0);
                     } completion:^(BOOL finished) {
                         [lineView removeFromSuperview];
                     }
     ];
    
    /*[self.audioVisualShapeLayer removeFromSuperlayer];
     self.audioVisualBezierPath = [UIBezierPath bezierPath];
     self.audioVisualShapeLayer = [CAShapeLayer layer];
     
     [self.audioVisualBezierPath moveToPoint:CGPointMake(self.houndifyMicrophoneButton.center.x, self.houndifyMicrophoneButton.center.y)];
     [self.audioVisualBezierPath addLineToPoint:CGPointMake(self.houndifyMicrophoneButton.center.x, self.houndifyMicrophoneButton.center.y - 300 * audioLevel)];
     self.audioVisualShapeLayer.path  = [self.audioVisualBezierPath CGPath];
     self.audioVisualShapeLayer.lineWidth = 3.0f;
     
     if(self.microphoneIsRecognizing) {
     self.audioVisualShapeLayer.strokeColor = [[UIColor greenColor] CGColor];
     self.audioVisualShapeLayer.fillColor = [[UIColor greenColor] CGColor];
     }
     else {
     self.audioVisualShapeLayer.strokeColor = [[UIColor redColor] CGColor];
     self.audioVisualShapeLayer.fillColor = [[UIColor redColor] CGColor];
     }
     
     [self.view.layer addSublayer:self.audioVisualShapeLayer];*/
}


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
        self.houndHandler = [HoundHandler getInstance];
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
    
    self.loadingAnimation = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
    self.loadingAnimation.loaderColor = [UIColor blueColor];
    self.loadingAnimation.diameter = 25.0f;
    self.loadingAnimation.cornerRadius = 25.0f;
    
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

- (void) showLoadingAnimation
{
    [self.loadingAnimation show];
}

- (void) hideLoadingAnimation
{
    [self.loadingAnimation hide];
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
                     }
                     completion:^(BOOL finished) {
                         self.houndifyMicrophoneButton.layer.shadowRadius = 0.0f;
                         self.houndifyMicrophoneButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         self.houndifyMicrophoneButton.frame = CGRectMake(self.view.center.x, 432, 80, 80); //0, 0, self.houndifyMicrophoneButton.frame.size.width * (2/3), self.houndifyMicrophoneButton.frame.size.height * (2/3));
                         self.houndifyMicrophoneButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (40 + 80));
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
                                                              
                                                              UILabel *floatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                                                              floatingLabel.center = self.view.center;
                                                              [floatingLabel setText:partialTranscript.partialTranscript];
                                                              [self.view addSubview:floatingLabel];
                                                              [self.view layoutIfNeeded];
                                                              
                                                              [UIView transitionWithView:floatingLabel duration:0.5f options:UIViewAnimationOptionCurveEaseOut
                                                                              animations:^(void) {
                                                                                  [floatingLabel setCenter:self.textView.center];
                                                                                  floatingLabel.alpha = 0.65;
                                                                              }
                                                                              completion:^(BOOL finished) {
                                                                                  [self.textView setText:floatingLabel.text];
                                                                                  [floatingLabel removeFromSuperview];
                                                                                  
                                                                                  //Change the TextView?
                                                                              }
                                                               ];
                                                          }
                                                          NSLog(@"PARTIAL: %@", partialTranscript.partialTranscript);
                                                      }
                                                      else if (responseType == HoundVoiceSearchResponseTypeHoundServer) {
                                                          
                                                          HoundDataHoundServer *houndServer = response;
                                                          HoundDataCommandResult *commandResult = houndServer.allResults.firstObject;
                                                          NSDictionary *nativeData = commandResult[@"NativeData"];
                                                          [self.textView setText:[self.houndHandler getTranscription:dictionary]];
                                                          NSLog(@"FINISHED HERE: %@", self.textView.text);
                                                          [self.houndHandler handleHoundResponse:dictionary nativeData:nativeData];
                                                          NSLog(@"Signaled delegate");
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

- (void) showText:(NSString *)text
{
    [self.textView setText:text];
}

@end

