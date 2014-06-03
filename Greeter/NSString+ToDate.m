//
//  NSString+ToDate.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 9/17/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "NSString+ToDate.h"

@implementation NSString (ToDate)

-(NSDate *)toDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    //9/6/2013 11:32:13 AM
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:self];
    return dateFromString;
}

@end
