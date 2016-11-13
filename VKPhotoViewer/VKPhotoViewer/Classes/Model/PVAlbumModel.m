//
//  PVAlbumModel.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/11/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "PVAlbumModel.h"

@implementation PVAlbumModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"albumId": @"id",
             @"ownerId": @"owner_id",
             @"thumbId": @"thumb_id",
             @"thumbSrc": @"thumb_src",
             @"title": @"title"
             };
}
 
- (NSURL*)getThumb {
    return [NSURL URLWithString:self.thumbSrc];
}

@end
