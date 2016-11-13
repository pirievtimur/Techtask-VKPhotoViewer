//
//  PVPhotoModel.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "PVPhotoModel.h"

@implementation PVPhotoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"photo75": @"photo_75",
             @"photo130": @"photo_130",
             @"photo604": @"photo_604",
             @"photo807": @"photo_807",
             @"photo1280": @"photo_1280",
             @"photo2560": @"photo_2560",
             @"photoDescription": @"text"
             };
}

    
- (NSURL*)getThumb {
    NSString *stringURL = [NSString new];
    if (self.photo604) {
        stringURL = self.photo604;
    } else if (self.photo807) {
        stringURL = self.photo807;
    } else if (self.photo1280) {
        stringURL = self.photo1280;
    } else {
        stringURL = self.photo2560;
    }
    return [NSURL URLWithString:stringURL];
}
    
- (NSString*)getPhotoDescription {
    return [self.photoDescription isEqualToString:@""] ? @"VK photo" : self.photoDescription;
}
    
- (NSURL*)getFullscreenImageURL {
    NSString *stringURL = [NSString new];
    if (self.photo2560) {
        stringURL = self.photo2560;
    } else if (self.photo1280) {
        stringURL = self.photo1280;
    } else if (self.photo807) {
        stringURL = self.photo807;
    } else if (self.photo604) {
        stringURL = self.photo604;
    } else if (self.photo130) {
        stringURL = self.photo130;
    } else {
        stringURL = self.photo75;
    }
    return [NSURL URLWithString:stringURL];
}

@end


/*

 id: 291951999,
 album_id: -15,
 owner_id: 20433523,
 photo_75: 'https://pp.vk.me/...0/-7/s_52f384c8.jpg',
 photo_130: 'https://pp.vk.me/...0/-7/m_ec63b7af.jpg',
 photo_604: 'https://pp.vk.me/...0/-7/x_80bf2a97.jpg',
 photo_807: 'https://pp.vk.me/...0/-7/y_b63e6698.jpg',
 photo_1280: 'https://pp.vk.me/...0/-7/z_f7392b93.jpg',
 width: 1280,
 height: 847,
 text: '',
 date: 1354486815

*/
