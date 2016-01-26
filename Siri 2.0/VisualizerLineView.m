
//
//  VisualizerLineView.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/26/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "VisualizerLineView.h"

@interface VisualizerLineView ()

@property float audioLevel;
@property BOOL isListening;

@end

@implementation VisualizerLineView

- (instancetype) initWithFrame:(CGRect)frame audioLevel:(float)audioLevel isListening:(BOOL)isListening
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.audioLevel = audioLevel;
        self.isListening = isListening;
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect
{
    UIBezierPath *audioVisualBezierPath = [UIBezierPath bezierPath];
    CAShapeLayer *audioVisualShapeLayer = [CAShapeLayer layer];
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(0, self.frame.size.height);
    
    [audioVisualBezierPath moveToPoint:startPoint];
    [audioVisualBezierPath addLineToPoint:endPoint];
    
    if(self.isListening) {
        [audioVisualShapeLayer setStrokeColor:[[UIColor greenColor] CGColor]];
    }
    else {
        [audioVisualShapeLayer setStrokeColor:[[UIColor redColor] CGColor]];
    }
    
    audioVisualShapeLayer.path  = [audioVisualBezierPath CGPath];
    audioVisualShapeLayer.lineWidth = 1.0f;
    
    [self.layer addSublayer:audioVisualShapeLayer];
}

@end