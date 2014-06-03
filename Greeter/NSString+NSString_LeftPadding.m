//
//  NSString+NSString_LeftPadding.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 8/19/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "NSString+NSString_LeftPadding.h"
#import <Security/Security.h>
#import "NSData+AES256.h"

@implementation NSString (NSString_LeftPadding)

- (NSString *) stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex
{
    if ([self length] <= newLength)
        return [[@"" stringByPaddingToLength:newLength - [self length] withString:padString startingAtIndex:padIndex] stringByAppendingString:self];
    else
        return [self copy];
}


-(NSString *)rsaEncryptedString
{
    SecKeyRef oPublicKey;
    SecKeyRef oPrivateKey;
    
    CFDictionaryRef myDictionary;
    
    CFTypeRef keys[2];
    CFTypeRef values[2];
    
    // Initialize dictionary of key params
    keys[0] = kSecAttrKeyType;
    values[0] = kSecAttrKeyTypeRSA;
    keys[1] = kSecAttrKeySizeInBits;
    int iByteSize = 1024;
    values[1] = CFNumberCreate( NULL, kCFNumberIntType, &iByteSize );
    myDictionary = CFDictionaryCreate( NULL, keys, values, sizeof(keys) / sizeof(keys[0]), NULL, NULL );
    
    // Generate keys
    OSStatus status = SecKeyGeneratePair( myDictionary, &oPublicKey, &oPrivateKey );
    if ( status != 0 )
        NSLog( @"SecKeyGeneratePair failed" );
    
    // Encrypt some data
    uint8_t* pPlainText = (uint8_t*)[self UTF8String];
    
    uint8_t aCipherText[1024];
    size_t iCipherLength = 1024;
    status = SecKeyEncrypt( oPublicKey, kSecPaddingPKCS1, pPlainText, strlen( (char*)pPlainText ) + 1, &aCipherText[0], &iCipherLength );
    if ( status != 0 )
        NSLog( @"SecKeyEncrypt failed" );
    NSData *dataOutput = [[NSData alloc] initWithBytes:aCipherText length:iCipherLength];
    
    NSString *stringOutput = [[NSString alloc] initWithData:dataOutput encoding:NSASCIIStringEncoding];
    return stringOutput;
}

-(NSData *)rsaEncryptedData
{
    SecKeyRef oPublicKey;
    SecKeyRef oPrivateKey;
    
    CFDictionaryRef myDictionary;
    
    CFTypeRef keys[2];
    CFTypeRef values[2];
    
    // Initialize dictionary of key params
    keys[0] = kSecAttrKeyType;
    values[0] = kSecAttrKeyTypeRSA;
    keys[1] = kSecAttrKeySizeInBits;
    int iByteSize = 1024;
    values[1] = CFNumberCreate( NULL, kCFNumberIntType, &iByteSize );
    myDictionary = CFDictionaryCreate( NULL, keys, values, sizeof(keys) / sizeof(keys[0]), NULL, NULL );
    
    // Generate keys
    OSStatus status = SecKeyGeneratePair( myDictionary, &oPublicKey, &oPrivateKey );
    if ( status != 0 )
        NSLog( @"SecKeyGeneratePair failed" );
    
    // Encrypt some data
    uint8_t* pPlainText = (uint8_t*)[self UTF8String];
    
    uint8_t aCipherText[1024];
    size_t iCipherLength = 1024;
    status = SecKeyEncrypt( oPublicKey, kSecPaddingPKCS1, pPlainText, strlen( (char*)pPlainText ) + 1, &aCipherText[0], &iCipherLength );
    if ( status != 0 )
        NSLog( @"SecKeyEncrypt failed" );

    return [[NSData alloc] initWithBytes:aCipherText length:iCipherLength];
}



-(NSString *)encryptedStringWithKey:(NSString *)key;
{
    NSData *stringAsData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSData *cipher = [stringAsData AES256EncryptWithKey:key];
    NSString *stringOutput = [[NSString alloc] initWithData:cipher encoding:NSUTF8StringEncoding];
    return stringOutput;

}

-(NSData *)encryptedDataWithKey:(NSString *)key;
{
    NSData *stringAsData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSData *cipher = [stringAsData AES256EncryptWithKey:key];
    return cipher;
}


@end
