# Microsoft Developer Studio Generated NMAKE File, Based on SendFax.dsp
!IF "$(CFG)" == ""
CFG=SendFax - Win32 Debug
!MESSAGE No configuration specified. Defaulting to SendFax - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "SendFax - Win32 Release" && "$(CFG)" != "SendFax - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "SendFax.mak" CFG="SendFax - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "SendFax - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "SendFax - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "SendFax - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\SendFax.exe" "$(OUTDIR)\SendFax.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.sbr"
	-@erase "$(INTDIR)\DlgSendFax.obj"
	-@erase "$(INTDIR)\DlgSendFax.sbr"
	-@erase "$(INTDIR)\SendFax.obj"
	-@erase "$(INTDIR)\SendFax.pch"
	-@erase "$(INTDIR)\SendFax.res"
	-@erase "$(INTDIR)\SendFax.sbr"
	-@erase "$(INTDIR)\SendFaxDlg.obj"
	-@erase "$(INTDIR)\SendFaxDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\SendFax.bsc"
	-@erase "$(OUTDIR)\SendFax.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SendFax.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SendFax.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SendFax.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\dlgFaxPortSetup.sbr" \
	"$(INTDIR)\DlgSendFax.sbr" \
	"$(INTDIR)\SendFax.sbr" \
	"$(INTDIR)\SendFaxDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\SendFax.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\SendFax.pdb" /machine:I386 /out:"$(OUTDIR)\SendFax.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\DlgSendFax.obj" \
	"$(INTDIR)\SendFax.obj" \
	"$(INTDIR)\SendFaxDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SendFax.res"

"$(OUTDIR)\SendFax.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "SendFax - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\SendFax.exe" "$(OUTDIR)\SendFax.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.sbr"
	-@erase "$(INTDIR)\DlgSendFax.obj"
	-@erase "$(INTDIR)\DlgSendFax.sbr"
	-@erase "$(INTDIR)\SendFax.obj"
	-@erase "$(INTDIR)\SendFax.pch"
	-@erase "$(INTDIR)\SendFax.res"
	-@erase "$(INTDIR)\SendFax.sbr"
	-@erase "$(INTDIR)\SendFaxDlg.obj"
	-@erase "$(INTDIR)\SendFaxDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\SendFax.bsc"
	-@erase "$(OUTDIR)\SendFax.exe"
	-@erase "$(OUTDIR)\SendFax.ilk"
	-@erase "$(OUTDIR)\SendFax.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SendFax.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SendFax.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SendFax.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\dlgFaxPortSetup.sbr" \
	"$(INTDIR)\DlgSendFax.sbr" \
	"$(INTDIR)\SendFax.sbr" \
	"$(INTDIR)\SendFaxDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\SendFax.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\SendFax.pdb" /debug /machine:I386 /out:"$(OUTDIR)\SendFax.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\DlgSendFax.obj" \
	"$(INTDIR)\SendFax.obj" \
	"$(INTDIR)\SendFaxDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SendFax.res"

"$(OUTDIR)\SendFax.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("SendFax.dep")
!INCLUDE "SendFax.dep"
!ELSE 
!MESSAGE Warning: cannot find "SendFax.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "SendFax - Win32 Release" || "$(CFG)" == "SendFax - Win32 Debug"
SOURCE=.\DlgFaxClose.cpp

"$(INTDIR)\DlgFaxClose.obj"	"$(INTDIR)\DlgFaxClose.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SendFax.pch"


SOURCE=.\dlgFaxPortSetup.cpp

"$(INTDIR)\dlgFaxPortSetup.obj"	"$(INTDIR)\dlgFaxPortSetup.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SendFax.pch"


SOURCE=.\DlgSendFax.cpp

"$(INTDIR)\DlgSendFax.obj"	"$(INTDIR)\DlgSendFax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SendFax.pch"


SOURCE=.\SendFax.cpp

"$(INTDIR)\SendFax.obj"	"$(INTDIR)\SendFax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SendFax.pch"


SOURCE=.\SendFax.rc

"$(INTDIR)\SendFax.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\SendFaxDlg.cpp

"$(INTDIR)\SendFaxDlg.obj"	"$(INTDIR)\SendFaxDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SendFax.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "SendFax - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SendFax.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\SendFax.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "SendFax - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SendFax.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\SendFax.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

