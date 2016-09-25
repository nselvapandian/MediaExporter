//
//  MediaExporter.m
//  liveplay
//
//  Created by mac_admin on 20/09/16.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDV.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MediaExporter : CDVPlugin
{
 NSMutableArray *songLists;
}

- (void)getMediaInfo:(CDVInvokedUrlCommand*)command;

@end
