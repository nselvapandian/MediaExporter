/********* MediaExporter.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "MediaExporter.h"

//@interface MediaExporter : CDVPlugin {
//  // Member variables go here.
//    NSMutableArray *songLists;
//}
//
//- (void)coolMethod:(CDVInvokedUrlCommand*)command;
//@end

@implementation MediaExporter

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)getMediaInfo:(CDVInvokedUrlCommand*)command
{
    NSArray* mediaInformation = [self mediaInformation];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:mediaInformation];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSMutableArray*)mediaInformation
{
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    MPMediaItem *mediaItem = [[MPMediaItem alloc]init];
    
    songLists = [NSMutableArray array];
    
    for (int i = 0; i < query.items.count; i++) {
        NSDictionary *song = [[NSDictionary alloc]initWithObjectsAndKeys:@"title",mediaItem.title,@"url",mediaItem.assetURL, nil];
        [songLists addObject:song];
    }
    return songLists;
}

- (NSString*) fetchSongFromMediaLibrary: (NSString *)urlString
{
    
    MPMediaItem *mediaItem = [[MPMediaItem alloc]init];
    
    for (int i = 0; i < songLists.count; i++) {
        MPMediaItem *media = songLists[i];
        if (media.assetURL == [[NSURL alloc]initWithString:urlString]) {
            mediaItem = media;
        }
    }
    //convert MPMediaItem to AVURLAsset.
    AVURLAsset *sset = [AVURLAsset assetWithURL:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL]];
    
    //get the extension of the file.
    NSString *fileType = [[[[sset.URL absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0] pathExtension];
    
    //init export, here you must set "presentName" argument to "AVAssetExportPresetPassthrough". If not, you will can't export mp3 correct.
    AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:sset presetName:AVAssetExportPresetAppleM4A];
    
    NSLog(@"export.supportedFileTypes : %@",export.supportedFileTypes);
    //export to mov format.
    export.outputFileType = @"com.apple.m4a-audio";
    
    export.shouldOptimizeForNetworkUse = YES;
    
    NSString *extension = (__bridge  NSString *)UTTypeCopyPreferredTagWithClass((__bridge  CFStringRef)export.outputFileType, kUTTagClassFilenameExtension);
    
    NSLog(@"extension %@",extension);
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.%@",@"song",extension];
    
    NSURL *outputURL = [NSURL fileURLWithPath:path];
    export.outputURL = outputURL;
    
    NSString *mp3Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.%@",@"song",fileType];
    
    [export exportAsynchronouslyWithCompletionHandler:^{
        
        if (export.status == AVAssetExportSessionStatusCompleted)
        {
            NSError *error = nil;
            
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:mp3Path error:&error];
            if (success) {
                [[NSFileManager defaultManager] moveItemAtPath:path toPath:mp3Path error:&error];
            }
            else
            {
                NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
            }
        }
        else
        {
            NSLog(@"%@",export.error);
        }
    }];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:mp3Path];
    
    if (fileExists) {
        return mp3Path;
    }
    
    return @"";
}

@end

