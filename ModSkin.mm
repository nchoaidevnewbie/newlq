#import <UIKit/UIKit.h>

#import "ModSkin.h"
#import "mahoa.h"

#import <MobileCoreServices/MobileCoreServices.h>

@implementation ModSkin

UIAlertController *alertCtrl;
UIAlertController *dialogCtrl;
NSFileManager *fileManager = [NSFileManager defaultManager];
NSString *documentDir = [NSSearchPathForDirectoriesInDomains(
    NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
bool check_Mod = false;


+ (void)ActiveModFile {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeZipArchive] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = (id<UIDocumentPickerDelegate>)self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate

+ (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *selectedFileURL = [urls firstObject];
    NSString *dataPathDSGM = [documentDir stringByAppendingPathComponent:@"/Resources"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPathDSGM]) {
        UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Loading"
                                                                              message:@"Đang Giải Nén Data Mod Skin\nVui Lòng Chờ Trong Giây Lát ..."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loadingAlert animated:YES completion:nil];
        
        NSString *tempZipPath = [documentDir stringByAppendingPathComponent:@"Mod Skin.zip"];
        NSData *zipData = [NSData dataWithContentsOfURL:selectedFileURL];
        [zipData writeToFile:tempZipPath atomically:YES];
        
        BOOL success = 
        [[NSFileManager defaultManager] removeItemAtPath:tempZipPath error:nil];
        [loadingAlert dismissViewControllerAnimated:YES completion:^{
            if (success) {
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Successfully"
                                                                                   message:@"Mod Skin thành công, ấn xác nhận để thoát."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Xác nhận"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                    exit(0);
                }]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
            } else {
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                   message:@"Giải Nén Tệp Zip Thất Bại\nVui Lòng Tạo Tệp Zip Như Hướng Dẫn"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
            }
        }];
    } else {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Không Tìm Thấy Thư Mục Gốc"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    }
}

+ (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

+ (void)ActiveMod {
    UIAlertController *dialogCtrl = [UIAlertController alertControllerWithTitle:@"Link Tải Mod Data"
                                                                        message:@"Vui Lòng Nhập Link Mod Skin"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    [dialogCtrl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dán link ...";
    }];
    [dialogCtrl addAction:[UIAlertAction actionWithTitle:@"Hủy"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    [dialogCtrl addAction:[UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action) {
        UITextField *inputFieldDSGM = dialogCtrl.textFields.firstObject;
        NSString *inputTextDSGM = inputFieldDSGM.text;
        NSString *convertedLinkDSGM = [inputTextDSGM stringByReplacingOccurrencesOfString:@"file/d/" withString:@"uc?export=download&id="];
        convertedLinkDSGM = [convertedLinkDSGM stringByReplacingOccurrencesOfString:@"/view?usp=drivesdk" withString:@""];
        NSString *dataPathDSGM = [documentDir stringByAppendingPathComponent:@"/Resources"];
        
        if ([inputTextDSGM isEqualToString:@""]) {
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Warring"
                                                                               message:@"Vui lòng nhập Link tải Mod Skin"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
        } else {
            if ([[NSFileManager defaultManager] fileExistsAtPath:dataPathDSGM]) {
                UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Loading"
                                                                                      message:@"Đang Tải Data Mod Skin\nVui Lòng Chờ Trong Giây Lát ..."
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loadingAlert animated:YES completion:nil];
                
                NSURLRequest *requestdsgm = [NSURLRequest requestWithURL:[NSURL URLWithString:convertedLinkDSGM]];
                [NSURLConnection sendAsynchronousRequest:requestdsgm
                                                   queue:[NSOperationQueue currentQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    [loadingAlert dismissViewControllerAnimated:YES completion:^{
                        if (error) {
                            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Lỗi Máy Chủ"
                                                                                               message:@"Tải Data Thất Bại"
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:nil]];
                            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                        } else {
                            NSString *tempZipPath = [documentDir stringByAppendingPathComponent:@"Mod Skin.zip"];
                            [data writeToFile:tempZipPath atomically:YES];
                            BOOL success =                             [[NSFileManager defaultManager] removeItemAtPath:tempZipPath error:nil];
                            if (success) {
                                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Successfully"
                                                                                                   message:@"Mod Skin thành công, ấn xác nhận để thoát."
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Xác nhận"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * _Nonnull action) {
                                    exit(0);
                                }]];
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                            } else {
                                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                   message:@"Giải Nén Tệp Zip Thất Bại\nVui Lòng Tạo Tệp Zip Như Hướng Dẫn"
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:nil]];
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                            }
                        }
                    }];
                }];
            } else {
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                   message:@"Không Tìm Thấy Thư Mục Gốc"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
            }
        }
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:dialogCtrl animated:YES completion:nil];
}

