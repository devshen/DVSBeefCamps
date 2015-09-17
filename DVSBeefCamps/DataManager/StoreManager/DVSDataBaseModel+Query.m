//
//  DVSDataBaseModel+Query.m
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/12/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "DVSDataBaseModel+Query.h"
#import <Realm/Realm.h>

@implementation DVSDataBaseModel (Query)

+ (NSArray *)queryObjectWhere:(NSString *)where
   sortedResultsUsingProperty:(NSString *)property
                    ascending:(BOOL)isAscend {
    RLMResults *results = [self objectsWhere:where];
    results = [results sortedResultsUsingProperty:property ascending:isAscend];
    NSMutableArray *mutableResults = [NSMutableArray new];
    for (DVSDataBaseModel *obj in results) {
        [mutableResults addObject:obj];
    }
    return [mutableResults copy];
}

+ (NSArray *)queryObjectWithPredicate:(NSPredicate *)predicate
           sortedResultsUsingProperty:(NSString *)property
                            ascending:(BOOL)isAscend {
    RLMResults *results = [self objectsWithPredicate:predicate];
    results = [results sortedResultsUsingProperty:property ascending:isAscend];
    NSMutableArray *mutableResults = [NSMutableArray new];
    for (DVSDataBaseModel *obj in results) {
        [mutableResults addObject:obj];
    }
    return [mutableResults copy];
}

@end
