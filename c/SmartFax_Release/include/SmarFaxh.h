#ifndef __SMARTFAX_H_
#define __SMARTFAX_H_
#include <tapi.h>
#include <windows.h>
/*
#ifdef  __cplusplus
extern "C" {
#endif
*/


#define BIRTH	1976

typedef  HANDLE SmartFaxObj;


enum EResolution
{        
    RE_FINE,    
    RE_STANDARD
};

enum EClass
{ 
	CLASS_1,
	CLASS_2
};

enum EErrorCorrect
{	
	ECM_DISABLE,
	ECM_ENABLE 
};

enum EBinaryFile
{
	BFT_DISABLE,
	BFT_ENABLE 
};

enum ECreateHead
{ 
	CH_DISABLE,
	CH_ENABLE	
};

enum EUsed2D
{ 
	U2D_DISABLE,
	U2D_ENABLE
};


enum EFaxSpeed
{ 
	FS_2400,
	FS_4800,
	FS_7200,
	FS_9600,
	FS_1200,
	FS_1440,
};



enum EVolume
{ 
	VO_OFF,
	VO_LOW,
	VO_MIDDLE,
	VO_HIGH		
};



typedef struct tag_SFaxParam
{
	HCALL			hCall;
	HLINE			hLine;
	EResolution		Resolution;				// 传真质量(RE_FINE | RE_STARDARD)

	unsigned char	nComPort ;				// 端口号(1 - 256 )

	EFaxSpeed		Speed;					//传真速度 ( 24 | 48 | 72 | 96 | 120 |144)

	EUsed2D			Is2D;					//压缩方式(U2D_ENABLE | U2D_DISABLE)

	EClass			Class;					//传真类型(CLASS_1 | CLASS_2 | CLASS_1.0 | CLASS_2.0)

	EVolume			Volume;				//Modem应答音量( 0 | 1 | 2 | 3 )

	char			FileName[MAX_PATH];		//传真文件名

	char			Identifi[56];			//传真识别符(一般添入自己的传真号码)

	EErrorCorrect	Ecm;					//纠错方式(ECM_ENABLE | ECM_DISABLE )

	HWND			Hwnd;					// 消息窗口句柄

	UINT			Msg;					//消息ID (WM_SMARTFAX)

	SmartFaxObj		*hFax;					//传真对象句柄

	// send extrac parameter
	char			FaxNumber[21];			//传真号码
	
	char			From[128];				//发送者信息

	char			To[128];				//接受者信息
				
	ECreateHead		CreateHead;				//建立传真页眉信息( CH_DISABLE | CH_ENABLE)

	EBinaryFile		BinaryFile;				//两进制文件传输(BFT_DISABLE | BFT_ENABLE )

	int				nStartPage;				//开始页
		
	#if defined(__cplusplus) && !defined(__BORLANDC__)
    //EXPDEF SFaxParam();
	#endif

}SFaxParam;


int TapiSendCMD_(HCALL &hCall,HLINE &hline,const char *strCMD);

/*

WM_FAXANI:				  // 送主叫消息

WM_FAXMONITORCLOSE:       // 监控关闭消息	

WM_FAXMONITORSTART:       // 监控开始消息

WM_FAXUSERCANCE:         //用户取消传真消息

WM_FAXMISSIONINOVER:    // 接收传真结束消息

WM_FAXCHANGESTATE:     // 传真状态改变消息
{
	FAXINIT:	// 初始化状态消息

	DIALFAX:  // 拨号状态消息

	ANSWER:   // 应答状态消息

	NEGOTIATION: //磋商状态消息

	TRAINING:   //训练状态消息
}

WM_FAXSETCIS:    //获得CIS消息
WM_FAXRECVPAGEDATA:  //接收数据消息
WM_ACCEPTPAGE:     //传真页接受消息
WM_REJECTPAGE:    //传真页拒绝消息
WM_FAXSPEED:   //传真速度消息
WM_FAXPAGE:  //传真页数量消息
WM_FAXECM: // ECM 消息
WM_FAXRING: //振铃消息
WM_FAXPROCESSPAGEDATA:   
*/




				  
const unsigned short D1DMR	= 0;		// 1-D Modified Huffman
const unsigned short D2DMR	= 1;		// 2-D Modified Huffman
const unsigned short D2DMMR	= 3;		// 2-D Modified Modified Read





