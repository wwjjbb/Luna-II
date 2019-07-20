/**
    Copyright 2016 Bill Binder <dxtwjb@gmail.com>

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
import QtQuick.Controls 1.2 as QtControls
import QtQuick.Layouts 1.2 as QtLayouts
import QtQuick.Dialogs 1.0 as QtDialogs

import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: generalPage

    property alias cfg_hemisphere: hemisphere.currentIndex  // 0=North 1=South
    property alias cfg_transparentShadow: transparentShadow.checked  // boolean
    property alias cfg_showBackground: showBackground.checked  // boolean
    property alias cfg_dateFormat: dateFormat.currentIndex // code: 0= 1= 2=...
    property alias cfg_dateFormatString: dateFormatString.text
    property alias cfg_diskColour: diskColour.color

    property int cfg_lunarIndex: 0        // index into imageChoices
    property string cfg_lunarImage: ''    // filename (from imageChoices)
    property int cfg_lunarImageTweak: 0   // rotation angle adjustment for the image (from imageChoices)

    property alias cfg_showGrid: showGrid.checked
    property alias cfg_showTycho: showTycho.checked
    property alias cfg_showCopernicus: showCopernicus.checked

    onCfg_lunarIndexChanged: {
        cfg_lunarImage = imageChoices.get(cfg_lunarIndex).filename
        cfg_lunarImageTweak = imageChoices.get(cfg_lunarIndex).tweak
      }

    ImageChoices {
        id: imageChoices
    }

    QtDialogs.ColorDialog {
        id: colorDialog
        title: i18n("Pick a colour for the moon")
        visible: false

        onAccepted: {
            diskColour.color = colorDialog.color
        }
    }

    QtLayouts.GridLayout {
        columns: 2
        rowSpacing: 15

        QtControls.Label {
            text: i18n("Preview")
        }
        QtLayouts.RowLayout {
            spacing: 20

            PlasmaComponents.ToolButton {
                id: previousButton
                iconSource: "go-previous"
                enabled: cfg_lunarIndex > 0
                onClicked: {
                    cfg_lunarIndex -= 1
                }
            }

            LunaIcon {
              id: lunaPreview
              width: 200
              height: 200
              hemisphere: cfg_hemisphere
              showShadow: false
              transparentShadow: false
              lunarImage: cfg_lunarImage
              lunarImageTweak: cfg_lunarImageTweak
              diskColour: cfg_diskColour
              showGrid: cfg_showGrid
              showTycho: cfg_showTycho
              showCopernicus: cfg_showCopernicus
            }

            PlasmaComponents.ToolButton {
                id: nextButton
                iconSource: "go-next"
                enabled: cfg_lunarIndex < imageChoices.count-1
                onClicked: {
                    cfg_lunarIndex += 1
                }
            }

            QtLayouts.ColumnLayout {
                spacing: 20

                QtControls.CheckBox {
                    id: showGrid
                    text: i18n("Show grid")
                }

                QtControls.CheckBox {
                    id: showTycho
                    text: i18n("Tycho")
                }

                QtControls.CheckBox {
                    id: showCopernicus
                    text: i18n("Copernicus")
                }

            }
        }

        QtControls.Label {
            text: i18n("Disk Colour")
            visible: cfg_lunarImage === ""
        }
        Rectangle {
            id: diskColour
            width: 50
            height: 50
            color: '#808040'
            border.color: '#000000'
            radius: height/2
            visible: cfg_lunarImage === ""

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    colorDialog.color = diskColour.color
                    colorDialog.visible = true
                }
            }
        }

        QtControls.Label {
            text: i18n("Hemisphere")
        }
        QtControls.ComboBox {
            id: hemisphere
            QtLayouts.Layout.fillWidth: true
            textRole: "key"
            model: ListModel {
                dynamicRoles: true
                Component.onCompleted: {
                append({key : i18n("Northern"), value: 0 })
                append({key : i18n("Southern"), value: 1 })
                }
            }
        }

        QtControls.Label {
            text: i18n("Date Format")
        }
        QtControls.ComboBox {
            id: dateFormat
            QtLayouts.Layout.fillWidth: true
            textRole: "key"
            model: ListModel {
                dynamicRoles: true
                Component.onCompleted: {
                append({ key: i18n("Text date"), value: 0 })
                append({ key: i18n("Short date"), value: 1 })
                append({ key: i18n("Long date"), value: 2 })
                append({ key: i18n("ISO date"), value: 3 })
                append({ key: i18n("Custom"), value: 4 })
                }
            }
        }

        QtControls.Label {
            text: i18n("Date Format String")
            visible: dateFormat.currentIndex == 4
        }
        QtControls.TextField {
            id: dateFormatString
            maximumLength: 24
            visible: dateFormat.currentIndex == 4
        }

        QtControls.CheckBox {
            id: transparentShadow
            text: i18n("Transparent shadow")
        }
        QtControls.CheckBox {
            id: showBackground
            text: i18n("Show background")
        }
        QtControls.Label {
            text: ""
        }

    }
}
