//
//  PVAlbumTableViewCell.h
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVAlbumModel.h"
#import "DACircularProgressView.h"

@interface PVAlbumTableViewCell : UITableViewCell

- (void)updateWithModel:(PVAlbumModel *)model;

@end
