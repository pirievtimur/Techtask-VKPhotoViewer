//
//  PVPhotosTableViewController.m
//  VKPhotoViewer
//
//  Created by Timur Piriev on 11/13/16.
//  Copyright © 2016 Timur Piriev. All rights reserved.
//

#import "PVPhotosTableViewController.h"
#import "PVPhotoTableViewCell.h"
#import "UIAlertController+Additions.h"
#import "PVPhotoModel.h"
#import "MWPhotoBrowser.h"
#import "MBProgressHUD.h"
#import "VKsdk.h"

// vk api methods, parameters
static NSString *getAlbumsMethod = @"photos.get";

static const CGFloat CELL_HEIGHT = 250;

@interface PVPhotosTableViewController () <MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSString *albumIdParameter;
@property (nonatomic, strong) NSMutableArray *photosData;
@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation PVPhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.albumIdParameter = [NSString stringWithFormat:@"%ld", (long)self.albumId];
    
    //register nib
    NSString *identifier = NSStringFromClass([PVPhotoTableViewCell class]);
    UINib *cellNib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:identifier];
    
    //set refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshUserPhotosData) forControlEvents:UIControlEventValueChanged];
    
    //get photos data
    [self getUserPhotos];
}

- (void)getUserPhotos {
    //method for getting photos data after loading of controller
    MBProgressHUD *activityView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    activityView.mode = MBProgressHUDModeIndeterminate;
    VKRequest *photosRequest = [VKRequest requestWithMethod:getAlbumsMethod parameters:@{VK_API_USER_ID:self.user.id, VK_API_ALBUM_ID: self.albumIdParameter}];
    [photosRequest executeWithResultBlock:^(VKResponse *response) {
        self.photosData = [self parseResponse:response.json];
        [self.tableView reloadData];
        [activityView hide:YES];
    } errorBlock:^(NSError *error) {
        [activityView hide:YES];
        NSString *errorString = [NSString stringWithFormat:@"%@", error.localizedDescription];
        [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:errorString] animated:true completion:nil];
    }];
}

- (void)refreshUserPhotosData {
    //additional method to avoid activity view during spinner
    VKRequest *photosRequest = [VKRequest requestWithMethod:getAlbumsMethod parameters:@{VK_API_USER_ID:self.user.id, VK_API_ALBUM_ID: self.albumIdParameter}];
    [photosRequest executeWithResultBlock:^(VKResponse *response) {
        self.photosData = [self parseResponse:response.json];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } errorBlock:^(NSError *error) {
        [self.refreshControl endRefreshing];
        NSString *errorString = [NSString stringWithFormat:@"%@", error.localizedDescription];
        [self presentViewController:[UIAlertController alertViewControllerWithTitle:@"Error" message:errorString] animated:true completion:nil];
    }];
}

- (NSMutableArray*)parseResponse:(NSDictionary*)responseObject {
    NSMutableArray *array = [NSMutableArray new];
    for (id jsonItem in responseObject[@"items"]) {
        NSError *error = nil;
        PVPhotoModel *photoModel = [MTLJSONAdapter modelOfClass:PVPhotoModel.class fromJSONDictionary:jsonItem error:&error];
        
        if (error) {
#if DEBUG
            NSLog(@"Unable to parse item %@", jsonItem);
#endif
            continue;
        }
        
        [array addObject:photoModel];
    }
    
    return array;
}


// MARK: - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photosData count];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([PVPhotoTableViewCell class]);
    PVPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    PVPhotoModel *dataForCell = [self.photosData objectAtIndex:indexPath.row];
    [cell updateWithModel:dataForCell];
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWPhotoBrowser *photoBrowser = [self photoBrowser];
    PVPhotoModel *dataForCell = [self.photosData objectAtIndex:indexPath.row];
    MWPhoto *photo = [[MWPhoto alloc] initWithURL:[dataForCell getFullscreenImageURL]];
    self.photosArray = [@[photo] mutableCopy];
    [self.navigationController pushViewController:photoBrowser animated:true];
}



// MARK: - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

// MARK: - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [self.photosArray objectAtIndex:index];
}

- (MWPhotoBrowser*)photoBrowser {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    return browser;
}



@end
