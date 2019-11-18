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

using Toybox.Graphics as Gfx;
using Toybox.Time;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// CLASS
//

class TSK_ViewTimer extends TSK_ViewGlobal {

  //
  // VARIABLES
  //

  // Resources
  // ... strings (cache)
  private var sLabelCallsignTowplane;
  private var sLabelCallsignGlider;
  private var sLabelFlightCycles;

  // Internals
  // ... fields
  private var bTitleShow;
  private var iFieldIndex;
  private var iFieldEpoch;


  //
  // FUNCTIONS: TSK_ViewGlobal (override/implement)
  //

  function initialize() {
    TSK_ViewGlobal.initialize();

    // Internals
    // ... fields
    self.bTitleShow = true;
    self.iFieldIndex = 0;
    self.iFieldEpoch = Time.now().value();
  }

  function prepare() {
    //Sys.println("DEBUG: TSK_ViewTimer.prepare()");
    TSK_ViewGlobal.prepare();

    // Load resources
    // ... strings
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
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewTimer));
  }

  function updateLayout() {
    //Sys.println("DEBUG: TSK_ViewTimer.updateLayout()");
    TSK_ViewGlobal.updateLayout(!self.bTitleShow);

    // Fields
    var oTimeNow = Time.now();
    var iEpochNow = oTimeNow.value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
      self.iFieldIndex = (self.iFieldIndex + 1) % 3;
      self.iFieldEpoch = iEpochNow;
    }

    // Colors
    // ... background
    self.oRezDrawableGlobal.setColorFieldsBackground($.TSK_oProcessing.bAlertFuel ? Gfx.COLOR_DK_RED : Gfx.COLOR_TRANSPARENT);

    // Set values
    var sValue;
    // ... off-block time
    if($.TSK_oTimer.oTimeOffBlock != null) {
      sValue = LangUtils.formatTime($.TSK_oTimer.oTimeOffBlock, $.TSK_oSettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueTopLeft.setText(sValue);
    // ... takeoff time
    if($.TSK_oTimer.oTimeTakeoff != null) {
      sValue = LangUtils.formatTime($.TSK_oTimer.oTimeTakeoff, $.TSK_oSettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueTopRight.setText(sValue);
    // ... block time (elapsed)
    if($.TSK_oTimer.oTimeOffBlock != null) {
      if($.TSK_oTimer.oTimeOnBlock != null) {
        sValue = LangUtils.formatElapsedTime($.TSK_oTimer.oTimeOffBlock, $.TSK_oTimer.oTimeOnBlock, false);
      }
      else {
        sValue = LangUtils.formatElapsedTime($.TSK_oTimer.oTimeOffBlock, oTimeNow, false);
      }
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueLeft.setText(sValue);
    // ... callsign / cycles
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      self.oRezLabelCenter.setText(self.sLabelCallsignTowplane);
      sValue = $.TSK_oTowplane.sCallsign;
    }
    else if(self.iFieldIndex == 1) {  // ... callsign (glider)
      self.oRezLabelCenter.setText(self.sLabelCallsignGlider);
      sValue = $.TSK_oGlider != null ? $.TSK_oGlider.sCallsign : $.TSK_NOVALUE_LEN2;
    }
    else {  // ... cycles
      self.oRezLabelCenter.setText(self.sLabelFlightCycles);
      sValue = $.TSK_oTimer.iCountCycles.format("%d");
    }
    self.oRezValueCenter.setText(sValue);
    // ... time: flight (elapsed)
    if($.TSK_oTimer.oTimeTakeoff != null) {
      if($.TSK_oTimer.oTimeLanding != null) {
        sValue = LangUtils.formatElapsedTime($.TSK_oTimer.oTimeTakeoff, $.TSK_oTimer.oTimeLanding, false);
      }
      else {
        sValue = LangUtils.formatElapsedTime($.TSK_oTimer.oTimeTakeoff, oTimeNow, false);
      }
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueRight.setText(sValue);
    // ... time: on-block
    if($.TSK_oTimer.oTimeOnBlock != null) {
      sValue = LangUtils.formatTime($.TSK_oTimer.oTimeOnBlock, $.TSK_oSettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueBottomLeft.setText(sValue);
    // ... time: landing
    if($.TSK_oTimer.oTimeLanding != null) {
      sValue = LangUtils.formatTime($.TSK_oTimer.oTimeLanding, $.TSK_oSettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueBottomRight.setText(sValue);
  }

}

class TSK_ViewTimerDelegate extends TSK_ViewGlobalDelegate {

  function initialize() {
    TSK_ViewGlobalDelegate.initialize();
  }

  function onBack() {
    //Sys.println("DEBUG: TSK_ViewTimerDelegate.onBack()");
    Ui.pushView(new TSK_MenuGeneric(:menuTimer), new TSK_MenuGenericDelegate(:menuTimer), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: TSK_ViewTimerDelegate.onPreviousPage()");
    Ui.switchToView(new TSK_ViewLog(), new TSK_ViewLogDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: TSK_ViewTimerDelegate.onNextPage()");
    Ui.switchToView(new TSK_ViewAltimeter(), new TSK_ViewAltimeterDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
