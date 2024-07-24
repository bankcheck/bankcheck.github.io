# Microsoft Developer Studio Generated NMAKE File, Based on Interactive Voice Sample.dsp
!IF "$(CFG)" == ""
CFG=Interactive Voice Sample - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Interactive Voice Sample - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Interactive Voice Sample - Win32 Release" && "$(CFG)" != "Interactive Voice Sample - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Interactive Voice Sample.mak" CFG="Interactive Voice Sample - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Interactive Voice Sample - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Interactive Voice Sample - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Interactive Voice Sample - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\Interactive Voice Sample.exe" "$(OUTDIR)\Interactive Voice Sample.pch" "$(OUTDIR)\Interactive Voice Sample.bsc"


CLEAN :
	-@erase "$(INTDIR)\BrookOpen.obj"
	-@erase "$(INTDIR)\BrookOpen.sbr"
	-@erase "$(INTDIR)\CINPDLG.OBJ"
	-@erase "$(INTDIR)\CINPDLG.SBR"
	-@erase "$(INTDIR)\DetectTone.obj"
	-@erase "$(INTDIR)\DetectTone.sbr"
	-@erase "$(INTDIR)\DialogicOpen.obj"
	-@erase "$(INTDIR)\DialogicOpen.sbr"
	-@erase "$(INTDIR)\DlgGenerateTone.obj"
	-@erase "$(INTDIR)\DlgGenerateTone.sbr"
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\DlgHelp.sbr"
	-@erase "$(INTDIR)\DlgSelectMsg.obj"
	-@erase "$(INTDIR)\DlgSelectMsg.sbr"
	-@erase "$(INTDIR)\DlgWaitForDTMF.obj"
	-@erase "$(INTDIR)\DlgWaitForDTMF.sbr"
	-@erase "$(INTDIR)\HOLMES.OBJ"
	-@erase "$(INTDIR)\HOLMES.SBR"
	-@erase "$(INTDIR)\Interactive Voice Sample.obj"
	-@erase "$(INTDIR)\Interactive Voice Sample.pch"
	-@erase "$(INTDIR)\Interactive Voice Sample.res"
	-@erase "$(INTDIR)\Interactive Voice Sample.sbr"
	-@erase "$(INTDIR)\Interactive Voice SampleDlg.obj"
	-@erase "$(INTDIR)\Interactive Voice SampleDlg.sbr"
	-@erase "$(INTDIR)\NMSOPEN.OBJ"
	-@erase "$(INTDIR)\NMSOPEN.SBR"
	-@erase "$(INTDIR)\OpenComPort.obj"
	-@erase "$(INTDIR)\OpenComPort.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\TRANSFER.OBJ"
	-@erase "$(INTDIR)\TRANSFER.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\VoiceFormats.obj"
	-@erase "$(INTDIR)\VoiceFormats.sbr"
	-@erase "$(OUTDIR)\Interactive Voice Sample.bsc"
	-@erase "$(OUTDIR)\Interactive Voice Sample.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MD /W3 /GX /Od /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Interactive Voice Sample.pch" /YX"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /o /win32 "NUL" 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Interactive Voice Sample.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Interactive Voice Sample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BrookOpen.sbr" \
	"$(INTDIR)\CINPDLG.SBR" \
	"$(INTDIR)\DetectTone.sbr" \
	"$(INTDIR)\DialogicOpen.sbr" \
	"$(INTDIR)\DlgGenerateTone.sbr" \
	"$(INTDIR)\DlgHelp.sbr" \
	"$(INTDIR)\DlgSelectMsg.sbr" \
	"$(INTDIR)\DlgWaitForDTMF.sbr" \
	"$(INTDIR)\HOLMES.SBR" \
	"$(INTDIR)\Interactive Voice Sample.sbr" \
	"$(INTDIR)\Interactive Voice SampleDlg.sbr" \
	"$(INTDIR)\NMSOPEN.SBR" \
	"$(INTDIR)\OpenComPort.sbr" \
	"$(INTDIR)\StdAfx.sbr" \
	"$(INTDIR)\TRANSFER.SBR" \
	"$(INTDIR)\VoiceFormats.sbr"

