# Microsoft Developer Studio Generated NMAKE File, Based on MSI Predictive Dialing Sample.dsp
!IF "$(CFG)" == ""
CFG=MSI Predictive Dialing Sample - Win32 Debug
!MESSAGE No configuration specified. Defaulting to MSI Predictive Dialing Sample - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "MSI Predictive Dialing Sample - Win32 Release" && "$(CFG)" != "MSI Predictive Dialing Sample - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "MSI Predictive Dialing Sample.mak" CFG="MSI Predictive Dialing Sample - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "MSI Predictive Dialing Sample - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "MSI Predictive Dialing Sample - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "MSI Predictive Dialing Sample - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\MSI Predictive Dialing Sample.exe"


CLEAN :
	-@erase "$(INTDIR)\MSI Predictive Dialing Sample.obj"
	-@erase "$(INTDIR)\MSI Predictive Dialing Sample.pch"
	-@erase "$(INTDIR)\MSI Predictive Dialing Sample.res"
	-@erase "$(INTDIR)\MSI Predictive Dialing SampleDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\MSI Predictive Dialing Sample.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\MSI Predictive Dialing Sample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\MSI Predictive Dialing Sample.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\MSI Predictive Dialing Sample.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\MSI Predictive Dialing Sample.pdb" /machine:I386 /out:"$(OUTDIR)\MSI Predictive Dialing Sample.exe" /libpath:"..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\MSI Predictive Dialing Sample.obj" \
	"$(INTDIR)\MSI Predictive Dialing SampleDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\MSI Predictive Dialing Sample.res"

"$(OUTDIR)\MSI Predictive Dialing Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "MSI Predictive Dialing Sample - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\MSI Predictive Dialing Sample.exe"


CLEAN :
	-@erase "$(INTDIR)\MSI Predictive Dialing Sample.obj"
	-@erase "$(INTDIR)\MSI Predictive Dialing Sample.pch"
	-@erase "$(INTDIR)\MSI Predictive Dialing Sample.res"
	-@erase "$(INTDIR)\MSI Predictive Dialing SampleDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\MSI Predictive Dialing Sample.exe"
	-@erase "$(OUTDIR)\MSI Predictive Dialing Sample.ilk"
	-@erase "$(OUTDIR)\MSI Predictive Dialing Sample.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\MSI Predictive Dialing Sample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\MSI Predictive Dialing Sample.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\MSI Predictive Dialing Sample.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\MSI Predictive Dialing Sample.pdb" /debug /machine:I386 /out:"$(OUTDIR)\MSI Predictive Dialing Sample.exe" /pdbtype:sept /libpath:"..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\MSI Predictive Dialing Sample.obj" \
	"$(INTDIR)\MSI Predictive Dialing SampleDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\MSI Predictive Dialing Sample.res"

"$(OUTDIR)\MSI Predictive Dialing Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("MSI Predictive Dialing Sample.dep")
!INCLUDE "MSI Predictive Dialing Sample.dep"
!ELSE 
!MESSAGE Warning: cannot find "MSI Predictive Dialing Sample.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "MSI Predictive Dialing Sample - Win32 Release" || "$(CFG)" == "MSI Predictive Dialing Sample - Win32 Debug"
SOURCE=".\MSI Predictive Dialing Sample.cpp"

"$(INTDIR)\MSI Predictive Dialing Sample.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\MSI Predictive Dialing Sample.pch"


SOURCE=".\MSI Predictive Dialing Sample.rc"

"$(INTDIR)\MSI Predictive Dialing Sample.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=".\MSI Predictive Dialing SampleDlg.cpp"

"$(INTDIR)\MSI Predictive Dialing SampleDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\MSI Predictive Dialing Sample.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "MSI Predictive Dialing Sample - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\MSI Predictive Dialing Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\MSI Predictive Dialing Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "MSI Predictive Dialing Sample - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\MSI Predictive Dialing Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\MSI Predictive Dialing Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

