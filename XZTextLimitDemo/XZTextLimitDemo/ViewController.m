//
//  ViewController.m
//  XZTextLimitDemo
//
//  Created by 徐章 on 16/7/12.
//  Copyright © 2016年 徐章. All rights reserved.
//

#define XZ_Limit_Length 10

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField_textDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (void)textField_textDidChange:(NSNotification *)notification {
    
    UITextField *textField = (UITextField *)notification.object;
    NSString *toBeString = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > XZ_Limit_Length) {
            UITextRange *textRange = textField.selectedTextRange;
            textField.text = [self subStringWithMaxLength:textField.text];
            textField.selectedTextRange = textRange;
        }
    }
}


- (NSString *)subStringWithMaxLength:(NSString *)text {
    __block NSString *aString = @"";
    __block int length = 0;
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {

        length++;
        
        if (length <= XZ_Limit_Length) {
            aString = [aString stringByAppendingString:substring];
        }
        
        
    }];
    
    
    return aString;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
