//
//  NSManagedObject+ToDictionary.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 8/19/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "NSManagedObject+ToDictionary.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSArray+BSJSONAdditions.h"

@implementation NSManagedObject (ToDictionary)

- (NSDictionary *)toDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSDictionary *dict = [self dictionaryWithValuesForKeys:attributes];
    return dict;
}

- (NSMutableDictionary *)toMutableDictionary
{
    NSArray *attributes = [[self.entity attributesByName] allKeys];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryWithValuesForKeys:attributes]];
    return dict;
    
}


- (NSDictionary *)propertiesDictionary
{
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    for (id property in [[self entity] properties])
    {
        if ([property isKindOfClass:[NSAttributeDescription class]])
        {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)property;
            NSString *name = [attributeDescription name];
            [properties setValue:[self valueForKey:name] forKey:name];
        }
        
        if ([property isKindOfClass:[NSRelationshipDescription class]])
        {
            NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)property;
            NSString *name = [relationshipDescription name];
            
            if ([relationshipDescription isToMany])
            {
                NSMutableArray *arr = [properties valueForKey:name];
                if (!arr)
                {
                    arr = [[NSMutableArray alloc] init];
                    [properties setValue:arr forKey:name];
                }
                
                for (NSManagedObject *o in [self mutableSetValueForKey:name])
                    [arr addObject:[o propertiesDictionary]];
            }
            else
            {
                NSManagedObject *o = [self valueForKey:name];
                [properties setValue:[o propertiesDictionary] forKey:name];
            }
        }
    }
    
    return properties;
}  

- (NSString *)jsonStringValue
{
    return [[self propertiesDictionary] jsonStringValue];
}
@end
