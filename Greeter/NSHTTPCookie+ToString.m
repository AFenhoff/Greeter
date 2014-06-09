//
//  NSHTTPCookie+NSHTTPCookie_ToString.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "NSHTTPCookie+ToString.h"

@implementation NSHTTPCookie (ToString)

- (NSString *) toString
{
    
    NSMutableString *cDesc      = [[NSMutableString alloc] init];
    [cDesc appendString:@"[NSHTTPCookie]\n"];
    [cDesc appendFormat:@"  name            = %@\n",            [[self name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cDesc appendFormat:@"  value           = %@\n",            [[self value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cDesc appendFormat:@"  domain          = %@\n",            [self domain]];
    [cDesc appendFormat:@"  path            = %@\n",            [self path]];
    [cDesc appendFormat:@"  expiresDate     = %@\n",            [self expiresDate]];
    [cDesc appendFormat:@"  sessionOnly     = %d\n",            [self isSessionOnly]];
    [cDesc appendFormat:@"  secure          = %d\n",            [self isSecure]];
    [cDesc appendFormat:@"  comment         = %@\n",            [self comment]];
    [cDesc appendFormat:@"  commentURL      = %@\n",            [self commentURL]];
    [cDesc appendFormat:@"  version         = %lu\n",            (unsigned long)[self version]];
    
    //  [cDesc appendFormat:@"  portList        = %@\n",            [cookie portList]];
    //  [cDesc appendFormat:@"  properties      = %@\n",            [cookie properties]];
    
    return cDesc;
}

- (NSArray *) toArray
{
    NSMutableArray *cookieProperties = [[NSMutableArray alloc] init];
    [cookieProperties setValue:self.name        forKey:@"name"];
    [cookieProperties setValue:self.value       forKey:@"value"];
    [cookieProperties setValue:self.domain      forKey:@"domain"];
    [cookieProperties setValue:self.path        forKey:@"path"];
    [cookieProperties setValue:self.expiresDate forKey:@"expiresDate"];
    [cookieProperties setValue:self.isSessionOnly ? @"1" : @"0"  forKey:@"isSessionOnly"];
    [cookieProperties setValue:self.isSecure ? @"1" : @"0"    forKey:@"isSecure"];
    [cookieProperties setValue:self.comment     forKey:@"comment"];
    [cookieProperties setValue:self.commentURL  forKey:@"commentURL"];
    [cookieProperties setValue:[NSString stringWithFormat:@"%d", self.version]     forKey:@"version"];
    
    return cookieProperties;
}

- (NSDictionary *) toDictionary
{
    NSArray *keys = [NSArray arrayWithObjects:@"name", @"value", @"domain", @"path", @"expiresDate", @"isSessionOnly", @"isSecure", nil];
    NSArray *objects = [NSArray arrayWithObjects:self.name, self.value, self.domain, self.path
                        , self.expiresDate ? self.expiresDate : @"", self.isSessionOnly ? @"1" : @"0",self.isSecure ? @"1" : @"0", nil];
    NSDictionary *cookieProperties = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    
    /*NSDictionary *cookieProperties = [[NSDictionary alloc] init];
    [cookieProperties setValue:self.name        forKey:@"name"];
    [cookieProperties setValue:self.value       forKey:@"value"];
    [cookieProperties setValue:self.domain      forKey:@"domain"];
    [cookieProperties setValue:self.path        forKey:@"path"];
    [cookieProperties setValue:self.expiresDate forKey:@"expiresDate"];
    [cookieProperties setValue:self.isSessionOnly ? @"1" : @"0"  forKey:@"isSessionOnly"];
    [cookieProperties setValue:self.isSecure ? @"1" : @"0"    forKey:@"isSecure"];
    [cookieProperties setValue:self.comment     forKey:@"comment"];
    [cookieProperties setValue:self.commentURL  forKey:@"commentURL"];
    [cookieProperties setValue:[NSString stringWithFormat:@"%d", self.version]     forKey:@"version"];
    */
    return cookieProperties;
}

@end
