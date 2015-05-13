//
//  FreeplaySettingsScene.h
//  Hoop Shooter
//
//  Created by Zaha on 5/12/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>

@interface FreeplaySettingsScene : SKScene

@property UISlider *gravitySlider;
@property SKLabelNode *gravityLabel;
@property UISlider *restitutionSlider;
@property SKLabelNode *restitutionLabel;
@property UISlider *velocityCoefficientSlider;
@property SKLabelNode *velocityCoefficientLabel;
@property UISwitch *roofSwitch;
@property SKLabelNode *roofSwitchLabel;
@property UISwitch *hoverSwitch;
@property SKLabelNode *hoverSwitchLabel;
@end
