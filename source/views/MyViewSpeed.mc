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
using Toybox.Graphics as Gfx;
using Toybox.Time;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// CLASS
//

class MyViewSpeed extends MyView {

  //
  // VARIABLES
  //

  // Resources
  // ... fields (labels)
  protected var oRezLabelBottomLeft as Ui.Text?;
  // ... strings (cache)
  private var sLabelGroundSpeed as String = "Gnd.Spd";
  private var sLabelAirSpeed as String = "Air Spd";


  //
  // FUNCTIONS: MyView (override/implement)
  //

  function initialize() {
    MyView.initialize();
  }

  function prepare() {
    //Sys.println("DEBUG: MyViewSpeed.prepare()");
    MyView.prepare();

    // Load resources
    // ... fields (labels)
    self.oRezLabelBottomLeft = View.findDrawableById("labelBottomLeft") as Ui.Text;
    // ... strings
    self.sLabelGroundSpeed = Ui.loadResource(Rez.Strings.labelGroundSpeed) as String;
    self.sLabelAirSpeed = Ui.loadResource(Rez.Strings.labelAirSpeed) as String;

    // Set labels, units and color
    // ... tow speed
    (View.findDrawableById("labelTopLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelTowSpeed) as String);
    (View.findDrawableById("unitTopLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitHorizontalSpeed]));
    (self.oRezValueTopLeft as Ui.Text).setColor(self.iColorText);
    // ... flight time
    (View.findDrawableById("labelTopRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelElapsedFlight) as String);
    (View.findDrawableById("unitTopRight") as Ui.Text).setText($.MY_NOVALUE_BLANK);
    (self.oRezValueTopRight as Ui.Text).setColor(self.iColorText);
    // ... vertical speed
    (View.findDrawableById("labelLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelVerticalSpeed) as String);
    (View.findDrawableById("unitLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitVerticalSpeed]));
    (self.oRezValueLeft as Ui.Text).setColor(self.iColorText);
    // ... callsign (dynamic label)
    (self.oRezValueCenter as Ui.Text).setColor(self.iColorText);
    // ... altitude
    (View.findDrawableById("labelRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelAltitude) as String);
    (View.findDrawableById("unitRight") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitElevation]));
    (self.oRezValueRight as Ui.Text).setColor(self.iColorText);
    // ... ground speed / air speed (dynamic label)
    (View.findDrawableById("unitBottomLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitHorizontalSpeed]));
    (self.oRezValueBottomLeft as Ui.Text).setColor(self.iColorText);
    // ... heading
    (View.findDrawableById("labelBottomRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelHeading) as String);
    (View.findDrawableById("unitBottomRight") as Ui.Text).setText("[°]");
    (self.oRezValueBottomRight as Ui.Text).setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    (self.oRezValueFooter as Ui.Text).setColor(Gfx.COLOR_DK_GRAY);
    (self.oRezValueFooter as Ui.Text).setText(Ui.loadResource(Rez.Strings.titleViewSpeed) as String);
  }

  function updateLayout(_b) {
    //Sys.println("DEBUG: MyViewSpeed.updateLayout()");
    MyView.updateLayout(!self.bTitleShow);

    // Fields
    var oTimeNow = Time.now();
    var iEpochNow = oTimeNow.value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
      self.iFieldIndex = (self.iFieldIndex + 1) % 2;
      self.iFieldEpoch = iEpochNow;
    }

    // Colors
    // ... background
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorFieldsBackground($.oMyProcessing.bAlertFuel ? Gfx.COLOR_DK_RED : Gfx.COLOR_TRANSPARENT);
    // ... alert fields
    var iColorFieldBackground = Gfx.COLOR_TRANSPARENT;
    var iColorFieldText = Gfx.COLOR_DK_GRAY;
    if($.oMyProcessing.bAlertTemperature) {
      iColorFieldBackground = Gfx.COLOR_RED;
      iColorFieldText = self.iColorText;
    }
    else if($.oMyProcessing.bAlertAltitude) {
      iColorFieldBackground = Gfx.COLOR_ORANGE;
      iColorFieldText = self.iColorText;
    }

    // Set values
    var fValue;
    var sValue;
    // ... tow speed
    if($.oMyGlider != null and LangUtils.notNaN(($.oMyGlider as MyGlider).fSpeedTowing)) {
      fValue = ($.oMyGlider as MyGlider).fSpeedTowing * $.oMySettings.fUnitHorizontalSpeedCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN2;
    }
    (self.oRezValueTopLeft as Ui.Text).setText(sValue);
    // ... flight time
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
    (self.oRezValueTopRight as Ui.Text).setText(sValue);
    // ... vertical speed
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertLeft(iColorFieldBackground);
    (self.oRezLabelLeft as Ui.Text).setColor(iColorFieldText);
    (self.oRezUnitLeft as Ui.Text).setColor(iColorFieldText);
    if(LangUtils.notNaN($.oMyProcessing.fVerticalSpeed)) {
      fValue = $.oMyProcessing.fVerticalSpeed * $.oMySettings.fUnitVerticalSpeedCoefficient;
      if($.oMySettings.fUnitVerticalSpeedCoefficient < 100.0f) {
        sValue = fValue.format("%+.1f");
      }
      else {
        sValue = fValue.format("%+.0f");
      }
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueLeft as Ui.Text).setText(sValue);
    // ... callsign
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertCenter(iColorFieldBackground);
    (self.oRezLabelCenter as Ui.Text).setColor(iColorFieldText);
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelCallsignTowplane);
      sValue = $.oMyTowplane.sCallsign;
    }
    else {  // ... callsign (glider)
      (self.oRezLabelCenter as Ui.Text).setText(self.sLabelCallsignGlider);
      sValue = $.oMyGlider != null ? ($.oMyGlider as MyGlider).sCallsign : $.MY_NOVALUE_LEN2;
    }
    (self.oRezValueCenter as Ui.Text).setText(sValue);
    // ... altitude
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertRight(iColorFieldBackground);
    (self.oRezLabelRight as Ui.Text).setColor(iColorFieldText);
    (self.oRezUnitRight as Ui.Text).setColor(iColorFieldText);
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeActual)) {
      fValue = $.oMyAltimeter.fAltitudeActual * $.oMySettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueRight as Ui.Text).setText(sValue);
    // ground speed / air speed
    if(self.iFieldIndex == 1 and LangUtils.notNaN($.oMyProcessing.fGroundSpeed) and $.oMyProcessing.fGroundSpeed < $.oMyTowplane.fSpeedOffBlock) {  // ... air speed
      (self.oRezLabelBottomLeft as Ui.Text).setText(self.sLabelAirSpeed);
      if(LangUtils.notNaN($.oMyProcessing.fAirSpeed)) {
        fValue = $.oMyProcessing.fAirSpeed * $.oMySettings.fUnitHorizontalSpeedCoefficient;
        sValue = fValue.format("%.0f");
      }
      else {
        sValue = $.MY_NOVALUE_LEN3;
      }
    }
    else {  // ... ground speed
      (self.oRezLabelBottomLeft as Ui.Text).setText(self.sLabelGroundSpeed);
      if(LangUtils.notNaN($.oMyProcessing.fGroundSpeed)) {
        fValue = $.oMyProcessing.fGroundSpeed * $.oMySettings.fUnitHorizontalSpeedCoefficient;
        sValue = fValue.format("%.0f");
      }
      else {
        sValue = $.MY_NOVALUE_LEN3;
      }
    }
    (self.oRezValueBottomLeft as Ui.Text).setText(sValue);
    // ... heading
    if(LangUtils.notNaN($.oMyProcessing.fHeading)) {
      //fValue = (($.oMyProcessing.fHeading * 180.0f/Math.PI).toNumber()) % 360;
      fValue = (($.oMyProcessing.fHeading * 57.2957795131f).toNumber()) % 360;
      sValue = fValue.format("%d");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueBottomRight as Ui.Text).setText(sValue);
  }

}

class MyViewSpeedDelegate extends MyViewDelegate {

  function initialize() {
    MyViewDelegate.initialize();
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: MyViewSpeedDelegate.onPreviousPage()");
    Ui.switchToView(new MyViewTimer(),
                    new MyViewTimerDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: MyViewSpeedDelegate.onNextPage()");
    Ui.switchToView(new MyViewAltimeter(),
                    new MyViewAltimeterDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
