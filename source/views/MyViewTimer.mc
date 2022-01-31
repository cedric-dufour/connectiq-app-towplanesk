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

class MyViewTimer extends MyViewGlobal {

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
  // FUNCTIONS: MyViewGlobal (override/implement)
  //

  function initialize() {
    MyViewGlobal.initialize();

    // Internals
    // ... fields
    self.bTitleShow = true;
    self.iFieldIndex = 0;
    self.iFieldEpoch = Time.now().value();
  }

  function prepare() {
    //Sys.println("DEBUG: MyViewTimer.prepare()");
    MyViewGlobal.prepare();

    // Load resources
    // ... strings
    self.sLabelCallsignTowplane = Ui.loadResource(Rez.Strings.labelCallsignTowplane);
    self.sLabelCallsignGlider = Ui.loadResource(Rez.Strings.labelCallsignGlider);
    self.sLabelFlightCycles = Ui.loadResource(Rez.Strings.labelFlightCycles);

    // Set labels, units and colors
    // ... off-block time
    View.findDrawableById("labelTopLeft").setText(Ui.loadResource(Rez.Strings.labelTimeOffBlock));
    View.findDrawableById("unitTopLeft").setText($.MY_NOVALUE_BLANK);
    self.oRezValueTopLeft.setColor(self.iColorText);
    // ... takeoff time
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelTimeTakeoff));
    View.findDrawableById("unitTopRight").setText($.MY_NOVALUE_BLANK);
    self.oRezValueTopRight.setColor(self.iColorText);
    // ... block time (elapsed)
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelElapsedBlock));
    View.findDrawableById("unitLeft").setText($.MY_NOVALUE_BLANK);
    self.oRezValueLeft.setColor(self.iColorText);
    // ... callsign / cycles (dynamic label)
    self.oRezValueCenter.setColor(self.iColorText);
    // ... flight time (elapsed)
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelElapsedFlight));
    View.findDrawableById("unitRight").setText($.MY_NOVALUE_BLANK);
    self.oRezValueRight.setColor(self.iColorText);
    // ... on-block time
    View.findDrawableById("labelBottomLeft").setText(Ui.loadResource(Rez.Strings.labelTimeOnBlock));
    View.findDrawableById("unitBottomLeft").setText($.MY_NOVALUE_BLANK);
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... landing time
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelTimeLanding));
    View.findDrawableById("unitBottomRight").setText($.MY_NOVALUE_BLANK);
    self.oRezValueBottomRight.setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewTimer));
  }

  function updateLayout() {
    //Sys.println("DEBUG: MyViewTimer.updateLayout()");
    MyViewGlobal.updateLayout(!self.bTitleShow);

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
    self.oRezDrawableGlobal.setColorFieldsBackground($.oMyProcessing.bAlertFuel ? Gfx.COLOR_DK_RED : Gfx.COLOR_TRANSPARENT);

    // Set values
    var sValue;
    // ... off-block time
    if($.oMyTimer.oTimeOffBlock != null) {
      sValue = LangUtils.formatTime($.oMyTimer.oTimeOffBlock, $.oMySettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueTopLeft.setText(sValue);
    // ... takeoff time
    if($.oMyTimer.oTimeTakeoff != null) {
      sValue = LangUtils.formatTime($.oMyTimer.oTimeTakeoff, $.oMySettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueTopRight.setText(sValue);
    // ... block time (elapsed)
    if($.oMyTimer.oTimeOffBlock != null) {
      if($.oMyTimer.oTimeOnBlock != null) {
        sValue = LangUtils.formatElapsedTime($.oMyTimer.oTimeOffBlock, $.oMyTimer.oTimeOnBlock, false);
      }
      else {
        sValue = LangUtils.formatElapsedTime($.oMyTimer.oTimeOffBlock, oTimeNow, false);
      }
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueLeft.setText(sValue);
    // ... callsign / cycles
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      self.oRezLabelCenter.setText(self.sLabelCallsignTowplane);
      sValue = $.oMyTowplane.sCallsign;
    }
    else if(self.iFieldIndex == 1) {  // ... callsign (glider)
      self.oRezLabelCenter.setText(self.sLabelCallsignGlider);
      sValue = $.oMyGlider != null ? $.oMyGlider.sCallsign : $.MY_NOVALUE_LEN2;
    }
    else {  // ... cycles
      self.oRezLabelCenter.setText(self.sLabelFlightCycles);
      sValue = $.oMyTimer.iCountCycles.format("%d");
    }
    self.oRezValueCenter.setText(sValue);
    // ... time: flight (elapsed)
    if($.oMyTimer.oTimeTakeoff != null) {
      if($.oMyTimer.oTimeLanding != null) {
        sValue = LangUtils.formatElapsedTime($.oMyTimer.oTimeTakeoff, $.oMyTimer.oTimeLanding, false);
      }
      else {
        sValue = LangUtils.formatElapsedTime($.oMyTimer.oTimeTakeoff, oTimeNow, false);
      }
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueRight.setText(sValue);
    // ... time: on-block
    if($.oMyTimer.oTimeOnBlock != null) {
      sValue = LangUtils.formatTime($.oMyTimer.oTimeOnBlock, $.oMySettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueBottomLeft.setText(sValue);
    // ... time: landing
    if($.oMyTimer.oTimeLanding != null) {
      sValue = LangUtils.formatTime($.oMyTimer.oTimeLanding, $.oMySettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueBottomRight.setText(sValue);
  }

}

class MyViewTimerDelegate extends MyViewGlobalDelegate {

  function initialize() {
    MyViewGlobalDelegate.initialize();
  }

  function onBack() {
    //Sys.println("DEBUG: MyViewTimerDelegate.onBack()");
    if($.oMyTimer.iState > MyTimer.STATE_STANDBY) {
      Ui.pushView(new MyMenuGeneric(:menuTimer),
                  new MyMenuGenericDelegate(:menuTimer),
                  Ui.SLIDE_IMMEDIATE);
      return true;
    }
    else if($.oMyActivity != null) {  // prevent activity data loss
      return true;
    }
    return false;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: MyViewTimerDelegate.onPreviousPage()");
    Ui.switchToView(new MyViewLog(),
                    new MyViewLogDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: MyViewTimerDelegate.onNextPage()");
    Ui.switchToView(new MyViewSpeed(),
                    new MyViewSpeedDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
