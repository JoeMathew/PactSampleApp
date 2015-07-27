//
//  ImageDownloader.m
//  pactSampleApp
//
//  Created by Joe Mathew on 27/07/2015.
//  Copyright (c) 2015 Joe Mathew. All rights reserved.
//

#import "ImageDownloader.h"
#import "PCNewsTableVC.h"
#import "PCNewsTableViewCell.h"
#import <UIKit/UIKit.h>

#define kAppIconSize 48

@interface ImageDownloader ()
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@end


#pragma mark -

@implementation ImageDownloader

// -------------------------------------------------------------------------------
//	startDownload
// -------------------------------------------------------------------------------
- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [[NSURLRequest requestWithURL:[NSURL URLWithString:self.cellData[@"imageHref"]]] autorelease];
    NSURLConnection *conn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    
    self.imageConnection = conn;
}

#pragma mark - NSURLConnectionDelegate

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Clear the activeDownload property to allow later attempts
    /*if (self.activeDownload) {
        [self.activeDownload release];
        self.activeDownload = nil;
    }
    
    // Release the connection now that it's finished
    if (self.imageConnection) {
        [self.imageConnection release];
        self.imageConnection = nil;
    }*/
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[[UIImage alloc] initWithData:self.activeDownload] autorelease];
    
    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
    {
        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        self.cellData[@"image"] = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        self.cellData[@"image"] = image;
    }
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
    {
        self.completionHandler();
    }
}

@end
