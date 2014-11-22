//
//  DapLuaBridge.h
//  DAP
//
//  Created by YJ Park on 14/11/10.
//  Copyright (c) 2014年 AngelDnD. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RegistryAPI;

@interface DapLuaState : NSObject

+ (DapLuaState *)sharedState;
- (void)eval: (NSString *)script;

@end
