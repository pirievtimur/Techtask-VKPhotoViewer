//
//  PVPhotoTableViewCell.h
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVPhotoTableViewCell : UITableViewCell
    
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *photoTitle;

@end
