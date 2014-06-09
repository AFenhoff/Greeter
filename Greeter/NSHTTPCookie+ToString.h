//
//  NSHTTPCookie+NSHTTPCookie_ToString.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPCookie (ToString)

- (NSString *) toString;
- (NSDictionary *) toDictionary;

@end
