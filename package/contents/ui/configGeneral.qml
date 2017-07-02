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

Item {
    id: generalPage

    property alias cfg_hemisphere: hemisphere.currentIndex  // 0=North 1=South
    property alias cfg_showBackground: showBackground.checked  // boolean
    property alias cfg_dateFormat: dateFormat.currentIndex // code: 0= 1= 2=...
    property alias cfg_dateFormatString: dateFormatString.text

    property alias cfg_lunarIndex: lunarImageSelection.currentIndex
    property alias cfg_lunarImage: lunarImageSelection.filename // filename
    property alias cfg_lunarImageTweak: lunarImageSelection.tweak // rotation angle adjustment for the image

    QtLayouts.GridLayout {
        columns: 2
        rowSpacing: 15

        QtControls.Label {
          text: i18n("Preview")
        }
        QtLayouts.RowLayout {
            spacing: 20
            LunaIcon {
              id: lunaPreview
              width: 200
              height: 200
              hemisphere: cfg_hemisphere
              showShadow: false
              lunarImage: cfg_lunarImage
              lunarImageTweak: cfg_lunarImageTweak
            }
            QtLayouts.ColumnLayout {
            QtControls.Button {
              text: i18n("Previous image")
              enabled: lunarImageSelection.currentIndex > 0
              onClicked: {
                lunarImageSelection.currentIndex -= 1
              }
            }
            QtControls.Button {
              text: i18n("Next image")
              enabled: lunarImageSelection.currentIndex < lunarImageSelection.count-1
              onClicked: {
                lunarImageSelection.currentIndex += 1
              }
            }
          }
        }

        QtControls.Label {
            text: i18n("Hemisphere")
        }
        QtControls.ComboBox {
            id: hemisphere
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
            id: showBackground
            text: i18n("Show background")
        }
        QtControls.Label {
            text: ""
        }

        QtControls.Label {
          visible: false
          text: i18n("Lunar Image")
        }
        QtLayouts.RowLayout {
            visible: false
            QtControls.ComboBox {
                id: lunarImageSelection

                property string filename
                property int tweak

                textRole: "key"
                model: ImageChoices {
                  id: imageChoices
                }
                onCurrentIndexChanged: {
                  filename = imageChoices.get(currentIndex).filename
                  tweak = imageChoices.get(currentIndex).tweak
                }
            }
        }



    }
}
