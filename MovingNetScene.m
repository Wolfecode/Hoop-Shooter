//
//  MovingNetScene.m
//  Hoop Shooter
//
//  Created by Zaha on 5/5/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "MovingNetScene.h"

@implementation MovingNetScene {
    float w;
    float h;
    float hoopY;
    float speed;
    int yDirection;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    
    hoopY = self.hoop.position.y;
    speed = 3;
    yDirection = 1;
}

-(void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    
    if(hoopY > h-100) {
        yDirection = -1;
    }
    if (hoopY < 100){
        yDirection = 1;
    }
    
    if(!self.isGamePaused){
        hoopY += speed * yDirection;
        self.hoop.position = CGPointMake(self.hoop.position.x, hoopY);
        
        self.hoopEdge.position = CGPointMake(self.hoopEdge.position.x, hoopY - h/3);
        self.addPoints.position = CGPointMake(self.addPoints.position.x, hoopY - h/3);
    }
}

@end