"$(OUTDIR)\Interactive Voice Sample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib voice.lib codec.lib bitiff.lib bidib.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Interactive Voice Sample.pdb" /machine:I386 /out:"$(OUTDIR)\Interactive Voice Sample.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BrookOpen.obj" \
	"$(INTDIR)\CINPDLG.OBJ" \
	"$(INTDIR)\DetectTone.obj" \
	"$(INTDIR)\DialogicOpen.obj" \
	"$(INTDIR)\DlgGenerateTone.obj" \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\DlgSelectMsg.obj" \
	"$(INTDIR)\DlgWaitForDTMF.obj" \
	"$(INTDIR)\HOLMES.OBJ" \
	"$(INTDIR)\Interactive Voice Sample.obj" \
	"$(INTDIR)\Interactive Voice SampleDlg.obj" \
	"$(INTDIR)\NMSOPEN.OBJ" \
	"$(INTDIR)\OpenComPort.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\TRANSFER.OBJ" \
	"$(INTDIR)\VoiceFormats.obj" \
	"$(INTDIR)\Interactive Voice Sample.res"

"$(OUTDIR)\Interactive Voice Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Interactive Voice Sample - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\Interactive Voice Sample.exe" "$(OUTDIR)\Interactive Voice Sample.bsc"


CLEAN :
	-@erase "$(INTDIR)\BrookOpen.obj"
	-@erase "$(INTDIR)\BrookOpen.sbr"
	-@erase "$(INTDIR)\CINPDLG.OBJ"
	-@erase "$(INTDIR)\CINPDLG.SBR"
	-@erase "$(INTDIR)\DetectTone.obj"
	-@erase "$(INTDIR)\DetectTone.sbr"
	-@erase "$(INTDIR)\DialogicOpen.obj"
	-@erase "$(INTDIR)\DialogicOpen.sbr"
	-@erase "$(INTDIR)\DlgGenerateTone.obj"
	-@erase "$(INTDIR)\DlgGenerateTone.sbr"
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\DlgHelp.sbr"
	-@erase "$(INTDIR)\DlgSelectMsg.obj"
	-@erase "$(INTDIR)\DlgSelectMsg.sbr"
	-@erase "$(INTDIR)\DlgWaitForDTMF.obj"
	-@erase "$(INTDIR)\DlgWaitForDTMF.sbr"
	-@erase "$(INTDIR)\HOLMES.OBJ"
	-@erase "$(INTDIR)\HOLMES.SBR"
	-@erase "$(INTDIR)\Interactive Voice Sample.obj"
	-@erase "$(INTDIR)\Interactive Voice Sample.pch"
	-@erase "$(INTDIR)\Interactive Voice Sample.res"
	-@erase "$(INTDIR)\Interactive Voice Sample.sbr"
	-@erase "$(INTDIR)\Interactive Voice SampleDlg.obj"
	-@erase "$(INTDIR)\Interactive Voice SampleDlg.sbr"
	-@erase "$(INTDIR)\NMSOPEN.OBJ"
	-@erase "$(INTDIR)\NMSOPEN.SBR"
	-@erase "$(INTDIR)\OpenComPort.obj"
	-@erase "$(INTDIR)\OpenComPort.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\TRANSFER.OBJ"
	-@erase "$(INTDIR)\TRANSFER.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\VoiceFormats.obj"
	-@erase "$(INTDIR)\VoiceFormats.sbr"
	-@erase "$(OUTDIR)\Interactive Voice Sample.bsc"
	-@erase "$(OUTDIR)\Interactive Voice Sample.exe"
	-@erase "$(OUTDIR)\Interactive Voice Sample.ilk"
	-@erase "$(OUTDIR)\Interactive Voice Sample.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MDd /W3 /GX /ZI /Od /I "..\..\..\inc" /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Interactive Voice Sample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /o /win32 "NUL" 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Interactive Voice Sample.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Interactive Voice Sample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BrookOpen.sbr" \
	"$(INTDIR)\CINPDLG.SBR" \
	"$(INTDIR)\DetectTone.sbr" \
	"$(INTDIR)\DialogicOpen.sbr" \
	"$(INTDIR)\DlgGenerateTone.sbr" \
	"$(INTDIR)\DlgHelp.sbr" \
	"$(INTDIR)\DlgSelectMsg.sbr" \
	"$(INTDIR)\DlgWaitForDTMF.sbr" \
	"$(INTDIR)\HOLMES.SBR" \
	"$(INTDIR)\Interactive Voice Sample.sbr" \
	"$(INTDIR)\Interactive Voice SampleDlg.sbr" \
	"$(INTDIR)\NMSOPEN.SBR" \
	"$(INTDIR)\OpenComPort.sbr" \
	"$(INTDIR)\StdAfx.sbr" \
	"$(INTDIR)\TRANSFER.SBR" \
	"$(INTDIR)\VoiceFormats.sbr"

