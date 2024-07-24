# Microsoft Developer Studio Generated NMAKE File, Based on ReceiveFaxWithDTMF.dsp
!IF "$(CFG)" == ""
CFG=ReceiveFaxWithDTMF - Win32 Debug
!MESSAGE No configuration specified. Defaulting to ReceiveFaxWithDTMF - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "ReceiveFaxWithDTMF - Win32 Release" && "$(CFG)" != "ReceiveFaxWithDTMF - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "ReceiveFaxWithDTMF.mak" CFG="ReceiveFaxWithDTMF - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "ReceiveFaxWithDTMF - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "ReceiveFaxWithDTMF - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\ReceiveFaxWithDTMF.exe" "$(OUTDIR)\ReceiveFaxWithDTMF.bsc"


CLEAN :
	-@erase "$(INTDIR)\BOpen.obj"
	-@erase "$(INTDIR)\BOpen.sbr"
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\DlgGOpen.obj"
	-@erase "$(INTDIR)\DlgGOpen.sbr"
	-@erase "$(INTDIR)\DlgNms.obj"
	-@erase "$(INTDIR)\DlgNms.sbr"
	-@erase "$(INTDIR)\OpenDialogic.obj"
	-@erase "$(INTDIR)\OpenDialogic.sbr"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMF.obj"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMF.pch"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMF.res"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMF.sbr"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMFDlg.obj"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMFDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\ReceiveFaxWithDTMF.bsc"
	-@erase "$(OUTDIR)\ReceiveFaxWithDTMF.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ReceiveFaxWithDTMF.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\ReceiveFaxWithDTMF.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ReceiveFaxWithDTMF.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BOpen.sbr" \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\DlgGOpen.sbr" \
	"$(INTDIR)\DlgNms.sbr" \
	"$(INTDIR)\OpenDialogic.sbr" \
	"$(INTDIR)\ReceiveFaxWithDTMF.sbr" \
	"$(INTDIR)\ReceiveFaxWithDTMFDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\ReceiveFaxWithDTMF.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\ReceiveFaxWithDTMF.pdb" /machine:I386 /out:"$(OUTDIR)\ReceiveFaxWithDTMF.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BOpen.obj" \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\DlgGOpen.obj" \
	"$(INTDIR)\DlgNms.obj" \
	"$(INTDIR)\OpenDialogic.obj" \
	"$(INTDIR)\ReceiveFaxWithDTMF.obj" \
	"$(INTDIR)\ReceiveFaxWithDTMFDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\ReceiveFaxWithDTMF.res"

"$(OUTDIR)\ReceiveFaxWithDTMF.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\ReceiveFaxWithDTMF.exe"


CLEAN :
	-@erase "$(INTDIR)\BOpen.obj"
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgGOpen.obj"
	-@erase "$(INTDIR)\DlgNms.obj"
	-@erase "$(INTDIR)\OpenDialogic.obj"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMF.obj"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMF.pch"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMF.res"
	-@erase "$(INTDIR)\ReceiveFaxWithDTMFDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\ReceiveFaxWithDTMF.exe"
	-@erase "$(OUTDIR)\ReceiveFaxWithDTMF.ilk"
	-@erase "$(OUTDIR)\ReceiveFaxWithDTMF.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\ReceiveFaxWithDTMF.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\ReceiveFaxWithDTMF.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ReceiveFaxWithDTMF.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\ReceiveFaxWithDTMF.pdb" /debug /machine:I386 /out:"$(OUTDIR)\ReceiveFaxWithDTMF.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BOpen.obj" \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\DlgGOpen.obj" \
	"$(INTDIR)\DlgNms.obj" \
	"$(INTDIR)\OpenDialogic.obj" \
	"$(INTDIR)\ReceiveFaxWithDTMF.obj" \
	"$(INTDIR)\ReceiveFaxWithDTMFDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\ReceiveFaxWithDTMF.res"

"$(OUTDIR)\ReceiveFaxWithDTMF.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "$(OUTDIR)\ReceiveFaxWithDTMF.exe"
   copy /b "Debug\ReceiveFaxWithDTMF.exe" "D:\Program Files\Black Ice Software Inc\FaxDem32\Bin\ReceiveFaxWithDTMF.exe"
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("ReceiveFaxWithDTMF.dep")
!INCLUDE "ReceiveFaxWithDTMF.dep"
!ELSE 
!MESSAGE Warning: cannot find "ReceiveFaxWithDTMF.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release" || "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"
SOURCE=.\BOpen.cpp

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"


"$(INTDIR)\BOpen.obj"	"$(INTDIR)\BOpen.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"


"$(INTDIR)\BOpen.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ENDIF 

SOURCE=.\DlgFaxClose.cpp

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"


"$(INTDIR)\DlgFaxClose.obj"	"$(INTDIR)\DlgFaxClose.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"


"$(INTDIR)\DlgFaxClose.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ENDIF 

SOURCE=.\DlgGOpen.cpp

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"


"$(INTDIR)\DlgGOpen.obj"	"$(INTDIR)\DlgGOpen.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"


"$(INTDIR)\DlgGOpen.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ENDIF 

SOURCE=.\DlgNms.cpp

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"


"$(INTDIR)\DlgNms.obj"	"$(INTDIR)\DlgNms.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"


"$(INTDIR)\DlgNms.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ENDIF 

SOURCE=.\OpenDialogic.cpp

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"


"$(INTDIR)\OpenDialogic.obj"	"$(INTDIR)\OpenDialogic.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"


"$(INTDIR)\OpenDialogic.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ENDIF 

SOURCE=.\ReceiveFaxWithDTMF.cpp

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"


"$(INTDIR)\ReceiveFaxWithDTMF.obj"	"$(INTDIR)\ReceiveFaxWithDTMF.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"


"$(INTDIR)\ReceiveFaxWithDTMF.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ENDIF 

SOURCE=.\ReceiveFaxWithDTMF.rc

"$(INTDIR)\ReceiveFaxWithDTMF.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\ReceiveFaxWithDTMFDlg.cpp

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"


"$(INTDIR)\ReceiveFaxWithDTMFDlg.obj"	"$(INTDIR)\ReceiveFaxWithDTMFDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"


"$(INTDIR)\ReceiveFaxWithDTMFDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFaxWithDTMF.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ReceiveFaxWithDTMF.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\ReceiveFaxWithDTMF.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "ReceiveFaxWithDTMF - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\ReceiveFaxWithDTMF.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\ReceiveFaxWithDTMF.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