+ (void)fetchModLinksWithCompletion:(void(^)(NSDictionary *links, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/WeansHHN/ModSkinFile/main/ModSkin.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            completion(jsonResponse, jsonError);
        }
    }];
}

+ (void)ActiveModFull {
    [self fetchModLinksWithCompletion:^(NSDictionary *links, NSError *error) {
        if (error) {
            // Handle error
            NSLog(@"Error fetching links: %@", error);
            return;
        }

        NSString *defaultModLink = links[@"modFullLink"]; // Lấy liên kết mod skin từ API JSON
        
        UIAlertController *dialogCtrl = [UIAlertController alertControllerWithTitle:@"Mod Skin"
                                                                            message:@"Bạn có muốn tải và cài đặt Mod Skin không?"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        [dialogCtrl addAction:[UIAlertAction actionWithTitle:@"Hủy"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
        [dialogCtrl addAction:[UIAlertAction actionWithTitle:@"Xác nhận"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
            NSString *convertedLinkDSGM = [defaultModLink stringByReplacingOccurrencesOfString:@"file/d/" withString:@"uc?export=download&id="];
            convertedLinkDSGM = [convertedLinkDSGM stringByReplacingOccurrencesOfString:@"/view?usp=drivesdk" withString:@""];
            NSString *dataPathDSGM = [documentDir stringByAppendingPathComponent:@"/Resources"];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:dataPathDSGM]) {
                UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Loading"
                                                                                      message:@"Đang Tải Data Mod Skin\nVui Lòng Chờ Trong Giây Lát ..."
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loadingAlert animated:YES completion:nil];
                
                NSURLRequest *requestdsgm = [NSURLRequest requestWithURL:[NSURL URLWithString:convertedLinkDSGM]];
                [NSURLConnection sendAsynchronousRequest:requestdsgm
                                                   queue:[NSOperationQueue currentQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    [loadingAlert dismissViewControllerAnimated:YES completion:^{
                        if (error) {
                            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Lỗi Máy Chủ"
                                                                                               message:@"Tải Data Thất Bại"
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:nil]];
                            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                        } else {
                            NSString *tempZipPath = [documentDir stringByAppendingPathComponent:@"Mod Skin.zip"];
                            [data writeToFile:tempZipPath atomically:YES];
                            BOOL success =                           [[NSFileManager defaultManager] removeItemAtPath:tempZipPath error:nil];
                            if (success) {
                                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Thành công"
                                                                                                   message:@"Mod Skin thành công, ấn xác nhận để thoát."
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Xác nhận"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * _Nonnull action) {
                                        exit(0);
                                    }]];
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                            } else {
                                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Lỗi"
                                                                                                   message:@"Không thể giải nén tệp zip"
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:nil]];
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                            }
                        }
                    }];
                }];
            } else {
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Lỗi"
                                                                                   message:@"Không tìm thấy thư mục gốc"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
            }
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:dialogCtrl animated:YES completion:nil];
    }];
}

