/**

		Copyright 2017 Bill Binder <dxtwjb@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.

*/

.pragma library

var rlookup;
var radius;

function sqr(x) {
  return x * x;
}

function setup(r) {
    radius = r;
    rlookup = [];
    for (var z=-r; z<=r; z++) {
        rlookup[z] = r*Math.sqrt(1 - sqr(z*1.0/r));
    }
    //console.log("Radius: " + r.toString());
    //console.log("Size:   " + rlookup.length.toString());

    return radius;
}

function get(z) {
    return rlookup[Math.abs(z)];
}
