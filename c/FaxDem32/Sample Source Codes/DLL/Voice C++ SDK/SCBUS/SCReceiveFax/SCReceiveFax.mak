# Microsoft Developer Studio Generated NMAKE File, Based on SCReceiveFax.dsp
!IF "$(CFG)" == ""
CFG=SCReceiveFax - Win32 Debug
!MESSAGE No configuration specified. Defaulting to SCReceiveFax - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "SCReceiveFax - Win32 Release" && "$(CFG)" != "SCReceiveFax - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "SCReceiveFax.mak" CFG="SCReceiveFax - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "SCReceiveFax - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "SCReceiveFax - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "SCReceiveFax - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\SCReceiveFax.exe"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\SCReceiveFax.obj"
	-@erase "$(INTDIR)\SCReceiveFax.pch"
	-@erase "$(INTDIR)\SCReceiveFax.res"
	-@erase "$(INTDIR)\SCReceiveFaxDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\SCReceiveFax.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCReceiveFax.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCReceiveFax.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCReceiveFax.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\SCReceiveFax.pdb" /machine:I386 /out:"$(OUTDIR)\SCReceiveFax.exe" /libpath:"..\..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCReceiveFax.obj" \
	"$(INTDIR)\SCReceiveFaxDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCReceiveFax.res"

"$(OUTDIR)\SCReceiveFax.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "SCReceiveFax - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\SCReceiveFax.exe" "$(OUTDIR)\SCReceiveFax.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\DlgHelp.sbr"
	-@erase "$(INTDIR)\SCReceiveFax.obj"
	-@erase "$(INTDIR)\SCReceiveFax.pch"
	-@erase "$(INTDIR)\SCReceiveFax.res"
	-@erase "$(INTDIR)\SCReceiveFax.sbr"
	-@erase "$(INTDIR)\SCReceiveFaxDlg.obj"
	-@erase "$(INTDIR)\SCReceiveFaxDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\SCReceiveFax.bsc"
	-@erase "$(OUTDIR)\SCReceiveFax.exe"
	-@erase "$(OUTDIR)\SCReceiveFax.ilk"
	-@erase "$(OUTDIR)\SCReceiveFax.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCReceiveFax.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCReceiveFax.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCReceiveFax.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgHelp.sbr" \
	"$(INTDIR)\SCReceiveFax.sbr" \
	"$(INTDIR)\SCReceiveFaxDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\SCReceiveFax.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\SCReceiveFax.pdb" /debug /machine:I386 /out:"$(OUTDIR)\SCReceiveFax.exe" /pdbtype:sept /libpath:"..\..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCReceiveFax.obj" \
	"$(INTDIR)\SCReceiveFaxDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCReceiveFax.res"

"$(OUTDIR)\SCReceiveFax.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("SCReceiveFax.dep")
!INCLUDE "SCReceiveFax.dep"
!ELSE 
!MESSAGE Warning: cannot find "SCReceiveFax.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "SCReceiveFax - Win32 Release" || "$(CFG)" == "SCReceiveFax - Win32 Debug"
SOURCE=.\DlgHelp.cpp

!IF  "$(CFG)" == "SCReceiveFax - Win32 Release"


"$(INTDIR)\DlgHelp.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCReceiveFax.pch"


!ELSEIF  "$(CFG)" == "SCReceiveFax - Win32 Debug"


"$(INTDIR)\DlgHelp.obj"	"$(INTDIR)\DlgHelp.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCReceiveFax.pch"


!ENDIF 

SOURCE=.\SCReceiveFax.cpp

!IF  "$(CFG)" == "SCReceiveFax - Win32 Release"


"$(INTDIR)\SCReceiveFax.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCReceiveFax.pch"


!ELSEIF  "$(CFG)" == "SCReceiveFax - Win32 Debug"


"$(INTDIR)\SCReceiveFax.obj"	"$(INTDIR)\SCReceiveFax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCReceiveFax.pch"


!ENDIF 

SOURCE=.\SCReceiveFax.rc

"$(INTDIR)\SCReceiveFax.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\SCReceiveFaxDlg.cpp

!IF  "$(CFG)" == "SCReceiveFax - Win32 Release"


"$(INTDIR)\SCReceiveFaxDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCReceiveFax.pch"


!ELSEIF  "$(CFG)" == "SCReceiveFax - Win32 Debug"


"$(INTDIR)\SCReceiveFaxDlg.obj"	"$(INTDIR)\SCReceiveFaxDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCReceiveFax.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "SCReceiveFax - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCReceiveFax.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\SCReceiveFax.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "SCReceiveFax - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCReceiveFax.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\SCReceiveFax.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