typedef void (CALLBACK * MODEMLISLITNECALLBACK)(DWORD dwDeviceId, const char *sLineName, const char *ComPort,unsigned long lParam);

static void CALLBACK ModemListCallbackFunc(DWORD dwDeviceId, const char *sLineName, const char *ComPort,unsigned long lParam);


static void CALLBACK ModemListCallbackFunc(DWORD dwDevice, const char *sLineName, const char *ComPort,unsigned long lParam)
{
	fprintf(stderr,"DeviceID: %d \nLineName: %s\nCommPort: %s \n",dwDevice,sLineName,ComPort);	
}


/**********************************************************************************
函数名:<GetModemDeviceList>
----------------------------
功能:		获得所有可用Modem列标信息
----------------------------
参数:
	1: lParam		
	2: lpfnCallback  回调函数

************************************************************************************/
bool GetModemDeviceList( unsigned long lParam, MODEMLISLITNECALLBACK lpfnCallback = ModemListCallbackFunc );





/**********************************************************************************
函数名:<ErrorCorrectFaxPage>
----------------------------
功能:		修正传真页
----------------------------
参数:
	1: Input			输入文件名		
	2: Output			输出文件名
	3: CompressionDF	压缩方式

************************************************************************************/


int ErrorCorrectFaxPage(const char *Input,const char*Output,unsigned short CompressionDF = D2DMMR);





long InitFaxTapiCall(HLINE &hLine,HCALL &hCall);
int ModemGetComPort( const char* strName );





/**********************************************************************************
函数名:<AbortPort>
----------------------------
功能:			中断传真操作!
----------------------------
参数:
	1: hFax		传真对象句柄	

************************************************************************************/

int AbortPort(SmartFaxObj *hFax);




/**********************************************************************************
函数名:<SmartFaxMonitorPort>
----------------------------
功能:			监视端口消息!
----------------------------
参数:
	1: hFax		传真对象句柄	
	2: nPort	端口号
	3: hWnd		消息窗口句柄
	4: Msg		消息ID (WM_SMARTFAX)

************************************************************************************/

int SmartFaxMonitorPort(SmartFaxObj *hFax ,unsigned char nPort,HWND hWnd,UINT Msg);






/**********************************************************************************
函数名:<TapiSmartReceiveFax>
----------------------------
功能:			通过TAPI接口接收传真!
----------------------------
参数:
	1: FaxParam		传真参数 (见SFaxParam定义)	
	
************************************************************************************/

int TapiSmartReceiveFax(int nAdd,const char* strAdd ,SFaxParam *FaxParam);








/**********************************************************************************
函数名:<_TapiSmartReceiveFax>
----------------------------
功能:			通过TAPI接口接收传真!
----------------------------
参数:
	1:	hFax			传真对象句柄	
	2:	hCall			传真参数
	3:	hline			传真参数
	4:	FileName		传真文件名
	5:	Identifi		传真识别符(一般添入自己的传真号码)
	6:	Volume			Modem应答音量( 0 | 1 | 2 | 3 )
	7:	Speed			传真需要的速度( 24 | 48 | 72 | 96 | 120 |144) 
	8:	Class			传真类型(CLASS_1 | CLASS_2 | CLASS_1.0 | CLASS_2.0)
	9:	Is2d			压缩方式(U2D_ENABLE | U2D_DISABLE) 
	10: ECM				纠错方式(ECM_ENABLE | ECM_DISABLE )
	11: hWnd			消息窗口句柄
	1:  Msg				消息ID (WM_SMARTFAX)
	

	

返回值:
  
	0:	    End if function completes successfully
	-1:     Exception error	
	101:    Failed to Open FAX file ~
	102:    Couldn't conneced  within 35 secs of ATA command
	103:	Resevr
	104:    Failed to send CSI frames 
	105:    Failed to send DIS frames 
	106:    Failed to send NFS frames 
	107:    Failed to send other negotiating frames
	108:    Failed to send CFR frames
	109:    Failed to training
	110:    Failed to send FTT frames
	111:    Failed to set training speed  3 times
	112:    Failed to send CRP frames
	113:    Failed to dropped carrier within 5 s 
	114:    Failed to respond to +FRM properly
	115:    Failed to get modem data
	116:    Failed to accept page data
  	201:	Couldn't be found transmit file 
	202:	Transmit file isn't TIFF CLASS
	203:	Call isn't answered within 30 s
	204:	Machine can't receive fax data
	205:	Couldn't set +FTM
	206:	Couldn't set +FTM
	210:	NO DIALTONE
	211:	BUSY
	212:	NO ANSWER
	213:	NO CARRIER

************************************************************************************/

