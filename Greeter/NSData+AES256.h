//
//  NSData+AES256.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 9/5/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
