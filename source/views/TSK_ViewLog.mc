// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Towplane Swiss Knife (TowplaneSK)
// Copyright (C) 2019 Cedric Dufour <http://cedric.dufour.name>
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
var TSK_iViewLogIndex = null;


//
// CLASS
//

class TSK_ViewLog extends TSK_ViewGlobal {

  //
  // VARIABLES
  //

  // Resources
  // ... strings (cache)
  private var sTitle;
  private var sLabelCallsignTowplane;
  private var sLabelCallsignGlider;
  private var sLabelFlightCycles;

  // Internals
  // ... fields
  private var bTitleShow;
  private var iFieldIndex;
  private var iFieldEpoch;
  // ... log
  private var iLogIndex = null;
  private var dictLog;


  //
  // FUNCTIONS: TSK_ViewGlobal (override/implement)
  //

  function initialize() {
    TSK_ViewGlobal.initialize();

    // Current view/log index
    $.TSK_iViewLogIndex = $.TSK_iLogIndex;

    // Internals
    // ... fields
    self.bTitleShow = true;
    self.iFieldIndex = 0;
    self.iFieldEpoch = Time.now().value();
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: TSK_ViewLog.onUpdate()");

    // Load log
    if(self.iLogIndex != $.TSK_iViewLogIndex) {
      self.loadLog();
    }

    // Done
    return TSK_ViewGlobal.onUpdate(_oDC);
  }

  function prepare() {
    //Sys.println("DEBUG: TSK_ViewLog.prepare()");
    TSK_ViewGlobal.prepare();

    // Load resources
    // ... strings
    self.sTitle = Ui.loadResource(Rez.Strings.titleViewLog);
    self.sLabelCallsignTowplane = Ui.loadResource(Rez.Strings.labelCallsignTowplane);
    self.sLabelCallsignGlider = Ui.loadResource(Rez.Strings.labelCallsignGlider);
    self.sLabelFlightCycles = Ui.loadResource(Rez.Strings.labelFlightCycles);

    // Set labels, units and colors
    // ... off-block time
    View.findDrawableById("labelTopLeft").setText(Ui.loadResource(Rez.Strings.labelTimeOffBlock));
    View.findDrawableById("unitTopLeft").setText($.TSK_NOVALUE_BLANK);
    self.oRezValueTopLeft.setColor(self.iColorText);
    // ... takeoff time
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelTimeTakeoff));
    View.findDrawableById("unitTopRight").setText($.TSK_NOVALUE_BLANK);
    self.oRezValueTopRight.setColor(self.iColorText);
    // ... block time (elapsed)
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelElapsedBlock));
    View.findDrawableById("unitLeft").setText($.TSK_NOVALUE_BLANK);
    self.oRezValueLeft.setColor(self.iColorText);
    // ... callsign / cycles (dynamic label)
    self.oRezValueCenter.setColor(self.iColorText);
    // ... flight time (elapsed)
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelElapsedFlight));
    View.findDrawableById("unitRight").setText($.TSK_NOVALUE_BLANK);
    self.oRezValueRight.setColor(self.iColorText);
    // ... on-block time
    View.findDrawableById("labelBottomLeft").setText(Ui.loadResource(Rez.Strings.labelTimeOnBlock));
    View.findDrawableById("unitBottomLeft").setText($.TSK_NOVALUE_BLANK);
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... landing time
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelTimeLanding));
    View.findDrawableById("unitBottomRight").setText($.TSK_NOVALUE_BLANK);
    self.oRezValueBottomRight.setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewLog));

    // Done
    return true;
  }

  function updateLayout() {
    //Sys.println("DEBUG: TSK_ViewLog.updateLayout()");
    TSK_ViewGlobal.updateLayout(false);

    // Fields
    var iEpochNow = Time.now().value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
      self.iFieldIndex = (self.iFieldIndex + 1) % 3;
      self.iFieldEpoch = iEpochNow;
    }

    // No log ?
    if(self.dictLog == null) {
      self.oRezValueTopLeft.setText($.TSK_NOVALUE_LEN3);
      self.oRezValueTopRight.setText($.TSK_NOVALUE_LEN3);
      self.oRezValueLeft.setText($.TSK_NOVALUE_LEN3);
      self.oRezLabelCenter.setText(self.sLabelFlightCycles);
      self.oRezValueCenter.setText($.TSK_NOVALUE_LEN2);
      self.oRezValueRight.setText($.TSK_NOVALUE_LEN3);
      self.oRezValueBottomLeft.setText($.TSK_NOVALUE_LEN3);
      self.oRezValueBottomRight.setText($.TSK_NOVALUE_LEN3);
      self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezValueFooter.setText(self.sTitle);
      return;
    }

    // Set values
    // ... time: off-block
    self.oRezValueTopLeft.setText(self.dictLog["timeOffBlock"]);
    // ... time: takeoff
    self.oRezValueTopRight.setText(self.dictLog["timeTakeoff"]);
    // ... time: block-to-block
    self.oRezValueLeft.setText(self.dictLog["elapsedBlock"]);
    // ... callsign / cycles
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      self.oRezLabelCenter.setText(self.sLabelCallsignTowplane);
      self.oRezValueCenter.setText(self.dictLog["towplane"]);
    }
    else if(self.iFieldIndex == 1) {  // ... callsign (glider)
      self.oRezLabelCenter.setText(self.sLabelCallsignGlider);
      self.oRezValueCenter.setText(self.dictLog["glider"]);
    }
    else {  // ... cycles
      self.oRezLabelCenter.setText(self.sLabelFlightCycles);
      self.oRezValueCenter.setText(self.dictLog["countCycles"]);
    }
    // ... time: flight (elapsed)
    self.oRezValueRight.setText(self.dictLog["elapsedFlight"]);
    // ... time: on-block
    self.oRezValueBottomLeft.setText(self.dictLog["timeOnBlock"]);
    // ... time: landing
    self.oRezValueBottomRight.setText(self.dictLog["timeLanding"]);
    // ... footer
    if(!self.bTitleShow) {
      self.oRezValueFooter.setColor(self.iColorText);
      self.oRezValueFooter.setText(self.dictLog["date"]);
    }
  }


  //
  // FUNCTIONS: self
  //

  function loadLog() {
    //Sys.println("DEBUG: TSK_ViewLog.loadLog()");

    // Check index
    if($.TSK_iViewLogIndex == null) {
      self.iLogIndex = null;
      self.dictLog = null;
      return;
    }

    // Load log entry
    self.iLogIndex = $.TSK_iViewLogIndex;
    var s = self.iLogIndex.format("%02d");
    var d = App.Storage.getValue(Lang.format("storLog$1$", [s]));
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
      d["towplane"] = $.TSK_NOVALUE_LEN2;
    }
    // ... glider
    if(d.get("glider") == null) {
      d["glider"] = $.TSK_NOVALUE_LEN2;
    }
    // ... off-block time (and date)
    if(d.get("timeOffBlock") != null) {
      oTimeOffBlock = new Time.Moment(d["timeOffBlock"]);
      var oTimeInfo = $.TSK_oSettings.bUnitTimeUTC ? Gregorian.utcInfo(oTimeOffBlock, Time.FORMAT_MEDIUM) : Gregorian.info(oTimeOffBlock, Time.FORMAT_MEDIUM);
      d["timeOffBlock"] = Lang.format("$1$:$2$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d")]);
      d["date"] = Lang.format("$1$ $2$", [oTimeInfo.month, oTimeInfo.day.format("%01d")]);
    } else {
      d["timeOffBlock"] = $.TSK_NOVALUE_LEN3;
      d["date"] = $.TSK_NOVALUE_LEN4;
    }
    // ... takeoff time
    if(d.get("timeTakeoff") != null) {
      oTimeTakeoff = new Time.Moment(d["timeTakeoff"]);
      d["timeTakeoff"] = TSK_Timer.formatTime(oTimeTakeoff);
    } else {
      d["timeTakeoff"] = $.TSK_NOVALUE_LEN3;
    }
    // ... cycles
    if(d.get("countCycles") != null) {
      d["countCycles"] = d["countCycles"].format("%d");
    } else {
      d["countCycles"] = $.TSK_NOVALUE_LEN2;
    }
    // landing time
    if(d.get("timeLanding") != null) {
      oTimeLanding = new Time.Moment(d["timeLanding"]);
      d["timeLanding"] = TSK_Timer.formatTime(oTimeLanding);
    } else {
      d["timeLanding"] = $.TSK_NOVALUE_LEN3;
    }
    // on-block time
    if(d.get("timeOnBlock") != null) {
      oTimeOnBlock = new Time.Moment(d["timeOnBlock"]);
      d["timeOnBlock"] = TSK_Timer.formatTime(oTimeOnBlock);
    } else {
      d["timeOnBlock"] = $.TSK_NOVALUE_LEN3;
    }
    // flight time (elapsed)
    if(oTimeTakeoff != null and oTimeLanding != null) {
      d["elapsedFlight"] = TSK_Timer.formatElapsedTime(oTimeTakeoff, oTimeLanding);
    }
    else {
      d["elapsedFlight"] = $.TSK_NOVALUE_LEN3;
    }
    // block time (elapsed)
    if(oTimeOffBlock != null and oTimeOnBlock != null) {
      d["elapsedBlock"] = TSK_Timer.formatElapsedTime(oTimeOffBlock, oTimeOnBlock);
    }
    else {
      d["elapsedBlock"] = $.TSK_NOVALUE_LEN3;
    }

    // Done
    self.dictLog = d;
  }

}

