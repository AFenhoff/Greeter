//
//  Common.h
//  Greeter
//
//  Created by Andrew Fenhoff on 9/20/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNavBarTitleFontSize                18.0f
#define kIsProductionSettingName            @"isProduction"
#define kApplicationModeSettingName         @"applicationMode"
#define kVersionSettingName                 @"version"
#define kGreeterMode                        @"greeterMode"


@interface Common : NSObject


+(UIActivityIndicatorView *)getNewActivityIndicator;
+ (void) showAlert:(NSString *)message forDelegate:(id)delegate;
+ (NSString *) getStringSetting:(NSString *)settingName;
+ (void) saveStringSetting:(NSString *)settingName Value:(NSString *)value;

+ (int) getIntSetting:(NSString *)settingName;

@end
