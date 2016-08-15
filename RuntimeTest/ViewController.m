//
//  ViewController.m
//  RuntimeTest
//
//  Created by WeibaYeQiang on 16/8/12.
//  Copyright © 2016年 YQ. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "CustomClass.h"
#import "PersonClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self oneParam];
    [self twoParam];
    [self two];
}

//拷贝对象
- (void)copyObj {
    CustomClass *objOld = [CustomClass new];
    id objNew = object_copy(objOld, sizeof(objOld));
    NSLog(@"objOld:%p",objOld);
    NSLog(@"objNew:%p",objNew);
    
    [objNew fun1];
}

//销毁对象
- (void)objectDispose {
    CustomClass *obj = [CustomClass new];
    object_dispose(obj);
    
    [obj release];
    [obj fun1];
}

//更改对象的类
- (void)setClassText {
    CustomClass *objOld = [CustomClass new];
    [objOld fun1];
    
    //Class aClass可以省略
//    Class aClass =
    object_setClass(objOld, [PersonClass class]);
    
//    NSLog(@"aClass >>> %@",NSStringFromClass(aClass));
    NSLog(@"objOld Class >>> %@",NSStringFromClass([objOld class]));
    
}

//获取class的类
- (void)getClassTest {
    CustomClass *objOld = [CustomClass new];
    Class aLogClass = object_getClass(objOld);
    NSLog(@"%@",NSStringFromClass([aLogClass class]));
    
    NSString *class = [objOld class];
    NSLog(@"%@",class);
}


//只有一个参参数的
- (void)oneParam {
    
    CustomClass *instance = [[CustomClass alloc] init];
    //    方法添加
    class_addMethod([CustomClass class],@selector(ocMethod:), (IMP)cfunction,"v@:@");
    if ([instance respondsToSelector:@selector(ocMethod:)]) {
        NSLog(@"Yes, instance respondsToSelector:@selector(ocMethod:)");
    } else
    {
        NSLog(@"Sorry");
    }

    [instance ocMethod:@"我是一个OC的method，C函数实现"];
    
}

//给类添加方法
void cfunction(id self, SEL _cmd, NSString *str) {
    NSLog(@"%@", str);
}

//有两个参数的
- (void)twoParam {
    
    PersonClass *person = [PersonClass new];
    class_addMethod([PersonClass class], @selector(hello:), (IMP)say, "v@:@@");
    
    if ([person respondsToSelector:@selector(hello:)]) {
        NSLog(@"person is responsToselect:@selector(hello)");
    } else {
        NSLog(@"sorry");
    }
    
    [person hello:@"hello",@"tom"];
}

//给类添加方法
void say(id self, SEL _cmd, NSString *str,NSString *person) {
    NSLog(@"say %@ to %@",str,person);
}

//然后在其他地方也能够调用这个方法
- (void)two {
    PersonClass *p = [PersonClass new];
    [p hello:@"1",@"2"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
