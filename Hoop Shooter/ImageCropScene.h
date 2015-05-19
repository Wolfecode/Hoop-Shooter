//
//  ImageCropScene.h
//  Hoop Shooter
//
//  Created by Zaha on 5/18/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ImageCropScene : SKScene <UIGestureRecognizerDelegate>

@property IBOutlet UIImageView *imageView;

@property  CGFloat circleRadius;
@property  CGPoint circleCenter;

@property CAShapeLayer *maskLayer;
@property  CAShapeLayer *circleLayer;

@property UIPinchGestureRecognizer *pinch;
@property UIPanGestureRecognizer *pan;

@end
