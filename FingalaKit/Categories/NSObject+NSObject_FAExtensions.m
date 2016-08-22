//
//  NSObject+NSObject_FAExtensions.m
//  FingalaKit
//
//  Created by Farhan Yousuf on 19/08/16.
//  Copyright © 2016 fingala. All rights reserved.
//

#import "NSObject+NSObject_FAExtensions.h"
#import <objc/runtime.h>

@implementation NSObject (NSObject_FAExtensions)


- (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

@end
