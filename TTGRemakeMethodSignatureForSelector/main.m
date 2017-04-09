//
//  main.m
//  TTGRemakeMethodSignatureForSelector
//
//  Created by tutuge on 2017/4/9.
//  Copyright © 2017年 tutuge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TTGRemakeMethodSignatureForSelector.h"

// Test protocol
@protocol TestProtocol <NSObject>

@required
- (void)protocolTestFunc1;
@optional
- (void)protocolTestFunc2;

@required
+ (void)protocolStaticTestFunc1;
@optional
+ (void)protocolStaticTestFunc2;

@end

@interface TestClass : NSObject <TestProtocol>

- (void)testFunc1;
- (void)testFunc3; // Without implementation

+ (void)staticTestFunc1;
+ (void)staticTestFunc3; // Without implementation

@end

@implementation TestClass

- (void)testFunc1 {
    NSLog(@"test func 1");
}
- (void)testFunc2 {} // Without declaration

+ (void)staticTestFunc1 {
    NSLog(@"static test func 1");
}

+ (void)staticTestFunc2 {} // Without declaration

- (void)protocolTestFunc1 {};
+ (void)protocolStaticTestFunc1 {};

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        TestClass *test = [TestClass new];
        NSLog(@"*** Test NSObject methodSignatureForSelector *** ");
        NSLog(@"*** TestClass ***");
        NSLog(@"removeObject: %@", [test methodSignatureForSelector:@selector(removeObject:)]);
        NSLog(@"testFunc1: %@", [test methodSignatureForSelector:@selector(testFunc1)]);
        NSLog(@"testFunc2: %@", [test methodSignatureForSelector:@selector(testFunc2)]);
        NSLog(@"testFunc3: %@", [test methodSignatureForSelector:@selector(testFunc3)]);
        NSLog(@"staticTestFunc1: %@", [TestClass methodSignatureForSelector:@selector(staticTestFunc1)]);
        NSLog(@"staticTestFunc2: %@", [TestClass methodSignatureForSelector:@selector(staticTestFunc2)]);
        NSLog(@"staticTestFunc3: %@", [TestClass methodSignatureForSelector:@selector(staticTestFunc3)]);
        
        NSLog(@"\n");
        NSLog(@"*** Protocol ***");
        NSLog(@"@required protocolTestFunc1: %@", [test methodSignatureForSelector:@selector(protocolTestFunc1)]);
        NSLog(@"@optional protocolTestFunc2: %@", [test methodSignatureForSelector:@selector(protocolTestFunc2)]);
        NSLog(@"@required protocolStaticTestFunc1: %@", [TestClass methodSignatureForSelector:@selector(protocolStaticTestFunc1)]);
        NSLog(@"@optional protocolStaticTestFunc2: %@", [TestClass methodSignatureForSelector:@selector(protocolStaticTestFunc2)]);
        
        NSLog(@"\n\n");
        NSLog(@"*** Test ttg_methodSignatureForSelector *** ");
        NSLog(@"*** TestClass ***");
        NSLog(@"removeObject: %@", [test ttg_methodSignatureForSelector:@selector(removeObject:)]);
        NSLog(@"testFunc1: %@", [test ttg_methodSignatureForSelector:@selector(testFunc1)]);
        NSLog(@"testFunc2: %@", [test ttg_methodSignatureForSelector:@selector(testFunc2)]);
        NSLog(@"testFunc3: %@", [test ttg_methodSignatureForSelector:@selector(testFunc3)]);
        NSLog(@"staticTestFunc1: %@", [TestClass ttg_methodSignatureForSelector:@selector(staticTestFunc1)]);
        NSLog(@"staticTestFunc2: %@", [TestClass ttg_methodSignatureForSelector:@selector(staticTestFunc2)]);
        NSLog(@"staticTestFunc3: %@", [TestClass ttg_methodSignatureForSelector:@selector(staticTestFunc3)]);
        
        NSLog(@"\n");
        NSLog(@"*** Protocol ***");
        NSLog(@"@required protocolTestFunc1: %@", [test ttg_methodSignatureForSelector:@selector(protocolTestFunc1)]);
        NSLog(@"@optional protocolTestFunc2: %@", [test ttg_methodSignatureForSelector:@selector(protocolTestFunc2)]);
        NSLog(@"@required protocolStaticTestFunc1: %@", [TestClass ttg_methodSignatureForSelector:@selector(protocolStaticTestFunc1)]);
        NSLog(@"@optional protocolStaticTestFunc2: %@", [TestClass ttg_methodSignatureForSelector:@selector(protocolStaticTestFunc2)]);
        
        NSLog(@"\n\n");
        
        // Test signature equal
        NSMethodSignature *signature1 = [test methodSignatureForSelector:@selector(testFunc1)];
        NSMethodSignature *signature2 = [test ttg_methodSignatureForSelector:@selector(testFunc1)];
        NSLog(@"signature1 == signature2: %d", [signature1 isEqual:signature2]);
        
        // Invoke instance method
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[test ttg_methodSignatureForSelector:@selector(testFunc1)]];
        invocation.target = test;
        invocation.selector = @selector(testFunc1);
        [invocation invoke];
        
        // Invoke class method
        invocation = [NSInvocation invocationWithMethodSignature:[TestClass ttg_methodSignatureForSelector:@selector(staticTestFunc1)]];
        invocation.target = [TestClass class];
        invocation.selector = @selector(staticTestFunc1);
        [invocation invoke];

    }
    return 0;
}
