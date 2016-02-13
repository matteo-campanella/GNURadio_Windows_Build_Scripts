# GNURadio Windows Build System
# Geof Nieboer

#setup
$root = $env:grwinbuildroot 
if (!$root) {$root = "C:\gr-build"}
cd $root
set-alias sz "$root\bin\7za.exe"  
Add-Type -assembly "system.io.compression.filesystem"

# Check for binary dependencies
if (-not (test-path "$root\bin\7za.exe")) {throw "7-zip (7za.exe) needed in bin folder"} 

#check for git/tar
if (-not (test-path "$env:ProgramFiles\Git\usr\bin\tar.exe")) {throw "Git For Windows must be installed"} 
set-alias tar "$env:ProgramFiles\Git\usr\bin\tar.exe"  

# Retrieve packages needed for Stage 1
cd $root/src-stage1-dependencies

# portaudio v19
if (!(Test-Path $root/packages/portaudio)) {
	mkdir $root/packages/portaudio
}
if (!(Test-Path $root/packages/portaudio/pa_stable_v19_20140130.tgz)) {
	cd $root/packages/portaudio
	wget http://portaudio.com/archives/pa_stable_v19_20140130.tgz -OutFile pa_stable_v19_20140130.tgz
} else {
	"portaudio already present"
}
if (!(Test-Path $root/src-stage1-dependencies/portaudio)) {
	$archive = "$root/packages/portaudio/pa_stable_v19_20140130.tgz"
	$archive2 = "pa_stable_v19_20140130.tar"
	$destination = "$root/src-stage1-dependencies/portaudio"
	cd $root/src-stage1-dependencies/
	sz x $archive 2>&1 | write-host
	sz x $archive2 2>&1 | write-host
	del $archive2 
}

# asio SDK for portaudio
# folder will already exist
if (!(Test-Path $root/packages/portaudio/asiosdk2.3.zip)) {
	cd $root/packages/portaudio
	wget http://www.steinberg.net/sdk_downloads/asiosdk2.3.zip -OutFile asiosdk2.3.zip
} else {
	"ASIO SDK already present"
}
if (!(Test-Path $root/src-stage1-dependencies/portaudio/src/hostapi/asio/asiosdk)) {
	$archive = "$root/packages/portaudio/asiosdk2.3.zip"
	$destination = "$root/src-stage1-dependencies/portaudio/src/hostapi/asio"
	[io.compression.zipfile]::ExtractToDirectory($archive, $destination)
	cd $destination
	ren asiosdk2.3 asiosdk
}

# VS2015 project files
if (!(Test-Path $root/packages/portaudio/portaudio_vs2015.7z)) {
	cd $root/packages/portaudio
	wget http://www.gcndevelopment.com/gnuradio/downloads/sources/portaudio_vs2015.7z -OutFile portaudio_vs2015.7z
} else {
	"portaudio VS project already present"
}
if (!(Test-Path $root/src-stage1-dependencies/portaudio/build/msvc/portaudio.vcxproj)) {
	$archive = "$root/packages/portaudio/portaudio_vs2015.7z"
	$destination = "$root/src-stage1-dependencies/portaudio/build/msvc/"
	cd $destination
	sz x $archive 2>&1 | write-host
}

# cppunit 1.12.1
if (!(Test-Path $root/packages/cppunit-1.12.1)) {
	mkdir $root/packages/cppunit-1.12.1
}
if (!(Test-Path $root/packages/cppunit-1.21.1/cppunit-1.12.1.7z)) {
	cd $root/packages/cppunit-1.12.1
	wget http://www.gcndevelopment.com/gnuradio/downloads/sources/cppunit-1.12.1.7z -OutFile cppunit-1.12.1.7z
} else {
	"cppunit-1.12.1 already present"
}
if (!(Test-Path $root/src-stage1-dependencies/cppunit-1.12.1)) {
	cd $root/src-stage1-dependencies
	$archive = "$root/packages/cppunit-1.12.1/cppunit-1.12.1.7z"
	$destination = "$root/src-stage1-dependencies/cppunit-1.12.1"
	cd $root/src-stage1-dependencies/
	sz x $archive
}

# fftw3.3.5
if (!(Test-Path $root/packages/fftw-3.3.5)) {
	mkdir $root/packages/fftw-3.3.5
}
if (!(Test-Path $root/packages/fftw-3.3.5/fftw-3.3.5.7z)) {
	cd $root/packages/fftw-3.3.5
	wget http://www.gcndevelopment.com/gnuradio/downloads/sources/fftw-3.3.5.7z -OutFile fftw-3.3.5.7z
} else {
	"FFTW3 already present"
}
if (!(Test-Path $root/src-stage1-dependencies/fftw-3.3.5)) {
	cd $root/src-stage1-dependencies
	$archive = "$root/packages/fftw-3.3.5/fftw-3.3.5.7z"
	$destination = "$root/src-stage1-dependencies/fftw-3.3.5"
	cd $root/src-stage1-dependencies/
	sz x $archive
}