int _TapiSmartReceiveFax(SmartFaxObj *hFax ,HCALL &hCall,HLINE &hline,const char *FileName, \
						 const char *Identifi,EVolume Volume ,EFaxSpeed Speed,\
						 EClass Class,EUsed2D Is2d,EErrorCorrect ECM,HWND hWnd,UINT Msg);








/**********************************************************************************
函数名:<TapiSmartSendFax>
----------------------------
功能:			通过TAPI接口发送传真!
----------------------------
参数:
	1: FaxParam		传真参数 (见SFaxParam定义)		
	
************************************************************************************/

int TapiSmartSendFax(int nAdd,const char* strAdd ,SFaxParam *FaxParam);











/**********************************************************************************
函数名:<_TapiSmartSendFax>
----------------------------
功能:			通过TAPI接口发送传真!
----------------------------
参数:
	1:	hFax			传真对象句柄	
	2:	hCall			传真参数
	3:	hline			传真参数
	4:	FileName		传真文件名
	5:	Identifi		传真识别符(一般添入自己的传真号码)
	6:	Volume			Modem应答音量( 0 | 1 | 2 | 3 )
	7:	Speed			传真需要的速度( 24 | 48 | 72 | 96 | 120 |144) 
	8:	Class			传真类型(CLASS_1 | CLASS_2 | CLASS_1.0 | CLASS_2.0)
	9:	Is2d			压缩方式(U2D_ENABLE | U2D_DISABLE) 
	10: ECM				纠错方式(ECM_ENABLE | ECM_DISABLE )
	11: CreateHead		建立传真页眉信息
	12: Resolution		传真质量
	13: From			发送者
	14: To				接受者
	15: hWnd			消息窗口句柄
	16: Msg				消息ID (WM_SMARTFAX)

返回值:
  
	0:	    End if function completes successfully
	-1:     Exception error	
	101:    Failed to Open FAX file ~
	102:    Couldn't conneced  within 35 secs of ATA command
	103:	Resevr
	104:    Failed to send CSI frames 
	105:    Failed to send DIS frames 
	106:    Failed to send NFS frames 
	107:    Failed to send other negotiating frames
	108:    Failed to send CFR frames
	109:    Failed to training
	110:    Failed to send FTT frames
	111:    Failed to set training speed  3 times
	112:    Failed to send CRP frames
	113:    Failed to dropped carrier within 5 s 
	114:    Failed to respond to +FRM properly
	115:    Failed to get modem data
	116:    Failed to accept page data
  	201:	Couldn't be found transmit file 
	202:	Transmit file isn't TIFF CLASS
	203:	Call isn't answered within 30 s
	204:	Machine can't receive fax data
	205:	Couldn't set +FTM
	206:	Couldn't set +FTM
	210:	NO DIALTONE
	211:	BUSY
	212:	NO ANSWER
	213:	NO CARRIER

	
************************************************************************************/

int _TapiSmartSendFax(SmartFaxObj *hFax ,HCALL &hCall,HLINE &hline,const char *Tel,const char *FileName,
					  const char *Identifi,EVolume Volume ,EFaxSpeed Speed,EClass Class,EUsed2D Is2d,
					  EErrorCorrect ECM,ECreateHead CreateHead,EResolution Resolution,
					  const char * From ,const char * Receiver,HWND hWnd,UINT Msg,int nStartPage);




