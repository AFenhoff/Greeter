//
//  NSString+NSString_ContainsString.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/4/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "NSString+ContainsString.h"

@implementation NSString (containsString)

- (BOOL) containsString: (NSString*) substring
{
    NSRange range = [self rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

- (BOOL) stringIsValidASCIIString
{
    
    #define BUFFER_SIZE 32
    NSRange range = { 0, BUFFER_SIZE };
    NSUInteger end = [self length];
    while (range.location < end)
    {
        unichar buffer[BUFFER_SIZE];
        if (range.location + range.length > end)
        {
            range.length = end - range.location;
        }
        [self getCharacters: buffer range: range];
        range.location += BUFFER_SIZE;
        for (unsigned i=0 ; i<range.length ; i++)
        {
            unichar c = buffer[i];
            NSLog(@"%d", (int)c);
//            switch (c)
            // Cases for different characters.
        }
    }
    return YES;
  }

-(NSString *)stringByEncodingSpecialCharacters
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               CFSTR("!@#$%^&*()_+=-\\][{}|';:""/.,<>?`~"), //"//!*'\"();:@&=+$,/?%#[]%~<>.|`"),
                                                               kCFStringEncodingUTF8));
    
}

@end
