//
//  DVSDataBaseModel+Query.h
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/12/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "DVSDataBaseModel.h"

@interface DVSDataBaseModel (Query)

+ (NSArray *)queryObjectWhere:(NSString *)where
   sortedResultsUsingProperty:(NSString *)property
                    ascending:(BOOL)isAscend;

+ (NSArray *)queryObjectWithPredicate:(NSPredicate *)predicate
           sortedResultsUsingProperty:(NSString *)property
                            ascending:(BOOL)isAscend;

@end
