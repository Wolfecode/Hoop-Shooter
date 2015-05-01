//
//  TimedScene.m
//  Hoop Shooter
//
//  Created by Zaha on 4/30/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "TimedScene.h"
#import "HighscoreDisplayScene.h"

@implementation TimedScene {
    NSTimer *timer;
    int timerDuration;
    SKLabelNode *timerLabel;
    float w;
    float h;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    timerDuration = 15;
    timerLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%i",timerDuration]];
    timerLabel.fontSize = 48;
    timerLabel.fontColor = [SKColor whiteColor];
    timerLabel.position = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-42);
    [self addChild:timerLabel];
}

-(void)countDown {
    timerDuration--;
    timerLabel.text = [NSString stringWithFormat:@"%i",timerDuration];
    if(timerDuration == 0){
        [timer invalidate];
        
        [self saveToParse];
        
        
    }
}

-(void)saveToParse {
//    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(w/2, h/2+20, 200, 40)];
//    textField.center = self.view.center;
//    textField.borderStyle = UITextBorderStyleRoundedRect;
//    textField.textColor = [UIColor blackColor];
//    textField.font = [UIFont systemFontOfSize:17.0];
//    textField.placeholder = @"Enter your name here";
//    textField.backgroundColor = [UIColor whiteColor];
//    textField.autocorrectionType = UITextAutocorrectionTypeYes;
//    textField.keyboardType = UIKeyboardTypeDefault;
//    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.delegate = self.delegate;
//    [self.view addSubview:textField];
//    
//    SKAction *wait = [SKAction waitForDuration:5.0];
//    [self runAction:wait];
    
    PFObject *score = [PFObject objectWithClassName:@"UserName"];
    [score setObject:@"name" forKey:@"userName"];
    [score setObject:@"userId" forKey:@"userId"];
    [score setObject:[NSNumber numberWithInt:self.score] forKey:@"userScore"];
    
    [score saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            HighscoreDisplayScene *highscoreDisplayScene = [HighscoreDisplayScene sceneWithSize:self.size];
            [self.view presentScene:highscoreDisplayScene];
            NSLog(@"YES");
        }
        else {
            NSLog(@"%@",error);
//            [self saveLocally];
        }
    }];
    
    
}

-(void)saveLocally {
    NSString* plistPath = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    if ((plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Highscore List.plist"]))
    {
        if ([manager isWritableFileAtPath:plistPath])
        {
            NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            [infoDict setObject:@"name" forKey:[NSString stringWithFormat:@"%i",self.score]];
            [infoDict writeToFile:plistPath atomically:NO];
            [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] ofItemAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
        }
    }
}

@end
