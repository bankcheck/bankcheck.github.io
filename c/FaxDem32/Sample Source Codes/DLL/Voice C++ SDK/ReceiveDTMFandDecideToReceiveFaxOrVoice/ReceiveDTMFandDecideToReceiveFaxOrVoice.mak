# Microsoft Developer Studio Generated NMAKE File, Based on ReceiveDTMFandDecideToReceiveFaxOrVoice.dsp
!IF "$(CFG)" == ""
CFG=ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug
!MESSAGE No configuration specified. Defaulting to ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release" && "$(CFG)" != "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "ReceiveDTMFandDecideToReceiveFaxOrVoice.mak" CFG="ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.exe"


CLEAN :
	-@erase "$(INTDIR)\BrookOpen.obj"
	-@erase "$(INTDIR)\DialogicOpen.obj"
	-@erase "$(INTDIR)\DlgWaitForDTMF.obj"
	-@erase "$(INTDIR)\HelpDialog.obj"
	-@erase "$(INTDIR)\NMSOpen.obj"
	-@erase "$(INTDIR)\OpenComPort.obj"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.obj"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.res"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\VoiceFormats.obj"
	-@erase "$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x40e /fo"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib voice.lib codec.lib bitiff.lib bidib.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pdb" /machine:I386 /out:"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.exe" /libpath:"..\..\..\Lib" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BrookOpen.obj" \
	"$(INTDIR)\DialogicOpen.obj" \
	"$(INTDIR)\DlgWaitForDTMF.obj" \
	"$(INTDIR)\HelpDialog.obj" \
	"$(INTDIR)\NMSOpen.obj" \
	"$(INTDIR)\OpenComPort.obj" \
	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.obj" \
	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\VoiceFormats.obj" \
	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.res"

"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.exe" "$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.bsc"


CLEAN :
	-@erase "$(INTDIR)\BrookOpen.obj"
	-@erase "$(INTDIR)\BrookOpen.sbr"
	-@erase "$(INTDIR)\DialogicOpen.obj"
	-@erase "$(INTDIR)\DialogicOpen.sbr"
	-@erase "$(INTDIR)\DlgWaitForDTMF.obj"
	-@erase "$(INTDIR)\DlgWaitForDTMF.sbr"
	-@erase "$(INTDIR)\HelpDialog.obj"
	-@erase "$(INTDIR)\HelpDialog.sbr"
	-@erase "$(INTDIR)\NMSOpen.obj"
	-@erase "$(INTDIR)\NMSOpen.sbr"
	-@erase "$(INTDIR)\OpenComPort.obj"
	-@erase "$(INTDIR)\OpenComPort.sbr"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.obj"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.res"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.sbr"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.obj"
	-@erase "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\VoiceFormats.obj"
	-@erase "$(INTDIR)\VoiceFormats.sbr"
	-@erase "$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.bsc"
	-@erase "$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.exe"
	-@erase "$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.ilk"
	-@erase "$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x40e /fo"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BrookOpen.sbr" \
	"$(INTDIR)\DialogicOpen.sbr" \
	"$(INTDIR)\DlgWaitForDTMF.sbr" \
	"$(INTDIR)\HelpDialog.sbr" \
	"$(INTDIR)\NMSOpen.sbr" \
	"$(INTDIR)\OpenComPort.sbr" \
	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.sbr" \
	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr" \
	"$(INTDIR)\VoiceFormats.sbr"

"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib voice.lib codec.lib bitiff.lib bidib.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pdb" /debug /machine:I386 /out:"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.exe" /pdbtype:sept /libpath:"..\..\..\Lib" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BrookOpen.obj" \
	"$(INTDIR)\DialogicOpen.obj" \
	"$(INTDIR)\DlgWaitForDTMF.obj" \
	"$(INTDIR)\HelpDialog.obj" \
	"$(INTDIR)\NMSOpen.obj" \
	"$(INTDIR)\OpenComPort.obj" \
	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.obj" \
	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\VoiceFormats.obj" \
	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.res"

"$(OUTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("ReceiveDTMFandDecideToReceiveFaxOrVoice.dep")
!INCLUDE "ReceiveDTMFandDecideToReceiveFaxOrVoice.dep"
!ELSE 
!MESSAGE Warning: cannot find "ReceiveDTMFandDecideToReceiveFaxOrVoice.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release" || "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"
SOURCE=.\BrookOpen.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\BrookOpen.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\BrookOpen.obj"	"$(INTDIR)\BrookOpen.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 

SOURCE=.\DialogicOpen.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\DialogicOpen.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\DialogicOpen.obj"	"$(INTDIR)\DialogicOpen.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 

SOURCE=.\DlgWaitForDTMF.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\DlgWaitForDTMF.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\DlgWaitForDTMF.obj"	"$(INTDIR)\DlgWaitForDTMF.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 

SOURCE=.\HelpDialog.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\HelpDialog.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\HelpDialog.obj"	"$(INTDIR)\HelpDialog.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 

SOURCE=.\NMSOpen.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\NMSOpen.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\NMSOpen.obj"	"$(INTDIR)\NMSOpen.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 

SOURCE=.\OpenComPort.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\OpenComPort.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\OpenComPort.obj"	"$(INTDIR)\OpenComPort.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 

SOURCE=.\ReceiveDTMFandDecideToReceiveFaxOrVoice.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.obj"	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 

SOURCE=.\ReceiveDTMFandDecideToReceiveFaxOrVoice.rc

"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.obj"	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=.\VoiceFormats.cpp

!IF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Release"


"$(INTDIR)\VoiceFormats.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ELSEIF  "$(CFG)" == "ReceiveDTMFandDecideToReceiveFaxOrVoice - Win32 Debug"


"$(INTDIR)\VoiceFormats.obj"	"$(INTDIR)\VoiceFormats.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveDTMFandDecideToReceiveFaxOrVoice.pch"


!ENDIF 


!ENDIF 

