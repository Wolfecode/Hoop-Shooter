//
//  ImageCropScene.m
//  Hoop Shooter
//
//  Created by Zaha on 5/18/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "ImageCropScene.h"
#import "SplashScreen.h"

@implementation ImageCropScene {
    float w;
    float h;
    NSUserDefaults *userDefaults;
}

-(void)didMoveToView:(SKView *)view {
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    userDefaults = [NSUserDefaults standardUserDefaults];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    self.imageView.image = [UIImage imageWithContentsOfFile:[userDefaults objectForKey:@"Ball Image"]];
    [self.view addSubview:self.imageView];
    [self editPhoto];
    
    SKLabelNode *save = [SKLabelNode labelNodeWithText:@"SAVE"];
    save.fontName = @"Myriad Pro";
    save.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    save.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    save.fontSize = 36;
    save.position = CGPointMake(w*3/4, 50);
    save.fontColor = [SKColor whiteColor];
    save.zPosition = 10;
    [self addChild:save];
    
    SKShapeNode *saveBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*11/24, save.fontSize + 30) cornerRadius:0];
    saveBox.name = @"Save";
    saveBox.position = save.position;
    saveBox.fillColor = [SKColor clearColor];
    saveBox.lineWidth = 5;
    saveBox.strokeColor = [SKColor whiteColor];
    saveBox.zPosition = 10;
    [self addChild:saveBox];
    
    SKLabelNode *cancel = [SKLabelNode labelNodeWithText:@"CANCEL"];
    cancel.fontName = @"Myriad Pro";
    cancel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    cancel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    cancel.fontSize = 36;
    cancel.position = CGPointMake(w/4, 50);
    cancel.fontColor = [SKColor whiteColor];
    cancel.zPosition = 10;
    [self addChild:cancel];
    
    SKShapeNode *cancelBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*11/24, cancel.fontSize + 30) cornerRadius:0];
    cancelBox.name = @"Cancel";
    cancelBox.position = cancel.position;
    cancelBox.fillColor = [SKColor clearColor];
    cancelBox.lineWidth = 5;
    cancelBox.strokeColor = [SKColor whiteColor];
    cancelBox.zPosition = 10;
    [self addChild:cancelBox];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    if([node.name isEqualToString:@"Save"]){
        [self didTouchUpInsideSaveButton];
    }
    if([node.name isEqualToString:@"Cancel"]){
        SplashScreen *splashScreen = [SplashScreen sceneWithSize:self.size];
        [self.view presentScene:splashScreen transition:[SKTransition doorsCloseHorizontalWithDuration:1]];
    }
}

-(void)editPhoto {
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    self.imageView.layer.mask = maskLayer;
    self.maskLayer = maskLayer;
    
    // create shape layer for circle we'll draw on top of image (the boundary of the circle)
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 3.0;
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    circleLayer.strokeColor = [[UIColor blackColor] CGColor];
    [self.imageView.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    // create circle path
    
    [self updateCirclePathAtLocation:CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0) radius:self.view.bounds.size.width * 0.30];
    
    // create pan gesture
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    [self.imageView addGestureRecognizer:pan];
    self.imageView.userInteractionEnabled = YES;
    self.pan = pan;
    
    // create pan gesture
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
    self.pinch = pinch;
}

- (void)updateCirclePathAtLocation:(CGPoint)location radius:(CGFloat)radius
{
    self.circleCenter = location;
    self.circleRadius = radius;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.circleCenter
                    radius:self.circleRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    self.maskLayer.path = [path CGPath];
    self.circleLayer.path = [path CGPath];
}

- (void)didTouchUpInsideSaveButton
{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"image.png"];
    
    CGFloat scale  = [[self.imageView.window screen] scale];
    CGFloat radius = self.circleRadius * scale;
    CGPoint center = CGPointMake(self.circleCenter.x * scale, self.circleCenter.y * scale);
    
    CGRect frame = CGRectMake(center.x - radius,
                              center.y - radius,
                              radius * 2.0,
                              radius * 2.0);
    
    // temporarily remove the circleLayer
    
    CALayer *circleLayer = self.circleLayer;
    [self.circleLayer removeFromSuperlayer];
    
    // render the clipped image
    
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([self.imageView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        // if iOS 7, just draw it
        
        [self.imageView drawViewHierarchyInRect:self.imageView.bounds afterScreenUpdates:YES];
    }
    else
    {
        // if pre iOS 7, manually clip it
        
        CGContextAddArc(context, self.circleCenter.x, self.circleCenter.y, self.circleRadius, 0, M_PI * 2.0, YES);
        CGContextClip(context);
        [self.imageView.layer renderInContext:context];
    }
    
    // capture the image and close the context
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // add the circleLayer back
    
    [self.imageView.layer addSublayer:circleLayer];
    
    // crop the image
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    // save the image
    
    NSData *data = UIImagePNGRepresentation(croppedImage);
    [data writeToFile:path atomically:YES];
    
    [userDefaults setObject:path forKey:@"Ball Image"];
    [self.imageView removeFromSuperview];
    
    // tell the user we're done
    
//    [[[UIAlertView alloc] initWithTitle:nil message:@"Saved" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    SplashScreen *splashScreen = [SplashScreen sceneWithSize:self.size];
    [self.view presentScene:splashScreen transition:[SKTransition doorsCloseHorizontalWithDuration:1]];
}

#pragma mark - Gesture recognizers

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    static CGPoint oldCenter;
    CGPoint tranlation = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        oldCenter = self.circleCenter;
    }
    
    CGPoint newCenter = CGPointMake(oldCenter.x + tranlation.x, oldCenter.y + tranlation.y);
    
    [self updateCirclePathAtLocation:newCenter radius:self.circleRadius];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    static CGFloat oldRadius;
    CGFloat scale = [gesture scale];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        oldRadius = self.circleRadius;
    }
    
    CGFloat newRadius = oldRadius * scale;
    
    [self updateCirclePathAtLocation:self.circleCenter radius:newRadius];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ((gestureRecognizer == self.pan   && otherGestureRecognizer == self.pinch) ||
        (gestureRecognizer == self.pinch && otherGestureRecognizer == self.pan))
    {
        return YES;
    }
    
    return NO;
}

@end