# Microsoft Developer Studio Generated NMAKE File, Based on Service.dsp
!IF "$(CFG)" == ""
CFG=Service - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Service - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Service - Win32 Release" && "$(CFG)" != "Service - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Service.mak" CFG="Service - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Service - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "Service - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Service - Win32 Release"

OUTDIR=.\WinRel
INTDIR=.\WinRel
# Begin Custom Macros
OutDir=.\WinRel
# End Custom Macros

ALL : "$(OUTDIR)\Service.exe" "$(OUTDIR)\Service.bsc"


CLEAN :
	-@erase "$(INTDIR)\SERVICE.OBJ"
	-@erase "$(INTDIR)\SERVICE.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\Service.bsc"
	-@erase "$(OUTDIR)\Service.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /ML /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Service.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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

RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Service.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\SERVICE.SBR"

"$(OUTDIR)\Service.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:no /pdb:"$(OUTDIR)\Service.pdb" /machine:I386 /out:"$(OUTDIR)\Service.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\SERVICE.OBJ"

"$(OUTDIR)\Service.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Service - Win32 Debug"

OUTDIR=.\WinDebug
INTDIR=.\WinDebug
# Begin Custom Macros
OutDir=.\WinDebug
# End Custom Macros

ALL : "$(OUTDIR)\Service.exe" "$(OUTDIR)\Service.bsc"


CLEAN :
	-@erase "$(INTDIR)\SERVICE.OBJ"
	-@erase "$(INTDIR)\SERVICE.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\Service.bsc"
	-@erase "$(OUTDIR)\Service.exe"
	-@erase "$(OUTDIR)\Service.ilk"
	-@erase "$(OUTDIR)\Service.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MLd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Service.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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

RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Service.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\SERVICE.SBR"

"$(OUTDIR)\Service.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\Service.pdb" /debug /machine:I386 /out:"$(OUTDIR)\Service.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\SERVICE.OBJ"

"$(OUTDIR)\Service.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Service.dep")
!INCLUDE "Service.dep"
!ELSE 
!MESSAGE Warning: cannot find "Service.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Service - Win32 Release" || "$(CFG)" == "Service - Win32 Debug"
SOURCE=.\SERVICE.CPP

"$(INTDIR)\SERVICE.OBJ"	"$(INTDIR)\SERVICE.SBR" : $(SOURCE) "$(INTDIR)"



!ENDIF 

