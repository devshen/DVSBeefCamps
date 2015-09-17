//
//  DVSStoreManager.h
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/12/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RLMRealm;
@class DVSDataBaseModel;
@interface DVSStoreManager : NSObject

/*!
 *  custom modify, block will execute between Realm WriteTransaction
 *
 *  @param block block with realm
 *
 *  @return bool
 */
+ (BOOL)modifyModel:(void (^)(RLMRealm *realm))block;

/*!
 *  add model
 *
 *  @param model DVSDataBaseModel *
 *
 *  @return bool
 */
+ (BOOL)addModel:(DVSDataBaseModel *)model;
+ (BOOL)addModels:(NSArray *)models;

/*!
 *  delete model
 *
 *  @param model DVSDataBaseModel *
 *
 *  @return bool
 */
+ (BOOL)deleteModel:(DVSDataBaseModel *)model;
+ (BOOL)deleteModels:(NSArray *)models;

/*!
 *  update, if can't find object, wil add automatic, need set PrimaryKey already
 *
 *  @param model DVSDataBaseModel *
 *
 *  @return bool
 */
+ (BOOL)updatingModelNeedPrimaryKey:(DVSDataBaseModel *)model;

/*!
 *  update model without primaryKey, change model's property in block
 *
 *  @param block
 *
 *  @return bool
 */
+ (BOOL)updatingModelWithoutPrimaryKey:(void(^)())block;


// now only support add/delete model from Default realm
// query can check out DVSDataBaseModel+Query

@end