/**********************************************************************************
函数名:	<SmartReceiveFax>
----------------------------
功能:	直接通过端口接收传真
----------------------------
参数:
	1: FaxParam		传真参数 (见SFaxParam定义)		
	
************************************************************************************/
int SmartReceiveFax(int nAdd,const char* strAdd ,SFaxParam *FaxParam);
//int SmartReceiveFax(SFaxParam *FaxParam);




/**********************************************************************************
函数名:<_SmartReceiveFax>
----------------------------
功能:	直接通过端口接收传真
----------------------------
参数:
	1:	hFax			传真对象句柄	
	2:	nPort			端口号	
	3:	FileName		传真文件名
	4:	Identifi		传真识别符(一般添入自己的传真号码)
	5:	Volume			Modem应答音量( 0 | 1 | 2 | 3 )
	6:	Speed			传真需要的速度( 24 | 48 | 72 | 96 | 120 |144) 
	7:	Class			传真类型(CLASS_1 | CLASS_2 | CLASS_1.0 | CLASS_2.0)
	8:	Is2d			压缩方式(U2D_ENABLE | U2D_DISABLE) 
	9:  ECM				纠错方式(ECM_ENABLE | ECM_DISABLE )	
	10: hWnd			消息窗口句柄
	11: Msg				消息ID (WM_SMARTFAX)
	
************************************************************************************/

int _SmartReceiveFax(SmartFaxObj *hFax  ,unsigned char nPort  ,const char *FaxFileName , 
					 const char *Identifi,EVolume Volume = VO_LOW,  EFaxSpeed Speed =FS_1440,					 
					 EClass Class = CLASS_1 ,EUsed2D Is2d = U2D_ENABLE ,EErrorCorrect ECM = ECM_ENABLE,
					 HWND hWnd = NULL ,UINT Msg = NULL);



/**********************************************************************************
函数名:_SmartReceiveFax
功能:接收传真文件
参数:
	1: nPort		端口号	
	2: FaxFileName	传真文件名
	3: Identifi     传真识别符(一般添入自己的传真号码)
	4: Speed		传真需要的速度(default 96) 
	5: Fclass		CLASS TYPE (defualt Class 1)
	6: Twodee		压缩方式(0 - 1D,1 - 2D defaul 1 ) 
	7: ECM			纠错方式(defaul 1)
	8: hWnd			接受传真消息的窗口句柄
	9: Msg			传真消息

返回值:

    0:	    End if function completes successfully
	-1:     Exception error	
	101:    Failed to Open FAX file ~
	102:    Couldn't conneced  within 35 secs of ATA command
	103:	Resevr
	104:    Failed to send CSI frames 
	105:    Failed to send DIS frames 
	106:    Failed to send NFS frames 
	107:    Failed to send other negotiating frames
	108:    Failed to send CFR frames
	109:    Failed to training
	110:    Failed to send FTT frames
	111:    Failed to set training speed  3 times
	112:    Failed to send CRP frames
	113:    Failed to dropped carrier within 5 s 
	114:    Failed to respond to +FRM properly
	115:    Failed to get modem data
	116:    Failed to accept page data
  	201:	Couldn't be found transmit file 
	202:	Transmit file isn't TIFF CLASS
	203:	Call isn't answered within 30 s
	204:	Machine can't receive fax data
	205:	Couldn't set +FTM
	206:	Couldn't set +FTM
	210:	NO DIALTONE
	211:	BUSY
	212:	NO ANSWER
	213:	NO CARRIER


*******************************************************************************/






/**********************************************************************************
函数名:	<SmartSendFax>
----------------------------
功能:	直接通过端口接收传真
----------------------------
参数:
	1: FaxParam		传真参数 (见SFaxParam定义)		
	
************************************************************************************/
int SmartSendFax(int nAdd,const char* strAdd ,SFaxParam *FaxParam);
//int SmartSendFax(SFaxParam *FaxParam);



