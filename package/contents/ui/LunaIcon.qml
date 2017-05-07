/**

    Copyright 2016,2017 Bill Binder <dxtwjb@gmail.com>
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

import "../code/shadowcalcs.js" as ShadowCalcs

Item {
    id: lunaIcon

    property int phaseNumber: 0
    property int hemisphere: 0

    // Degrees. 0= new moon, 90= first quarter, 180= full moon, 270= third quarter
    property int theta: 45

    PlasmaCore.Svg {
        id: lunaSvg
        imagePath: plasmoid.file("data", "fife-moon.svg");
        //If you want the old image, enable this line instead ...
        //imagePath: plasmoid.file("data", "luna-gskbyte13.svg");
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

    Canvas {
        id: shadow
        width: lunaSvgItem.width
        height: lunaSvgItem.height
        anchors.centerIn: parent
        contextType: "2d"

        onPaint:
        {
            context.reset()
            context.globalAlpha = 0.9
            context.fillStyle = '#000000'

            var ct = Math.cos(lunaIcon.theta/180*Math.PI)
            var radius = ShadowCalcs.setup(Math.floor(shadow.height/2))

            var cn = Math.floor(shadow.width/2)

            // These two determine which side of the centre meridan to draw
            // the two arcs enclosing the shadow area.
            var terminator = (lunaIcon.theta <= 180) ? 1 : -1
            var edge = (lunaIcon.theta <= 180) ? -1 : 1

            context.beginPath()
            context.moveTo(ShadowCalcs.get(-radius) + cn, -radius + cn)
            for (var z = -radius+1; z <= radius; z++ ) {
                context.lineTo(terminator*ShadowCalcs.get(z)*ct + cn, z+cn)
            }

            for (z = radius-1; z >= -radius+1; --z) {
              context.lineTo(edge*ShadowCalcs.get(z) + cn, z+cn)
            }

            context.closePath()
            context.fill()

        }
    }
}
