# Microsoft Developer Studio Generated NMAKE File, Based on Ocxdemo.dsp
!IF "$(CFG)" == ""
CFG=OCXDEMO - Win32 Release
!MESSAGE No configuration specified. Defaulting to OCXDEMO - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "OCXDEMO - Win32 Release" && "$(CFG)" != "OCXDEMO - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Ocxdemo.mak" CFG="OCXDEMO - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "OCXDEMO - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "OCXDEMO - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "OCXDEMO - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\Ocxdemo.exe" "$(OUTDIR)\Ocxdemo.bsc"


CLEAN :
	-@erase "$(INTDIR)\Dialogic.obj"
	-@erase "$(INTDIR)\Dialogic.sbr"
	-@erase "$(INTDIR)\fax.obj"
	-@erase "$(INTDIR)\fax.sbr"
	-@erase "$(INTDIR)\FaxConfig.obj"
	-@erase "$(INTDIR)\FaxConfig.sbr"
	-@erase "$(INTDIR)\MainFrm.obj"
	-@erase "$(INTDIR)\MainFrm.sbr"
	-@erase "$(INTDIR)\NMSOpen.obj"
	-@erase "$(INTDIR)\NMSOpen.sbr"
	-@erase "$(INTDIR)\OCXDEMO.obj"
	-@erase "$(INTDIR)\Ocxdemo.pch"
	-@erase "$(INTDIR)\OCXDEMO.res"
	-@erase "$(INTDIR)\OCXDEMO.sbr"
	-@erase "$(INTDIR)\OcxdemoD.obj"
	-@erase "$(INTDIR)\OcxdemoD.sbr"
	-@erase "$(INTDIR)\OcxdemoV.obj"
	-@erase "$(INTDIR)\OcxdemoV.sbr"
	-@erase "$(INTDIR)\Options.obj"
	-@erase "$(INTDIR)\Options.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\Ocxdemo.bsc"
	-@erase "$(OUTDIR)\Ocxdemo.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MD /W3 /GX /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Ocxdemo.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\OCXDEMO.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Ocxdemo.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\Dialogic.sbr" \
	"$(INTDIR)\fax.sbr" \
	"$(INTDIR)\FaxConfig.sbr" \
	"$(INTDIR)\MainFrm.sbr" \
	"$(INTDIR)\NMSOpen.sbr" \
	"$(INTDIR)\OCXDEMO.sbr" \
	"$(INTDIR)\OcxdemoD.sbr" \
	"$(INTDIR)\OcxdemoV.sbr" \
	"$(INTDIR)\Options.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\Ocxdemo.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Ocxdemo.pdb" /machine:I386 /out:"$(OUTDIR)\Ocxdemo.exe" /libpath:"..\..\..\..\inc" 
LINK32_OBJS= \
	"$(INTDIR)\Dialogic.obj" \
	"$(INTDIR)\fax.obj" \
	"$(INTDIR)\FaxConfig.obj" \
	"$(INTDIR)\MainFrm.obj" \
	"$(INTDIR)\NMSOpen.obj" \
	"$(INTDIR)\OCXDEMO.obj" \
	"$(INTDIR)\OcxdemoD.obj" \
	"$(INTDIR)\OcxdemoV.obj" \
	"$(INTDIR)\Options.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\OCXDEMO.res"

"$(OUTDIR)\Ocxdemo.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "OCXDEMO - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\Ocxdemo.exe" "$(OUTDIR)\Ocxdemo.bsc"


