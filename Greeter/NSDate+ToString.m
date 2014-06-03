//
//  NSDate+ToString.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 9/17/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "NSDate+ToString.h"

@implementation NSDate (ToString)

-(NSString *)toString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    //2013-09-18 03:34:04 +0000
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    NSString *stringFromDate = @"";
    // voila!
    stringFromDate = [dateFormatter stringFromDate:self];
    return stringFromDate;
}

@end
