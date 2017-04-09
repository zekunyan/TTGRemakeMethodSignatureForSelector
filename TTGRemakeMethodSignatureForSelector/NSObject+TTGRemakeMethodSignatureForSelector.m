//
//  NSObject+TTGRemakeMethodSignatureForSelector.m
//  TTGRemakeMethodSignatureForSelector
//
//  Created by tutuge on 2017/4/9.
//  Copyright © 2017年 tutuge. All rights reserved.
//

#import "NSObject+TTGRemakeMethodSignatureForSelector.h"
#import <objc/runtime.h>

struct objc_method_description ttg_MethodDescription(Class class, SEL sel) {
    // Result
    struct objc_method_description description = (struct objc_method_description){NULL, NULL};
    
    // Loop class
    Class currentClass = class;
    
    while (currentClass && description.name == NULL) {
        // Get protocol list
        unsigned int count = 0;
        __unsafe_unretained Protocol **protocols = class_copyProtocolList(currentClass, &count);
        
        // Check each protocol
        for (unsigned int i = 0; i < count; i++) {
            // Required method
            description = protocol_getMethodDescription(protocols[i], sel, YES, class_isMetaClass(currentClass) ^ 1);
            if (description.name != NULL) {
                break;
            }
            
            // Optional method
            description = protocol_getMethodDescription(protocols[i], sel, NO, class_isMetaClass(currentClass) ^ 1);
            if (description.name != NULL) {
                break;
            }
        }
        
        // release
        free(protocols);
        
        // Found in protocol
        if (description.name != NULL) {
            return description;
        }
        
        // Get superClass and continue
        currentClass = class_getSuperclass(currentClass);
    }
    
    // Get implemented instance method
    Method method = class_getInstanceMethod(class, sel);
    if (method) {
        // Get description
        return *method_getDescription(method);
    } else {
        // Return Null result
        return (struct objc_method_description){NULL, NULL};
    }
}

@implementation NSObject (TTGRemakeMethodSignatureForSelector)

- (NSMethodSignature *)ttg_methodSignatureForSelector:(SEL)sel {
    struct objc_method_description description = ttg_MethodDescription([self class], sel); // Get from class
    if (sel && description.types != NULL) {
        return [NSMethodSignature signatureWithObjCTypes:description.types];
    } else {
        return nil;
    }
}

+ (NSMethodSignature *)ttg_methodSignatureForSelector:(SEL)sel {
    struct objc_method_description description = ttg_MethodDescription(object_getClass(self), sel); //  Get from metaClass
    if (sel && description.types != NULL) {
        return [NSMethodSignature signatureWithObjCTypes:description.types];
    } else {
        return nil;
    }
}

@end