CLEAN :
	-@erase "$(INTDIR)\Dialogic.obj"
	-@erase "$(INTDIR)\Dialogic.sbr"
	-@erase "$(INTDIR)\fax.obj"
	-@erase "$(INTDIR)\fax.sbr"
	-@erase "$(INTDIR)\FaxConfig.obj"
	-@erase "$(INTDIR)\FaxConfig.sbr"
	-@erase "$(INTDIR)\MainFrm.obj"
	-@erase "$(INTDIR)\MainFrm.sbr"
	-@erase "$(INTDIR)\NMSOpen.obj"
	-@erase "$(INTDIR)\NMSOpen.sbr"
	-@erase "$(INTDIR)\OCXDEMO.obj"
	-@erase "$(INTDIR)\Ocxdemo.pch"
	-@erase "$(INTDIR)\OCXDEMO.res"
	-@erase "$(INTDIR)\OCXDEMO.sbr"
	-@erase "$(INTDIR)\OcxdemoD.obj"
	-@erase "$(INTDIR)\OcxdemoD.sbr"
	-@erase "$(INTDIR)\OcxdemoV.obj"
	-@erase "$(INTDIR)\OcxdemoV.sbr"
	-@erase "$(INTDIR)\Options.obj"
	-@erase "$(INTDIR)\Options.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\Ocxdemo.bsc"
	-@erase "$(OUTDIR)\Ocxdemo.exe"
	-@erase "$(OUTDIR)\Ocxdemo.ilk"
	-@erase "$(OUTDIR)\Ocxdemo.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Ocxdemo.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\OCXDEMO.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Ocxdemo.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\Dialogic.sbr" \
	"$(INTDIR)\fax.sbr" \
	"$(INTDIR)\FaxConfig.sbr" \
	"$(INTDIR)\MainFrm.sbr" \
	"$(INTDIR)\NMSOpen.sbr" \
	"$(INTDIR)\OCXDEMO.sbr" \
	"$(INTDIR)\OcxdemoD.sbr" \
	"$(INTDIR)\OcxdemoV.sbr" \
	"$(INTDIR)\Options.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\Ocxdemo.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\Ocxdemo.pdb" /debug /machine:I386 /out:"$(OUTDIR)\Ocxdemo.exe" /libpath:"..\..\..\..\inc" 
LINK32_OBJS= \
	"$(INTDIR)\Dialogic.obj" \
	"$(INTDIR)\fax.obj" \
	"$(INTDIR)\FaxConfig.obj" \
	"$(INTDIR)\MainFrm.obj" \
	"$(INTDIR)\NMSOpen.obj" \
	"$(INTDIR)\OCXDEMO.obj" \
	"$(INTDIR)\OcxdemoD.obj" \
	"$(INTDIR)\OcxdemoV.obj" \
	"$(INTDIR)\Options.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\OCXDEMO.res"

"$(OUTDIR)\Ocxdemo.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Ocxdemo.dep")
!INCLUDE "Ocxdemo.dep"
!ELSE 
!MESSAGE Warning: cannot find "Ocxdemo.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "OCXDEMO - Win32 Release" || "$(CFG)" == "OCXDEMO - Win32 Debug"
SOURCE=.\Dialogic.cpp

"$(INTDIR)\Dialogic.obj"	"$(INTDIR)\Dialogic.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\fax.cpp

"$(INTDIR)\fax.obj"	"$(INTDIR)\fax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\FaxConfig.cpp

"$(INTDIR)\FaxConfig.obj"	"$(INTDIR)\FaxConfig.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\MainFrm.cpp

"$(INTDIR)\MainFrm.obj"	"$(INTDIR)\MainFrm.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\NMSOpen.cpp

"$(INTDIR)\NMSOpen.obj"	"$(INTDIR)\NMSOpen.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\OCXDEMO.cpp

"$(INTDIR)\OCXDEMO.obj"	"$(INTDIR)\OCXDEMO.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\OCXDEMO.rc

"$(INTDIR)\OCXDEMO.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\OcxdemoD.cpp

"$(INTDIR)\OcxdemoD.obj"	"$(INTDIR)\OcxdemoD.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\OcxdemoV.cpp

"$(INTDIR)\OcxdemoV.obj"	"$(INTDIR)\OcxdemoV.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\Options.cpp

"$(INTDIR)\Options.obj"	"$(INTDIR)\Options.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Ocxdemo.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "OCXDEMO - Win32 Release"

CPP_SWITCHES=/nologo /Zp1 /MD /W3 /GX /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Ocxdemo.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\Ocxdemo.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "OCXDEMO - Win32 Debug"

CPP_SWITCHES=/nologo /Zp1 /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Ocxdemo.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\Ocxdemo.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

