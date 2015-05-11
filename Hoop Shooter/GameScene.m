//
//  GameScene.m
//  Hoop Shooter
//
//  Created by Zaha on 4/28/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "GameScene.h"
#import "SplashScreen.h"

@implementation GameScene {
    float w;
    float h;
    BOOL atBottom;
    BOOL shotWillCount;
    BOOL hasClearedHoopArea;
}

static const uint32_t ballCategory = 1;
static const uint32_t rimCategory = 2;
static const uint32_t hoopEdgeCategory = 4;
static const uint32_t edgeBodyCategory = 8;
static const uint32_t checkScoreCategory = 16;
static const uint32_t addPoints = 32;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    _isGamePaused = NO;
    _bounceSound = [SKAction playSoundFileNamed:@"Bounce.mp3" waitForCompletion:NO];
    _swishSound = [SKAction playSoundFileNamed:@"Swish.mp3" waitForCompletion:NO];
    
    self.backgroundColor = [SKColor lightGrayColor];
    
    CGPoint points[] = {
        CGPointMake(0, 20000),
        CGPointMake(0, 0),
        CGPointMake(w, 0),
        CGPointMake(w, 20000),
    };
    
    CGMutablePathRef boundary = CGPathCreateMutable();
    CGPathAddLines(boundary, nil, points, 4);
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:boundary];
    self.physicsBody.categoryBitMask = edgeBodyCategory;
    self.physicsWorld.contactDelegate = self;
    
    [self addBall];
    [self addLabels];
    [self addHoop];
    [self addPauseButton];
}

- (void)addLabels {
    _shotLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%i", _shotCount]];
    _shotLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _shotLabel.position = CGPointMake(5, 10);
    [self addChild:_shotLabel];
    
    _scoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%i", _score]];
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    _scoreLabel.position = CGPointMake(w-5, 10);
    [self addChild:_scoreLabel];
}

-(void)addPauseButton {
    _pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"Pause Icon"];
    _pauseButton.name = @"pause";
    [_pauseButton setSize:CGSizeMake(25, 25)];
    _pauseButton.position = CGPointMake(self.pauseButton.size.width/2, h - self.pauseButton.size.height);
    [self addChild:_pauseButton];
}

- (void)addHoop {
    _hoop = [SKSpriteNode spriteNodeWithImageNamed:@"Hoop"];
    _hoop.position = CGPointMake(w-self.hoop.size.width/2,h/3);
    CGPoint rimEdge = CGPointMake(-self.hoop.size.width/2, self.hoop.size.height/2);
    _hoop.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5 center:rimEdge];
    _hoop.physicsBody.dynamic = NO;
    _hoop.physicsBody.categoryBitMask = rimCategory;
    
    
    _hoopEdge = [SKNode node];
    _hoopEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(w-7, self.hoop.position.y+self.hoop.size.height/2) toPoint:CGPointMake(w, self.hoop.position.y+self.hoop.size.height/2)];
    
    _checkShot = [SKNode node];
    _checkShot.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(w-self.hoop.size.width, self.hoop.position.y + self.hoop.size.height/2) toPoint:CGPointMake(w-7, self.hoop.position.y + self.hoop.size.height/2)];
    _checkShot.physicsBody.categoryBitMask = checkScoreCategory;
    _checkShot.physicsBody.contactTestBitMask = ballCategory;
    
    _addPoints = [SKNode node];
    _addPoints.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(w-self.hoop.size.width, self.hoop.position.y - self.hoop.size.height/2) toPoint:CGPointMake(w-7, self.hoop.position.y - self.hoop.size.height/2)];
    _addPoints.physicsBody.categoryBitMask = addPoints;
    _checkShot.physicsBody.contactTestBitMask = ballCategory;
    
    [self addChild:_checkShot];
    [self addChild:_addPoints];
    [self addChild:_hoopEdge];
    [self addChild:_hoop];
}

