//
//  DapLuaState.h
//  DapLua
//
//  Created by YJ Park on 14/11/10.
//  Copyright (c) 2014年 AngelDnD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DapCore/DapCore-Swift.h"

@class RegistryAPI;

@interface DapLuaState : NSObject

+ (DapLuaState *)sharedState;
- (void)bootstrap;
- (void)eval: (NSString *)script;
- (void)onBoolChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath
              lastValue: (bool) lastValue value: (bool)value;
- (void)onIntChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath
              lastValue: (int) lastValue value: (int)value;
- (void)onLongChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath
              lastValue: (long long) lastValue value: (long long)value;
- (void)onFloatChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath
              lastValue: (float) lastValue value: (float)value;
- (void)onDoubleChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath
              lastValue: (double) lastValue value: (double)value;
- (void)onStringChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath
              lastValue: (NSString *) lastValue value: (NSString *)value;
- (void)onEvent: (NSString *)itemPath channelPath: (NSString *)channelPath
              evt: (Data *) evt;
- (void)onRequest: (NSString *)itemPath handlerPath: (NSString *)handlerPath
              req: (Data *) req;
- (void)onResponse: (NSString *)itemPath handlerPath: (NSString *)handlerPath
              req: (Data *) req res: (Data *) res;
- (Data *)doHandle: (NSString *)itemPath handlerPath: (NSString *)handlerPath
              req: (Data *) req;

@end