+ (void)Backup {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *resourceFolderPath = [documentsPath stringByAppendingPathComponent:@"/Resources/1.55.1/"];
    NSString *backupFolderPath = [documentsPath stringByAppendingPathComponent:@"Resource_Backup/1.55.1/"];

    // Danh sách các thư mục hoặc file cần backup
    NSArray *itemsToBackup = @[@"Ages", @"AssetRefs", @"Databin", @"Prefab_Characters"];

    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    if ([fileManager fileExistsAtPath:backupFolderPath]) {
        // Thực hiện khôi phục
        NSError *restoreError = nil;

        for (NSString *item in itemsToBackup) {
            NSString *sourcePath = [backupFolderPath stringByAppendingPathComponent:item];
            NSString *destinationPath = [resourceFolderPath stringByAppendingPathComponent:item];

            if ([fileManager fileExistsAtPath:sourcePath]) {
                // Nếu mục đích đã tồn tại, xóa nó trước khi sao chép
                if ([fileManager fileExistsAtPath:destinationPath]) {
                    [fileManager removeItemAtPath:destinationPath error:nil];
                }
                [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&restoreError];
            }
        }

        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:NSSENCRYPT("Thành công") message:NSSENCRYPT("Khôi phục hoàn tất.") preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {    
            timer(1.5){
                exit(3);
                });
        }]];
        [rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    } else {
        // Thực hiện backup và đổi tên
        NSError *backupError = nil;

        // Tạo thư mục backup
        if ([fileManager createDirectoryAtPath:backupFolderPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            for (NSString *item in itemsToBackup) {
                NSString *sourcePath = [resourceFolderPath stringByAppendingPathComponent:item];
                NSString *destinationPath = [backupFolderPath stringByAppendingPathComponent:item];

                if ([fileManager fileExistsAtPath:sourcePath]) {
                    [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&backupError];
                }
            }

            [self showAlertWithTitle:@"Thành công" message:@"Backup hoàn tất." inViewController:rootViewController];
        } else {
            [self showAlertWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Lỗi khi tạo thư mục backup: %@", backupError.localizedDescription] inViewController:rootViewController];
        }
    }
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message inViewController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/*+ (void)Backup {
    [self fetchModLinksWithCompletion:^(NSDictionary *links, NSError *error) {
        if (error) {
            // Handle error
            NSLog(@"Error fetching links: %@", error);
            return;
        }

        NSString *defaultModLink = links[@"backupLink"]; // Lấy liên kết backup từ API JSON
        
        UIAlertController *dialogCtrl = [UIAlertController alertControllerWithTitle:@"Remove Mod Skin"
                                                                            message:@"Bạn có muốn tải và Remove Mod Skin không?"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        [dialogCtrl addAction:[UIAlertAction actionWithTitle:@"Hủy"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
        [dialogCtrl addAction:[UIAlertAction actionWithTitle:@"Xác nhận"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
            NSString *convertedLinkDSGM = [defaultModLink stringByReplacingOccurrencesOfString:@"file/d/" withString:@"uc?export=download&id="];
            convertedLinkDSGM = [convertedLinkDSGM stringByReplacingOccurrencesOfString:@"/view?usp=drivesdk" withString:@""];
            NSString *dataPathDSGM = [documentDir stringByAppendingPathComponent:@"/Resources"];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:dataPathDSGM]) {
                UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Loading"
                                                                                      message:@"Đang Tải Data\nVui Lòng Chờ Trong Giây Lát ..."
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loadingAlert animated:YES completion:nil];
                
                NSURLRequest *requestdsgm = [NSURLRequest requestWithURL:[NSURL URLWithString:convertedLinkDSGM]];
                [NSURLConnection sendAsynchronousRequest:requestdsgm
                                                   queue:[NSOperationQueue currentQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    [loadingAlert dismissViewControllerAnimated:YES completion:^{
                        if (error) {
                            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Lỗi Máy Chủ"
                                                                                               message:@"Tải Data Thất Bại"
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:nil]];
                            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                        } else {
                            NSString *tempZipPath = [documentDir stringByAppendingPathComponent:@"Mod Skin.zip"];
                            [data writeToFile:tempZipPath atomically:YES];
                            BOOL success = [SSZipArchive unzipFileAtPath:tempZipPath toDestination:dataPathDSGM];
                            [[NSFileManager defaultManager] removeItemAtPath:tempZipPath error:nil];
                            if (success) {
                                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Thành công"
                                                                                                   message:@"Mod Skin thành công, ấn xác nhận để thoát."
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Xác nhận"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * _Nonnull action) {
                                        exit(0);
                                    }]];
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                            } else {
                                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Lỗi"
                                                                                                   message:@"Không thể giải nén tệp zip"
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:nil]];
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                            }
                        }
                    }];
                }];
            } else {
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Lỗi"
                                                                                   message:@"Không tìm thấy thư mục gốc"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
            }
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:dialogCtrl animated:YES completion:nil];
    }];
}*/


@end