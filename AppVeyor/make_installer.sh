#!/usr/bin/env bash
function addFile {
    echo $1
    cp $1 .
    echo "Source: \"$(basename $1)\"; DestDir: \"{app}\"; Flags: ignoreversion" >> installer.iss
}

function addFileIn {
    echo $1
    mkdir -p $2
    cp $1 $2
    name=$2\\$(basename $1)
    7z a -tzip portable.zip $name
    echo "Source: \"$name\"; DestDir: \"{app}\\$2\"; Flags: ignoreversion" >> installer.iss
}

ver=$(cat main.cpp | grep setApplicationVersion | sed "s/\\s*a.setApplicationVersion(\"//g" | sed "s/\");//g")

cd packages/windows
cp ../../KShare.exe . || exit 3

sed "s/;VER;/$ver/" installer.iss.pattern.top > installer.iss

addFile ../../build/QtAV-depends-windows-x86+x64/bin/avcodec-57.dll
addFile ../../build/QtAV-depends-windows-x86+x64/bin/avformat-57.dll
addFile ../../build/QtAV-depends-windows-x86+x64/bin/avutil-55.dll
addFile ../../build/QtAV-depends-windows-x86+x64/bin/swresample-2.dll
addFile ../../build/QtAV-depends-windows-x86+x64/bin/swscale-4.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Core.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Network.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Gui.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Widgets.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5WinExtras.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Network.dll

addFileIn /c/Qt/5.9/mingw53_32/plugins/platforms/qwindows.dll platforms

addFile /c/Qt/5.9/mingw53_32/bin/LIBSTDC++-6.DLL
addFile /c/Qt/5.9/mingw53_32/bin/LIBWINPTHREAD-1.DLL
addFile /c/Qt/5.9/mingw53_32/bin/LIBGCC_S_DW2-1.DLL

ls

cat installer.iss.pattern.bottom >> installer.iss
"C:\Program Files (x86)\Inno Setup 5\ISCC.exe" installer.iss
cp Output/setup.exe ../../installer.exe || exit 1
cp Output/portable.zip ../../ || exit 2
