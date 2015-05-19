//
//  ImagePickerScene.m
//  Hoop Shooter
//
//  Created by Zaha on 5/13/15.
//  Copyright (c) 2015 Zaha Wolfe. All rights reserved.
//

#import "ImagePickerScene.h"
#import "GameViewController.h"
#import "SplashScreen.h"
#import "ImageCropScene.h"

@implementation ImagePickerScene {
    float w;
    float h;
    NSMutableDictionary *dict;
    NSUserDefaults *defaults;
}

-(void)didMoveToView:(SKView *)view {
    w = self.view.frame.size.width;
    h = self.view.frame.size.height;
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.paused = YES;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picker.delegate = self;
    
    UIWindow* appWindow = [UIApplication sharedApplication].windows.firstObject;
    [appWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
       UIImage* photoTaken = info[UIImagePickerControllerOriginalImage];
    
       NSData *imageData = UIImagePNGRepresentation(photoTaken);
       
       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       NSString *documentsDirectory = [paths objectAtIndex:0];
       
       NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
       
       if (![imageData writeToFile:imagePath atomically:NO])
       {
           NSLog(@"Failed to cache image data to disk");
           UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem. Photo failed to save." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", nil];
           [failedAlert show];
       }
       else
       {
           NSLog(@"the cachedImagedPath is %@",imagePath);
           [defaults setObject:imagePath forKey:@"Ball Image"];
       }
        
        ImageCropScene *cropScene = [ImageCropScene sceneWithSize:self.size];
        [self.view presentScene:cropScene];
       //6
       self.paused = NO;
   }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    SplashScreen *splashScreen = [SplashScreen sceneWithSize:self.size];
    [self.view presentScene:splashScreen];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    SplashScreen *splashScreen = [SplashScreen sceneWithSize:self.size];
    [self.view presentScene:splashScreen transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:1]];
}

@end
