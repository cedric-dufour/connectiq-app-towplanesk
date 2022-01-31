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

class MyViewSpeed extends MyViewGlobal {

  //
  // VARIABLES
  //

  // Resources
  // ... fields (labels)
  protected var oRezLabelBottomLeft;
  // ... strings (cache)
  private var sLabelCallsignTowplane;
  private var sLabelCallsignGlider;
  private var sLabelGroundSpeed;
  private var sLabelAirSpeed;

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
    //Sys.println("DEBUG: MyViewSpeed.prepare()");
    MyViewGlobal.prepare();

    // Load resources
    // ... fields (labels)
    self.oRezLabelBottomLeft = View.findDrawableById("labelBottomLeft");
    // ... strings
    self.sLabelCallsignTowplane = Ui.loadResource(Rez.Strings.labelCallsignTowplane);
    self.sLabelCallsignGlider = Ui.loadResource(Rez.Strings.labelCallsignGlider);
    self.sLabelGroundSpeed = Ui.loadResource(Rez.Strings.labelGroundSpeed);
    self.sLabelAirSpeed = Ui.loadResource(Rez.Strings.labelAirSpeed);

    // Set labels, units and color
    // ... tow speed
    View.findDrawableById("labelTopLeft").setText(Ui.loadResource(Rez.Strings.labelTowSpeed));
    View.findDrawableById("unitTopLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitHorizontalSpeed]));
    self.oRezValueTopLeft.setColor(self.iColorText);
    // ... flight time
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelElapsedFlight));
    View.findDrawableById("unitTopRight").setText($.MY_NOVALUE_BLANK);
    self.oRezValueTopRight.setColor(self.iColorText);
    // ... vertical speed
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelVerticalSpeed));
    View.findDrawableById("unitLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitVerticalSpeed]));
    self.oRezValueLeft.setColor(self.iColorText);
    // ... callsign (dynamic label)
    self.oRezValueCenter.setColor(self.iColorText);
    // ... altitude
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelAltitude));
    View.findDrawableById("unitRight").setText(Lang.format("[$1$]", [$.oMySettings.sUnitElevation]));
    self.oRezValueRight.setColor(self.iColorText);
    // ... ground speed / air speed (dynamic label)
    View.findDrawableById("unitBottomLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitHorizontalSpeed]));
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... heading
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelHeading));
    View.findDrawableById("unitBottomRight").setText("[°]");
    self.oRezValueBottomRight.setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewSpeed));

    // Done
    return true;
  }

  function updateLayout() {
    //Sys.println("DEBUG: MyViewSpeed.updateLayout()");
    MyViewGlobal.updateLayout(!self.bTitleShow);

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
    self.oRezDrawableGlobal.setColorFieldsBackground($.oMyProcessing.bAlertFuel ? Gfx.COLOR_DK_RED : Gfx.COLOR_TRANSPARENT);
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
    if($.oMyGlider != null and $.oMyGlider.fSpeedTowing != null) {
      fValue = $.oMyGlider.fSpeedTowing * $.oMySettings.fUnitHorizontalSpeedCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN2;
    }
    self.oRezValueTopLeft.setText(sValue);
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
    self.oRezValueTopRight.setText(sValue);
    // ... vertical speed
    self.oRezDrawableGlobal.setColorAlertLeft(iColorFieldBackground);
    self.oRezLabelLeft.setColor(iColorFieldText);
    self.oRezUnitLeft.setColor(iColorFieldText);
    if($.oMyProcessing.fVerticalSpeed != null) {
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
    self.oRezValueLeft.setText(sValue);
    // ... callsign
    self.oRezDrawableGlobal.setColorAlertCenter(iColorFieldBackground);
    self.oRezLabelCenter.setColor(iColorFieldText);
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      self.oRezLabelCenter.setText(self.sLabelCallsignTowplane);
      sValue = $.oMyTowplane.sCallsign;
    }
    else {  // ... callsign (glider)
      self.oRezLabelCenter.setText(self.sLabelCallsignGlider);
      sValue = $.oMyGlider != null ? $.oMyGlider.sCallsign : $.MY_NOVALUE_LEN2;
    }
    self.oRezValueCenter.setText(sValue);
    // ... altitude
    self.oRezDrawableGlobal.setColorAlertRight(iColorFieldBackground);
    self.oRezLabelRight.setColor(iColorFieldText);
    self.oRezUnitRight.setColor(iColorFieldText);
    if($.oMyAltimeter.fAltitudeActual != null) {
      fValue = $.oMyAltimeter.fAltitudeActual * $.oMySettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueRight.setText(sValue);
    // ground speed / air speed
    if(self.iFieldIndex == 1 and $.oMyProcessing.fGroundSpeed != null and $.oMyProcessing.fGroundSpeed < $.oMyTowplane.fSpeedOffBlock) {  // ... air speed
      self.oRezLabelBottomLeft.setText(self.sLabelAirSpeed);
      if($.oMyProcessing.fAirSpeed != null) {
        fValue = $.oMyProcessing.fAirSpeed * $.oMySettings.fUnitHorizontalSpeedCoefficient;
        sValue = fValue.format("%.0f");
      }
      else {
        sValue = $.MY_NOVALUE_LEN3;
      }
    }
    else {  // ... ground speed
      self.oRezLabelBottomLeft.setText(self.sLabelGroundSpeed);
      if($.oMyProcessing.fGroundSpeed != null) {
        fValue = $.oMyProcessing.fGroundSpeed * $.oMySettings.fUnitHorizontalSpeedCoefficient;
        sValue = fValue.format("%.0f");
      }
      else {
        sValue = $.MY_NOVALUE_LEN3;
      }
    }
    self.oRezValueBottomLeft.setText(sValue);
    // ... heading
    if($.oMyProcessing.fHeading != null) {
      //fValue = (($.oMyProcessing.fHeading * 180.0f/Math.PI).toNumber()) % 360;
      fValue = (($.oMyProcessing.fHeading * 57.2957795131f).toNumber()) % 360;
      sValue = fValue.format("%d");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueBottomRight.setText(sValue);
  }

}

class MyViewSpeedDelegate extends MyViewGlobalDelegate {

  function initialize() {
    MyViewGlobalDelegate.initialize();
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
