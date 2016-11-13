//
//  UIViewController+Additions.h
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/11/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

+ (instancetype)newInstance;
+ (NSString *)storyboardName;
+ (NSString *)className;

@end
