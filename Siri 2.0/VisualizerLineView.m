
//
//  VisualizerLineView.m
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/26/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import "VisualizerLineView.h"

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