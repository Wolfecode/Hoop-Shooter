//
//  FreeplaySettingsScene.m
//  Hoop Shooter
//
//  Created by Zaha on 5/12/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "FreeplaySettingsScene.h"
#import "GameScene.h"
#import "SplashScreen.h"

@implementation FreeplaySettingsScene {
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
    
    self.backgroundColor = [SKColor darkGrayColor];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    UIImage *image = [self imageWithImage:[UIImage imageNamed:@"Basketball"] scaledToSize:CGSizeMake(20, 20)];

    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithText:@"SETTINGS"];
    titleLabel.fontName = @"Myriad Pro";
    titleLabel.fontSize = 48;
    titleLabel.position = CGPointMake(w/2, h - 50);
    titleLabel.fontColor = [SKColor whiteColor];
    titleLabel.xScale = xScale;
    titleLabel.yScale = yScale;
    [self addChild:titleLabel];
    
    _gravityLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Gravity: %.2f",[userDefaults floatForKey:@"Gravity"]]];
    _gravityLabel.fontName = @"Myriad Pro";
    _gravityLabel.fontSize = 24;
    _gravityLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _gravityLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _gravityLabel.xScale = xScale;
    _gravityLabel.position = CGPointMake(w/24, h - 100*yScale);
    [self addChild:_gravityLabel];
    
    _gravitySlider = [[UISlider alloc] initWithFrame:CGRectMake(w*7/12, 88*yScale, w*5/12, 24)];
    [_gravitySlider addTarget:self action:@selector(gravitySliderAction:) forControlEvents:UIControlEventValueChanged];
    [_gravitySlider setContinuous:YES];
    [_gravitySlider setMinimumValue:0];
    [_gravitySlider setMaximumValue:15];
    [_gravitySlider setValue:[userDefaults floatForKey:@"Gravity"]];
    [_gravitySlider setThumbImage:image forState:UIControlStateNormal];
    [_gravitySlider setMinimumTrackTintColor:[UIColor orangeColor]];
    [self.view addSubview:_gravitySlider];
    
    _restitutionLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Bounciness: %.2f",[userDefaults floatForKey:@"Restitution"]]];
    _restitutionLabel.fontName = @"Myriad Pro";
    _restitutionLabel.fontSize = 24;
    _restitutionLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _restitutionLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _restitutionLabel.xScale = xScale;
    _restitutionLabel.position = CGPointMake(w/24, h - 188*yScale);
    [self addChild:_restitutionLabel];
    
    _restitutionSlider = [[UISlider alloc] initWithFrame:CGRectMake(w*7/12, 2*88*yScale, w*5/12, 24)];
    [_restitutionSlider addTarget:self action:@selector(restitutionSliderAction:) forControlEvents:UIControlEventValueChanged];
    [_restitutionSlider setContinuous:YES];
    [_restitutionSlider setMinimumValue:0];
    [_restitutionSlider setMaximumValue:1.0];
    [_restitutionSlider setValue:[userDefaults floatForKey:@"Restitution"]];
    [_restitutionSlider setThumbImage:image forState:UIControlStateNormal];
    [_restitutionSlider setMinimumTrackTintColor:[UIColor orangeColor]];
    [self.view addSubview:_restitutionSlider];
    
    _velocityCoefficientLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Speed Factor: %.1f",[userDefaults floatForKey:@"Velocity Coefficient"]]];
    _velocityCoefficientLabel.fontName = @"Myriad Pro";
    _velocityCoefficientLabel.fontSize = 24;
    _velocityCoefficientLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _velocityCoefficientLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _velocityCoefficientLabel.xScale = xScale;
    _velocityCoefficientLabel.position = CGPointMake(w/24, h - 274*yScale);
    [self addChild:_velocityCoefficientLabel];
    
    _velocityCoefficientSlider = [[UISlider alloc] initWithFrame:CGRectMake(w*7/12, 3*87*yScale, w*5/12, 24)];
    [_velocityCoefficientSlider addTarget:self action:@selector(velocityCoefficientAction:) forControlEvents:UIControlEventValueChanged];
    [_velocityCoefficientSlider setContinuous:YES];
    [_velocityCoefficientSlider setMinimumValue:1];
    [_velocityCoefficientSlider setMaximumValue:10];
    [_velocityCoefficientSlider setValue:[userDefaults floatForKey:@"Velocity Coefficient"]];
    [_velocityCoefficientSlider setThumbImage:image forState:UIControlStateNormal];
    [_velocityCoefficientSlider setMinimumTrackTintColor:[UIColor orangeColor]];
    [self.view addSubview:_velocityCoefficientSlider];
    
    if([userDefaults boolForKey:@"Roof?"]){
        _roofSwitchLabel = [SKLabelNode labelNodeWithText:@"Game has roof: YES"];
    }
    else {
        _roofSwitchLabel = [SKLabelNode labelNodeWithText:@"Game has roof: NO"];
    }
    _roofSwitchLabel.fontName = @"Myriad Pro";
    _roofSwitchLabel.fontSize = 24;
    _roofSwitchLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _roofSwitchLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _roofSwitchLabel.xScale = xScale;
    _roofSwitchLabel.position = CGPointMake(w/24, h - 362*yScale);
    [self addChild:_roofSwitchLabel];
    
    _roofSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(w*10/12, 4*87*yScale, 100*xScale, 50)];
    [_roofSwitch addTarget:self action:@selector(roofSwitchAction:) forControlEvents:UIControlEventValueChanged];
    _roofSwitch.on = [userDefaults boolForKey:@"Roof?"];
    _roofSwitch.onTintColor = [UIColor orangeColor];
    [self.view addSubview:_roofSwitch];
    
    _hoverSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(w*10/12, 5*87*yScale, 100, 50)];
    [_hoverSwitch addTarget:self action:@selector(hoverSwitchAction:) forControlEvents:UIControlEventValueChanged];
    _hoverSwitch.on = [userDefaults boolForKey:@"Hover?"];
    _hoverSwitch.onTintColor = [UIColor orangeColor];
    [self.view addSubview:_hoverSwitch];
    
    if([userDefaults boolForKey:@"Hover?"]){
        _hoverSwitchLabel = [SKLabelNode labelNodeWithText:@"Ball will hover: YES"];
    }
    else {
        _hoverSwitchLabel = [SKLabelNode labelNodeWithText:@"Ball will hover: NO"];
    }
    _hoverSwitchLabel.fontName = @"Myriad Pro";
    _hoverSwitchLabel.fontSize = 24;
    _hoverSwitchLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _hoverSwitchLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _hoverSwitchLabel.xScale = xScale;
    _hoverSwitchLabel.position = CGPointMake(w/24, h - 450*yScale);
    [self addChild:_hoverSwitchLabel];
    
    
   
    SKLabelNode *home = [SKLabelNode labelNodeWithText:@"HOME"];
    home.fontName = @"Myriad Pro";
    home.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    home.fontSize = 24;
    home.position = CGPointMake(w/4, 50);
    home.fontColor = [SKColor whiteColor];
    [self addChild:home];
    
    SKShapeNode *homeBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w/2 - 20, home.fontSize + 30) cornerRadius:0];
    homeBox.name = @"Home";
    homeBox.position = home.position;
    homeBox.fillColor = [SKColor clearColor];
    homeBox.lineWidth = 5;
    homeBox.strokeColor = [SKColor whiteColor];
    [self addChild:homeBox];
    
    SKLabelNode *freeplay = [SKLabelNode labelNodeWithText:@"FREEPLAY"];
    freeplay.fontName = @"Myriad Pro";
    freeplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    freeplay.fontSize = 24;
    freeplay.position = CGPointMake(w*3/4, 50);
    freeplay.fontColor = [SKColor whiteColor];
    freeplay.xScale = xScale;
    [self addChild:freeplay];
    
    SKShapeNode *freeplayBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w/2 - 20, freeplay.fontSize + 30) cornerRadius:0];
    freeplayBox.name = @"Freeplay";
    freeplayBox.position = freeplay.position;
    freeplayBox.fillColor = [SKColor clearColor];
    freeplayBox.lineWidth = 5;
    freeplayBox.strokeColor = [SKColor whiteColor];
    [self addChild:freeplayBox];
}

