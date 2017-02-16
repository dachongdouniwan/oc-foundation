// Import this file when U really need !

// ----------------------------------
// Version
// ----------------------------------

#undef  __VERSION__
#define __VERSION__         ("0.1.0")

#define __MUST_ON__         (1)
#define __MUST_OFF__        (0)

#define __ON__              (1)
#define __OFF__             (0)
#define __AUTO__            (DEBUG)

// ----------------------------------
// Debug predefine
// ----------------------------------

#define __DEBUG__       (__ON__)    /// 調試模式
#define __TESTING__     (__OFF__)   /// 單元測試
#define __LOGGING__     (__ON__)    /// 日誌模式
#define __SERVICE__     (__ON__)    /// 後臺服務
