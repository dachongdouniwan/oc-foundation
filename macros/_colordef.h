//
//     ____              _____    _____    _____
//    / ___\   /\ /\     \_   \   \_  _\  /\  __\
//    \ \     / / \ \     / /\/    / /    \ \  _\_
//  /\_\ \    \ \_/ /  /\/ /_     / /      \ \____\
//  \____/     \___/   \____/    /__|       \/____/
//
//	Copyright BinaryArtists development team and other contributors
//
//	https://github.com/BinaryArtists/suite.great
//
//	Free to use, prefer to discuss!
//
//  Welcome!
//

#ifndef _colordef_h
#define _colordef_h

#define color_with_rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define color_with_rgb(r,g,b) color_with_rgba(r, g, b, 1.0f)

#define color_white     [UIColor whiteColor]            // 1.0 white
#define color_black     [UIColor blackColor]            // 0.0 white
#define color_darkGray  [UIColor darkGrayColor]         // 0.333 white
#define color_lightGray [UIColor lightGrayColor]        // 0.667 white
#define color_gray      [UIColor grayColor]             // 0.5 white
#define color_red       [UIColor redColor]              // 1.0, 0.0, 0.0 RGB
#define color_green     [UIColor greenColor]            // 0.0, 1.0, 0.0 RGB
#define color_blue      [UIColor blueColor]             // 0.0, 0.0, 1.0 RGB
#define color_cyan      [UIColor cyanColor]             // 0.0, 1.0, 1.0 RGB
#define color_yellow    [UIColor yellowColor]           // 1.0, 1.0, 0.0 RGB
#define color_magenta   [UIColor magentaColor]          // 1.0, 0.0, 1.0 RGB
#define color_orange    [UIColor orangeColor]           // 1.0, 0.5, 0.0 RGB
#define color_purple    [UIColor purpleColor]           // 0.5, 0.0, 0.5 RGB
#define color_brown     [UIColor brownColor]            // 0.6, 0.4, 0.2 RGB
#define color_clear     [UIColor clearColor]            // 0.0 white, 0.0 alpha

#endif /* _colordef_h */
