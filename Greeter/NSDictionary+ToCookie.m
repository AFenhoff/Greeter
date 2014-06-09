//
//  NSDictionary+ToCookie.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "NSDictionary+ToCookie.h"

@implementation NSDictionary (ToCookie)

- (NSHTTPCookie *)toCookie
{
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:self];
    return cookie;
}

@end
