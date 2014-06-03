//
//  NSString+NSString_LeftPadding.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 8/19/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_LeftPadding)
- (NSString *) stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex;

-(NSString *)encryptedStringWithKey:(NSString *)key;
-(NSData *)encryptedDataWithKey:(NSString *)key;

@end
