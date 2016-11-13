//
//  PVAlbumTableViewCell.h
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVAlbumTableViewCell : UITableViewCell
    
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;

@end
