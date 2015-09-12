//
//  DVSNetConfig.h
//  DVSBeefCamps
//
//  Created by Quan.Shen on 9/5/15.
//  Copyright (c) 2015 com.devshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVSNetConfig : NSObject

@property (nonatomic, strong) NSString *mainBaseUrl;

+ (DVSNetConfig *)sharedInstance;

@end
