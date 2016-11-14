//
//  PVAlbumTableViewCell.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "PVAlbumTableViewCell.h"
#import "Masonry/Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PVAlbumTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (nonatomic) DACircularProgressView *progressView;

@end


@implementation PVAlbumTableViewCell

- (void)prepareForReuse {
    self.albumTitle.text = @"";
    self.albumImage.image = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[self.albumImage layer] setCornerRadius:5.f];
    
    self.progressView = [self progressViewForCell];
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.center.equalTo(self.contentView);
    }];
}

- (void)updateWithModel:(PVAlbumModel *)model {
    [self.albumImage sd_setImageWithURL:[model getThumb] placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:((CGFloat)receivedSize / (CGFloat)expectedSize) animated:YES];
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.hidden = YES;
            self.albumImage.image = image;
            self.albumTitle.text = model.title;
        });
    }];
}

- (DACircularProgressView *)progressViewForCell {
    DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
    progressView.userInteractionEnabled = NO;
    progressView.thicknessRatio = 0.1;
    progressView.roundedCorners = NO;
    return progressView;
}

@end
