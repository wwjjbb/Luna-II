#!/bin/sh

# based on example found here:
#   https://techbase.kde.org/Development/Tutorials/Localization/i18n_Build_Systems

BUGADDR="https://github.com/wwjjbb/Luna-II/issues"	# MSGID-Bugs

BASEDIR=".."	# root of translatable sources
METADATA="../../metadata.desktop"
WDIR=`pwd`		# working dir

PROJECT=plasma_applet_$(grep "X-KDE-PluginInfo-Name" $METADATA | sed 's/.*=//')
VERSION=$(grep "X-KDE-PluginInfo-Version" $METADATA | sed 's/.*=//')

RCSCRIPT="$WDIR/rc.js"

echo "Preparing rc files"

cd ${BASEDIR}

# additional string for KAboutData
echo 'i18nc("NAME OF TRANSLATORS","Your names");' > $RCSCRIPT
echo 'i18nc("EMAIL OF TRANSLATORS","Your emails");' >> $RCSCRIPT

cd ${WDIR}

echo "Done preparing rc files"

echo "Extracting messages"

cd ${BASEDIR}

# see above on sorting
find . -name '*.qml' -o -name '*.js' | sort > ${WDIR}/infiles.list

cd ${WDIR}
xgettext --from-code=UTF-8 -C -kde -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 -ktr2i18n:1 \
	-kI18N_NOOP:1 -kI18N_NOOP2:1c,2 -kaliasLocale -kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3 \
	--msgid-bugs-address="${BUGADDR}" \
	--files-from=infiles.list -D ${BASEDIR} -D ${WDIR} -o ${PROJECT}.pot || { echo "error while calling xgettext. aborting."; exit 1; }

echo "Done extracting messages"


echo "Merging translations"

catalogs=$(find . -name '*.po')
for cat in $catalogs; do
  echo $cat
  msgmerge -o $cat.new $cat ${PROJECT}.pot
  mv $cat.new $cat
done

echo "Done merging translations"

echo "Generating mo files"

catalogs=$(find . -name '*.po')
for cat in $catalogs; do
  echo $cat
	catdir=locale/${cat%.*}/LC_MESSAGES
	mkdir -p $catdir
  msgfmt $cat -o $catdir/$PROJECT.mo
done

echo "Done generating mo files"



echo "Cleaning up"
cd ${WDIR}
rm infiles.list
rm $RCSCRIPT

echo "Done"
