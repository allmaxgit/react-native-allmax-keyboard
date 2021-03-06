#import "RNAllmaxKeyboard.h"
#import <React/RCTUIManager.h>
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <React/RCTUtils.h>
#import <RCTText/RCTTextInput.h>

@implementation RNAllmaxKeyboard

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE(RNAllmaxKeyboard)

RCT_EXPORT_METHOD(installKeyboard:(nonnull NSString *)keyboardType
                  forTextFieldbyReactTag:(nonnull NSNumber *)reactTag
                  withHeight:(nonnull NSNumber *)keyboardHeight) {
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];
    if ([textField inputView] == nil) {
        UIView* keyboardView = [[RCTRootView alloc]
                                initWithBridge:[self.bridge valueForKey:@"parentBridge"]
                                moduleName:@"AllMaxKeyboard"
                                initialProperties:@{
                                                    @"tag": reactTag,
                                                    @"keyboardType": keyboardType
                                                    }
                                ];

        [keyboardView setFrame:CGRectMake(0, 0, 0, [keyboardHeight floatValue])];
        [textField setInputView:keyboardView];
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    [textField reloadInputViews];
}

RCT_EXPORT_METHOD(uninstall:(nonnull NSNumber *)reactTag)
{
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];

    [textField setInputView:nil];
    [textField setInputAccessoryView: nil];
    [textField reloadInputViews];
}

RCT_EXPORT_METHOD(insertText:(nonnull NSNumber *)reactTag withText:(NSString*)text) {
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];
    NSLog(@"%@", textField.inputAccessoryView);
    UIView* accessoryView = textField.inputAccessoryView;
    [textField replaceRange:textField.selectedTextRange withText:text];
    [textField setInputAccessoryView:accessoryView];
    [textField reloadInputViews];
}

RCT_EXPORT_METHOD(backSpace:(nonnull NSNumber *)reactTag) {
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];

    UITextRange* range = textField.selectedTextRange;
    if ([textField comparePosition:range.start toPosition:range.end] == 0) {
        range = [textField textRangeFromPosition:[textField positionFromPosition:range.start offset:-1] toPosition:range.start];
    }
    [textField replaceRange:range withText:@""];
}

RCT_EXPORT_METHOD(doDelete:(nonnull NSNumber *)reactTag) {
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];

    UITextRange* range = textField.selectedTextRange;
    if ([textField comparePosition:range.start toPosition:range.end] == 0) {
        range = [textField textRangeFromPosition:range.start toPosition:[textField positionFromPosition: range.start offset: 1]];
    }
    [textField replaceRange:range withText:@""];
}

RCT_EXPORT_METHOD(moveLeft:(nonnull NSNumber *)reactTag) {
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];

    UITextRange* range = textField.selectedTextRange;
    UITextPosition* position = range.start;

    if ([textField comparePosition:range.start toPosition:range.end] == 0) {
        position = [textField positionFromPosition: position offset: -1];
    }

    textField.selectedTextRange = [textField textRangeFromPosition: position toPosition:position];
}

RCT_EXPORT_METHOD(moveRight:(nonnull NSNumber *)reactTag) {
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];

    UITextRange* range = textField.selectedTextRange;
    UITextPosition* position = range.end;

    if ([textField comparePosition:range.start toPosition:range.end] == 0) {
        position = [textField positionFromPosition: position offset: 1];
    }

    textField.selectedTextRange = [textField textRangeFromPosition: position toPosition:position];
}

RCT_EXPORT_METHOD(switchSystemKeyboard:(nonnull NSNumber*) reactTag) {
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];

    UIView* inputView = textField.inputView;
    textField.inputView = nil;
    [textField reloadInputViews];
    textField.inputView = inputView;
}

RCT_EXPORT_METHOD(done:(nonnull NSNumber*) reactTag) {
    RCTTextInput *textInputView = (RCTTextInput*)[_bridge.uiManager viewForReactTag:reactTag];
    UITextField* textField = (UITextField*)[textInputView backedTextInputView];

    [textField sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
    [textField endEditing:YES];
//    [textField resignFirstResponder];
//    [textField becomeFirstResponder];
}


@end
