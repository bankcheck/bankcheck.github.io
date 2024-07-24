# Microsoft Developer Studio Generated NMAKE File, Based on SCSendFax.dsp
!IF "$(CFG)" == ""
CFG=SCSendFax - Win32 Debug
!MESSAGE No configuration specified. Defaulting to SCSendFax - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "SCSendFax - Win32 Release" && "$(CFG)" != "SCSendFax - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "SCSendFax.mak" CFG="SCSendFax - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "SCSendFax - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "SCSendFax - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "SCSendFax - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\SCSendFax.exe"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\SCSendFax.obj"
	-@erase "$(INTDIR)\SCSendFax.pch"
	-@erase "$(INTDIR)\SCSendFax.res"
	-@erase "$(INTDIR)\SCSendFaxDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\SCSendFax.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCSendFax.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCSendFax.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCSendFax.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib bitiff.lib bidib.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\SCSendFax.pdb" /machine:I386 /out:"$(OUTDIR)\SCSendFax.exe" /libpath:"..\..\..\..\..\lib" /libpath:"..\..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCSendFax.obj" \
	"$(INTDIR)\SCSendFaxDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCSendFax.res"

"$(OUTDIR)\SCSendFax.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "SCSendFax - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\SCSendFax.exe" "$(OUTDIR)\SCSendFax.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\DlgHelp.sbr"
	-@erase "$(INTDIR)\SCSendFax.obj"
	-@erase "$(INTDIR)\SCSendFax.pch"
	-@erase "$(INTDIR)\SCSendFax.res"
	-@erase "$(INTDIR)\SCSendFax.sbr"
	-@erase "$(INTDIR)\SCSendFaxDlg.obj"
	-@erase "$(INTDIR)\SCSendFaxDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\SCSendFax.bsc"
	-@erase "$(OUTDIR)\SCSendFax.exe"
	-@erase "$(OUTDIR)\SCSendFax.ilk"
	-@erase "$(OUTDIR)\SCSendFax.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCSendFax.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCSendFax.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCSendFax.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgHelp.sbr" \
	"$(INTDIR)\SCSendFax.sbr" \
	"$(INTDIR)\SCSendFaxDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\SCSendFax.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib bitiff.lib bidib.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\SCSendFax.pdb" /debug /machine:I386 /out:"$(OUTDIR)\SCSendFax.exe" /pdbtype:sept /libpath:"..\..\..\..\lib" /libpath:"..\..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCSendFax.obj" \
	"$(INTDIR)\SCSendFaxDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCSendFax.res"

"$(OUTDIR)\SCSendFax.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("SCSendFax.dep")
!INCLUDE "SCSendFax.dep"
!ELSE 
!MESSAGE Warning: cannot find "SCSendFax.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "SCSendFax - Win32 Release" || "$(CFG)" == "SCSendFax - Win32 Debug"
SOURCE=.\DlgHelp.cpp

!IF  "$(CFG)" == "SCSendFax - Win32 Release"


"$(INTDIR)\DlgHelp.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCSendFax.pch"


!ELSEIF  "$(CFG)" == "SCSendFax - Win32 Debug"


"$(INTDIR)\DlgHelp.obj"	"$(INTDIR)\DlgHelp.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCSendFax.pch"


!ENDIF 

SOURCE=.\SCSendFax.cpp

!IF  "$(CFG)" == "SCSendFax - Win32 Release"


"$(INTDIR)\SCSendFax.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCSendFax.pch"


!ELSEIF  "$(CFG)" == "SCSendFax - Win32 Debug"


"$(INTDIR)\SCSendFax.obj"	"$(INTDIR)\SCSendFax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCSendFax.pch"


!ENDIF 

SOURCE=.\SCSendFax.rc

"$(INTDIR)\SCSendFax.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\SCSendFaxDlg.cpp

!IF  "$(CFG)" == "SCSendFax - Win32 Release"


"$(INTDIR)\SCSendFaxDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCSendFax.pch"


!ELSEIF  "$(CFG)" == "SCSendFax - Win32 Debug"


"$(INTDIR)\SCSendFaxDlg.obj"	"$(INTDIR)\SCSendFaxDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCSendFax.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "SCSendFax - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCSendFax.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\SCSendFax.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "SCSendFax - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCSendFax.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\SCSendFax.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

