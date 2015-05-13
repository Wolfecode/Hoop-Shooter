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
#import "MovingNetScene.h"
#import "FreeplaySettingsScene.h"

@implementation SplashScreen {
    float w;
    float h;
}

-(void)didMoveToView:(SKView *)view {
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;

    self.backgroundColor = [SKColor grayColor];
    
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithText:@"Hoop Shooter"];
    titleLabel.fontName = @"Myriad Pro";
    titleLabel.fontSize = 48;
    titleLabel.position = CGPointMake(w/2, h - 100);
    titleLabel.fontColor = [SKColor whiteColor];
    [self addChild:titleLabel];
    
    SKSpriteNode *ballImage = [SKSpriteNode spriteNodeWithImageNamed:@"Basketball"];
    ballImage.position = CGPointMake(w/2, h - 160);
    ballImage.size = CGSizeMake(60, 60);
    [self addChild:ballImage];
    
    SKLabelNode *freeplay = [SKLabelNode labelNodeWithText:@"FREEPLAY"];
    freeplay.fontName = @"Myriad Pro";
    freeplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    freeplay.fontSize = 36;
    freeplay.position = CGPointMake(w/2, h/2 + 40);
    freeplay.fontColor = [SKColor whiteColor];
    [self addChild:freeplay];
    
    SKShapeNode *freeplayBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, freeplay.fontSize + 30) cornerRadius:0];
    freeplayBox.name = @"Freeplay";
    freeplayBox.position = freeplay.position;
    freeplayBox.fillColor = [SKColor clearColor];
    freeplayBox.lineWidth = 5;
    freeplayBox.strokeColor = [SKColor whiteColor];
    [self addChild:freeplayBox];
    
    SKLabelNode *settings = [SKLabelNode labelNodeWithText:@"SETTINGS"];
    settings.fontName = @"Myriad Pro";
    settings.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    settings.fontSize = 36;
    settings.position = CGPointMake(w/2, h/2 + 100);
    settings.fontColor = [SKColor whiteColor];
    [self addChild:settings];
    
    SKShapeNode *settingsBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, settings.fontSize + 30) cornerRadius:0];
    settingsBox.name = @"Settings";
    settingsBox.position = settings.position;
    settingsBox.fillColor = [SKColor clearColor];
    settingsBox.lineWidth = 5;
    settingsBox.strokeColor = [SKColor whiteColor];
    [self addChild:settingsBox];
    
    SKLabelNode *timedGame = [SKLabelNode labelNodeWithText:@"TIMED"];
    timedGame.fontName = @"Myriad Pro";
    timedGame.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    timedGame.fontSize = 36;
    timedGame.position = CGPointMake(w/2,h/2-60);
    timedGame.fontColor = [SKColor whiteColor];
    [self addChild:timedGame];
    
    SKShapeNode *timedGameBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, timedGame.fontSize + 30) cornerRadius:0];
    timedGameBox.name = @"Timed";
    timedGameBox.position = timedGame.position;
    timedGameBox.fillColor = [SKColor clearColor];
    timedGameBox.lineWidth = 5;
    timedGameBox.strokeColor = [SKColor whiteColor];
    [self addChild:timedGameBox];

    SKLabelNode *movingBasket = [SKLabelNode labelNodeWithText:@"MOVING HOOP"];
    movingBasket.fontName = @"Myriad Pro";
    movingBasket.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    movingBasket.fontSize = 36;
    movingBasket.position = CGPointMake(w/2,h/2-160);
    movingBasket.fontColor = [SKColor whiteColor];
    [self addChild:movingBasket];
    
    SKShapeNode *movingBasketBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, movingBasket.fontSize + 30) cornerRadius:0];
    movingBasketBox.name = @"Moving Hoop";
    movingBasketBox.position = movingBasket.position;
    movingBasketBox.fillColor = [SKColor clearColor];
    movingBasketBox.lineWidth = 5;
    movingBasketBox.strokeColor = [SKColor whiteColor];
    [self addChild:movingBasketBox];
    
    SKLabelNode *shot = [SKLabelNode labelNodeWithText:@"Shot Count"];
    shot.fontName = @"Myriad Pro";
    shot.fontSize = 28;
    shot.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    shot.position = CGPointMake(5, 10);
    [self addChild:shot];
    
    SKLabelNode *score = [SKLabelNode labelNodeWithText:@"Score Count"];
    score.fontName = @"Myriad Pro";
    score.fontSize = 28;
    score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    score.position = CGPointMake(w - 5, 10);
    [self addChild:score];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    if([node.name isEqualToString:@"Freeplay"]){
        GameScene *gameScene = [GameScene sceneWithSize:self.size];
        [self.view presentScene:gameScene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
    }
    if([node.name isEqualToString:@"Timed"]){
        TimedScene *timedScene = [TimedScene sceneWithSize:self.size];
        [self.view presentScene:timedScene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
    }
    if([node.name isEqualToString:@"Moving Hoop"]){
        MovingNetScene *movingNetScene = [MovingNetScene sceneWithSize:self.size];
        [self.view presentScene:movingNetScene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
    }
    if ([node.name isEqualToString:@"Settings"]) {
        FreeplaySettingsScene *settingsScene = [FreeplaySettingsScene sceneWithSize:self.size];
        [self.view presentScene:settingsScene];
    }
}
@end
