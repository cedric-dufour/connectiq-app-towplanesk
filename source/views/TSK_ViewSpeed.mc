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

class TSK_ViewSpeed extends TSK_ViewGlobal {

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
    //Sys.println("DEBUG: TSK_ViewSpeed.prepare()");
    TSK_ViewGlobal.prepare();

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
    View.findDrawableById("unitTopLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitHorizontalSpeed]));
    self.oRezValueTopLeft.setColor(self.iColorText);
    // ... flight time
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelElapsedFlight));
    View.findDrawableById("unitTopRight").setText($.TSK_NOVALUE_BLANK);
    self.oRezValueTopRight.setColor(self.iColorText);
    // ... vertical speed
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelVerticalSpeed));
    View.findDrawableById("unitLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitVerticalSpeed]));
    self.oRezValueLeft.setColor(self.iColorText);
    // ... callsign (dynamic label)
    self.oRezValueCenter.setColor(self.iColorText);
    // ... altitude
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelAltitude));
    View.findDrawableById("unitRight").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitElevation]));
    self.oRezValueRight.setColor(self.iColorText);
    // ... ground speed / air speed (dynamic label)
    View.findDrawableById("unitBottomLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitHorizontalSpeed]));
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
    //Sys.println("DEBUG: TSK_ViewSpeed.updateLayout()");
    TSK_ViewGlobal.updateLayout(!self.bTitleShow);

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
    self.oRezDrawableGlobal.setColorFieldsBackground($.TSK_oProcessing.bAlertFuel ? Gfx.COLOR_DK_RED : Gfx.COLOR_TRANSPARENT);
    // ... alert fields
    var iColorFieldBackground = Gfx.COLOR_TRANSPARENT;
    var iColorFieldText = Gfx.COLOR_DK_GRAY;
    if($.TSK_oProcessing.bAlertTemperature) {
      iColorFieldBackground = Gfx.COLOR_RED;
      iColorFieldText = self.iColorText;
    }
    else if($.TSK_oProcessing.bAlertAltitude) {
      iColorFieldBackground = Gfx.COLOR_ORANGE;
      iColorFieldText = self.iColorText;
    }

    // Set values
    var fValue;
    var sValue;
    // ... tow speed
    if($.TSK_oGlider != null and $.TSK_oGlider.fSpeedTowing != null) {
      fValue = $.TSK_oGlider.fSpeedTowing * $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN2;
    }
    self.oRezValueTopLeft.setText(sValue);
    // ... flight time
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
    self.oRezValueTopRight.setText(sValue);
    // ... vertical speed
    self.oRezDrawableGlobal.setColorAlertLeft(iColorFieldBackground);
    self.oRezLabelLeft.setColor(iColorFieldText);
    self.oRezUnitLeft.setColor(iColorFieldText);
    if($.TSK_oProcessing.fVerticalSpeed != null) {
      fValue = $.TSK_oProcessing.fVerticalSpeed * $.TSK_oSettings.fUnitVerticalSpeedCoefficient;
      if($.TSK_oSettings.fUnitVerticalSpeedCoefficient < 100.0f) {
        sValue = fValue.format("%+.1f");
      }
      else {
        sValue = fValue.format("%+.0f");
      }
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueLeft.setText(sValue);
    // ... callsign
    self.oRezDrawableGlobal.setColorAlertCenter(iColorFieldBackground);
    self.oRezLabelCenter.setColor(iColorFieldText);
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      self.oRezLabelCenter.setText(self.sLabelCallsignTowplane);
      sValue = $.TSK_oTowplane.sCallsign;
    }
    else {  // ... callsign (glider)
      self.oRezLabelCenter.setText(self.sLabelCallsignGlider);
      sValue = $.TSK_oGlider != null ? $.TSK_oGlider.sCallsign : $.TSK_NOVALUE_LEN2;
    }
    self.oRezValueCenter.setText(sValue);
    // ... altitude
    self.oRezDrawableGlobal.setColorAlertRight(iColorFieldBackground);
    self.oRezLabelRight.setColor(iColorFieldText);
    self.oRezUnitRight.setColor(iColorFieldText);
    if($.TSK_oAltimeter.fAltitudeActual != null) {
      fValue = $.TSK_oAltimeter.fAltitudeActual * $.TSK_oSettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueRight.setText(sValue);
    // ground speed / air speed
    if(self.iFieldIndex == 1 and $.TSK_oProcessing.fGroundSpeed != null and $.TSK_oProcessing.fGroundSpeed < $.TSK_oTowplane.fSpeedOffBlock) {  // ... air speed
      self.oRezLabelBottomLeft.setText(self.sLabelAirSpeed);
      if($.TSK_oProcessing.fAirSpeed != null) {
        fValue = $.TSK_oProcessing.fAirSpeed * $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;
        sValue = fValue.format("%.0f");
      }
      else {
        sValue = $.TSK_NOVALUE_LEN3;
      }
    }
    else {  // ... ground speed
      self.oRezLabelBottomLeft.setText(self.sLabelGroundSpeed);
      if($.TSK_oProcessing.fGroundSpeed != null) {
        fValue = $.TSK_oProcessing.fGroundSpeed * $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;
        sValue = fValue.format("%.0f");
      }
      else {
        sValue = $.TSK_NOVALUE_LEN3;
      }
    }
    self.oRezValueBottomLeft.setText(sValue);
    // ... heading
    if($.TSK_oProcessing.fHeading != null) {
      //fValue = (($.TSK_oProcessing.fHeading * 180.0f/Math.PI).toNumber()) % 360;
      fValue = (($.TSK_oProcessing.fHeading * 57.2957795131f).toNumber()) % 360;
      sValue = fValue.format("%d");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueBottomRight.setText(sValue);
  }

}

class TSK_ViewSpeedDelegate extends TSK_ViewGlobalDelegate {

  function initialize() {
    TSK_ViewGlobalDelegate.initialize();
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: TSK_ViewSpeedDelegate.onPreviousPage()");
    Ui.switchToView(new TSK_ViewTimer(), new TSK_ViewTimerDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: TSK_ViewSpeedDelegate.onNextPage()");
    Ui.switchToView(new TSK_ViewAltimeter(), new TSK_ViewAltimeterDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
