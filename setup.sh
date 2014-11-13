#!/bin/bash
done_message () {
    if [ $? == 0 ]; then
        echo " done."
        if [ "x$1" != "x" ]; then
            echo $1;
        fi
    else
        echo " failed.  See setup.log file for error messages." $2
    fi
}

echo > setup.log;
echo -n "Installing Perl prerequisites ..."
if ! ( perl -MExtUtils::MakeMaker -e 1 >/dev/null 2>&1); then
    echo;
    echo "WARNING: Your Perl installation does not seem to include a complete set of core modules.  Attempting to cope with this, but if installation fails please make sure that at least ExtUtils::MakeMaker is installed.  For most users, the best way to do this is to use your system's package manager: apt, yum, fink, homebrew, or similar.";
fi;
( set -x;
  bin/cpanm -v --notest -l extlib Crypt::PBKDF2 DBI DBD::Pg < /dev/null;
  cd src/main/webapp/jbrowse;
  bin/cpanm -v --notest -l ../../../../extlib/ --installdeps .< /dev/null;
  bin/cpanm -v --notest -l ../../../../extlib/ --installdeps .< /dev/null;
  set -e;
  bin/cpanm -v --notest -l ../../../../extlib/ --installdeps .< /dev/null;
  cd -;
  cp -r src/main/webapp/jbrowse/bin/ bin;
  cp -r src/main/webapp/jbrowse/src/perl5 src/perl5;
) >>setup.log 2>&1;
done_message "" "As a first troubleshooting step, make sure development libraries and header files for GD, Zlib, and libpng are installed and try again.";
