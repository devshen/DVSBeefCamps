//
//  DVSStoreManager.m
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/12/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import "DVSStoreManager.h"
#import "DVSDataBaseModel.h"
#import <Realm/Realm.h>

@interface DVSStoreManager ()
@property (nonatomic,strong) NSOperationQueue *operationQueue;///<not use right now
@end

@implementation DVSStoreManager

+ (DVSStoreManager *)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });
    return _sharedInstance;
}

+ (BOOL)modifyModel:(void (^)(RLMRealm *))block {
    [[DVSStoreManager sharedInstance]modifyInBackground:^(RLMRealm *realm) {
        block(realm);
    }];
    return YES;
}

+ (BOOL)addModel:(DVSDataBaseModel *)model {
    [[DVSStoreManager sharedInstance]modifyInBackground:^(RLMRealm *realm) {
        [realm addObject:model];
    }];
    return YES;
}

+ (BOOL)addModels:(NSArray *)models {
    [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[DVSDataBaseModel class]]) {
            *stop = YES;
            NSAssert(NO, @"member of models must be a subclass of DVSDataBaseModel");
        }
    }];
    for (DVSDataBaseModel *model in models) {
        [[DVSStoreManager sharedInstance]modifyInBackground:^(RLMRealm *realm) {
            [realm addObject:model];
        }];
    }
    return YES;
}

+ (BOOL)deleteModel:(DVSDataBaseModel *)model {
    [[DVSStoreManager sharedInstance]modifyInBackground:^(RLMRealm *realm) {
        [realm deleteObject:model];
    }];
    return YES;
}

+ (BOOL)deleteModels:(NSArray *)models {
    [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[DVSDataBaseModel class]]) {
            *stop = YES;
            NSAssert(NO, @"member of models must be a subclass of DVSDataBaseModel");
        }
    }];
    for (DVSDataBaseModel *model in models) {
        [[DVSStoreManager sharedInstance]modifyInBackground:^(RLMRealm *realm) {
            [realm deleteObject:model];
        }];
    }
    return YES;
}

+ (BOOL)updatingModelNeedPrimaryKey:(DVSDataBaseModel *)model {

    if (model.keyId) {
        [[DVSStoreManager sharedInstance]modifyInBackground:^(RLMRealm *realm) {
            [[model class] createInRealm:realm withValue:model];
        }];
    } else {
        NSLog(@"updatingModelNeedPrimaryKey : model not set PrimaryKey");
        return NO;
    }
    return YES;
}

+ (BOOL)updatingModelWithoutPrimaryKey:(void (^)())block {
    
    
    return YES;
}

#pragma mark - privite
- (instancetype)init {
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)modifyInBackground:(void (^)(RLMRealm *realm))block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            block(realm);
            [realm commitWriteTransaction];
        }
    });
}

@end
