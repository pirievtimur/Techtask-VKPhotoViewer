//
//  PVAlbumModel.h
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/11/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "Mantle/Mantle.h"

@interface PVAlbumModel : MTLModel <MTLJSONSerializing>

@property (nonatomic) long albumId;
@property (nonatomic) NSInteger ownerId;
@property (nonatomic) NSInteger thumbId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *thumbSrc;

- (NSURL*)getThumb;

@end
