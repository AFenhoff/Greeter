//
//  NSManagedObject+ToDictionary.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 8/19/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ToDictionary)

- (NSDictionary *)toDictionary;
- (NSMutableDictionary *)toMutableDictionary;
- (NSString *)jsonStringValue;

@end
