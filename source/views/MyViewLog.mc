// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Towplane Swiss Knife (TowplaneSK)
// Copyright (C) 2019-2022 Cedric Dufour <http://cedric.dufour.name>
//
// Towplane Swiss Knife (TowplaneSK) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Towplane Swiss Knife (TowplaneSK) is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Current view/log index
var iMyViewLogIndex as Number = -1;


//
// CLASS
//

class MyViewLog extends MyView {

  //
  // VARIABLES
  //

  // Resources
  // ... strings (cache)
  private var sTitle as String = "Log";
  private var sLabelFlightCycles as String = "Cycles";

  // Internals
  // ... log
  private var iLogIndex as Number = -1;
  private var dictLog as Dictionary?;


  //
  // FUNCTIONS: MyView (override/implement)
  //

  function initialize() {
    MyView.initialize();

    // Current view/log index
    $.iMyViewLogIndex = $.iMyLogIndex;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: MyViewLog.onUpdate()");

    // Load log
    if(self.iLogIndex != $.iMyViewLogIndex) {
      self.loadLog();
    }

    // Done
    MyView.onUpdate(_oDC);
  }

  function prepare() {
    //Sys.println("DEBUG: MyViewLog.prepare()");
    MyView.prepare();

    // Load resources
    // ... strings
    self.sTitle = Ui.loadResource(Rez.Strings.titleViewLog) as String;
    self.sLabelFlightCycles = Ui.loadResource(Rez.Strings.labelFlightCycles) as String;

    // Set labels, units and colors
    // ... off-block time
    (View.findDrawableById("labelTopLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelTimeOffBlock) as String);
    (View.findDrawableById("unitTopLeft") as Ui.Text).setText($.MY_NOVALUE_BLANK);
    (self.oRezValueTopLeft as Ui.Text).setColor(self.iColorText);
    // ... takeoff time
    (View.findDrawableById("labelTopRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelTimeTakeoff) as String);
    (View.findDrawableById("unitTopRight") as Ui.Text).setText($.MY_NOVALUE_BLANK);
    (self.oRezValueTopRight as Ui.Text).setColor(self.iColorText);
    // ... block time (elapsed)
    (View.findDrawableById("labelLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelElapsedBlock) as String);
    (View.findDrawableById("unitLeft") as Ui.Text).setText($.MY_NOVALUE_BLANK);
    (self.oRezValueLeft as Ui.Text).setColor(self.iColorText);
    // ... callsign / cycles (dynamic label)
    (self.oRezValueCenter as Ui.Text).setColor(self.iColorText);
    // ... flight time (elapsed)
    (View.findDrawableById("labelRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelElapsedFlight) as String);
    (View.findDrawableById("unitRight") as Ui.Text).setText($.MY_NOVALUE_BLANK);
    (self.oRezValueRight as Ui.Text).setColor(self.iColorText);
    // ... on-block time
    (View.findDrawableById("labelBottomLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelTimeOnBlock) as String);
    (View.findDrawableById("unitBottomLeft") as Ui.Text).setText($.MY_NOVALUE_BLANK);
    (self.oRezValueBottomLeft as Ui.Text).setColor(self.iColorText);
    // ... landing time
    (View.findDrawableById("labelBottomRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelTimeLanding) as String);
    (View.findDrawableById("unitBottomRight") as Ui.Text).setText($.MY_NOVALUE_BLANK);
    (self.oRezValueBottomRight as Ui.Text).setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    (self.oRezValueFooter as Ui.Text).setColor(Gfx.COLOR_DK_GRAY);
    (self.oRezValueFooter as Ui.Text).setText(Ui.loadResource(Rez.Strings.titleViewLog) as String);
  }

  function updateLayout(_b) {
    //Sys.println("DEBUG: MyViewLog.updateLayout()");
    MyView.updateLayout(false);

    // Fields
    var iEpochNow = Time.now().value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
      self.iFieldIndex = (self.iFieldIndex + 1) % 3;
      self.iFieldEpoch = iEpochNow;
    }

    // No log ?
    if(self.dictLog == null) {
      (self.oRezValueTopLeft as Ui.Text).setText($.MY_NOVALUE_LEN3);
      (self.oRezValueTopRight as Ui.Text).setText($.MY_NOVALUE_LEN3);
      (self.oRezValueLeft as Ui.Text).setText($.MY_NOVALUE_LEN3);
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelFlightCycles);
      (self.oRezValueCenter as Ui.Text).setText($.MY_NOVALUE_LEN2);
      (self.oRezValueRight as Ui.Text).setText($.MY_NOVALUE_LEN3);
      (self.oRezValueBottomLeft as Ui.Text).setText($.MY_NOVALUE_LEN3);
      (self.oRezValueBottomRight as Ui.Text).setText($.MY_NOVALUE_LEN3);
      (self.oRezValueFooter as Ui.Text).setColor(Gfx.COLOR_DK_GRAY);
      (self.oRezValueFooter as Ui.Text).setText(self.sTitle);
      return;
    }

    // Set values
    // ... time: off-block
    (self.oRezValueTopLeft as Ui.Text).setText((self.dictLog as Dictionary)["timeOffBlock"] as String);
    // ... time: takeoff
    (self.oRezValueTopRight as Ui.Text).setText((self.dictLog as Dictionary)["timeTakeoff"] as String);
    // ... time: block-to-block
    (self.oRezValueLeft as Ui.Text).setText((self.dictLog as Dictionary)["elapsedBlock"] as String);
    // ... callsign / cycles
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelCallsignTowplane);
      (self.oRezValueCenter as Ui.Text).setText((self.dictLog as Dictionary)["towplane"] as String);
    }
    else if(self.iFieldIndex == 1) {  // ... callsign (glider)
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelCallsignGlider);
      (self.oRezValueCenter as Ui.Text).setText((self.dictLog as Dictionary)["glider"] as String);
    }
    else {  // ... cycles
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelFlightCycles);
      (self.oRezValueCenter as Ui.Text).setText((self.dictLog as Dictionary)["countCycles"] as String);
    }
    // ... time: flight (elapsed)
    (self.oRezValueRight as Ui.Text).setText((self.dictLog as Dictionary)["elapsedFlight"] as String);
    // ... time: on-block
    (self.oRezValueBottomLeft as Ui.Text).setText((self.dictLog as Dictionary)["timeOnBlock"] as String);
    // ... time: landing
    (self.oRezValueBottomRight as Ui.Text).setText((self.dictLog as Dictionary)["timeLanding"] as String);
    // ... footer
    if(!self.bTitleShow) {
      (self.oRezValueFooter as Ui.Text).setColor(self.iColorText);
      (self.oRezValueFooter as Ui.Text).setText((self.dictLog as Dictionary)["date"] as String);
    }
  }


  //
  // FUNCTIONS: self
  //

  function loadLog() as Void {
    //Sys.println("DEBUG: MyViewLog.loadLog()");

    // Check index
    if($.iMyViewLogIndex < 0) {
      self.iLogIndex = -1;
      self.dictLog = null;
      return;
    }

    // Load log entry
    self.iLogIndex = $.iMyViewLogIndex;
    var s = self.iLogIndex.format("%02d");
    var d = App.Storage.getValue(format("storLog$1$", [s])) as Dictionary?;
    if(d == null) {
      self.dictLog = null;
      return;
    }

    // Validate/textualize log entry
    var oTimeOffBlock = null;
    var oTimeTakeoff = null;
    var oTimeLanding = null;
    var oTimeOnBlock = null;
    // ... towplane
    if(d.get("towplane") == null) {
      d["towplane"] = $.MY_NOVALUE_LEN2;
    }
    // ... glider
    if(d.get("glider") == null) {
      d["glider"] = $.MY_NOVALUE_LEN2;
    }
    // ... off-block time (and date)
    if(d.get("timeOffBlock") != null) {
      oTimeOffBlock = new Time.Moment(d["timeOffBlock"] as Number);
      d["timeOffBlock"] = LangUtils.formatTime(oTimeOffBlock, $.oMySettings.bUnitTimeUTC, false);
      d["date"] = LangUtils.formatDate(oTimeOffBlock, $.oMySettings.bUnitTimeUTC);
    } else {
      d["timeOffBlock"] = $.MY_NOVALUE_LEN3;
      d["date"] = $.MY_NOVALUE_LEN4;
    }
    // ... takeoff time
    if(d.get("timeTakeoff") != null) {
      oTimeTakeoff = new Time.Moment(d["timeTakeoff"] as Number);
      d["timeTakeoff"] = LangUtils.formatTime(oTimeTakeoff, $.oMySettings.bUnitTimeUTC, false);
    } else {
      d["timeTakeoff"] = $.MY_NOVALUE_LEN3;
    }
    // ... cycles
    if(d.get("countCycles") != null) {
      d["countCycles"] = (d["countCycles"] as Number).format("%d");
    } else {
      d["countCycles"] = $.MY_NOVALUE_LEN2;
    }
    // landing time
    if(d.get("timeLanding") != null) {
      oTimeLanding = new Time.Moment(d["timeLanding"] as Number);
      d["timeLanding"] = LangUtils.formatTime(oTimeLanding, $.oMySettings.bUnitTimeUTC, false);
    } else {
      d["timeLanding"] = $.MY_NOVALUE_LEN3;
    }
    // on-block time
    if(d.get("timeOnBlock") != null) {
      oTimeOnBlock = new Time.Moment(d["timeOnBlock"] as Number);
      d["timeOnBlock"] = LangUtils.formatTime(oTimeOnBlock, $.oMySettings.bUnitTimeUTC, false);
    } else {
      d["timeOnBlock"] = $.MY_NOVALUE_LEN3;
    }
    // flight time (elapsed)
    if(oTimeTakeoff != null and oTimeLanding != null) {
      d["elapsedFlight"] = LangUtils.formatElapsedTime(oTimeTakeoff, oTimeLanding, false);
    }
    else {
      d["elapsedFlight"] = $.MY_NOVALUE_LEN3;
    }
    // block time (elapsed)
    if(oTimeOffBlock != null and oTimeOnBlock != null) {
      d["elapsedBlock"] = LangUtils.formatElapsedTime(oTimeOffBlock, oTimeOnBlock, false);
    }
    else {
      d["elapsedBlock"] = $.MY_NOVALUE_LEN3;
    }

    // Done
    self.dictLog = d;
  }

}

class MyViewLogDelegate extends MyViewDelegate {

  function initialize() {
    MyViewDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: MyViewDelegate.onMenu()");
    Ui.pushView(new MyMenuGeneric(:menuSettings),
                new MyMenuGenericDelegate(:menuSettings),
                Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onSelect() {
    //Sys.println("DEBUG: MyViewLogDelegate.onSelect()");
    if($.iMyViewLogIndex < 0) {
      $.iMyViewLogIndex = $.iMyLogIndex;
    }
    else {
      $.iMyViewLogIndex = ($.iMyViewLogIndex + 1) % $.MY_STORAGE_SLOTS;
    }
    Ui.requestUpdate();
    return true;
  }

  function onBack() {
    //Sys.println("DEBUG: MyViewLogDelegate.onBack()");
    if($.iMyViewLogIndex < 0) {
      $.iMyViewLogIndex = $.iMyLogIndex;
    }
    else {
      $.iMyViewLogIndex = ($.iMyViewLogIndex - 1 + $.MY_STORAGE_SLOTS) % $.MY_STORAGE_SLOTS;
    }
    Ui.requestUpdate();
    return true;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: MyViewLogDelegate.onPreviousPage()");
    Ui.switchToView(new MyViewGlider(),
                    new MyViewGliderDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: MyViewLogDelegate.onNextPage()");
    Ui.switchToView(new MyViewTimer(),
                    new MyViewTimerDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
