//
//  PCNewsTableViewCell.h
//  pactSampleApp
//
//  Created by Joe Mathew on 25/07/2015.
//  Copyright (c) 2015 Joe Mathew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCNewsTableViewCell : UITableViewCell {

}

@property(nonatomic,retain) NSMutableDictionary *cellData;
@property(nonatomic,retain) UIImageView *contentImageView;
@property(nonatomic,retain) UIImage *contentImage;
@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UILabel *contentLabel;

- (void)configureContent:(NSIndexPath*) indexPath;
+ (CGFloat) getCellHeightForContent:(NSDictionary*)contentData;

@end
