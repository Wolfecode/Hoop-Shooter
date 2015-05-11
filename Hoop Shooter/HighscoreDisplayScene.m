//
//  HighscoreDisplayScene.m
//  Hoop Shooter
//
//  Created by Zaha on 4/30/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "HighscoreDisplayScene.h"
#import "SplashScreen.h"

@implementation HighscoreDisplayScene {
    float w;
    float h;
}

-(void)didMoveToView:(SKView *)view {
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    self.backgroundColor = [SKColor lightGrayColor];
    
    SKLabelNode *mainLabel = [SKLabelNode labelNodeWithText:@"HIGHSCORES"];
    mainLabel.fontName = @"Myriad Pro";
    mainLabel.fontSize = 32;
    mainLabel.fontColor = [SKColor blackColor];
    mainLabel.position = CGPointMake(w/2, h-50);
    [self addChild:mainLabel];
    
    float textWidth = mainLabel.frame.size.width;
    NSArray *objects = [self getParseList];
    int i = 0;
    for (PFObject *object in objects){
        SKLabelNode *nameLabel = [SKLabelNode labelNodeWithText:[object[@"userName"] capitalizedString]];
        nameLabel.fontName = @"Myriad Pro";
        nameLabel.fontSize = 20;
        nameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        nameLabel.fontColor = [SKColor orangeColor];
        nameLabel.position = CGPointMake(w/2 - textWidth/2, h - 100 - (i*50));
        [self addChild:nameLabel];
        
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%@",object[@"userScore"]]];
        highScoreLabel.fontName = @"Myriad Pro";
        highScoreLabel.fontSize = 20;
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        highScoreLabel.fontColor = [SKColor redColor];
        highScoreLabel.position = CGPointMake(w/2 + textWidth/2, h - 100 - (i*50));
        [self addChild:highScoreLabel];
        i++;
    }
    
    SKLabelNode *home = [SKLabelNode labelNodeWithText:@"HOME"];
    home.fontName = @"Myriad Pro";
    home.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    home.fontSize = 36;
    home.position = CGPointMake(w/2, 50);
    home.fontColor = [SKColor whiteColor];
    home.zPosition = 10;
    [self addChild:home];
    
    SKShapeNode *homeBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, home.fontSize + 30) cornerRadius:0];
    homeBox.name = @"Home Button";
    homeBox.position = home.position;
    homeBox.fillColor = [SKColor clearColor];
    homeBox.lineWidth = 5;
    homeBox.strokeColor = [SKColor whiteColor];
    homeBox.zPosition = 10;
    [self addChild:homeBox];
}

-(NSArray *)getParseList {
    PFQuery *query = [PFQuery queryWithClassName:@"UserName"];
    if([query countObjects] == 0){
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByDescending:@"userScore"];
    query.limit = 10;
    
    NSArray *objects = [query findObjects];
    return objects;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    
    if ([node.name isEqualToString:@"Home Button"]) {
        SplashScreen *splashScreen = [SplashScreen sceneWithSize:self.size];
        [self.view presentScene:splashScreen transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:1]];
    };
}

@end
