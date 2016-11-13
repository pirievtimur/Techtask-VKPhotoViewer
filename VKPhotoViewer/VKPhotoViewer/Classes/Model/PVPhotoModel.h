//
//  PVPhotoModel.h
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "Mantle/Mantle.h"

@interface PVPhotoModel : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *photo75;
@property (nonatomic) NSString *photo130;
@property (nonatomic) NSString *photo604;
@property (nonatomic) NSString *photo807;
@property (nonatomic) NSString *photo1280;
@property (nonatomic) NSString *photo2560;
@property (nonatomic) NSString *photoDescription;

    
- (NSURL*)getThumb;
- (NSString*)getPhotoDescription;
- (NSURL*)getFullscreenImageURL;

@end
