//
//  Common.m
//  Greeter
//
//  Created by Andrew Fenhoff on 9/20/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "Common.h"
#import <QuartzCore/QuartzCore.h>

@implementation Common
NSUserDefaults *prefs;


+(UIActivityIndicatorView *)getNewActivityIndicator
{
    UIActivityIndicatorView *newActivityIndicator = [[UIActivityIndicatorView alloc]
                                                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    newActivityIndicator.hidesWhenStopped = YES;
    [newActivityIndicator setFrame:CGRectMake(newActivityIndicator.center.x, newActivityIndicator.center.x, 100.0f, 100.0f)];
    [newActivityIndicator setCenter:[[UIApplication sharedApplication] keyWindow].center];
    [newActivityIndicator setBackgroundColor:[UIColor grayColor]];
    [newActivityIndicator setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [newActivityIndicator.layer setOpaque:NO];
    [newActivityIndicator.layer setOpacity:0.7f];
    [newActivityIndicator.layer setCornerRadius:8.0f];
    [[[UIApplication sharedApplication] keyWindow] addSubview:newActivityIndicator];
    return newActivityIndicator;
}

+ (void) showAlert:(NSString *)message forDelegate:(id)delegate
{
	UIAlertView* alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Yard Ops"]
                                                  message:message
                                                 delegate:delegate
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [alert show];
}

+ (NSString *) getStringSetting:(NSString *)settingName
{
    if(!prefs){prefs = [NSUserDefaults standardUserDefaults];}
    NSString *returnValue = [prefs objectForKey:settingName];
    if (!returnValue){return @"";}
    return returnValue;
}

+ (void) saveStringSetting:(NSString *)settingName Value:(NSString *)value
{
    if(!prefs){prefs = [NSUserDefaults standardUserDefaults];}
    [prefs setObject:value forKey:settingName];
}


+ (int) getIntSetting:(NSString *)settingName
{
    if(!prefs){prefs = [NSUserDefaults standardUserDefaults];}
    int returnValue = [prefs integerForKey:settingName];
    if (!returnValue){return 0;}
    return returnValue;
}
@end
