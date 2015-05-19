//
//  GameScene.h
//  Hoop Shooter
//

//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property SKSpriteNode *ball;
@property SKSpriteNode *hoop;
@property SKNode *hoopEdge;
@property SKNode *checkShot;
@property SKNode *addPoints;
@property SKSpriteNode *pauseButton;
@property SKLabelNode *resume;
@property SKShapeNode *resumeBox;
@property SKLabelNode *settings;
@property SKShapeNode *settingsBox;
@property SKLabelNode *home;
@property SKShapeNode *homeBox;
@property CGVector savedVector;
@property CGPoint firstTouchPoint;
@property int score;
@property SKLabelNode *scoreLabel;
@property int shotCount;
@property SKLabelNode *shotLabel;
@property SKAction *bounceSound;
@property SKAction *swishSound;
@property BOOL isGamePaused;
@property float gravity;
@property float restitution;
@property float velocityCoefficient;
@property BOOL doesHover;
@property BOOL hasRoof;

-(void)pauseGame;
-(void)unpauseGame;
-(void)setDefaultValues;
@end
