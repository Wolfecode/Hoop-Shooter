//
//  SplashScreen.m
//  Hoop Shooter
//
//  Created by Zaha on 4/28/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "SplashScreen.h"
#import "GameScene.h"
#import "TimedScene.h"

@implementation SplashScreen {
    float w;
    float h;
}

-(void)didMoveToView:(SKView *)view {
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    
    self.backgroundColor = [SKColor orangeColor];
    
    SKLabelNode *basketballLabel = [SKLabelNode labelNodeWithText:@"Hoop Shooter"];
    basketballLabel.fontSize = 42;
    basketballLabel.fontName = @"Arial Bold";
    basketballLabel.position = CGPointMake(w/2, h - 40);
    basketballLabel.fontColor = [SKColor blackColor];
    [self addChild:basketballLabel];
    
    SKLabelNode *freeplay = [SKLabelNode labelNodeWithText:@"Freeplay Mode"];
    freeplay.name = @"freeplay";
    freeplay.fontSize = 32;
    freeplay.fontName = @"Britannic Bold";
    freeplay.position = CGPointMake(w/2, h/2 + 40);
    freeplay.fontColor = [SKColor blackColor];
    [self addChild:freeplay];
    
    SKLabelNode *timedGame = [SKLabelNode labelNodeWithText:@"Timed Game"];
    timedGame.name = @"timed";
    timedGame.fontName = @"Britannic Bold";
    timedGame.fontSize = 32;
    timedGame.position = CGPointMake(w/2, h/2-40);
    timedGame.fontColor = [SKColor blackColor];
    [self addChild:timedGame];
    
    SKLabelNode *shot = [SKLabelNode labelNodeWithText:@"Shot Count"];
    shot.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    shot.position = CGPointMake(5, 10);
    [self addChild:shot];
    
    SKLabelNode *score = [SKLabelNode labelNodeWithText:@"Score Count"];
    score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    score.position = CGPointMake(w - 5, 10);
    [self addChild:score];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    if([node.name isEqualToString:@"freeplay"]){
        GameScene *gameScene = [GameScene sceneWithSize:self.size];
        [self.view presentScene:gameScene];
    }
    if([node.name isEqualToString:@"timed"]){
        TimedScene *timedScene = [TimedScene sceneWithSize:self.size];
        [self.view presentScene:timedScene];
    }
}
@end
