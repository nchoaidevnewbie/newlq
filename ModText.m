#import <UIKit/UIKit.h>
#import "ModText.h"

@implementation ModText

+ (void)replaceTextInFileWithAlert:(NSString *)filePath originalText:(NSString *)originalText viewController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Chỉnh sửa văn bản"
                                                                             message:@"Nhập văn bản mới để thay thế"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Văn bản mới";
    }];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Thay thế" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *newText = alertController.textFields.firstObject.text;
        NSError *error = nil;

        NSString *fullFilePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
        NSMutableString *fileContents = [NSMutableString stringWithContentsOfFile:fullFilePath encoding:NSUTF8StringEncoding error:&error];

        if (error) {
            [self showAlertWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Lỗi khi đọc file: %@", error.localizedDescription] viewController:viewController];
            return;
        }

        // Tìm kiếm chuỗi gốc bao gồm cả phần giá trị hiện tại
        NSString *pattern = [NSString stringWithFormat:@"%@.*", originalText];
        NSRange range = [fileContents rangeOfString:pattern options:NSRegularExpressionSearch];

        if (range.location != NSNotFound) {
            // Thay thế giá trị mới vào đúng vị trí sau dấu "="
            NSString *newLine = [NSString stringWithFormat:@"%@%@", originalText, newText];

            [fileContents replaceCharactersInRange:range withString:newLine];

            BOOL success = [fileContents writeToFile:fullFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];

            if (!success) {
                [self showAlertWithTitle:@"Lỗi" message:[NSString stringWithFormat:@"Lỗi khi ghi file: %@", error.localizedDescription] viewController:viewController];
            } else {
                [self showAlertWithTitle:@"Thành công" message:@"Thay thế văn bản thành công." viewController:viewController];
            }
        } else {
            [self showAlertWithTitle:@"Lỗi" message:@"Không tìm thấy dòng cần thay thế." viewController:viewController];
        }
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];

    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)backup {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    // URL trực tiếp để tải tệp
    NSURL *url = [NSURL URLWithString:@"https://github.com/WeansHHN/ModSkinFile/releases/download/ModSkinFiles/languageMap_Newbie.txt"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithTitle:@"Lỗi" message:@"Lỗi khi tải tệp từ URL" viewController:viewController];
            });
            return;
        }

        // Lưu tệp vào đường dẫn mong muốn
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resources/1.55.1/Languages/VN_Garena_VN/languageMap_Newbie.txt"];
        BOOL success = [data writeToFile:filePath atomically:YES];
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithTitle:@"Thành công" message:@"Giải mã thành công!" viewController:viewController];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithTitle:@"Lỗi" message:@"Không thể ghi tệp vào đường dẫn" viewController:viewController];
            });
        }
    }];

    [task resume];
}

+ (void)downloadFileFromURL:(NSURL *)url viewController:(UIViewController *)viewController {
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"Loading"
                                                                          message:@"Đang Tải File..."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    [viewController presentViewController:loadingAlert animated:YES completion:nil];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [loadingAlert dismissViewControllerAnimated:YES completion:^{
            if (error) {
                [self showAlertWithTitle:@"Lỗi Máy Chủ" message:@"Tải File Thất Bại" viewController:viewController];
            } else {
                NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resources/1.55.1/Languages/VN_Garena_VN/languageMap_Newbie.txt"];
                if ([data writeToFile:filePath atomically:YES]) {
                    [self showAlertWithTitle:@"Thành công" message:@"Tải và thay thế file thành công!" viewController:viewController];
                } else {
                    [self showAlertWithTitle:@"Lỗi" message:@"Không thể ghi file" viewController:viewController];
                }
            }
        }];
    }] resume];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:alertCtrl animated:YES completion:nil];
}


@end