- (void)addBall {
    _ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
    _ball.position = CGPointMake(_ball.size.width, _ball.size.height*3/2);
    _ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_ball.frame.size.width/2];
    _ball.physicsBody.categoryBitMask = ballCategory;
    _ball.physicsBody.contactTestBitMask = checkScoreCategory | edgeBodyCategory | rimCategory | hoopEdgeCategory;
    _ball.physicsBody.collisionBitMask = rimCategory | hoopEdgeCategory | edgeBodyCategory;
    _ball.physicsBody.usesPreciseCollisionDetection = YES;
    _ball.physicsBody.linearDamping = 0;
    _ball.physicsBody.restitution = 0.7;
    
    [self addChild:_ball];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
    if([node.name isEqualToString:@"pause"]){
        [self pauseGame];
    }
    
    for(UITouch *touch in touches){
        _firstTouchPoint = [touch locationInNode:self];
        
        _ball.physicsBody.velocity = CGVectorMake(0, 0);
        self.physicsWorld.gravity = CGVectorMake(0, 0);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        CGPoint endPoint = [touch locationInNode:self];
        float vectX = 5*(endPoint.x - self.firstTouchPoint.x);
        float vectY = 5*(endPoint.y - self.firstTouchPoint.y);
        
        CGVector ballVect = CGVectorMake(vectX, vectY);
        _ball.physicsBody.velocity = ballVect;
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        
        if(_isGamePaused == NO){
            _shotCount ++;
        }
    }
    UITouch *touch = [touches anyObject];
    SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
    if(_isGamePaused && [node.name isEqualToString:@"Home Button"]){
        SplashScreen *splashScreen = [SplashScreen sceneWithSize:self.size];
        [self.view presentScene:splashScreen transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:1]];
    }
    if(_isGamePaused && [node.name isEqualToString:@"Resume Game"]){
        [self unpauseGame];
    }
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == checkScoreCategory) {
        if(hasClearedHoopArea && _ball.physicsBody.velocity.dy < 0) {
            shotWillCount = YES;
            _score ++;
            [self runAction:_swishSound];

//            hasClearedHoopArea = NO;
        }
    }
//    if((contact.bodyA.categoryBitMask == addPoints || contact.bodyB.categoryBitMask == addPoints)) {
//        _score ++;
//        [self runAction:_swishSound];
//        shotWillCount = NO;
//    }
    else if(_ball.position.y != 30.0){
        [self runAction:_bounceSound];
    }
}


-(void)pauseGame {
    _savedVector = _ball.physicsBody.velocity;
    _isGamePaused = YES; //Set pause flag to true
    self.paused = YES; //Pause scene and physics simulation
    //Display pause screen etc.
    _home = [SKLabelNode labelNodeWithText:@"HOME"];
    _home.fontName = @"Myriad Pro";
    _home.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _home.fontSize = 36;
    _home.position = CGPointMake(w/2, h/2 + 50);
    _home.fontColor = [SKColor whiteColor];
    _home.zPosition = 10;
    [self addChild:_home];
    
    _homeBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, _home.fontSize + 30) cornerRadius:0];
    _homeBox.name = @"Home Button";
    _homeBox.position = _home.position;
    _homeBox.fillColor = [SKColor clearColor];
    _homeBox.lineWidth = 5;
    _homeBox.strokeColor = [SKColor whiteColor];
    _homeBox.zPosition = 10;
    [self addChild:_homeBox];
    
    _resume = [SKLabelNode labelNodeWithText:@"RESUME"];
    _resume.fontName = @"Myriad Pro";
    _resume.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _resume.fontSize = 36;
    _resume.position = CGPointMake(w/2, h/2 - 50);
    _resume.fontColor = [SKColor whiteColor];
    _resume.zPosition = 10;
    [self addChild:_resume];
    
    _resumeBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w*3/4, _resume.fontSize + 30) cornerRadius:0];
    _resumeBox.name = @"Resume Game";
    _resumeBox.position = _resume.position;
    _resumeBox.fillColor = [SKColor clearColor];
    _resumeBox.lineWidth = 5;
    _resumeBox.strokeColor = [SKColor whiteColor];
    _resumeBox.zPosition = 10;
    [self addChild:_resumeBox];
    
}

-(void)unpauseGame {
    [_home removeFromParent];
    [_homeBox removeFromParent];
    [_resume removeFromParent];
    [_resumeBox removeFromParent];
    
    _isGamePaused = NO; //Set pause flag to false
    self.paused = NO; //Resume scene and physics simulation
    
    _ball.physicsBody.velocity = _savedVector;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    _scoreLabel.text = [NSString stringWithFormat:@"%i", _score];
    _shotLabel.text = [NSString stringWithFormat:@"%i", _shotCount];
    if(_ball.position.y < 31 && _ball.position.y > 30){
        if(atBottom == YES){
        _ball.position = CGPointMake(_ball.position.x, 30);
        }
        atBottom = YES;
    }
    else {
        atBottom = NO;
    }
    
    if(_ball.position.x < w - self.hoop.size.width){
        hasClearedHoopArea = YES;
//        shotWillCount = NO;
    }

}

@end
