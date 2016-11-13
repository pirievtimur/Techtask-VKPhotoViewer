//
//  PVLoginViewController.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/11/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "PVLoginViewController.h"
#import "PVAlbumsTableViewController.h"

static NSArray *permissions = nil;
static NSString *appId = @"5723402";

@interface PVLoginViewController ()

- (UIAlertController*)alertViewControllerWithTitle:(NSString*)title message:(NSString*)message;

@end

@implementation PVLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    permissions = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [[VKSdk initializeWithAppId:appId] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:permissions completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self.navigationController pushViewController:[PVAlbumsTableViewController newInstance] animated:true];
        } else if (error) {
            [self presentViewController:[self alertViewControllerWithTitle:@"Error" message:@"Fail to authorize"] animated:true completion:nil];
        }
    }];

}

//MARK: - IBAction

- (IBAction)onButtonClickLogin:(id)sender {
    [VKSdk authorize:permissions];
}

//MARK: - VkSDKDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self.navigationController pushViewController:[PVAlbumsTableViewController newInstance] animated:true];
    } else if (result.error) {
        [self presentViewController:[self alertViewControllerWithTitle:@"Error" message:@"Fail to authorize"] animated:true completion:nil];
    }
}

- (void)vkSdkUserAuthorizationFailed {
    [self presentViewController:[self alertViewControllerWithTitle:@"Error" message:@"Fail to authorize"] animated:true completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//MARK: - VKSdkUIDelegate

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

//MARK: - UIAlertViewController

- (UIAlertController*)alertViewControllerWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:okAlertAction];
    return alertVC;
}

@end
