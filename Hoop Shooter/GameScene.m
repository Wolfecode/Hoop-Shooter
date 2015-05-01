//
//  GameScene.m
//  Hoop Shooter
//
//  Created by Zaha on 4/28/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    float w;
    float h;
}

static const uint32_t ballCategory = 1;
static const uint32_t checkScoreCategory = 2;
static const uint32_t rimCategory = 4;
static const uint32_t hoopEdgeCategory = 8;
static const uint32_t edgeBodyCategory = 16;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    _bounceSound = [SKAction playSoundFileNamed:@"Bounce.mp3" waitForCompletion:NO];
    _swish = [SKAction playSoundFileNamed:@"Swish.mp3" waitForCompletion:NO];
    
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
    self.physicsBody.restitution = 0.0;
    
    [self addBall];
    [self addLabels];
    [self addHoop];
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

- (void)addHoop {
    SKSpriteNode *hoop = [SKSpriteNode spriteNodeWithImageNamed:@"Hoop"];
    hoop.position = CGPointMake(w-hoop.size.width/2,h/3);
    CGPoint rimEdge = CGPointMake(-hoop.size.width/2, hoop.size.height/2);
    hoop.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5 center:rimEdge];
    hoop.physicsBody.dynamic = NO;
    hoop.physicsBody.categoryBitMask = rimCategory;
    
    
    SKNode *hoopEdge = [SKNode node];
    hoopEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(w-7, hoop.position.y+hoop.size.height/2) toPoint:CGPointMake(w, hoop.position.y+hoop.size.height/2)];
    
    SKNode *addPoints= [SKNode node];
    addPoints.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(w-hoop.size.width, hoop.position.y + hoop.size.height/2) toPoint:CGPointMake(w-7, hoop.position.y + hoop.size.height/2)];
    addPoints.physicsBody.categoryBitMask = checkScoreCategory;
    addPoints.physicsBody.contactTestBitMask = ballCategory;
    
    [self addChild:addPoints];
    [self addChild:hoopEdge];
    [self addChild:hoop];
}

- (void)addBall {
    _ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
    _ball.position = CGPointMake(_ball.size.width, _ball.size.height);
    _ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_ball.frame.size.width/2];
    _ball.physicsBody.categoryBitMask = ballCategory;
    _ball.physicsBody.contactTestBitMask = checkScoreCategory;
    _ball.physicsBody.collisionBitMask = rimCategory | hoopEdgeCategory | edgeBodyCategory;
    _ball.physicsBody.linearDamping = 0;
    _ball.physicsBody.restitution = 0.7;
    
    [self addChild:_ball];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches){
        _startPoint = [touch locationInNode:self];
        
        _ball.physicsBody.velocity = CGVectorMake(0, 0);
        self.physicsWorld.gravity = CGVectorMake(0, 0);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        CGPoint endPoint = [touch locationInNode:self];
        float vectX = 5*(endPoint.x - _startPoint.x);
        float vectY = 5*(endPoint.y - _startPoint.y);
        
        CGVector ballVect = CGVectorMake(vectX, vectY);
        _ball.physicsBody.velocity = ballVect;
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        
        _shotCount ++;
    }
}


-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *notTheBall;
//    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
//        notTheBall = contact.bodyB;
//    }
//    else{
//        notTheBall = contact.bodyA;
//    }
    if (contact.bodyA.categoryBitMask == checkScoreCategory) {
        _score ++;
        [self runAction:_swish];
    }
    else {
        [self runAction:_bounceSound];
    }
//    if(notTheBall.categoryBitMask == edgeBodyCategory){
//        [self runAction:_bounceSound];
//    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    _scoreLabel.text = [NSString stringWithFormat:@"%i", _score];
    _shotLabel.text = [NSString stringWithFormat:@"%i", _shotCount];

}

@end
