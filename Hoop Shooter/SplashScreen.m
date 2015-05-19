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
#import "ImagePickerScene.h"

@implementation SplashScreen {
    float w;
    float h;
    float xScale;
    float yScale;
    NSUserDefaults *userDefaults;
}

-(void)didMoveToView:(SKView *)view {
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    xScale = w/375;
    yScale = h/667;
    userDefaults = [NSUserDefaults standardUserDefaults];

    self.backgroundColor = [SKColor colorWithRed:.7 green:.7 blue:1 alpha:1];
    
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithText:@"Hoop Shooter"];
    titleLabel.fontName = @"Myriad Pro";
    titleLabel.fontSize = 48;
    titleLabel.position = CGPointMake(w/2, h - 50);
    titleLabel.fontColor = [SKColor whiteColor];
    titleLabel.xScale = xScale;
    titleLabel.yScale = yScale;
    [self addChild:titleLabel];
    
    
    SKSpriteNode *ballImage = [SKSpriteNode spriteNodeWithImageNamed:[userDefaults objectForKey:@"Ball Image"]];
    ballImage.position = CGPointMake(w/2, h - 110*yScale);
    ballImage.size = CGSizeMake(60*yScale, 60*yScale);
    ballImage.name = @"Ball Image";
    [self addChild:ballImage];
    
    SKLabelNode *freeplay = [SKLabelNode labelNodeWithText:@"FREEPLAY"];
    freeplay.fontName = @"Myriad Pro";
    freeplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    freeplay.fontSize = 36;
    freeplay.position = CGPointMake(w/2, h/2 + 125*yScale);
    freeplay.fontColor = [SKColor whiteColor];
    freeplay.xScale = xScale;
    [self addChild:freeplay];
    
    SKShapeNode *freeplayBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, freeplay.fontSize + 30*yScale) cornerRadius:0];
    freeplayBox.name = @"Freeplay";
    freeplayBox.position = freeplay.position;
    freeplayBox.fillColor = [SKColor clearColor];
    freeplayBox.lineWidth = 5;
    freeplayBox.strokeColor = [SKColor whiteColor];
    [self addChild:freeplayBox];
    
    SKLabelNode *timedGame = [SKLabelNode labelNodeWithText:@"TIMED"];
    timedGame.fontName = @"Myriad Pro";
    timedGame.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    timedGame.fontSize = 36;
    timedGame.position = CGPointMake(w/2, h/2 + 25*yScale);
    timedGame.fontColor = [SKColor whiteColor];
    timedGame.xScale = xScale;
    [self addChild:timedGame];
    
    SKShapeNode *timedGameBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, timedGame.fontSize + 30*yScale) cornerRadius:0];
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
    movingBasket.position = CGPointMake(w/2,h/2 - 75*yScale);
    movingBasket.fontColor = [SKColor whiteColor];
    movingBasket.xScale = xScale;
    [self addChild:movingBasket];
    
    SKShapeNode *movingBasketBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, movingBasket.fontSize + 30*yScale) cornerRadius:0];
    movingBasketBox.name = @"Moving Hoop";
    movingBasketBox.position = movingBasket.position;
    movingBasketBox.fillColor = [SKColor clearColor];
    movingBasketBox.lineWidth = 5;
    movingBasketBox.strokeColor = [SKColor whiteColor];
    [self addChild:movingBasketBox];
    
    SKLabelNode *settings = [SKLabelNode labelNodeWithText:@"SETTINGS"];
    settings.fontName = @"Myriad Pro";
    settings.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    settings.fontSize = 36;
    settings.position = CGPointMake(w/2, h/2 - 175*yScale);
    settings.fontColor = [SKColor whiteColor];
    settings.xScale = xScale;
    [self addChild:settings];
    
    SKShapeNode *settingsBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, settings.fontSize + 30*yScale) cornerRadius:0];
    settingsBox.name = @"Settings";
    settingsBox.position = settings.position;
    settingsBox.fillColor = [SKColor clearColor];
    settingsBox.lineWidth = 5;
    settingsBox.strokeColor = [SKColor whiteColor];
    [self addChild:settingsBox];
    
    SKLabelNode *shot = [SKLabelNode labelNodeWithText:@"Shot Count"];
    shot.fontName = @"Myriad Pro";
    shot.fontSize = 28;
    shot.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    shot.position = CGPointMake(5, 10);
    shot.xScale = xScale;
    shot.yScale = yScale;
    [self addChild:shot];
    
    SKLabelNode *score = [SKLabelNode labelNodeWithText:@"Score Count"];
    score.fontName = @"Myriad Pro";
    score.fontSize = 28;
    score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    score.position = CGPointMake(w - 5, 10);
    score.xScale = xScale;
    score.yScale = yScale;
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
    if([node.name isEqualToString:@"Ball Image"]){
        ImagePickerScene *imagePickerScene = [ImagePickerScene sceneWithSize:self.size];
        [self.view presentScene:imagePickerScene];
    }
}
@end