#python
if (!(Test-Path $root/packages/python27)) {
	mkdir $root/packages/python27
}
if (!(Test-Path $root/packages/python27/python2710-x64-Source.zip)) {
	cd $root/packages/python27
	wget http://www.gcndevelopment.com/gnuradio/downloads/libraries/python27/python2710-x64-Source.zip -OutFile python2710-x64-Source.zip
} else {
	"python already present"
}
if (!(Test-Path $root/packages/python27/python-pcbuild.vc14.zip)) {
	cd $root/packages/python27
	wget http://www.gcndevelopment.com/gnuradio/downloads/sources/python-pcbuild.vc14.zip -OutFile pcbuild.vc14.zip
} else {
	"python already present"
}
if (!(Test-Path $root/src-stage1-dependencies/python27)) {
	cd $root/src-stage1-dependencies
	$BackupPath = "$root/packages/python27/python2710-x64-Source.zip"
	$destination = "$root/src-stage1-dependencies/python27"
	[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)
	$BackupPath = "$root/packages/python27/pcbuild.vc14.zip"
	$destination = "$root/src-stage1-dependencies/python27/Python-2.7.10"
	[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)
}

# zlib
if (!(Test-Path $root/src-stage1-dependencies/zlib)) {
		cd $root/src-stage1-dependencies
		git clone https://github.com/gnieboer/zlib.git 2>&1 | write-host 
	} else {
		"zlib already present";
	}

#libsodium
if (!(Test-Path $root/src-stage1-dependencies/libsodium)) {
		cd $root/src-stage1-dependencies
	git clone https://github.com/gnieboer/libsodium.git 2>&1 | write-host 
	} else {
		"libsodium already present";
	}

#GSL
if (!(Test-Path $root/packages/GSL)) {
	mkdir $root/packages/GSL
}
if (!(Test-Path $root/packages/GSL/gsl-vs2015-3276.zip)) {
	cd $root/packages/GSL
	wget http://www.gcndevelopment.com/gnuradio/downloads/sources/customwingsl2015-3276.zip -OutFile gsl-vs2015-3276.zip
} else {
	"GSL already present"
}
if (!(Test-Path $root/src-stage1-dependencies/gsl-1.16)) {
	cd $root/src-stage1-dependencies
	$BackupPath = "$root/packages/GSL/gsl-vs2015-3276.zip"
	$destination = "$root/src-stage1-dependencies/gsl-1.16"
	[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)
}

#openssl
$openssl_version = "1.0.2f"
if (!(Test-Path $root/packages/openssl)) {
	mkdir $root/packages/openssl 
}
if (!(Test-Path $root/packages/openssl/openssl-$openssl_version.tar.gz)) {
	cd $root/packages/openssl
	wget ftp://ftp.openssl.org/source/openssl-$openssl_version.tar.gz -OutFile openssl-$openssl_version.tar.gz
} 
if (!(Test-Path $root/packages/openssl/openssl-vs14.zip)) {
	cd $root/packages/openssl
	wget http://www.gcndevelopment.com/gnuradio/downloads/sources/openssl-vs14.zip -OutFile openssl-vs14.zip
} 
if (!(Test-Path $root/src-stage1-dependencies/openssl)) {
	cd $root/src-stage1-dependencies
	$BackupPath = "../packages/openssl/openssl-$openssl_version.tar.gz"
	$destination = "$root/src-stage1-dependencies"
	tar zxf $BackupPath 2>&1 | write-host 
	ren openssl-$openssl_version openssl
}
if (!(Test-Path $root/src-stage1-dependencies/openssl/openssl.vcxproj)) {
	cd $root/src-stage1-dependencies
	$BackupPath = "$root/packages/openssl/openssl-vs14.zip"
	$destination = "$root/src-stage1-dependencies/openssl"
	[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)
}

# Qt
if (!(Test-Path $root/packages/Qt4)) {
	mkdir $root/packages/Qt4 
}
if (!(Test-Path $root/packages/Qt4/qt-everywhere-opensource-src-4.8.7.zip)) {
	cd $root/packages/Qt4
	wget http://download.qt.io/archive/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.7.zip
} 

if (!(Test-Path $root/src-stage1-dependencies/Qt4)) {
	cd $root/src-stage1-dependencies
	$BackupPath = "$root/packages/Qt4/qt-everywhere-opensource-src-4.8.7.zip"
	$destination = "$root/src-stage1-dependencies"
	[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)
	ren qt-everywhere-opensource-src-4.8.7 Qt4
}

# Boost
if (!(Test-Path $root/packages/boost)) {
	mkdir $root/packages/boost 
}
if (!(Test-Path $root/packages/boost/boost_1_60_0.zip)) {
	cd $root/packages/boost
	wget "http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.zip" -OutFile boost_1_60_0.zip  -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox
} 
if (!(Test-Path $root/src-stage1-dependencies/boost)) {
	cd $root/src-stage1-dependencies
	$BackupPath = "$root/packages/boost/boost_1_60_0.zip"
	$destination = "$root/src-stage1-dependencies"
	[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)
	ren boost_1_60_0 boost
}

# cleanup

# return to original directory
cd $root/scripts