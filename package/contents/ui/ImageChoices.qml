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

import QtQuick 2.1 as QtQuick

QtQuick.ListModel {
  id: imageChoices
  QtQuick.ListElement { key: "Light";        value: 0; filename: "fife-moon.svg"; tweak: 4 }
  QtQuick.ListElement { key: "Dark";         value: 1; filename: "full-moon-dark.svg"; tweak: -15 }
  QtQuick.ListElement { key: "Original";     value: 2; filename: "luna-gskbyte13.svg"; tweak: 0 }
  QtQuick.ListElement { key: "Yellow Disk";  value: 4; filename: "yellow-disk.svg"; tweak: 0 }
}
