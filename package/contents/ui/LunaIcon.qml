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
import QtGraphicalEffects 1.12
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import "../code/shadowcalcs.js" as ShadowCalcs

Item {
    id: lunaIcon

    property int phaseNumber: 0
    property int latitude: 90  //Degrees: 0=Equator, 90=North Pole, -90=South Pole
    property bool showShadow: true
    property bool transparentShadow: true

    property string lunarImage: ''
    property color diskColour: '#ffffff'
    property int lunarImageTweak: 0

    property bool showGrid: false
    property bool showTycho: false
    property bool showCopernicus: false

    // Degrees. 0= new moon, 90= first quarter, 180= full moon, 270= third quarter
    property int theta: 45

    PlasmaCore.Svg {
        id: lunaSvg
        imagePath: lunarImage === '' ? '' : plasmoid.file("data", lunarImage)
    }

    PlasmaCore.SvgItem {
        id: lunaSvgItem
        visible: false 

        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height)
        height: Math.min(parent.width, parent.height)

        svg: lunaSvg

        // Rotation to compensate the moon's image basic position to a north pole view
        // FIXME: Somehow it does not work when applied to OpacityMask or Blend
        transformOrigin: Item.Center
        rotation: -lunarImageTweak  
    }

    Canvas {
        id: shadow
        width: lunaSvgItem.width
        height: lunaSvgItem.height
        visible: false

        property int latitude: lunaIcon.latitude
        property int theta: lunaIcon.theta
        property bool showShadow: lunaIcon.showShadow
        property string lunarImage: lunaIcon.lunarImage
        property string diskColour: lunaIcon.diskColour
        property bool showGrid: lunaIcon.showGrid
        property bool showTycho: lunaIcon.showTycho
        property bool showCopernicus: lunaIcon.showCopernicus

        anchors.centerIn: parent
        contextType: "2d"

        onLatitudeChanged: requestPaint()

        onThetaChanged: requestPaint()

        onLunarImageChanged: requestPaint()

        onDiskColourChanged: requestPaint()

        onShowGridChanged: requestPaint()
        onShowTychoChanged: requestPaint()
        onShowCopernicusChanged: requestPaint()

        onPaint:
        {
            context.reset()
            context.globalAlpha = 0.9
            context.fillStyle = '#000000'

            function radians(deg) {
                return deg / 180.0 * Math.PI;
            }

            function marker(latitude,longitude) {
              var dy = radius * Math.sin(radians(latitude))
              var dx = radius * Math.cos(radians(latitude)) * Math.sin(radians(longitude))
              //console.log("dx: " + dx.toString())
              //console.log("dy: " + dy.toString())
              context.beginPath()
              context.strokeStyle = "#FF0000"
              context.arc(dx,-dy,5,0,2*Math.PI)
              context.moveTo(dx-5, -dy-5)
              context.lineTo(dx+5, -dy+5)
              context.moveTo(dx-5, -dy+5)
              context.lineTo(dx+5, -dy-5)
              context.stroke()
            }

            function grid() {

              context.beginPath()
              context.strokeStyle = "#FF4040"
              context.moveTo(0,-radius)
              context.lineTo(0,radius)
              context.moveTo(-radius,0)
              context.lineTo(radius,0)
              context.stroke()

              context.beginPath()
              context.strokeStyle = "#40FF40"
              for (var ll=10;ll<65;ll+=10) {
                var dy = radius * Math.sin(radians(ll))
                context.moveTo(-radius,dy)
                context.lineTo(radius,dy)
                context.moveTo(-radius,-dy)
                context.lineTo(radius,-dy)
              }
              context.stroke()
            }

            //console.log("Angle: " + theta.toString())

            var ct = Math.cos(theta/180*Math.PI)
            var radius = ShadowCalcs.setup(Math.floor(shadow.height/2))

            //console.log("radius: " + radius.toString())

            context.translate(radius,radius)

            // These two determine which side of the centre meridan to draw
            // the two arcs enclosing the shadow area.
            var terminator = (theta <= 180) ? 1 : -1
            var edge = (theta <= 180) ? -1 : 1

            var z

            if (lunarImage === '') {
                context.beginPath()
                context.fillStyle = diskColour
                context.arc(0,0,radius,0,2*Math.PI)
                context.closePath()
                context.fill()
            }

            if (showShadow) {
              context.beginPath()
              context.fillStyle = '#000000'
              context.moveTo(ShadowCalcs.get(-radius), -radius)
              for (z = -radius+1; z <= radius; z++ ) {
                  context.lineTo(terminator*ShadowCalcs.get(z)*ct, z)
              }

              for (z = radius-1; z >= -radius+1; --z) {
                context.lineTo(edge*ShadowCalcs.get(z), z)
              }

              context.closePath()
              context.fill()
            }
            else {
              // Callibration markers
              if (showGrid)
                  grid()

              if (showTycho)
                  marker(-43,-11.5)  // Tycho

              if (showCopernicus)
                  marker(9.6,-20)    // Copernicus
            }
        }
    }

    // Shadow acts as a transparecy mask
    OpacityMask {
        anchors.fill: lunaSvgItem
        source: lunaSvgItem
        maskSource: shadow
        invert: true
        rotation: latitude - 90
        visible: transparentShadow
    }

    // Shadow is printed on top of the moon image
    Blend {
        anchors.fill: lunaSvgItem
        source: lunaSvgItem
        foregroundSource: shadow
        rotation: latitude - 90
        mode: "normal"
        visible: !transparentShadow
    }
}
