//
//  PVPhotosTableViewController.h
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Additions.h"
#import "VKSdk.h"

@interface PVPhotosTableViewController : UITableViewController

@property (nonatomic, assign) long albumId;
@property (nonatomic, strong) VKUser *user;

@end
