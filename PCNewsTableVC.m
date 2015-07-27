//
//  PCNewsTableVC.m
//  pactSampleApp
//
//  Created by Joe Mathew on 25/07/2015.
//  Copyright (c) 2015 Joe Mathew. All rights reserved.
//

#import "PCNewsTableVC.h"
#import "PCNewsTableViewCell.h"
#import "ImageDownloader.h"

#define kWebDataUrl @"https://dl.dropboxusercontent.com/u/746330/facts.json"

@interface PCNewsTableVC ()
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation PCNewsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = _tableTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source/delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_rowData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PCNewsTableViewCell getCellHeightForContent:_rowData[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PCNewsTableViewCell *pctCell = [tableView dequeueReusableCellWithIdentifier:@"pctCell"];
    
    if (!pctCell) {
        pctCell = [[[PCNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:@"pctCell"] autorelease];
    }
    
    // Configure the cell...
    pctCell.cellData = _rowData[indexPath.row];
    [pctCell configureContent:indexPath];
    
    //If Image is not already downloaded and the image url is not null, start downloading the image for the row
    if ((!(_rowData[indexPath.row])[@"image"]) &&
        (![(id)[NSNull null] isEqual: (_rowData[indexPath.row])[@"imageHref"]])) {
        //To keep the tableview scrolling smooth...
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startImgDownload:_rowData[indexPath.row] forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        //pctCell.contentImageView.image = [UIImage imageNamed:@"Placeholder.png"];
    } else if((_rowData[indexPath.row])[@"image"]){
        NSLog(@"Row: %d. Reusing Image", indexPath.row);
        pctCell.contentImageView.image = (_rowData[indexPath.row])[@"image"];
    }
    
    return pctCell;
}

// -------------------------------------------------------------------------------
//	- (void)startImgDownload:(NSMutableDictionary *)cellData forIndexPath:(NSIndexPath *)indexPath

//  Start image download. Implements completion handler because by the time downlad is completed asynchronously
//  the table cell might represent a different row
// -------------------------------------------------------------------------------
- (void)startImgDownload:(NSMutableDictionary *)cellData forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (nil == imageDownloader)
    {
        imageDownloader = [[[ImageDownloader alloc] init] autorelease];
        imageDownloader.cellData = cellData;
        [imageDownloader setCompletionHandler:^{
            PCNewsTableViewCell *cell = (PCNewsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            if (nil != cellData[@"image"]) {
                NSLog(@"Image download complete. Setting to row %d", indexPath.row);
                cell.contentImageView.image = (UIImage *)((_rowData[indexPath.row])[@"image"]);
            }
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        (self.imageDownloadsInProgress)[indexPath] = imageDownloader;
        [imageDownloader startDownload];
    }
}

@end
