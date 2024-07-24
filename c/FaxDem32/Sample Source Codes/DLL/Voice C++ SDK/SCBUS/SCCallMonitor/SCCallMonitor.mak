# Microsoft Developer Studio Generated NMAKE File, Based on SCCallMonitor.dsp
!IF "$(CFG)" == ""
CFG=SCCallMonitor - Win32 Debug
!MESSAGE No configuration specified. Defaulting to SCCallMonitor - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "SCCallMonitor - Win32 Release" && "$(CFG)" != "SCCallMonitor - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "SCCallMonitor.mak" CFG="SCCallMonitor - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "SCCallMonitor - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "SCCallMonitor - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "SCCallMonitor - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\SCCallMonitor.exe"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\SCCallMonitor.obj"
	-@erase "$(INTDIR)\SCCallMonitor.pch"
	-@erase "$(INTDIR)\SCCallMonitor.res"
	-@erase "$(INTDIR)\SCCallMonitorDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\SCCallMonitor.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCCallMonitor.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCCallMonitor.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCCallMonitor.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\SCCallMonitor.pdb" /machine:I386 /out:"$(OUTDIR)\SCCallMonitor.exe" /libpath:"..\..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCCallMonitor.obj" \
	"$(INTDIR)\SCCallMonitorDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCCallMonitor.res"

"$(OUTDIR)\SCCallMonitor.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "SCCallMonitor - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\SCCallMonitor.exe" "$(OUTDIR)\SCCallMonitor.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\DlgHelp.sbr"
	-@erase "$(INTDIR)\SCCallMonitor.obj"
	-@erase "$(INTDIR)\SCCallMonitor.pch"
	-@erase "$(INTDIR)\SCCallMonitor.res"
	-@erase "$(INTDIR)\SCCallMonitor.sbr"
	-@erase "$(INTDIR)\SCCallMonitorDlg.obj"
	-@erase "$(INTDIR)\SCCallMonitorDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\SCCallMonitor.bsc"
	-@erase "$(OUTDIR)\SCCallMonitor.exe"
	-@erase "$(OUTDIR)\SCCallMonitor.ilk"
	-@erase "$(OUTDIR)\SCCallMonitor.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /GX /ZI /Od /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCCallMonitor.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCCallMonitor.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCCallMonitor.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgHelp.sbr" \
	"$(INTDIR)\SCCallMonitor.sbr" \
	"$(INTDIR)\SCCallMonitorDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\SCCallMonitor.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\SCCallMonitor.pdb" /debug /machine:I386 /out:"$(OUTDIR)\SCCallMonitor.exe" /pdbtype:sept /libpath:"..\..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCCallMonitor.obj" \
	"$(INTDIR)\SCCallMonitorDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCCallMonitor.res"

"$(OUTDIR)\SCCallMonitor.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("SCCallMonitor.dep")
!INCLUDE "SCCallMonitor.dep"
!ELSE 
!MESSAGE Warning: cannot find "SCCallMonitor.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "SCCallMonitor - Win32 Release" || "$(CFG)" == "SCCallMonitor - Win32 Debug"
SOURCE=.\DlgHelp.cpp

!IF  "$(CFG)" == "SCCallMonitor - Win32 Release"


"$(INTDIR)\DlgHelp.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallMonitor.pch"


!ELSEIF  "$(CFG)" == "SCCallMonitor - Win32 Debug"


"$(INTDIR)\DlgHelp.obj"	"$(INTDIR)\DlgHelp.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallMonitor.pch"


!ENDIF 

SOURCE=.\SCCallMonitor.cpp

!IF  "$(CFG)" == "SCCallMonitor - Win32 Release"


"$(INTDIR)\SCCallMonitor.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallMonitor.pch"


!ELSEIF  "$(CFG)" == "SCCallMonitor - Win32 Debug"


"$(INTDIR)\SCCallMonitor.obj"	"$(INTDIR)\SCCallMonitor.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallMonitor.pch"


!ENDIF 

SOURCE=.\SCCallMonitor.rc

"$(INTDIR)\SCCallMonitor.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\SCCallMonitorDlg.cpp

!IF  "$(CFG)" == "SCCallMonitor - Win32 Release"


"$(INTDIR)\SCCallMonitorDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallMonitor.pch"


!ELSEIF  "$(CFG)" == "SCCallMonitor - Win32 Debug"


"$(INTDIR)\SCCallMonitorDlg.obj"	"$(INTDIR)\SCCallMonitorDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallMonitor.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "SCCallMonitor - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCCallMonitor.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\SCCallMonitor.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "SCCallMonitor - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /GX /ZI /Od /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCCallMonitor.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\SCCallMonitor.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

