#ifndef ModText_h
#define ModText_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModText : NSObject

/**
 Thay thế văn bản trong file với một hộp thoại xác nhận và nhập văn bản mới từ người dùng.

 @param filePath Đường dẫn đến file cần thay thế văn bản.
 @param originalText Văn bản gốc cần thay thế trong file.
 @param viewController UIViewController hiện tại để trình bày các hộp thoại.
 */
+ (void)replaceTextInFileWithAlert:(NSString *)filePath
                       originalText:(NSString *)originalText
                      viewController:(UIViewController *)viewController;

/**
 Sao lưu file từ liên kết API và thay thế file hiện tại.

 Hộp thoại xác nhận sẽ được hiển thị để người dùng xác nhận hành động.
 */
+ (void)backup;

/**
 Tải file từ URL và lưu vào thư mục Documents.

 @param url URL của file cần tải.
 @param viewController UIViewController hiện tại để trình bày các hộp thoại.
 */
+ (void)downloadFileFromURL:(NSURL *)url
               viewController:(UIViewController *)viewController;

/**
 Hiển thị hộp thoại cảnh báo với tiêu đề và thông điệp.

 @param title Tiêu đề của hộp thoại.
 @param message Thông điệp của hộp thoại.
 @param viewController UIViewController hiện tại để trình bày hộp thoại.
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            viewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END

#endif