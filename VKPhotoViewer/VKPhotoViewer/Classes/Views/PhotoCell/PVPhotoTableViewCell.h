//
//  PVPhotoTableViewCell.h
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "PVPhotoModel.h"

@interface PVPhotoTableViewCell : UITableViewCell
    


- (void)updateWithModel:(PVPhotoModel *) model;

@end
