//
//  RSPlaceHolderTextView.h
//  RedScarf
//
//  Created by lishipeng on 15/12/26.
//  Copyright © 2015年 zhangb. All rights reserved.
//


@interface RSPlaceHolderTextView : UITextView {
NSString *placeholder;
UIColor *placeholderColor;
@private
UILabel *placeHolderLabel;
}

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;
- (void)designatePlaceholder:(NSString *)string;

@end