"$(OUTDIR)\Interactive Voice Sample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib voice.lib codec.lib bitiff.lib bidib.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\Interactive Voice Sample.pdb" /debug /machine:I386 /out:"$(OUTDIR)\Interactive Voice Sample.exe" /pdbtype:sept /libpath:"..\..\..\Lib" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BrookOpen.obj" \
	"$(INTDIR)\CINPDLG.OBJ" \
	"$(INTDIR)\DetectTone.obj" \
	"$(INTDIR)\DialogicOpen.obj" \
	"$(INTDIR)\DlgGenerateTone.obj" \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\DlgSelectMsg.obj" \
	"$(INTDIR)\DlgWaitForDTMF.obj" \
	"$(INTDIR)\HOLMES.OBJ" \
	"$(INTDIR)\Interactive Voice Sample.obj" \
	"$(INTDIR)\Interactive Voice SampleDlg.obj" \
	"$(INTDIR)\NMSOPEN.OBJ" \
	"$(INTDIR)\OpenComPort.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\TRANSFER.OBJ" \
	"$(INTDIR)\VoiceFormats.obj" \
	"$(INTDIR)\Interactive Voice Sample.res"

"$(OUTDIR)\Interactive Voice Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Interactive Voice Sample.dep")
!INCLUDE "Interactive Voice Sample.dep"
!ELSE 
!MESSAGE Warning: cannot find "Interactive Voice Sample.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Interactive Voice Sample - Win32 Release" || "$(CFG)" == "Interactive Voice Sample - Win32 Debug"
SOURCE=.\BrookOpen.cpp

"$(INTDIR)\BrookOpen.obj"	"$(INTDIR)\BrookOpen.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\CINPDLG.CPP

"$(INTDIR)\CINPDLG.OBJ"	"$(INTDIR)\CINPDLG.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DetectTone.cpp

"$(INTDIR)\DetectTone.obj"	"$(INTDIR)\DetectTone.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DialogicOpen.cpp

"$(INTDIR)\DialogicOpen.obj"	"$(INTDIR)\DialogicOpen.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DlgGenerateTone.CPP

"$(INTDIR)\DlgGenerateTone.obj"	"$(INTDIR)\DlgGenerateTone.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DlgHelp.cpp

"$(INTDIR)\DlgHelp.obj"	"$(INTDIR)\DlgHelp.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DlgSelectMsg.cpp

"$(INTDIR)\DlgSelectMsg.obj"	"$(INTDIR)\DlgSelectMsg.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\DlgWaitForDTMF.cpp

"$(INTDIR)\DlgWaitForDTMF.obj"	"$(INTDIR)\DlgWaitForDTMF.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\HOLMES.CPP

"$(INTDIR)\HOLMES.OBJ"	"$(INTDIR)\HOLMES.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=".\Interactive Voice Sample.cpp"

"$(INTDIR)\Interactive Voice Sample.obj"	"$(INTDIR)\Interactive Voice Sample.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=".\Interactive Voice Sample.rc"

"$(INTDIR)\Interactive Voice Sample.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=".\Interactive Voice SampleDlg.cpp"

"$(INTDIR)\Interactive Voice SampleDlg.obj"	"$(INTDIR)\Interactive Voice SampleDlg.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\NMSOPEN.CPP

"$(INTDIR)\NMSOPEN.OBJ"	"$(INTDIR)\NMSOPEN.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\OpenComPort.cpp

"$(INTDIR)\OpenComPort.obj"	"$(INTDIR)\OpenComPort.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "Interactive Voice Sample - Win32 Release"

CPP_SWITCHES=/nologo /Zp1 /MD /W3 /GX /Od /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Interactive Voice Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\Interactive Voice Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "Interactive Voice Sample - Win32 Debug"

CPP_SWITCHES=/nologo /Zp1 /MDd /W3 /GX /ZI /Od /I "..\..\..\inc" /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Interactive Voice Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\Interactive Voice Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=.\TRANSFER.CPP

"$(INTDIR)\TRANSFER.OBJ"	"$(INTDIR)\TRANSFER.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\VoiceFormats.cpp

"$(INTDIR)\VoiceFormats.obj"	"$(INTDIR)\VoiceFormats.sbr" : $(SOURCE) "$(INTDIR)"



!ENDIF 

