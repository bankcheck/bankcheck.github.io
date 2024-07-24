# Microsoft Developer Studio Generated NMAKE File, Based on OpenFaxBoards.dsp
!IF "$(CFG)" == ""
CFG=OpenFaxBoards - Win32 Debug
!MESSAGE No configuration specified. Defaulting to OpenFaxBoards - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "OpenFaxBoards - Win32 Release" && "$(CFG)" != "OpenFaxBoards - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "OpenFaxBoards.mak" CFG="OpenFaxBoards - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "OpenFaxBoards - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "OpenFaxBoards - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "OpenFaxBoards - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\OpenFaxBoards.exe"


CLEAN :
	-@erase "$(INTDIR)\BOpen.obj"
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgGOpen.obj"
	-@erase "$(INTDIR)\DlgNms.obj"
	-@erase "$(INTDIR)\OpenDialogic.obj"
	-@erase "$(INTDIR)\OpenFaxBoards.obj"
	-@erase "$(INTDIR)\OpenFaxBoards.pch"
	-@erase "$(INTDIR)\OpenFaxBoards.res"
	-@erase "$(INTDIR)\OpenFaxBoardsDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\OpenFaxBoards.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\OpenFaxBoards.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\OpenFaxBoards.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\OpenFaxBoards.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\OpenFaxBoards.pdb" /machine:I386 /out:"$(OUTDIR)\OpenFaxBoards.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BOpen.obj" \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\DlgGOpen.obj" \
	"$(INTDIR)\DlgNms.obj" \
	"$(INTDIR)\OpenDialogic.obj" \
	"$(INTDIR)\OpenFaxBoards.obj" \
	"$(INTDIR)\OpenFaxBoardsDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\OpenFaxBoards.res"

"$(OUTDIR)\OpenFaxBoards.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "OpenFaxBoards - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\OpenFaxBoards.exe"


CLEAN :
	-@erase "$(INTDIR)\BOpen.obj"
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgGOpen.obj"
	-@erase "$(INTDIR)\DlgNms.obj"
	-@erase "$(INTDIR)\OpenDialogic.obj"
	-@erase "$(INTDIR)\OpenFaxBoards.obj"
	-@erase "$(INTDIR)\OpenFaxBoards.pch"
	-@erase "$(INTDIR)\OpenFaxBoards.res"
	-@erase "$(INTDIR)\OpenFaxBoardsDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\OpenFaxBoards.exe"
	-@erase "$(OUTDIR)\OpenFaxBoards.ilk"
	-@erase "$(OUTDIR)\OpenFaxBoards.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\OpenFaxBoards.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\OpenFaxBoards.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\OpenFaxBoards.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\OpenFaxBoards.pdb" /debug /machine:I386 /out:"$(OUTDIR)\OpenFaxBoards.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BOpen.obj" \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\DlgGOpen.obj" \
	"$(INTDIR)\DlgNms.obj" \
	"$(INTDIR)\OpenDialogic.obj" \
	"$(INTDIR)\OpenFaxBoards.obj" \
	"$(INTDIR)\OpenFaxBoardsDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\OpenFaxBoards.res"

"$(OUTDIR)\OpenFaxBoards.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "$(OUTDIR)\OpenFaxBoards.exe"
   copy /b "Debug\OpenFaxBoards.exe" "D:\Program Files\Black Ice Software Inc\FaxDem32\Bin\OpenFaxBoards.exe"
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("OpenFaxBoards.dep")
!INCLUDE "OpenFaxBoards.dep"
!ELSE 
!MESSAGE Warning: cannot find "OpenFaxBoards.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "OpenFaxBoards - Win32 Release" || "$(CFG)" == "OpenFaxBoards - Win32 Debug"
SOURCE=.\BOpen.cpp

"$(INTDIR)\BOpen.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenFaxBoards.pch"


SOURCE=.\DlgFaxClose.cpp

"$(INTDIR)\DlgFaxClose.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenFaxBoards.pch"


SOURCE=.\DlgGOpen.cpp

"$(INTDIR)\DlgGOpen.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenFaxBoards.pch"


SOURCE=.\DlgNms.cpp

"$(INTDIR)\DlgNms.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenFaxBoards.pch"


SOURCE=.\OpenDialogic.cpp

"$(INTDIR)\OpenDialogic.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenFaxBoards.pch"


SOURCE=.\OpenFaxBoards.cpp

"$(INTDIR)\OpenFaxBoards.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenFaxBoards.pch"


SOURCE=.\OpenFaxBoards.rc

"$(INTDIR)\OpenFaxBoards.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\OpenFaxBoardsDlg.cpp

"$(INTDIR)\OpenFaxBoardsDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenFaxBoards.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "OpenFaxBoards - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\OpenFaxBoards.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\OpenFaxBoards.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "OpenFaxBoards - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\OpenFaxBoards.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\OpenFaxBoards.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

