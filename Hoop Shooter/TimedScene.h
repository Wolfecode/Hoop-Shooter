//
//  TimedScene.h
//  Hoop Shooter
//
//  Created by Zaha on 4/30/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "GameScene.h"
#import <Parse/Parse.h>

@interface TimedScene : GameScene <UIAlertViewDelegate>

@property NSTimer *timer;
@property int timerDuration;
@property SKLabelNode *timerLabel;
@property SKLabelNode *highscores;
@property SKShapeNode *highscoresBox;

@end
