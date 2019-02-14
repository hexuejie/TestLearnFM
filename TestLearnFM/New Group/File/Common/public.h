#define ScreenWidth [[UIScreen mainScreen] bounds].size.width //屏幕宽度
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height //屏幕高度

#define CustomFit ScreenWidth/375

#define APP ((AppDelegate*)[UIApplication sharedApplication].delegate)

#define CURRENT_VIEW_WIDTH                          self.view.frame.size.width
#define CURRENT_VIEW_HEIGTH                         self.view.frame.size.height

#define CURRENT_FRAME_WIDTH                         self.frame.size.width
#define CURRENT_FRAME_HEIGTH                        self.frame.size.height

#define kScreenSize                                 [UIScreen mainScreen].bounds
#define kScreenWidth                                kScreenSize.size.width
#define kScreenHeight                               kScreenSize.size.height

#define  SET_SYNCHRONIZE(_synchronize) [[NSUserDefaults standardUserDefaults] _synchronize]

#define HexRGB(hexRGB) [UIColor colorWithRed:((float)((hexRGB & 0xFF0000) >> 16))/255.0 green:((float)((hexRGB & 0xFF00) >> 8))/255.0 blue:((float)(hexRGB & 0xFF))/255.0 alpha:1.0]  //0xFFFFFF


#define  GET_IMAGE_WITH_NAME_AND_TYPE(name,type)  \
[UIImage imageWithContentsOfFile:\
[[NSBundle mainBundle]\
pathForResource:name ofType:type]]

#define  GET_IMAGE_WITH_NAME(name)  \
[UIImage imageWithContentsOfFile:\
[[NSBundle mainBundle]\
pathForResource:name ofType:@"png"]]

#define kAlbumFile @"albumPlist.plist"  //专辑缓存
#define kMusicFile @"musicPlist.plist"  //歌曲缓存

#define kCollectionFile @"collectionPlist.plist"  //收藏缓存


#define AuthToken @"c3c1c3e31dd14f499caacb2d2b3aefea"//默认id
#define Studentid @"bba5be2582ed4796bc00cc791521b9e5"

//#ifdef YES

#define KRequestSingle @"/single_api"
#define KRequestFM @"http://218.76.7.150:8080/ajiau-api/ParentServer"
//http://218.76.7.150:8080/ajiau-api/ParentServer
