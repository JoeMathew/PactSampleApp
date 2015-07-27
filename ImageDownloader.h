//
//  ImageDownloader.h
//  pactSampleApp
//
//  Created by Joe Mathew on 27/07/2015.
//  Copyright (c) 2015 Joe Mathew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject

//@property (nonatomic, strong) AppRecord *appRecord;
@property(nonatomic, retain) NSMutableDictionary * cellData;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