/**********************************************************************************
函数名:<_SmartSendFax>
----------------------------
功能:	直接通过端口发送传真
----------------------------
参数:
	1:	hFax			传真对象句柄	
	2:	nPort			端口号		
	3:	FileName		传真文件名
	4:	Identifi		传真识别符(一般添入自己的传真号码)
	5:	Volume			Modem应答音量( 0 | 1 | 2 | 3 )
	6:	Speed			传真需要的速度( 24 | 48 | 72 | 96 | 120 |144) 
	7:	Class			传真类型(CLASS_1 | CLASS_2 | CLASS_1.0 | CLASS_2.0)
	8:	Is2d			压缩方式(U2D_ENABLE | U2D_DISABLE) 
	9:  ECM				纠错方式(ECM_ENABLE | ECM_DISABLE )
	10: CreateHead		建立传真页眉信息
	11: Resolution		传真质量
	12: From			发送者
	13: To				接受者
	14: hWnd			消息窗口句柄
	15: Msg				消息ID (WM_SMARTFAX)

	
************************************************************************************/

int _SmartSendFax(SmartFaxObj *hFax ,unsigned char nPort,const char *Tel,
				  const char *FaxFileName, const char *Identifi,EVolume Volume ,EFaxSpeed Speed,
				  EUsed2D Is2d,EErrorCorrect ECM,ECreateHead CreateHead,EResolution Resolution,
				  const char * From ,const char * Receiver,HWND hWnd,UINT Msg,int nStartPage);

/**********************************************************************************
函数名:SmartSendFax
功能:发送传真文件
参数:
	1: nPort		端口号
	2: Tel			接受端号码
	3: FaxFileName	传真文件名
	4: Identifi     传真识别符(一般添入自己的传真号码)
	5: Speed		传真需要的速度(default 96) 
	6: Fclass		CLASS TYPE (defualt Class 1)
	7: Twodee		压缩方式(0 - 1D,1 - 2D defaul 1 ) 
	8: ECM			纠错方式(defaul 1)
	9: hWnd			接受传真消息的窗口句柄
	9: Msg			传真消息

返回值:

    0:	    End if function completes successfully
	-1:     Exception error	
	101:    Failed to Open FAX file ~
	102:    Couldn't conneced  within 35 secs of ATA command
	103:	Resevr
	104:    Failed to send CSI frames 
	105:    Failed to send DIS frames 
	106:    Failed to send NFS frames 
	107:    Failed to send other negotiating frames
	108:    Failed to send CFR frames
	109:    Failed to training
	110:    Failed to send FTT frames
	111:    Failed to set training speed  3 times
	112:    Failed to send CRP frames
	113:    Failed to dropped carrier within 5 s 
	114:    Failed to respond to +FRM properly
	115:    Failed to get modem data
	116:    Failed to accept page data
  	201:	Couldn't be found transmit file 
	202:	Transmit file isn't TIFF CLASS
	203:	Call isn't answered within 30 s
	204:	Machine can't receive fax data
	205:	Couldn't set +FTM
	206:	Couldn't set +FTM
	210:	NO DIALTONE
	211:	BUSY
	212:	NO ANSWER
	213:	NO CARRIER

*******************************************************************************/




	
// fax message for windows 

#define WM_SMARTFAX				WM_USER+101


#define WM_FAXMISSIONINOVER		0x101
#define WM_FAXCHANGESTATE		0x102
#define WM_FAXSETCIS			0x103
#define WM_FAXSETSPEED			0x104
#define WM_FAXMISSIONOUTOVER	0x105
#define WM_FAXRECVPAGEDATA		0x106
#define WM_FAXSENDPAGEDATA		0x107
#define WM_ACCEPTPAGE			0x108
#define WM_REJECTPAGE			0x109
#define WM_FAXSPEED				0x110
#define WM_FAXPROCESSPAGEDATA	0x111
#define WM_FAXUSERCANCE			0x112
#define WM_FAXECM				0x113
#define WM_FAXPAGE				0x114

#define WM_FAXRING				0x115

#define WM_FAXMONITORCLOSE		0x116
#define WM_FAXMONITORSTART		0x117
#define WM_FAXMONITORFAIL		0x118

#define WM_FAXANI				0x119


#define FAXINIT					0
#define DIALFAX					1
#define ANSWER					2
#define NEGOTIATION				3
#define TRAINING				4



/*

#ifdef  __cplusplus
}
#endif
*/














#endif //__SMARTFAX_H_