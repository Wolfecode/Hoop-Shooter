//
//  TimedScene.m
//  Hoop Shooter
//
//  Created by Zaha on 4/30/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "TimedScene.h"
#import "HighscoreDisplayScene.h"
#import "SplashScreen.h"

@implementation TimedScene {
    float w;
    float h;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    _timerDuration = 1;
    _timerLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%i",_timerDuration]];
    _timerLabel.fontSize = 48;
    _timerLabel.fontColor = [SKColor whiteColor];
    _timerLabel.position = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-42);
    [self addChild:_timerLabel];
}

-(void)countDown {
    if (!self.isGamePaused) {
        _timerDuration--;
    }
    _timerLabel.text = [NSString stringWithFormat:@"%i",_timerDuration];
    if(_timerDuration == 0){
        [_timer invalidate];
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"SAVE YOUR SCORE"
                                                              message:@"Save your name along with your score so you can check out your own High Scores!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
        myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [myAlertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        NSString *name;
        if([[alertView textFieldAtIndex:0] hasText]){
            name = [[alertView textFieldAtIndex:0] text];
            [name capitalizedString];
        }
        else {
           name = @"No Name";
        }
        
        [self saveToParse:name];
//        [self saveLocally:name];
    }
    else {
        SplashScreen *splashScreen = [SplashScreen sceneWithSize:self.size];
        [self.view presentScene:splashScreen transition:[SKTransition pushWithDirection:SKTransitionDirectionDown duration:1]];
    }
}

-(void)pauseGame {
    [super pauseGame];
    self.home.position = CGPointMake(w/2, h/2 + 100);
    self.homeBox.position = self.home.position;
    
    _highscores = [SKLabelNode labelNodeWithText:@"HIGHSCORES"];
    _highscores.fontName = @"Myriad Pro";
    _highscores.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _highscores.fontSize = 36;
    _highscores.position = CGPointMake(w/2, h/2);
    _highscores.fontColor = [SKColor whiteColor];
    _highscores.zPosition = 10;
    [self addChild:_highscores];
    
    _highscoresBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, self.highscores.fontSize + 30) cornerRadius:0];
    _highscoresBox.name = @"Highscores Box";
    _highscoresBox.position = self.highscores.position;
    _highscoresBox.fillColor = [SKColor clearColor];
    _highscoresBox.lineWidth = 5;
    _highscoresBox.strokeColor = [SKColor whiteColor];
    _highscoresBox.zPosition = 10;
    [self addChild:_highscoresBox];
    
    self.resume.position = CGPointMake(w/2, h/2 - 100);
    self.resumeBox.position = self.resume.position;
}

-(void)unpauseGame {
    [super unpauseGame];
    
    [_highscores removeFromParent];
    [_highscoresBox removeFromParent];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    if([node.name isEqualToString:@"Highscores Box"]) {
        [_timer invalidate];
        HighscoreDisplayScene *highscoreDisplayScene = [HighscoreDisplayScene sceneWithSize:self.size];
        [self.view presentScene:highscoreDisplayScene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:1]];
    }
}

-(void)saveToParse:(NSString *)name {
    PFObject *globalScore = [PFObject objectWithClassName:@"GlobalScores"];
    [globalScore setObject:name forKey:@"userName"];
    [globalScore setObject:@"userId" forKey:@"userId"];
    [globalScore setObject:[NSNumber numberWithInt:self.score] forKey:@"userScore"];
    [globalScore saveEventually];
    
    PFObject *score = [PFObject objectWithClassName:@"UserName"];
    [score setObject:name forKey:@"userName"];
    [score setObject:@"userId" forKey:@"userId"];
    [score setObject:[NSNumber numberWithInt:self.score] forKey:@"userScore"];
    
    [score saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            HighscoreDisplayScene *highscoreDisplayScene = [HighscoreDisplayScene sceneWithSize:self.size];
            [self.view presentScene:highscoreDisplayScene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:1]];
        }
        else {
            [score saveEventually];
            UIAlertView *internetError = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Sorry, there seems to be a problem connecting to the internet. Please try again soon." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
            [internetError show];
            NSLog(@"%@",error);
        }
    }];
}

@end
