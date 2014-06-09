//
//  NSDictionary+ToCookie.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ToCookie)

- (NSHTTPCookie *)toCookie;

@end
