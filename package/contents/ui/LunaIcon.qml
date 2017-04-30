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

Item {
    id: lunaIcon

    property int phaseNumber: 0
    property int hemisphere: 0

    PlasmaCore.Svg {
        id: lunaSvg
        imagePath: plasmoid.file("data", "luna-gskbyte" + phaseNumber + ".svg");
    }

    PlasmaCore.SvgItem {
        id: lunaSvgItem

        anchors.centerIn: parent
        width: Math.min(parent.width,parent.height)
        height: Math.min(parent.width,parent.height)

        svg: lunaSvg

        // deal with northern <-> southern hemisphere
        transformOrigin: Item.Center
        rotation: hemisphere == 0 ? 0 : 180
    }
}
