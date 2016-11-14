//
//  UIAlertController+Additions.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/14/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "UIAlertController+Additions.h"

@implementation UIAlertController (Additions)

+ (UIAlertController*)alertViewControllerWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:okAlertAction];
    return alertVC;
}

@end
