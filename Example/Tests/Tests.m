//
//  BAPeekPopTests.m
//  BAPeekPopTests
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

// https://github.com/kiwi-bdd/Kiwi

@import Kiwi;
#import <BAPeekPop/BAPeekPop.h>

SPEC_BEGIN(Tests)

describe(@"BAPeekPop", ^{
    context(@"test initialization", ^{
        it(@"BAPeekPop", ^{
            BAPeekPop *baPeekPop = [[BAPeekPop alloc] initWithTarget:nil];
            [[baPeekPop shouldNot] beNil];
        });
        
        it(@"BAPreviewAction", ^{
            BAPreviewAction *baPreviewAction = [BAPreviewAction actionWithTitle:@"UIPreviewActionStyleDefault" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                // no operation
            }];
            [[baPreviewAction shouldNot] beNil];
            [[theValue(baPreviewAction.style) should] equal:theValue(UIPreviewActionStyleDefault)];
        });
        
        it(@"BAPreviewActionGroup", ^{
            BAPreviewActionGroup *baPreviewActionGoup = [BAPreviewActionGroup actionGroupWithTitle:@"UIPreviewActionGroup" style:UIPreviewActionStyleDefault actions:@[[BAPreviewAction actionWithTitle:@"ActionGroup with 1st position" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            }],
                                                                                                                                                              [BAPreviewAction actionWithTitle:@"ActionGroup with 2nd position" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            }],
                                                                                                                                                              [BAPreviewAction actionWithTitle:@"ActionGroup with 3rd position" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            }]
                                                                                                                                                              ]];
            
            [[baPreviewActionGoup shouldNot] beNil];
        });
    });
});

SPEC_END

