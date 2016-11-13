//
//  UIViewController+Additions.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/11/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

+ (instancetype)newInstance {
    NSString* storyboardName = [self storyboardName];
    NSString* className = [self className];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    id newInstance = [sb instantiateViewControllerWithIdentifier:className];
    
    return newInstance;
}


+ (NSString *)storyboardName {
    return [[NSStringFromClass(self) componentsSeparatedByString:@"."] lastObject];
}

+ (NSString *)className {
    return [[NSStringFromClass(self) componentsSeparatedByString:@"."] lastObject];
}

@end
