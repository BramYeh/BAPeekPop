# BAPeekPop

[![CI Status](http://img.shields.io/travis/Bram (hryeh)/BAPeekPop.svg?style=flat)](https://travis-ci.org/BramYeh/BAPeekPop)
[![Version](https://img.shields.io/cocoapods/v/BAPeekPop.svg?style=flat)](http://cocoapods.org/pods/BAPeekPop)
[![License](https://img.shields.io/cocoapods/l/BAPeekPop.svg?style=flat)](http://cocoapods.org/pods/BAPeekPop)
[![Platform](https://img.shields.io/cocoapods/p/BAPeekPop.svg?style=flat)](http://cocoapods.org/pods/BAPeekPop)

* Peek &amp; Pop Compat for Long Press on non 3D touch Device of iOS 9+ 
* BAPeekPop is the Objective-C library to support 3D touch similar operation on older device via long-press

![BAPeekPop](https://github.com/BramYeh/BAPeekPop/blob/master/bapeekpop.gif)

## Integration Guide

### Initilization and Register

To integrate BAPeekPop, in your viewcontroller, you just init BAPeekPop instance and call its register

```objc
BAPeekPop *baPeekPop = [[BAPeekPop alloc] initWithTarget:self];
[baPeekPop registerForPreviewingWithDelegate:self sourceView:self.view];
```

The delegate is the same as `id<UIViewControllerPreviewingDelegate>`

### Delegate Handler

BAPeekPop has no extra methods in delegate, you only need to implement 
```
NS_CLASS_AVAILABLE_IOS(9_0) @protocol UIViewControllerPreviewingDelegate <NSObject>
```

The reference ![example](https://github.com/BramYeh/BAPeekPop/blob/master/Example/BAPeekPop/ViewController.m#L95)

### How to add Action and Group Buttons

It's similar as original implementaion, you need to offer 
```@property(nonatomic, readonly) NSArray<id<UIPreviewActionItem>> *previewActionItems;`` 
in the previewing-viewcontroller

And in this array, you need to add objects of `BAPreviewAction` or `BAPreviewActionGroup`

BAPeekPop has offer their factory methods as following

```objc
NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewAction : UIPreviewAction

@property(nonatomic, assign, readonly) UIPreviewActionStyle style;

+ (instancetype)actionWithTitle:(NSString *)title style:(UIPreviewActionStyle)style handler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))handler;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewActionGroup : UIPreviewActionGroup

+ (instancetype)actionGroupWithTitle:(NSString *)title style:(UIPreviewActionStyle)style actions:(NSArray<BAPreviewAction *> *)actions;

@end
```
The reference ![example](https://github.com/BramYeh/BAPeekPop/blob/master/Example/BAPeekPop/PreviewingViewController.m#L53)


## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

BAPeekPop is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BAPeekPop"
```

## Author

Bram (hryeh), hryeh@yahoo-inc.com

## License

BAPeekPop is available under the MIT license. See the LICENSE file for more info.
