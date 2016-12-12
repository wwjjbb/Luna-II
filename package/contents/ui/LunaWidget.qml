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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import "plasmapackage:/code/phases.js" as Phases
import "plasmapackage:/code/lunacalc.js" as LunaCalc

Item {
	id: lunaWidget
//	width: labelButtonColumn.width + 20 // dirty hack to have 10px margins around the contents
	width: maximumWidth
//	height: labelButtonColumn.height + 20 // idem
	height: maximumHeight // dirty hack: since the highlight of a PlasmaComponents.ToolButton is wider than the button itself, we must calculate the maximum height in order to avoid resizing the dialog each time a button is pressed
	focus: true // needs to be focused, otherwise the key events aren't caught

	property variant dateFormat: Qt.DefaultLocaleLongDate;
	property int maximumWidth: 0
	property int maximumHeight: 0

	Component.onCompleted: {
		plasmoid.addEventListener("ConfigChanged", configChanged);
		configChanged();
		showTodayPhases();
	}

	function configChanged() {
		setDateFormat(plasmoid.readConfig("dateFormat"), plasmoid.readConfig("dateFormatString"));
	}

	function update() {
		showTodayPhases();
	}

	Keys.onUpPressed: showPreviousPhases()
	Keys.onLeftPressed: showPreviousPhases()
	Keys.onRightPressed: showNextPhases()
	Keys.onDownPressed: showNextPhases()
	Keys.onPressed: {
		if (event.key == Qt.Key_Home)
			showTodayPhases();
		else if (event.key == Qt.Key_PageUp)
			showPreviousPhases();
		else if (event.key == Qt.Key_PageDown)
			showNextPhases();
	}

	function setDateFormat(format, formatString) {
		if (format == 0)
			lunaWidget.dateFormat = Qt.TextDate;
		else if (format == 1)
			lunaWidget.dateFormat = Qt.DefaultLocaleShortDate;
		else if (format == 2)
			lunaWidget.dateFormat = Qt.DefaultLocaleLongDate;
		else if (format == 3)
			lunaWidget.dateFormat = Qt.ISODate;
		else
			lunaWidget.dateFormat = formatString;
		showPhases(LunaCalc.reloadPhases());
	}

	function showPhases(phases) {
		lastNewText.text = Qt.formatDateTime(phases[0], dateFormat);
		firstQuarterText.text = Qt.formatDateTime(phases[1], dateFormat);
		fullMoonText.text = Qt.formatDateTime(phases[2], dateFormat);
		thirdQuarterText.text = Qt.formatDateTime(phases[3], dateFormat);
		nextNewText.text = Qt.formatDateTime(phases[4], dateFormat);
		lunaWidget.focus = true;
		maximumWidth = Math.max(maximumWidth, labelButtonColumn.width + 20);
	}

	function showTodayPhases() {
		showPhases(LunaCalc.getTodayPhases());
	}

	function showPreviousPhases() {
		showPhases(LunaCalc.getPreviousPhases());
	}

	function showNextPhases() {
		showPhases(LunaCalc.getNextPhases());
	}

	MouseEventListener {
		anchors.fill: parent
		onWheelMoved: {
			if (wheel.delta > 0)
				showNextPhases();
			else
				showPreviousPhases();
		}
	}

	Column {
		id: labelButtonColumn
//		anchors.centerIn: lunaWidget
		anchors.top: lunaWidget.top
		anchors.topMargin: 10
		anchors.horizontalCenter: lunaWidget.horizontalCenter
		spacing: 10
		onHeightChanged: maximumHeight = Math.max(maximumHeight, height + 20);
		Grid {
			id: labelArea
			columns: 2
			flow: Grid.LeftToRight
			PlasmaComponents.Label {
				id: lastNewLabel
				text: i18n("Last new:") + "  "
			}
			PlasmaComponents.Label {
				id: lastNewText
			}
			PlasmaComponents.Label {
				id: firstQuarterLabel
				text: i18n("First quarter:") + "  "
			}
			PlasmaComponents.Label {
				id: firstQuarterText
			}
			PlasmaComponents.Label {
				id: fullMoonLabel
				text: i18n("Full moon:") + "  "
			}
			PlasmaComponents.Label {
				id: fullMoonText
			}
			PlasmaComponents.Label {
				id: thirdQuarterLabel
				text: i18n("Third quarter:") + "  "
			}
			PlasmaComponents.Label {
				id: thirdQuarterText
			}
			PlasmaComponents.Label {
				id: nextNewLabel
				text: i18n("Next new:") + "  "
			}
			PlasmaComponents.Label {
				id: nextNewText
			}
		}
		Row {
			id: buttonRow
			anchors.horizontalCenter: parent.horizontalCenter
			PlasmaComponents.ToolButton {
				id: previousButton
				iconSource: "go-previous"
				onClicked: showPreviousPhases();
			}
			PlasmaComponents.ToolButton {
				id: todayButton
				iconSource: "go-jump-today"
				onClicked: showTodayPhases();
			}
			PlasmaComponents.ToolButton {
				id: nextButton
				iconSource: "go-next"
				onClicked: showNextPhases();
			}
		}
	}
}
