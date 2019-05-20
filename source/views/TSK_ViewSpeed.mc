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
  // ... strings (cache)
  private var sLabelCallsignTowplane;
  private var sLabelCallsignGlider;
  private var sLabelTowSpeed;

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
    // ... strings
    self.sLabelCallsignTowplane = Ui.loadResource(Rez.Strings.labelCallsignTowplane);
    self.sLabelCallsignGlider = Ui.loadResource(Rez.Strings.labelCallsignGlider);
    self.sLabelTowSpeed = Ui.loadResource(Rez.Strings.labelTowSpeed);

    // Set labels, units and color
    // ... ground speed
    View.findDrawableById("labelTopLeft").setText(Ui.loadResource(Rez.Strings.labelGroundSpeed));
    View.findDrawableById("unitTopLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitHorizontalSpeed]));
    self.oRezValueTopLeft.setColor(self.iColorText);
    // ... heading
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelHeading));
    View.findDrawableById("unitTopRight").setText("[°]");
    self.oRezValueTopRight.setColor(self.iColorText);
    // ... air speed
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelAirSpeed));
    View.findDrawableById("unitLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitHorizontalSpeed]));
    self.oRezValueLeft.setColor(self.iColorText);
    // ... callsign / tow speed (dynamic label)
    self.oRezValueCenter.setColor(self.iColorText);
    // ... vertical speed
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelVerticalSpeed));
    View.findDrawableById("unitRight").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitVerticalSpeed]));
    self.oRezValueRight.setColor(self.iColorText);
    // ... wind speed
    View.findDrawableById("labelBottomLeft").setText(Ui.loadResource(Rez.Strings.labelWindSpeed));
    View.findDrawableById("unitBottomLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitHorizontalSpeed]));
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... wind direction
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelWindDirection));
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
    var iEpochNow = Time.now().value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
      self.iFieldIndex = (self.iFieldIndex + 1) % 3;
      self.iFieldEpoch = iEpochNow;
    }

    // Colors
    // ... background
    self.oRezDrawableGlobal.setColorFieldsBackground($.TSK_oProcessing.bAlertFuel ? Gfx.COLOR_DK_RED : Gfx.COLOR_TRANSPARENT);
    // ... alert fields
    var iColorFieldBackground = Gfx.COLOR_TRANSPARENT;
    var iColorFieldText = Gfx.COLOR_DK_GRAY;
    if($.TSK_oGlider != null and $.TSK_oProcessing.fAirSpeed != null and $.TSK_oProcessing.fAirSpeed < $.TSK_oTowplane.fSpeedMaxTowing) {
      var fSpeedDelta = ($.TSK_oProcessing.fAirSpeed - $.TSK_oGlider.fSpeedTowing) / $.TSK_oGlider.fSpeedTowing;
      if(fSpeedDelta < 0.0f) {
        fSpeedDelta = -fSpeedDelta;
      }
      if(fSpeedDelta > 0.15f) {  // more than 15%
        iColorFieldBackground = Gfx.COLOR_RED;
        iColorFieldText = self.iColorText;
      }
      else if(fSpeedDelta > 0.05f) {  // more than 5%
        iColorFieldBackground = Gfx.COLOR_ORANGE;
        iColorFieldText = self.iColorText;
      }
      else {  // within tolerance
        iColorFieldBackground = Gfx.COLOR_DK_GREEN;
        iColorFieldText = self.iColorText;
      }
    }

    // Set values
    var fValue;
    var sValue;
    // ... ground speed
    if($.TSK_oProcessing.fGroundSpeed != null) {
      fValue = $.TSK_oProcessing.fGroundSpeed * $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueTopLeft.setText(sValue);
    // ... heading
    if($.TSK_oProcessing.fHeading != null) {
      //fValue = (($.TSK_oProcessing.fHeading * 180.0f/Math.PI).toNumber()) % 360;
      fValue = (($.TSK_oProcessing.fHeading * 57.2957795131f).toNumber()) % 360;
      sValue = fValue.format("%d");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueTopRight.setText(sValue);
    // ... air speed
    self.oRezDrawableGlobal.setColorAlertLeft(iColorFieldBackground);
    self.oRezLabelLeft.setColor(iColorFieldText);
    self.oRezUnitLeft.setColor(iColorFieldText);
    if($.TSK_oProcessing.fAirSpeed != null) {
      fValue = $.TSK_oProcessing.fAirSpeed * $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueLeft.setText(sValue);
    // ... callsign / tow speed
    self.oRezDrawableGlobal.setColorAlertCenter(iColorFieldBackground);
    self.oRezLabelCenter.setColor(iColorFieldText);
    if(self.iFieldIndex == 0) {  // ... callsign (towplane)
      self.oRezLabelCenter.setText(self.sLabelCallsignTowplane);
      sValue = $.TSK_oTowplane.sCallsign;
    }
    else if(self.iFieldIndex == 1) {  // ... callsign (glider)
      self.oRezLabelCenter.setText(self.sLabelCallsignGlider);
      sValue = $.TSK_oGlider != null ? $.TSK_oGlider.sCallsign : $.TSK_NOVALUE_LEN2;
    }
    else {  // ... tow speed
      self.oRezLabelCenter.setText(self.sLabelTowSpeed);
      if($.TSK_oGlider != null and $.TSK_oGlider.fSpeedTowing != null) {
        fValue = $.TSK_oGlider.fSpeedTowing * $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;
        sValue = fValue.format("%.0f");
      }
      else {
        sValue = $.TSK_NOVALUE_LEN2;
      }
    }
    self.oRezValueCenter.setText(sValue);
    // ... vertical speed
    self.oRezDrawableGlobal.setColorAlertRight(iColorFieldBackground);
    self.oRezLabelRight.setColor(iColorFieldText);
    self.oRezUnitRight.setColor(iColorFieldText);
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
    self.oRezValueRight.setText(sValue);
    // ... wind speed
    if($.TSK_oSettings.fWindSpeed != null) {
      fValue = $.TSK_oSettings.fWindSpeed * $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueBottomLeft.setText(sValue);
    // ... wind direction
    if($.TSK_oSettings.fWindDirection != null) {
      //fValue = (($.TSK_oSettings.fWindDirection * 180.0f/Math.PI).toNumber()) % 360;
      fValue = (($.TSK_oSettings.fWindDirection * 57.2957795131f).toNumber()) % 360;
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
    Ui.switchToView(new TSK_ViewAltimeter(), new TSK_ViewAltimeterDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: TSK_ViewSpeedDelegate.onNextPage()");
    Ui.switchToView(new TSK_ViewTowplane(), new TSK_ViewTowplaneDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