-(void)gravitySliderAction:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    //-- Do further actions
    _gravityLabel.text = [NSString stringWithFormat:@"Gravity: %.2f",value];
    [userDefaults setFloat:value forKey:@"Gravity"];
}

-(void)restitutionSliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    
    _restitutionLabel.text = [NSString stringWithFormat:@"Bounciness: %.2f",value];
    [userDefaults setFloat:value forKey:@"Restitution"];
}

-(void)velocityCoefficientAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    
    _velocityCoefficientLabel.text = [NSString stringWithFormat:@"Speed Factor: %.1f", value];
    [userDefaults setFloat:value forKey:@"Velocity Coefficient"];
}

-(void)roofSwitchAction:(id)sender {
    UISwitch *roofSwitch = (UISwitch *)sender;
    [userDefaults setBool:roofSwitch.on forKey:@"Roof?"];
    if(roofSwitch.on){
        _roofSwitchLabel.text = @"Game has roof: YES";
    }
    else {
        _roofSwitchLabel.text = @"Game has roof: NO";
    }
}

-(void)hoverSwitchAction:(id)sender {
    UISwitch *hoverSwitch = (UISwitch *)sender;
    [userDefaults setBool:hoverSwitch.on forKey:@"Hover?"];
    if(hoverSwitch.on){
        _hoverSwitchLabel.text = @"Ball will hover: YES";
    }
    else {
        _hoverSwitchLabel.text = @"Ball will hover: NO";
    }
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    if([node.name isEqualToString:@"Home"]){
        [self clearView];
        SplashScreen *splashScreen = [SplashScreen sceneWithSize:self.size];
        [self.view presentScene:splashScreen transition:[SKTransition doorsCloseVerticalWithDuration:1]];
    }
    if([node.name isEqualToString:@"Freeplay"]){
        [self clearView];
        GameScene *freeplay = [GameScene sceneWithSize:self.size];
        [self.view presentScene:freeplay transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:1]];
    }
}

-(void)clearView {
    [_gravitySlider removeFromSuperview];
    [_restitutionSlider removeFromSuperview];
    [_velocityCoefficientSlider removeFromSuperview];
    [_hoverSwitch removeFromSuperview];
    [_roofSwitch removeFromSuperview];
}

@end
