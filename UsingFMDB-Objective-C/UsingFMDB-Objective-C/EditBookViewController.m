//
//  EditBookViewController.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/13.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "EditBookViewController.h"
#import "Book.h"
#import "BookDAO.h"

@interface EditBookViewController () <UINavigationBarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *releaseDatePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation EditBookViewController

/**
 * Called after the controller's view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Edit";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.authorTextField.delegate = self;
    self.titleTextField.delegate  = self;

    if (self.originalBook) {
        self.authorTextField.text   = self.originalBook.author;
        self.titleTextField.text    = self.originalBook.title;
        self.releaseDatePicker.date = self.originalBook.releaseDate;
    }

    [self updateDoneButton];
}

/**
 * Sent to the view controller when the app receives a memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

/**
 * Cancel the editing.
 *
 * @param sender Event target.
 */
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Complete the editing.
 *
 * @param sender Event target.
 */
- (IBAction)done:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didFinishEditBook:author:title:releaseDate:)]) {
        NSInteger bookId = self.originalBook ? self.originalBook.bookId : kBookIdNone;
        [self.delegate didFinishEditBook:bookId
                                  author:self.authorTextField.text
                                   title:self.titleTextField.text
                             releaseDate:self.releaseDatePicker.date];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Occurs when the TextField for the title is edited.
 *
 * @param sender Event target.
 */
- (IBAction)didEditingChangedAuthorTextField:(id)sender {
    [self updateDoneButton];
}

/**
 * Occurs when the TextField for the author is edited.
 *
 * @param sender Event target.
 */
- (IBAction)didEditingChangedTitleTextField:(id)sender {
    [self updateDoneButton];
}

#pragma mark - UINavigationBarDelegate

/**
 * UINavigatonBar の位置を取得します。
 *
 * @param bar UINavigatonBar の参照。
 *
 * @return UINavigatonBar の位置情報。
 */
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - UITextFieldDelegate

/**
 * Asks the delegate if the text field should process the pressing of the return button.
 *
 * @param textField The text field whose return button was pressed.
 *
 * @return YES if the text field should implement its default behavior for the return button; otherwise, NO.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private

/**
 * Update the done button.
 */
- (void)updateDoneButton {
    self.doneButton.enabled = ( 0 < self.authorTextField.text.length && 0 < self.titleTextField.text.length );
}

@end
