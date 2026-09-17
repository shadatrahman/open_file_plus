#import "./include/open_file_safe_plus/OpenFilePlugin.h"

@interface OpenFilePlugin ()<UIDocumentInteractionControllerDelegate>
@end

static NSString *const CHANNEL_NAME = @"open_file";

@implementation OpenFilePlugin{
    FlutterResult _result;
    UIDocumentInteractionController *_documentController;
    UIDocumentInteractionController *_interactionController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:CHANNEL_NAME
                                     binaryMessenger:[registrar messenger]];
    OpenFilePlugin* instance = [[OpenFilePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"open_file" isEqualToString:call.method]) {
        _result = result;
        NSString *msg = call.arguments[@"file_path"];
        if(msg==nil){
            NSDictionary * dict = @{@"message":@"the file path cannot be null", @"type":@-4};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            result(json);
            return;
        }
        NSFileManager *fileManager=[NSFileManager defaultManager];
        BOOL fileExist=[fileManager fileExistsAtPath:msg];
        if(fileExist){
            //            NSURL *resourceToOpen = [NSURL fileURLWithPath:msg];
//            NSString *exestr = [[msg pathExtension] lowercaseString];
            _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:msg]];
            _documentController.delegate = self;
            NSString *uti = call.arguments[@"uti"];
            BOOL isBlank = [self isBlankString:uti];
            if(!isBlank){
                _documentController.UTI = uti;
            }
//             else{
//                 if([exestr isEqualToString:@"rtf"]){
//                     _documentController.UTI=@"public.rtf";
//                 }else if([exestr isEqualToString:@"txt"]){
//                     _documentController.UTI=@"public.plain-text";
//                 }else if([exestr isEqualToString:@"html"]||
//                          [exestr isEqualToString:@"htm"]){
//                     _documentController.UTI=@"public.html";
//                 }else if([exestr isEqualToString:@"xml"]){
//                     _documentController.UTI=@"public.xml";
//                 }else if([exestr isEqualToString:@"tar"]){
//                     _documentController.UTI=@"public.tar-archive";
//                 }else if([exestr isEqualToString:@"gz"]||
//                          [exestr isEqualToString:@"gzip"]){
//                     _documentController.UTI=@"org.gnu.gnu-zip-archive";
//                 }else if([exestr isEqualToString:@"tgz"]){
//                     _documentController.UTI=@"org.gnu.gnu-zip-tar-archive";
//                 }else if([exestr isEqualToString:@"jpg"]||
//                          [exestr isEqualToString:@"jpeg"]){
//                     _documentController.UTI=@"public.jpeg";
//                 }else if([exestr isEqualToString:@"png"]){
//                     _documentController.UTI=@"public.png";
//                 }else if([exestr isEqualToString:@"avi"]){
//                     _documentController.UTI=@"public.avi";
//                 }else if([exestr isEqualToString:@"mpg"]||
//                          [exestr isEqualToString:@"mpeg"]){
//                     _documentController.UTI=@"public.mpeg";
//                 }else if([exestr isEqualToString:@"mp4"]){
//                     _documentController.UTI=@"public.mpeg-4";
//                 }else if([exestr isEqualToString:@"3gpp"]||
//                          [exestr isEqualToString:@"3gp"]){
//                     _documentController.UTI=@"public.3gpp";
//                 }else if([exestr isEqualToString:@"mp3"]){
//                     _documentController.UTI=@"public.mp3";
//                 }else if([exestr isEqualToString:@"zip"]){
//                     _documentController.UTI=@"com.pkware.zip-archive";
//                 }else if([exestr isEqualToString:@"gif"]){
//                     _documentController.UTI=@"com.compuserve.gif";
//                 }else if([exestr isEqualToString:@"bmp"]){
//                     _documentController.UTI=@"com.microsoft.bmp";
//                 }else if([exestr isEqualToString:@"ico"]){
//                     _documentController.UTI=@"com.microsoft.ico";
//                 }else if([exestr isEqualToString:@"doc"]){
//                     _documentController.UTI=@"com.microsoft.word.doc";
//                 }else if([exestr isEqualToString:@"xls"]){
//                     _documentController.UTI=@"com.microsoft.excel.xls";
//                 }else if([exestr isEqualToString:@"ppt"]){
//                     _documentController.UTI=@"com.microsoft.powerpoint.​ppt";
//                 }else if([exestr isEqualToString:@"wav"]){
//                     _documentController.UTI=@"com.microsoft.waveform-​audio";
//                 }else if([exestr isEqualToString:@"wm"]){
//                     _documentController.UTI=@"com.microsoft.windows-​media-wm";
//                 }else if([exestr isEqualToString:@"wmv"]){
//                     _documentController.UTI=@"com.microsoft.windows-​media-wmv";
//                 }else if([exestr isEqualToString:@"pdf"]){
//                     _documentController.UTI=@"com.adobe.pdf";
//                 }else {
//                     NSLog(@"doc type not supported for preview");
//                     NSLog(@"%@", exestr);
//                 }
//             }
            @try {
                BOOL presented = [_documentController presentPreviewAnimated:YES];
                if(!presented){
                    UIView *view = [self topViewController].view;
                    if(view != nil){
                        presented = [_documentController presentOpenInMenuFromRect:view.bounds inView:view animated:YES];
                    }
                }
                if(!presented){
                    NSDictionary * dict = @{@"message":@"No APP found to open this file。", @"type":@-1};
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    result(json);
                }
            }@catch (NSException *exception) {
                NSDictionary * dict = @{@"message":@"File opened incorrectly。", @"type":@-4};
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                result(json);
            }
        }else{
            NSDictionary * dict = @{@"message":@"the file does not exist", @"type":@-2};
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

            result(json);
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    NSDictionary * dict = @{@"message":@"done", @"type":@0};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    _result(json);
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
      NSDictionary * dict = @{@"message":@"done", @"type":@0};
      NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
      NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

      _result(json);
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return [self topViewController];
}

- (UIWindow *)keyWindow {
    if (@available(iOS 13.0, *)) {
        UIWindow *fallback = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]] ||
                (scene.activationState != UISceneActivationStateForegroundActive &&
                 scene.activationState != UISceneActivationStateForegroundInactive)) {
                continue;
            }
            BOOL active = scene.activationState == UISceneActivationStateForegroundActive;
            for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                if (window.isHidden || window.rootViewController == nil) {
                    continue;
                }
                if (window.isKeyWindow && active) {
                    return window;
                }
                if (fallback == nil ||
                    (active && fallback.windowScene.activationState != UISceneActivationStateForegroundActive)) {
                    fallback = window;
                }
            }
        }
        if (fallback != nil) {
            return fallback;
        }
    }
    UIWindow *window = nil;
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        window = delegate.window;
    }
    if (window == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        window = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
    }
    return window;
}

- (UIViewController *)topViewController {
    UIViewController *controller = [self keyWindow].rootViewController;
    while (controller.presentedViewController != nil && !controller.presentedViewController.isBeingDismissed) {
        controller = controller.presentedViewController;
    }
    return controller;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        return YES;
    }
    return NO;
}
@end
