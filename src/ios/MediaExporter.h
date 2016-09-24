//
//  MediaExporter.m
//  liveplay
//
//  Created by mac_admin on 20/09/16.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MediaExporter : CDVPlugin
{}

- (void)getMediaInfo:(CDVInvokedUrlCommand*)command;

@end
