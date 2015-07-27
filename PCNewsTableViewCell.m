//
//  PCNewsTableViewCell.m
//  pactSampleApp
//
//  Created by Joe Mathew on 25/07/2015.
//  Copyright (c) 2015 Joe Mathew. All rights reserved.
//

#import "PCNewsTableViewCell.h"
#define kPadding_side 10.0
#define kTitleMaxWidth 300.0
#define kImageMaxWidth 70.0
#define kImageMaxHeight 50.0

@interface PCNewsTableViewCell () {
    
}

@end

@implementation PCNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel       = [[[UILabel alloc] init]autorelease];
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
        _contentLabel     = [[[UILabel alloc]init]autorelease];
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 20, kImageMaxWidth, 35)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// -------------------------------------------------------------------------------
//	- (void)configureContent:(NSIndexPath*) indexPath
//  Configure the cell content. Set text in Title label and content label.
// -------------------------------------------------------------------------------
- (void)configureContent:(NSIndexPath*) indexPath {
    NSLog(@"CellData = %@", _cellData);
    
    [_titleLabel setFrame:CGRectMake(kPadding_side, kPadding_side, kTitleMaxWidth, [PCNewsTableViewCell heigtForLabelString:_cellData[@"title"]
                                                                                      forWidth:kTitleMaxWidth
                                                                                      withFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]])];
    if (![(id)[NSNull null] isEqual:_cellData[@"title"]]) {
        _titleLabel.text = _cellData[@"title"];
    }
    _titleLabel.textColor = [UIColor colorWithRed:(20/255.0) green:(50/255.0) blue:(250/255.0) alpha:1];
    [self.contentView addSubview:_titleLabel];

    CGFloat contentLabelWidth = kTitleMaxWidth;
    if (![(id)[NSNull null] isEqual: _cellData[@"imageHref"]]) {
        contentLabelWidth = kTitleMaxWidth - kImageMaxWidth;
        //contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_contentImageView];
    }
    
    [_contentLabel setFrame:CGRectMake(kPadding_side, _titleLabel.frame.size.height + kPadding_side,
                                       contentLabelWidth, [PCNewsTableViewCell heigtForLabelString:_cellData[@"description"]
                                                                                      forWidth:contentLabelWidth
                                                                                      withFont:[UIFont fontWithName:@"Arial" size:14.0f]])];
    if (![(id)[NSNull null] isEqual:_cellData[@"description"]]) {
        _contentLabel.text = _cellData[@"description"];
    }
    [self.contentView addSubview:_contentLabel];
}

// -------------------------------------------------------------------------------
//	+ (CGFloat) getCellHeightForContent:(NSDictionary*)contentData
//  Find the required height for the cell with a given content.
// -------------------------------------------------------------------------------
+ (CGFloat) getCellHeightForContent:(NSDictionary*)contentData {
    
    CGFloat cellHeight          = 0.0f;
    CGFloat imageViewHeight     = 0.0f;

    // Calculate height for the title label...
    CGFloat labelHeight         = [self heigtForLabelString:contentData[@"title"]
                                                   forWidth:kTitleMaxWidth
                                                   withFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
    cellHeight += labelHeight;
    
    // Calculate height for the description label...
    // If Image URL is not null, reduce the space for content label to include the image on the right
    CGFloat contentLabelWidth   = kTitleMaxWidth;
    if (![(id)[NSNull null] isEqual: contentData[@"imageHref"]]) {
        contentLabelWidth       = kTitleMaxWidth - kImageMaxWidth - kPadding_side;
        imageViewHeight         = kImageMaxHeight;
    }
    labelHeight     = [self heigtForLabelString:contentData[@"description"]
                                       forWidth:contentLabelWidth
                                       withFont:[UIFont fontWithName:@"Arial" size:14.0f]];
    
    if (labelHeight > imageViewHeight) {
        cellHeight += labelHeight;
    } else {
        cellHeight += imageViewHeight;
    }
    
    return cellHeight;
}

// -------------------------------------------------------------------------------
//	+ (CGFloat)heigtForLabelString:(NSString *)stringValue forWidth:(CGFloat)width withFont:(UIFont*)font
//  Calculates the required height for a label to show the given content.
// -------------------------------------------------------------------------------
+ (CGFloat)heigtForLabelString:(NSString *)stringValue forWidth:(CGFloat)width withFont:(UIFont*)font{
    
    if (![(id)[NSNull null] isEqual:stringValue]) {
        CGSize constraint = CGSizeMake(width,9999);
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect rect = [stringValue boundingRectWithSize:constraint
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:attributes
                                                context:nil];
        return rect.size.height;
    } else {
        return 0.0f;
    }
}


@end
