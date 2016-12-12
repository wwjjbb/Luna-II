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
import QtQuick.Layouts 1.3 as QtLayouts

Item {
    id: generalPage
    
    property alias cfg_hemisphere: hemisphere.currentIndex  // 0=North 1=South
    property alias cfg_showBackground: showBackground.checked  // boolean
    property alias cfg_dateFormat: dateFormat.currentIndex // code: 0= 1= 2=... 
    property alias cfg_dateFormatString: dateFormatString.text
    
    QtLayouts.GridLayout {
        columns: 2
        rowSpacing: 15
        
        QtControls.Label {
            text: i18n("Hemisphere")
        }
        QtControls.ComboBox {
            id: hemisphere
            textRole: "key"
            model: ListModel {
            ListElement { key : "Northern"; value: 0 }
                ListElement { key : "Southern"; value: 1 }
            }
        }
            
        QtControls.Label {
            text: i18n("Date Format")
        }
        QtControls.ComboBox {
            id: dateFormat
            textRole: "key"
            model: ListModel {
                ListElement { key: "Text date"; value: 0 }
                ListElement { key: "Short date"; value: 1 }
                ListElement { key: "Long date"; value: 2 }
                ListElement { key: "ISO date"; value: 3 }
                ListElement { key: "Custom"; value: 4 }
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

    }
}
