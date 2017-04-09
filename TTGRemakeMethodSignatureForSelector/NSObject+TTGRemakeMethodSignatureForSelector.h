//
//  NSObject+TTGRemakeMethodSignatureForSelector.h
//  TTGRemakeMethodSignatureForSelector
//
//  Created by tutuge on 2017/4/9.
//  Copyright © 2017年 tutuge. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Remake [NSObject methodSignatureForSelector:]
 *  Just for research
 */
@interface NSObject (TTGRemakeMethodSignatureForSelector)

/**
 *  Get instance method signature
 *
 *  @param sel selector
 *
 *  @return signature
 */
- (NSMethodSignature *)ttg_methodSignatureForSelector:(SEL)sel;

/**
 *  Get class method signature
 *
 *  @param sel selector
 *
 *  @return signature
 */
+ (NSMethodSignature *)ttg_methodSignatureForSelector:(SEL)sel;

@end
