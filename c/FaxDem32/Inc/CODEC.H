#ifndef CODEC_HEADER_INCLUDEC
#define CODEC_HEADER_INCLUDEC


#define CODEC_MESSAGE   "CODEC Message"
#define CDC_STARTED             1
#define CDC_FINISHED    2

#define MODE_ASYNC              0
#define MODE_SYNC               1

#define FREQ_7200               0
#define FREQ_14400              1
#define FREQ_21100              2
#define FREQ_11025              3
#define FREQ_22050              4

int __declspec(dllexport) StartCODEC(HWND hwndParent, int nPriority);
void __declspec(dllexport) TerminateCODEC();

int __declspec(dllexport) ConvertVOC2WAV(const char *lpcSrcFile, const char *lpcDestFile, short sBPS, short nFreq, bool bSyncMode);
int __declspec(dllexport) ConvertWAV2VOC(const char *lpcSrcFile, const char *lpcDestFile, short sBPS, bool bSyncMode);
int __declspec(dllexport) ConvertPCMtoDialogicADPCM(const char *lpcSrcFile, const char *lpcDestFile, bool bSyncMode);
int __declspec(dllexport) ConvertDialogicADPCMtoPCM(const char *lpcSrcFile, const char *lpcDestFile, bool bSyncMode);
int __declspec(dllexport) ConvertGSM2WAV(const char *lpcSrcFile, const char *lpcDestFile, bool bSyncMode);
int __declspec(dllexport) ConvertWAV2GSM(const char *lpcSrcFile, const char *lpcDestFile, bool bSyncMode);
int __declspec(dllexport) ConvertPCMtoIMAADPCM(const char *lpcSrcFile, const char *lpcDestFile, bool bSyncMode);
int __declspec(dllexport) ConvertIMAADPCMtoPCM(const char *lpcSrcFile, const char *lpcDestFile, bool bSyncMode);
int __declspec(dllexport) ConvertPCM8toPCM11(const char *lpcSrcFile, const char *lpcDestFile, bool bSyncMode);
int __declspec(dllexport) ConvertPCM11toPCM8(const char *lpcSrcFile, const char *lpcDestFile, bool bSyncMode);

#endif