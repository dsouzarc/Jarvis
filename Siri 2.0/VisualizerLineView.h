//
//  VisualizerLineView.h
//  Siri 2.0
//
//  Created by Ryan D'souza on 1/26/16.
//  Copyright © 2016 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Line visualizer for detecting audio */

@interface VisualizerLineView : UIView

- (instancetype) initWithFrame:(CGRect)frame audioLevel:(float)audioLevel isListening:(BOOL)isListening;

@end