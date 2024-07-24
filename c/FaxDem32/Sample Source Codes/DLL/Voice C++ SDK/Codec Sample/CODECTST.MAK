# Microsoft Developer Studio Generated NMAKE File, Based on CODECTST.DSP
!IF "$(CFG)" == ""
CFG=CODECTST - Win32 Debug
!MESSAGE No configuration specified. Defaulting to CODECTST - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "CODECTST - Win32 Release" && "$(CFG)" != "CODECTST - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "CODECTST.MAK" CFG="CODECTST - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "CODECTST - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "CODECTST - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "CODECTST - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\CODECTST.exe" "$(OUTDIR)\CODECTST.bsc"


CLEAN :
	-@erase "$(INTDIR)\CodecTst.obj"
	-@erase "$(INTDIR)\CodecTst.sbr"
	-@erase "$(INTDIR)\resoure.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\CODECTST.bsc"
	-@erase "$(OUTDIR)\CODECTST.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /ML /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\CODECTST.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\resoure.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\CODECTST.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\CodecTst.sbr"

"$(OUTDIR)\CODECTST.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=user32.lib gdi32.lib comdlg32.lib codec.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\CODECTST.pdb" /machine:I386 /out:"$(OUTDIR)\CODECTST.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\CodecTst.obj" \
	"$(INTDIR)\resoure.res"

"$(OUTDIR)\CODECTST.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "CODECTST - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\CODECTST.exe" "$(OUTDIR)\CODECTST.bsc"


CLEAN :
	-@erase "$(INTDIR)\CodecTst.obj"
	-@erase "$(INTDIR)\CodecTst.sbr"
	-@erase "$(INTDIR)\resoure.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\CODECTST.bsc"
	-@erase "$(OUTDIR)\CODECTST.exe"
	-@erase "$(OUTDIR)\CODECTST.ilk"
	-@erase "$(OUTDIR)\CODECTST.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MLd /W3 /Gm /Gi /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\CODECTST.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\resoure.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\CODECTST.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\CodecTst.sbr"

"$(OUTDIR)\CODECTST.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=user32.lib gdi32.lib comdlg32.lib codec.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\CODECTST.pdb" /debug /machine:I386 /out:"$(OUTDIR)\CODECTST.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\CodecTst.obj" \
	"$(INTDIR)\resoure.res"

"$(OUTDIR)\CODECTST.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("CODECTST.DEP")
!INCLUDE "CODECTST.DEP"
!ELSE 
!MESSAGE Warning: cannot find "CODECTST.DEP"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "CODECTST - Win32 Release" || "$(CFG)" == "CODECTST - Win32 Debug"
SOURCE=.\CodecTst.cpp

"$(INTDIR)\CodecTst.obj"	"$(INTDIR)\CodecTst.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=.\resoure.rc

"$(INTDIR)\resoure.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

