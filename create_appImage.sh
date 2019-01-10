#!/bin/bash
#Crea il pacchetto di installazione per banana usando il appimagekit
#
#Changelog:
#

programname=$0

isBeta=""
isExperimental=""

while getopts ":bxh" opt; do
    case $opt in
       b )
          isBeta="1"
          ;;
       x )
          isExperimental="1"
          ;;
       \? )
          echo "Invalid option: -$OPTARG" >&2
          exit 2
          ;;
       h )
          echo "Usage: $programname [OPTION]"
          echo "Create a install package for Banana 9 64 bit."
          echo "  -b        Create a package for the beta release (with an expiring license)"
          echo "  -x        Create a package for the experimental release"
          echo "  -h        Display this help"
          exit 2
          ;;
    esac
done

#Imposta i percorsi
bananaExeNameBuild=banana90
bananaPackageName=banana9
if [ "$isExperimental" == "1" ] ; then
   echo "Creating installer for Banana Experimental 9"
   bananaExeNameFinale=bananaExperimental9
   bananaInstallerNameFinale=bananaexpm9-setup
elif [ "$isBeta" == "1" ] ; then
   echo "Creating installer for Banana Beta 9"
   bananaExeNameFinale=banana9beta
   bananaInstallerNameFinale=banana9-beta-setup
else
   echo "Creating installer for Banana 9"
   bananaExeNameFinale=banana9
   bananaInstallerNameFinale=banana9-setup
fi

scriptDir=$(readlink -f  "$(dirname "${BASH_SOURCE[0]}")")
baseDir=$(readlink -f  "$scriptDir/../..")
baseDirInstaller=$baseDir/installer
originalBinDir=$baseDir/build-release

qtVersion=5.12
qtDir=~/Qt/5.12.0
extraLibDir=$baseDir/libs/lib/linux

#Leggi versione programma dal file banana.h
bananaDefineFile="$baseDir/src/base/banana.h"
pkgVersion=$(grep T_VERSION_SERIALNUMBER $bananaDefineFile)
pkgVersion=$(echo "$pkgVersion" | sed -n 's|.*T_VERSION_SERIALNUMBER *"\([^"]*\)".*|\1|p')
pkgVersion=$(echo "$pkgVersion" | sed -n 's|\(.\).\(.\).\(.\)-\(.*\)|\1.\2.\3.\4|p')
if [ -z "$pkgVersion" ] ; then
   echo "Unable to retrieve version from file $bananaDefineFile"
   exit 1;
fi

#Verifica che i files eseguibili siano presenti
if [ ! -f "$originalBinDir/$bananaExeNameBuild" ]; then
   echo "Eseguibile applicazione $originalBinDir/$bananaExeNameBuild non trovato"
   echo "Verificare la build directory ed eseguire il build del progetto $bananaExeNameBuild"
   exit
fi

outPackageDir=$scriptDir/output/$bananaExeNameFinale
outUsrDir=$outPackageDir/usr
outBinDir=$outUsrDir/bin
outLibDir=$outUsrDir/lib
outShareDir=$outPackageDir/usr/share

qtGcc=$qtDir/gcc_64
qtLibDir=$qtGcc/lib
qtPluginsDir=$qtGcc/plugins
qtQmlDir=$qtGcc/qml

