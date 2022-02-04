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

import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.Time;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// CLASS
//

class MyViewTimer extends MyView {

  //
  // VARIABLES
  //

  // Resources
  // ... strings (cache)
  private var sLabelFlightCycles as String = "Cycles";


  //
  // FUNCTIONS: MyView (override/implement)
  //

  function initialize() {
    MyView.initialize();
  }

  function prepare() {
    //Sys.println("DEBUG: MyViewTimer.prepare()");
    MyView.prepare();

    // Load resources
    // ... strings
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
    (self.oRezValueFooter as Ui.Text).setText(Ui.loadResource(Rez.Strings.titleViewTimer) as String);
  }

  function updateLayout(_b) {
    //Sys.println("DEBUG: MyViewTimer.updateLayout()");
    MyView.updateLayout(!self.bTitleShow);

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
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorFieldsBackground($.oMyProcessing.bAlertFuel ? Gfx.COLOR_DK_RED : Gfx.COLOR_TRANSPARENT);

    // Set values
    var sValue;
    // ... off-block time
    if($.oMyTimer.oTimeOffBlock != null) {
      sValue = LangUtils.formatTime($.oMyTimer.oTimeOffBlock, $.oMySettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueTopLeft as Ui.Text).setText(sValue);
    // ... takeoff time
    if($.oMyTimer.oTimeTakeoff != null) {
      sValue = LangUtils.formatTime($.oMyTimer.oTimeTakeoff, $.oMySettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueTopRight as Ui.Text).setText(sValue);
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
    (self.oRezValueLeft as Ui.Text).setText(sValue);
    // ... callsign / cycles
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelCallsignTowplane);
      sValue = $.oMyTowplane.sCallsign;
    }
    else if(self.iFieldIndex == 1) {  // ... callsign (glider)
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelCallsignGlider);
      sValue = $.oMyGlider != null ? ($.oMyGlider as MyGlider).sCallsign : $.MY_NOVALUE_LEN2;
    }
    else {  // ... cycles
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelFlightCycles);
      sValue = $.oMyTimer.iCountCycles.format("%d");
    }
    (self.oRezValueCenter as Ui.Text).setText(sValue);
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
    (self.oRezValueRight as Ui.Text).setText(sValue);
    // ... time: on-block
    if($.oMyTimer.oTimeOnBlock != null) {
      sValue = LangUtils.formatTime($.oMyTimer.oTimeOnBlock, $.oMySettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueBottomLeft as Ui.Text).setText(sValue);
    // ... time: landing
    if($.oMyTimer.oTimeLanding != null) {
      sValue = LangUtils.formatTime($.oMyTimer.oTimeLanding, $.oMySettings.bUnitTimeUTC, false);
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueBottomRight as Ui.Text).setText(sValue);
  }

}

class MyViewTimerDelegate extends MyViewDelegate {

  function initialize() {
    MyViewDelegate.initialize();
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