class TSK_ViewLogDelegate extends TSK_ViewGlobalDelegate {

  function initialize() {
    TSK_ViewGlobalDelegate.initialize();
  }

  function onSelect() {
    //Sys.println("DEBUG: TSK_ViewLogDelegate.onSelect()");
    if($.TSK_iViewLogIndex == null) {
      $.TSK_iViewLogIndex = $.TSK_iLogIndex;
    }
    else {
      $.TSK_iViewLogIndex = ($.TSK_iViewLogIndex + 1) % $.TSK_STORAGE_SLOTS;
    }
    Ui.requestUpdate();
    return true;
  }

  function onBack() {
    //Sys.println("DEBUG: TSK_ViewLogDelegate.onBack()");
    if($.TSK_iViewLogIndex == null) {
      $.TSK_iViewLogIndex = $.TSK_iLogIndex;
    }
    else {
      $.TSK_iViewLogIndex = ($.TSK_iViewLogIndex - 1 + $.TSK_STORAGE_SLOTS) % $.TSK_STORAGE_SLOTS;
    }
    Ui.requestUpdate();
    return true;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: TSK_ViewLogDelegate.onPreviousPage()");
    Ui.switchToView(new TSK_ViewGlider(), new TSK_ViewGliderDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: TSK_ViewLogDelegate.onNextPage()");
    Ui.switchToView(new TSK_ViewTimer(), new TSK_ViewTimerDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
