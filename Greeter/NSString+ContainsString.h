//
//  NSString+NSString_ContainsString.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/4/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (containsString)

- (BOOL) containsString: (NSString*) substring;
- (BOOL) stringIsValidASCIIString;

@end
