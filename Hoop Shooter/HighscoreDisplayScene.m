//
//  HighscoreDisplayScene.m
//  Hoop Shooter
//
//  Created by Zaha on 4/30/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "HighscoreDisplayScene.h"

@implementation HighscoreDisplayScene {
    float w;
    float h;
}

-(void)didMoveToView:(SKView *)view {
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    self.backgroundColor = [SKColor lightGrayColor];
    
    SKLabelNode *mainLabel = [SKLabelNode labelNodeWithText:@"YOUR HIGHSCORES"];
    mainLabel.fontName = @"Britannic Bold";
    mainLabel.fontSize = 32;
    mainLabel.fontColor = [SKColor blackColor];
    mainLabel.position = CGPointMake(w/2, h-50);
    [self addChild:mainLabel];
    
    NSArray *objects = [self getParseList];
    NSLog(@"%@",objects);
    int i = 0;
    for (PFObject *object in objects){
        SKLabelNode *nameLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%@:",object[@"userName"]]];
        nameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        nameLabel.fontColor = [SKColor blueColor];
        nameLabel.position = CGPointMake(w/2, h - 100 - (i*50));
        [self addChild:nameLabel];
        
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%@",object[@"userScore"]]];
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        highScoreLabel.fontColor = [SKColor redColor];
        highScoreLabel.position = CGPointMake(w/2 + 5, h - 100 - (i*50));
        [self addChild:highScoreLabel];
        i++;
    }
    
}

-(NSArray *)getParseList {
    NSLog(@"Getparseworking");
    PFQuery *query = [PFQuery queryWithClassName:@"UserName"];
    [query orderByDescending:@"userScore"];
    query.limit = 10;
    
    NSArray *objects = [query findObjects];
    return objects;
}

//-(NSDictionary)getLocalList {
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Highscore File Local" withExtension:@"plist"];
//    NSDictionary *namesAndScores = [NSDictionary dictionaryWithContentsOfURL:url];
//    NSArray *highscores = [namesAndScores allValues];
//    NSArray *descendingScores =  [[[highscores sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
//    return namesAndScores;
//}

@end
