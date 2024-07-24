# Microsoft Developer Studio Generated NMAKE File, Based on SCCallSwitch.dsp
!IF "$(CFG)" == ""
CFG=SCCallSwitch - Win32 Debug
!MESSAGE No configuration specified. Defaulting to SCCallSwitch - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "SCCallSwitch - Win32 Release" && "$(CFG)" != "SCCallSwitch - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "SCCallSwitch.mak" CFG="SCCallSwitch - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "SCCallSwitch - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "SCCallSwitch - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "SCCallSwitch - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\SCCallSwitch.exe"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\SCCallSwitch.obj"
	-@erase "$(INTDIR)\SCCallSwitch.pch"
	-@erase "$(INTDIR)\SCCallSwitch.res"
	-@erase "$(INTDIR)\SCCallSwitchDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\SCCallSwitch.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\inc" /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCCallSwitch.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCCallSwitch.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCCallSwitch.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\SCCallSwitch.pdb" /machine:I386 /out:"$(OUTDIR)\SCCallSwitch.exe" /libpath:"..\lib" /libpath:"..\..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCCallSwitch.obj" \
	"$(INTDIR)\SCCallSwitchDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCCallSwitch.res"

"$(OUTDIR)\SCCallSwitch.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "SCCallSwitch - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\SCCallSwitch.exe" "$(OUTDIR)\SCCallSwitch.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\DlgHelp.sbr"
	-@erase "$(INTDIR)\SCCallSwitch.obj"
	-@erase "$(INTDIR)\SCCallSwitch.pch"
	-@erase "$(INTDIR)\SCCallSwitch.res"
	-@erase "$(INTDIR)\SCCallSwitch.sbr"
	-@erase "$(INTDIR)\SCCallSwitchDlg.obj"
	-@erase "$(INTDIR)\SCCallSwitchDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\SCCallSwitch.bsc"
	-@erase "$(OUTDIR)\SCCallSwitch.exe"
	-@erase "$(OUTDIR)\SCCallSwitch.ilk"
	-@erase "$(OUTDIR)\SCCallSwitch.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /GX /ZI /Od /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCCallSwitch.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCCallSwitch.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCCallSwitch.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgHelp.sbr" \
	"$(INTDIR)\SCCallSwitch.sbr" \
	"$(INTDIR)\SCCallSwitchDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\SCCallSwitch.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\SCCallSwitch.pdb" /debug /machine:I386 /out:"$(OUTDIR)\SCCallSwitch.exe" /pdbtype:sept /libpath:"..\..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCCallSwitch.obj" \
	"$(INTDIR)\SCCallSwitchDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCCallSwitch.res"

"$(OUTDIR)\SCCallSwitch.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("SCCallSwitch.dep")
!INCLUDE "SCCallSwitch.dep"
!ELSE 
!MESSAGE Warning: cannot find "SCCallSwitch.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "SCCallSwitch - Win32 Release" || "$(CFG)" == "SCCallSwitch - Win32 Debug"
SOURCE=.\DlgHelp.cpp

!IF  "$(CFG)" == "SCCallSwitch - Win32 Release"


"$(INTDIR)\DlgHelp.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallSwitch.pch"


!ELSEIF  "$(CFG)" == "SCCallSwitch - Win32 Debug"


"$(INTDIR)\DlgHelp.obj"	"$(INTDIR)\DlgHelp.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallSwitch.pch"


!ENDIF 

SOURCE=.\SCCallSwitch.cpp

!IF  "$(CFG)" == "SCCallSwitch - Win32 Release"


"$(INTDIR)\SCCallSwitch.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallSwitch.pch"


!ELSEIF  "$(CFG)" == "SCCallSwitch - Win32 Debug"


"$(INTDIR)\SCCallSwitch.obj"	"$(INTDIR)\SCCallSwitch.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallSwitch.pch"


!ENDIF 

SOURCE=.\SCCallSwitch.rc

"$(INTDIR)\SCCallSwitch.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\SCCallSwitchDlg.cpp

!IF  "$(CFG)" == "SCCallSwitch - Win32 Release"


"$(INTDIR)\SCCallSwitchDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallSwitch.pch"


!ELSEIF  "$(CFG)" == "SCCallSwitch - Win32 Debug"


"$(INTDIR)\SCCallSwitchDlg.obj"	"$(INTDIR)\SCCallSwitchDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCCallSwitch.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "SCCallSwitch - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\inc" /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCCallSwitch.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\SCCallSwitch.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "SCCallSwitch - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /GX /ZI /Od /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCCallSwitch.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\SCCallSwitch.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

