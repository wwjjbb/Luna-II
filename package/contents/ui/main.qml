/**

    Copyright 2016 Bill Binder <dxtwjb@gmail.com>
    Updated the Luna QML plasmoid from Plasma 4 to Plasma 5.
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

import QtQuick 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import QtQuick.Layouts 1.2 as QtLayouts
import QtQuick.Controls 1.2 as QtControls
import org.kde.plasma.components 2.0 as PlasmaComponents

import "../code/phases.js" as Phases
import "../code/lunacalc.js" as LunaCalc

Item {
    id: main
    property int minimumWidth
    property int minimumHeight
    property int maximumWidth
    property int maximumHeight
    property int preferredWidth
    property int preferredHeight
    property var currentPhase

    property bool showBackground: Plasmoid.configuration.showBackground
    property int hemisphere: Plasmoid.configuration.hemisphere
    property int dateFormat: Plasmoid.configuration.dateFormat
    property string dateFormatString: Plasmoid.configuration.dateFormatString

    Plasmoid.backgroundHints: showBackground ? "DefaultBackground" : "NoBackground"
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.icon: ""
    Plasmoid.toolTipMainText: currentPhase.text
    Plasmoid.toolTipSubText: currentPhase.subText

    Plasmoid.compactRepresentation: Item {
        id: compact

        property int hemisphere: main.hemisphere
        property bool showBackground: main.showBackground

        Component.onCompleted: updateDetails()

        onHemisphereChanged: updateDetails()

        function updateDetails() {
            // set the correct image for the moon
            currentPhase = LunaCalc.getCurrentPhase();
            lunaIcon.phaseNumber = currentPhase.number;
            lunaIcon.hemisphere = hemisphere;
        }

        Timer {
            id: hourlyTimer
            interval: 60 * 60 * 1000 // 60 minutes
            repeat: true
            running: true
            onTriggered: updateDetails()
        }

        LunaIcon {
            id: lunaIcon
            hemisphere: hemisphere
            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                onClicked: plasmoid.expanded = !plasmoid.expanded
            }
        }

    }

    Plasmoid.fullRepresentation: Item {
        id: full

        QtLayouts.Layout.preferredWidth: lunaWidget.QtLayouts.Layout.minimumWidth
        QtLayouts.Layout.preferredHeight: lunaWidget.QtLayouts.Layout.minimumHeight

        property int dateFormat: main.dateFormat
        property string dateFormatString: main.dateFormatString

        //onLw_widthChanged: width = lw_width //console.log("It changed! " + lw_width.toString())

        onDateFormatChanged: {
            lunaWidget.dateFormat = dateFormat;
        }

        onDateFormatStringChanged: {
            lunaWidget.dateFormatString = dateFormatString;
        }

        LunaWidget {
            id: lunaWidget
            dateFormat: dateFormat
            dateFormatString: dateFormatString
        }
    }
}
