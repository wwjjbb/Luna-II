/**

    Copyright (C) 2011, 2012, 2013 Glad Deschrijver <glad.deschrijver@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

import "plasmapackage:/code/phases.js" as Phases
import "plasmapackage:/code/lunacalc.js" as LunaCalc

Item {
	id: main
	property int minimumWidth
	property int minimumHeight
	property int maximumWidth
	property int maximumHeight
	property int preferredWidth
	property int preferredHeight

	Component.onCompleted: {
		// refresh moon image
		plasmoid.addEventListener("dataUpdated", dataUpdated);
		dataEngine("time").connectSource("Local", main, 360000, PlasmaCore.AlignToHour);

		// change configuration
		plasmoid.addEventListener("ConfigChanged", configChanged);
		configChanged();

		plasmoid.setAspectRatioMode(ConstrainedSquare);
	}

	function dataUpdated(source, data) {
		// set the correct image for the moon
		var currentPhase = LunaCalc.getCurrentPhase();
		lunaIcon.phaseNumber = currentPhase.number

		// set tooltip text
		lunaToolTip.mainText = currentPhase.text;
		lunaToolTip.subText = currentPhase.subText;

		// update values in dialog
		if (lunaDialogLoader.source != "")
			lunaDialogLoader.item.update();
	}

	function configChanged() {
		if (plasmoid.formFactor != Horizontal
		    && plasmoid.formFactor != Vertical
		    && plasmoid.readConfig("showBackground") == true)
			plasmoid.setBackgroundHints(DefaultBackground);
		else
			plasmoid.setBackgroundHints(NoBackground);
	}

	LunaIcon {
		id: lunaIcon
		anchors.fill: parent
	}

	PlasmaCore.ToolTip {
		id: lunaToolTip
		target: main
		mainText: i18n("Luna")
	}

	MouseArea {
		id: toggleDialogHandler
		anchors.fill: main
		onClicked: {
			if (lunaDialogLoader.source == "")
				lunaDialogLoader.source = Qt.resolvedUrl("LunaDialog.qml");
			lunaDialogLoader.item.toggleShown(main);
		}
	}

	Loader {
		id: lunaDialogLoader
	}
}
