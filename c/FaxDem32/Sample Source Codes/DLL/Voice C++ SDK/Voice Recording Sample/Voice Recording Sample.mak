# Microsoft Developer Studio Generated NMAKE File, Based on Voice Recording Sample.dsp
!IF "$(CFG)" == ""
CFG=Voice Recording Sample - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Voice Recording Sample - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Voice Recording Sample - Win32 Release" && "$(CFG)" != "Voice Recording Sample - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Voice Recording Sample.mak" CFG="Voice Recording Sample - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Voice Recording Sample - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Voice Recording Sample - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Voice Recording Sample - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\Voice Recording Sample.exe" "$(OUTDIR)\Voice Recording Sample.pch"


CLEAN :
	-@erase "$(INTDIR)\CINPDLG.OBJ"
	-@erase "$(INTDIR)\DlgMessage.obj"
	-@erase "$(INTDIR)\HOLMES.OBJ"
	-@erase "$(INTDIR)\OpenComPort.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\Voice Recording Sample.obj"
	-@erase "$(INTDIR)\Voice Recording Sample.pch"
	-@erase "$(INTDIR)\Voice Recording Sample.res"
	-@erase "$(INTDIR)\Voice Recording SampleDlg.obj"
	-@erase "$(OUTDIR)\Voice Recording Sample.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MD /W3 /GX /Od /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Fp"$(INTDIR)\Voice Recording Sample.pch" /YX"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Voice Recording Sample.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Voice Recording Sample.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib codec.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Voice Recording Sample.pdb" /machine:I386 /out:"$(OUTDIR)\Voice Recording Sample.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\CINPDLG.OBJ" \
	"$(INTDIR)\DlgMessage.obj" \
	"$(INTDIR)\HOLMES.OBJ" \
	"$(INTDIR)\OpenComPort.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\Voice Recording Sample.obj" \
	"$(INTDIR)\Voice Recording SampleDlg.obj" \
	"$(INTDIR)\Voice Recording Sample.res"

"$(OUTDIR)\Voice Recording Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Voice Recording Sample - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\Voice Recording Sample.exe" "$(OUTDIR)\Voice Recording Sample.pch" "$(OUTDIR)\Voice Recording Sample.bsc"


CLEAN :
	-@erase "$(INTDIR)\CINPDLG.OBJ"
	-@erase "$(INTDIR)\CINPDLG.SBR"
	-@erase "$(INTDIR)\DlgMessage.obj"
	-@erase "$(INTDIR)\DlgMessage.sbr"
	-@erase "$(INTDIR)\HOLMES.OBJ"
	-@erase "$(INTDIR)\HOLMES.SBR"
	-@erase "$(INTDIR)\OpenComPort.obj"
	-@erase "$(INTDIR)\OpenComPort.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\Voice Recording Sample.obj"
	-@erase "$(INTDIR)\Voice Recording Sample.pch"
	-@erase "$(INTDIR)\Voice Recording Sample.res"
	-@erase "$(INTDIR)\Voice Recording Sample.sbr"
	-@erase "$(INTDIR)\Voice Recording SampleDlg.obj"
	-@erase "$(INTDIR)\Voice Recording SampleDlg.sbr"
	-@erase "$(OUTDIR)\Voice Recording Sample.bsc"
	-@erase "$(OUTDIR)\Voice Recording Sample.exe"
	-@erase "$(OUTDIR)\Voice Recording Sample.ilk"
	-@erase "$(OUTDIR)\Voice Recording Sample.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MDd /W3 /Gm /Gi /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Voice Recording Sample.pch" /YX"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Voice Recording Sample.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Voice Recording Sample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\CINPDLG.SBR" \
	"$(INTDIR)\DlgMessage.sbr" \
	"$(INTDIR)\HOLMES.SBR" \
	"$(INTDIR)\OpenComPort.sbr" \
	"$(INTDIR)\StdAfx.sbr" \
	"$(INTDIR)\Voice Recording Sample.sbr" \
	"$(INTDIR)\Voice Recording SampleDlg.sbr"

"$(OUTDIR)\Voice Recording Sample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=voice.lib codec.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\Voice Recording Sample.pdb" /debug /machine:I386 /out:"$(OUTDIR)\Voice Recording Sample.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\CINPDLG.OBJ" \
	"$(INTDIR)\DlgMessage.obj" \
	"$(INTDIR)\HOLMES.OBJ" \
	"$(INTDIR)\OpenComPort.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\Voice Recording Sample.obj" \
	"$(INTDIR)\Voice Recording SampleDlg.obj" \
	"$(INTDIR)\Voice Recording Sample.res"

"$(OUTDIR)\Voice Recording Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Voice Recording Sample.dep")
!INCLUDE "Voice Recording Sample.dep"
!ELSE 
!MESSAGE Warning: cannot find "Voice Recording Sample.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Voice Recording Sample - Win32 Release" || "$(CFG)" == "Voice Recording Sample - Win32 Debug"
SOURCE=.\CINPDLG.CPP

!IF  "$(CFG)" == "Voice Recording Sample - Win32 Release"


"$(INTDIR)\CINPDLG.OBJ" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Recording Sample - Win32 Debug"


"$(INTDIR)\CINPDLG.OBJ"	"$(INTDIR)\CINPDLG.SBR" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\DlgMessage.cpp

!IF  "$(CFG)" == "Voice Recording Sample - Win32 Release"


"$(INTDIR)\DlgMessage.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Recording Sample - Win32 Debug"


"$(INTDIR)\DlgMessage.obj"	"$(INTDIR)\DlgMessage.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\HOLMES.CPP

!IF  "$(CFG)" == "Voice Recording Sample - Win32 Release"


"$(INTDIR)\HOLMES.OBJ" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Recording Sample - Win32 Debug"


"$(INTDIR)\HOLMES.OBJ"	"$(INTDIR)\HOLMES.SBR" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\OpenComPort.cpp

!IF  "$(CFG)" == "Voice Recording Sample - Win32 Release"


"$(INTDIR)\OpenComPort.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Recording Sample - Win32 Debug"


"$(INTDIR)\OpenComPort.obj"	"$(INTDIR)\OpenComPort.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "Voice Recording Sample - Win32 Release"

CPP_SWITCHES=/nologo /Zp1 /MD /W3 /GX /Od /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Fp"$(INTDIR)\Voice Recording Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\Voice Recording Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "Voice Recording Sample - Win32 Debug"

CPP_SWITCHES=/nologo /Zp1 /MDd /W3 /Gm /Gi /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Voice Recording Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\Voice Recording Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=".\Voice Recording Sample.cpp"

!IF  "$(CFG)" == "Voice Recording Sample - Win32 Release"


"$(INTDIR)\Voice Recording Sample.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Recording Sample - Win32 Debug"


"$(INTDIR)\Voice Recording Sample.obj"	"$(INTDIR)\Voice Recording Sample.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=".\Voice Recording Sample.rc"

"$(INTDIR)\Voice Recording Sample.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=".\Voice Recording SampleDlg.cpp"

!IF  "$(CFG)" == "Voice Recording Sample - Win32 Release"


"$(INTDIR)\Voice Recording SampleDlg.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Recording Sample - Win32 Debug"


"$(INTDIR)\Voice Recording SampleDlg.obj"	"$(INTDIR)\Voice Recording SampleDlg.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 


!ENDIF 

