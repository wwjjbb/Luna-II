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

Item {
	id: lunaIcon
//	property int minimumWidth
//	property int minimumHeight

	property int phaseNumber: 0

	Component.onCompleted: {
		plasmoid.addEventListener("ConfigChanged", configChanged);
		configChanged();
	}

	function configChanged() {
		var hemisphere = plasmoid.readConfig("hemisphere");
		lunaSvgItem.rotation = hemisphere == 0 ? 0 : 180;
	}

	PlasmaCore.Svg {
		id: lunaSvg
		imagePath: plasmoid.file("data", "luna-gskbyte" + phaseNumber + ".svg");
//		imagePath: plasmoid.file("data", "luna-gskbyte.svgz"); // is slower; see also lunaSvgItem.elementId below
	}

	PlasmaCore.SvgItem {
		id: lunaSvgItem
		anchors.fill: parent
		svg: lunaSvg
//		elementId: phaseNumber.toString() // to be used when luna-gskbyte.svgz is used; is slower

		// deal with northern <-> southern hemisphere
		transformOrigin: Item.Center
		rotation: 0
	}
}
