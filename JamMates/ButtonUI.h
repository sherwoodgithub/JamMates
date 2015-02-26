//
//  ButtonUI.h
//  JamMates
//
//  Created by Stephen Sherwood on 2/26/15.
//  Copyright (c) 2015 Stephen Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonUI : UIButton

@property  (nonatomic, assign) CGFloat hue;
@property  (nonatomic, assign) CGFloat saturation;
@property  (nonatomic, assign) CGFloat brightness;

@end


/*
 VC.h
 @interface ViewController : UIViewController
 
 @property (nonatomic, strong) IBOutlet CoolButton * coolButton;
 
 - (IBAction)hueValueChanged:(id)sender;
 - (IBAction)saturationValueChanged:(id)sender;
 - (IBAction)brightnessValueChanged:(id)sender;
 
 @end
 
 VC.m
 #import "ButtonUI.h"
 
*/