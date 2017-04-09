# TTGRemakeMethodSignatureForSelector

Remake `methodSignatureForSelector:`，just for research.

## Core code

ttg_MethodDescription

```
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
```

NSObject Category 

```
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
```

## CoreFoundation.framework implementation from Hopper Disassemabler

[NSObject methodSignatureForSelector:]

```
void * +[NSObject methodSignatureForSelector:](void * self, void * _cmd, void * arg2) {
    rdi = self;
    rbx = arg2;
    if ((rbx != 0x0) && (___methodDescriptionForSelector(object_getClass(rdi), rbx) != 0x0)) {
            rax = [NSMethodSignature signatureWithObjCTypes:rdx];
    }
    else {
            rax = 0x0;
    }
    return rax;
}
```

___methodDescriptionForSelector:

![](https://github.com/zekunyan/TTGRemakeMethodSignatureForSelector/raw/master/Resources/TTGRemakeMethodSignatureForSelector_1.png)

```
int ___methodDescriptionForSelector(int arg0, int arg1) {
    var_40 = arg1;
    var_38 = arg0;
    if (arg0 == 0x0) goto loc_918d6;

loc_917e2:
    r15 = var_38;
    goto loc_917f0;

loc_917f0:
    r12 = class_copyProtocolList(r15, 0x0);
    var_50 = r15;
    if (0x0 == 0x0) goto loc_918a0;

loc_91814:
    r13 = 0x0;
    var_48 = r12;
    goto loc_91820;

loc_91820:
    rbx = var_40;
    rdi = r15;
    r15 = protocol_getMethodDescription(*(r12 + r13 * 0x8), rbx, 0x1, (class_isMetaClass(r15) ^ 0x1) & 0xff);
    r14 = 0x1;
    if (r15 != 0x0) goto loc_918b4;

loc_91853:
    r15 = protocol_getMethodDescription(*(r12 + r13 * 0x8), rbx, 0x0, (class_isMetaClass(rdi) ^ 0x1) & 0xff);
    r14 = 0x0;
    if (r15 != 0x0) goto loc_918b0;

loc_91879:
    r13 = r13 + 0x1;
    r15 = var_50;
    r12 = var_48;
    if (r13 < 0x0) goto loc_91820;

loc_9188c:
    r15 = 0x0;
    goto loc_918b4;

loc_918b4:
    free(r12);
    if (r15 != 0x0) goto loc_918ff;

loc_918c1:
    r15 = class_getSuperclass(var_50);
    if (r15 != 0x0) goto loc_917f0;

loc_918d6:
    rax = class_getInstanceMethod(var_38, var_40);
    if (rax != 0x0) {
            rax = method_getDescription(rax);
            r15 = *rax;
            r14 = *(rax + 0x8);
    }
    else {
            r15 = 0x0;
            r14 = 0x0;
    }
    goto loc_918ff;

loc_918ff:
    rax = r15;
    return rax;

loc_918b0:
    r12 = var_48;
    goto loc_918b4;

loc_918a0:
    if (r12 == 0x0) goto loc_918c1;

loc_918a5:
    r14 = 0x0;
    r15 = 0x0;
    goto loc_918b4;
}
```



