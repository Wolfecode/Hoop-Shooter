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
    float xScale;
    float yScale;
}

-(void)didMoveToView:(SKView *)view {
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    xScale = w/375;
    yScale = h/667;
    self.backgroundColor = [SKColor blackColor];
    
    SKLabelNode *mainLabel = [SKLabelNode labelNodeWithText:@"HIGHSCORES"];
    mainLabel.fontName = @"Myriad Pro";
    mainLabel.fontSize = 32*xScale;
    mainLabel.fontColor = [SKColor whiteColor];
    mainLabel.position = CGPointMake(w/2, h - 50*yScale);
    [self addChild:mainLabel];
    
    float textWidth = mainLabel.frame.size.width;
    NSArray *objects = [self getParseList];
    int i = 0;
    NSLog(@"%@",objects);
    for (PFObject *object in objects){
        SKLabelNode *nameLabel = [SKLabelNode labelNodeWithText:[object[@"userName"] capitalizedString]];
        nameLabel.fontName = @"Myriad Pro";
        nameLabel.fontSize = 20;
        nameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        nameLabel.fontColor = [SKColor orangeColor];
        nameLabel.position = CGPointMake(w/2 - textWidth/2, h - (i+2)*50*yScale);
        [self addChild:nameLabel];
        NSLog(@"%i", i);

        
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%@",object[@"userScore"]]];
        highScoreLabel.fontName = @"Myriad Pro";
        highScoreLabel.fontSize = 20;
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        highScoreLabel.fontColor = [SKColor redColor];
        highScoreLabel.position = CGPointMake(w/2 + textWidth/2, h - (i+2)*50*yScale);
        [self addChild:highScoreLabel];
        i++;
        NSLog(@"This is: %i", i);
    }
    
    SKLabelNode *home = [SKLabelNode labelNodeWithText:@"HOME"];
    home.fontName = @"Myriad Pro";
    home.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    home.fontSize = 36;
    home.position = CGPointMake(w/2, 50*yScale);
    home.fontColor = [SKColor whiteColor];
    home.zPosition = 10;
    [self addChild:home];
    
    SKShapeNode *homeBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(textWidth, home.fontSize + 20) cornerRadius:0];
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
    if(!query){
//    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByDescending:@"userScore"];
    query.limit = 10;
    
    NSArray *objects = [query findObjects];
    NSLog(@"%@",objects);
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