#Crea cartella output
rm -r $scriptDir/output/*
mkdir -p $outBinDir
mkdir -p $outLibDir
mkdir -p $outShareDir/Lang
mkdir -p $outShareDir/Fonts
mkdir -p $outShareDir/License
mkdir -p $outShareDir/Ssl
mkdir -p $outShareDir/Templates
mkdir -p $outShareDir/icons

#Copia icone
cp $baseDir/src/resources/png/banico* $outShareDir/icons

#Copia librerie
cp $extraLibDir/libhpdf.so $outLibDir
cp $extraLibDir/qt$qtVersion/libQtWebApp.so* $outLibDir

#copia librerie aggiuntive
cp /lib/x86_64-linux-gnu/libpng12.so.0 $outLibDir

#symlink a openssl 1.0.2
ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 $outLibDir/libssl.so
ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 $outLibDir/libcrypto.so

#copia librerie Qt
cp -r $qtLibDir/libicuuc.so.5* $outLibDir
cp -r $qtLibDir/libicui18n.so.5* $outLibDir
cp -r $qtLibDir/libicudata.so.5* $outLibDir

cp -r $qtLibDir/libQt5Core.so.5* $outLibDir
cp -r $qtLibDir/libQt5DBus.so.5* $outLibDir
cp -r $qtLibDir/libQt5Gui.so.5* $outLibDir
cp -r $qtLibDir/libQt5Network.so.5* $outLibDir
cp -r $qtLibDir/libQt5Positioning.so.5* $outLibDir
cp -r $qtLibDir/libQt5PrintSupport.so.5* $outLibDir
cp -r $qtLibDir/libQt5Qml.so.5* $outLibDir
cp -r $qtLibDir/libQt5Quick.so.5* $outLibDir
cp -r $qtLibDir/libQt5QuickControls2.so.5* $outLibDir
cp -r $qtLibDir/libQt5QuickTemplates2.so.5* $outLibDir
cp -r $qtLibDir/libQt5QuickWidgets.so.5* $outLibDir
cp -r $qtLibDir/libQt5SerialPort.so.5* $outLibDir
cp -r $qtLibDir/libQt5Svg.so.5* $outLibDir
cp -r $qtLibDir/libQt5Test.so.5* $outLibDir
cp -r $qtLibDir/libQt5Widgets.so.5* $outLibDir
cp -r $qtLibDir/libQt5XcbQpa.so.5* $outLibDir
cp -r $qtLibDir/libQt5X11Extras.so* $outLibDir
cp -r $qtLibDir/libQt5Xml.so.5* $outLibDir
cp -r $qtLibDir/libQt5XmlPatterns.so.5* $outLibDir


#Copia WebEngine
mkdir -p $outUsrDir/plugins
cp -r $qtPluginsDir/bearer $outUsrDir/plugins
cp -r $qtPluginsDir/iconengines $outUsrDir/plugins
cp -r $qtPluginsDir/imageformats $outUsrDir/plugins
cp -r $qtPluginsDir/platforminputcontexts $outUsrDir/plugins
cp -r $qtPluginsDir/platforms $outUsrDir/plugins
cp -r $qtPluginsDir/position $outUsrDir/plugins
cp -r $qtPluginsDir/printsupport $outUsrDir/plugins
cp -r $qtPluginsDir/xcbglintegrations $outUsrDir/plugins
cp $scriptDir/resources/qt.conf $outBinDir
cp -r $qtGcc/libexec/* $outBinDir
cp -r $qtGcc/resources $outUsrDir
mkdir $outUsrDir/translations
cp -r $qtGcc/translations/qtwebengine_locales $outUsrDir/translations

cp -r $qtLibDir/libQt5WebChannel.so.5* $outLibDir
cp -r $qtLibDir/libQt5WebEngine.so.5* $outLibDir
cp -r $qtLibDir/libQt5WebEngineCore.so.5* $outLibDir
cp -r $qtLibDir/libQt5WebEngineWidgets.so.5* $outLibDir
cp -r $qtLibDir/libQt5WebChannel.la $outLibDir

rm $outLibDir/*.debug

#Copia moduli Qml
mkdir $outUsrDir/qml
mkdir -p $outUsrDir/qml/Qt/labs
cp -r $qtQmlDir/Qt/labs/folderlistmodel $outUsrDir/qml/Qt/labs
cp -r $qtQmlDir/Qt/labs/settings $outUsrDir/qml/Qt/labs
cp -r $qtQmlDir/QtGraphicalEffects $outUsrDir/qml
cp -r $qtQmlDir/QtQml $outUsrDir/qml
cp -r $qtQmlDir/QtQuick $outUsrDir/qml
cp -r $qtQmlDir/QtQuick.2 $outUsrDir/qml


#Copia traduzioni, esempi, fonts e licenza
rsync -r --exclude=.svn $baseDirInstaller/Lang/*.qm $outShareDir/Lang
rsync -r --exclude=.svn $baseDirInstaller/Fonts/*.* $outShareDir/Fonts
rsync -r --exclude=.svn $baseDirInstaller/Ssl/*.pem $outShareDir/Ssl
rsync -r --exclude=.svn $baseDirInstaller/Ssl/*.key $outShareDir/Ssl
rsync -r --exclude=.svn $baseDirInstaller/License/ $outShareDir/License
rsync -r --exclude=.svn --exclude=*.bak $baseDirInstaller/Templates/ $outShareDir/Templates

#Copia eseguibile
strip -s -o $outBinDir/$bananaExeNameFinale $originalBinDir/$bananaExeNameBuild
chmod a+x $outBinDir/$bananaExeNameFinale

#crea AppRun
cp $scriptDir/resources/AppRun $outPackageDir
echo '$dirname'/usr/bin/$bananaExeNameFinale '"$@"' >> $outPackageDir/AppRun
chmod a+x $outPackageDir/AppRun

#copia file .desktop e metadata
#mkdir -p $outShareDir/metainfo
#cp $scriptDir/resources/metadata.xml $outShareDir/metainfo/$bananaExeNameFinale.appdata.xml
#sed -i "s/@progrId@/$bananaExeNameFinale/g" $outShareDir/metainfo/$bananaExeNameFinale.appdata.xml
#sed -i "s/@progrSuffix@/$suffixName/g" $outShareDir/metainfo/$bananaExeNameFinale.appdata.xml

cp $baseDir/src/resources/svg/banico.svg $outPackageDir
cp $scriptDir/resources/file.desktop $outShareDir
cp $scriptDir/resources/mime-ac2.xml $outShareDir

#scarica AppImageTool, commentare se aggiornato
#wget -c https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
#chmod a+x appimagetool-x86_64.AppImage

#crea appImage
desktopFile=$outPackageDir/$bananaExeNameFinale.desktop
cp $scriptDir/resources/file.desktop $desktopFile
sed -i "s:@name@:$bananaExeNameFinale:g" $desktopFile
sed -i "s:@exepath@:$outBinDir/AppRun:g" $desktopFile
$scriptDir/appimagetool-x86_64.AppImage $outPackageDir

#crea pacchetto tgz
mv $outPackageDir/AppRun $outPackageDir/start_$bananaExeNameFinale.sh
cp $scriptDir/resources/README.txt $outPackageDir/
rm $desktopFile
cp $scriptDir/resources/file.desktop $desktopFile
sed -i "s:@name@:$bananaExeNameFinale:g" $desktopFile
cp $scriptDir/resources/install-banana.sh $outPackageDir/
sed -i "s:@name@:$bananaExeNameFinale:g" $outPackageDir/install-banana.sh
chmod +x $outPackageDir/install-banana.sh


tar -czf $bananaExeNameFinale.tar.gz -C $outPackageDir .

mv $scriptDir/ban* $scriptDir/output
