/**

    Copyright 1998, 2000  Stephan Kulow <coolo@kde.org>
    Copyright 2008 by Davide Bettio <davide.bettio@kdemail.net>
    Copyright (C) 2009, 2011, 2012, 2013 Glad Deschrijver <glad.deschrijver@gmail.com>
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

var lunation = 0;

function getLunation(time)
{
//	var lunation = 0;
	var nextNew = new Date(0);

	// obtain reasonable start value for lunation so that the while loop below has a minimal amount of iterations (for faster startup of the plasmoid)
	var reference = 947178885000; // number of milliseconds between 1970-01-01 00:00:00 and 2000-01-06 18:14:45 (first new moon of 2000, see lunation in phases.js)
	var lunationDuration = 2551442877; // number of milliseconds in 29.530588853 days (average lunation duration, same number as in (47.1) in phases.js)
//	var lunationDuration = 2583360000; // number of milliseconds in 29.9 days (maximum lunation duration, see wikipedia on synodic month); use this if the bug ever appears that the lunar phases displayed at startup are too much in the future
	var lunation = Math.floor((time.getTime() - reference) / lunationDuration);

	do {
		var JDE = Phases.moonphasebylunation(lunation, 0);
		nextNew = Phases.JDtoDate(JDE);
		lunation++;
	} while (nextNew < time);

	lunation -= 2;
	return lunation;
}

function getPhasesByLunation(lunation)
{
	var phases = new Array();
	phases[0] = Phases.JDtoDate(Phases.moonphasebylunation(lunation, 0)); // new moon
	phases[1] = Phases.JDtoDate(Phases.moonphasebylunation(lunation, 1)); // first quarter
	phases[2] = Phases.JDtoDate(Phases.moonphasebylunation(lunation, 2)); // full moon
	phases[3] = Phases.JDtoDate(Phases.moonphasebylunation(lunation, 3)); // last quarter
	phases[4] = Phases.JDtoDate(Phases.moonphasebylunation(lunation+1, 0)); // next new moon
	return phases;
}

function getTodayPhases()
{
	var today = new Date();
	lunation = getLunation(today);
	return getPhasesByLunation(lunation);
}

function getPreviousPhases()
{
	lunation--;
	return getPhasesByLunation(lunation);
}

function getNextPhases()
{
	lunation++;
	return getPhasesByLunation(lunation);
}

function reloadPhases()
{
	return getPhasesByLunation(lunation);
}

function getCurrentPhase() // this function assumes that today is between phases[0] (last new moon) and phases[4] (next new moon)
{

	var oneDay = 1000 * 60 * 60 * 24;
	var today = new Date().getTime();
	var phases = getTodayPhases();

  /* -------------------------------------------------------------------------
  // Estimate where the terminator is - base this on knowing where it
  // is at each quarter, and interpolating. Cowboy maths.
  // Determines how far into the current quarter we are, and uses
  // the result to work out where the terminator is. This allows for
  // the quarters being different sizes, rather than assuming they are
  // each one quarter of the cycle time.

  var qnum = 0;
  while (today > phases[qnum+1] && qnum < 3) {
     qnum++;
  }
  var quarterTime = phases[qnum+1].getTime() - phases[qnum].getTime();
  var sinceQuarter = today - phases[qnum].getTime();
  var terminator = Math.floor(((sinceQuarter / quarterTime) + qnum) * 90);
  --------------------------------------------------------------------- */

  // /*
  // Work out where the terminator is, 0..359 degrees
  var cycleTime = phases[4].getTime() - phases[0].getTime();
  var sinceNew = today - phases[0].getTime();
  var terminator = Math.floor((sinceNew / cycleTime) * 360);
  // */

  // Keep this in the range [0,360):
	if (terminator >= 360) {
		terminator -= 360;
	}
	//console.log("Terminator: " + terminator.toString());

	// set time for all phases to 00:00:00 in order to obtain the correct phase for today (these changes should be local)
	for (var i = 0; i < 5; i++) {
		phases[i].setHours(0);
		phases[i].setMinutes(0);
		phases[i].setSeconds(0);
	}

	// if today <= first quarter, calculate day since last new moon
	var daysFromFirstQuarter = Math.floor((today - phases[1].getTime()) / oneDay);
	if (daysFromFirstQuarter == 0)
		return {number: 7, terminator:terminator, text: i18n("First Quarter"), subText: ""};
	else if (daysFromFirstQuarter < 0) {
		var daysFromLastNew = Math.floor((today - phases[0].getTime()) / oneDay);
		if (daysFromLastNew == 0)
			return {number: 0, terminator:terminator, text: i18n("New Moon"), subText: ""};
		else if (daysFromLastNew == 1)
			return {number: 1, terminator:terminator, text: i18n("Waxing Crescent"), subText: i18n("Yesterday was New Moon")};
		else // assume that today >= last new moon
			return {number: daysFromLastNew, terminator:terminator, text: i18n("Waxing Crescent"), subText: i18n("%1 days since New Moon", daysFromLastNew)};
	}

	// if today >= third quarter, calculate day until next new moon
	var daysFromThirdQuarter = Math.floor((today - phases[3].getTime()) / oneDay);
	if (daysFromThirdQuarter == 0)
		return {number: 21, terminator:terminator, text: i18n("Last Quarter"), subText: ""};
	else if (daysFromThirdQuarter > 0) {
		var daysToNextNew = -Math.floor((today - phases[4].getTime()) / oneDay);
		if (daysToNextNew == 0)
			return {number: 0, terminator:terminator, text: i18n("New Moon"), subText: ""};
		else if (daysToNextNew == 1)
			return {number: 27, terminator:terminator, text: i18n("Waning Crescent"), subText: i18n("Tomorrow is New Moon")};
		else // assume that today <= next new moon
			return {number: 28 - daysToNextNew, terminator:terminator, text: i18n("Waning Crescent"), subText: i18n("%1 days to New Moon", daysToNextNew)};
	}

	// in all other cases, calculate day from or until full moon
	var daysFromFullMoon = Math.floor((today - phases[2].getTime()) / oneDay);
	if (daysFromFullMoon == 0)
		return {number: 14, terminator:terminator, text: i18n("Full Moon"), subText: ""};
	else if (daysFromFullMoon == -1)
		return {number: 13, terminator:terminator, text: i18n("Waxing Gibbous"), subText: i18n("Tomorrow is Full Moon")};
	else if (daysFromFullMoon < -1)
		return {number: 14 + daysFromFullMoon, terminator:terminator, text: i18n("Waxing Gibbous"), subText: i18n("%1 days to Full Moon", -daysFromFullMoon)};
	else if (daysFromFullMoon == 1)
		return {number: 15, terminator:terminator, text: i18n("Waning Gibbous"), subText: i18n("Yesterday was Full Moon")};
	else if (daysFromFullMoon > 1)
		return {number: 14 + daysFromFullMoon, terminator:terminator, text: i18n("Waning Gibbous"), subText: i18n("%1 days since Full Moon", daysFromFullMoon)};

	// this should never happen:
	console.log("We cannot count :-(");
	return {number: -1, text: ""};
}
