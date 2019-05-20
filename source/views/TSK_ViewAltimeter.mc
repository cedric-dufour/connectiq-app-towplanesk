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

class TSK_ViewAltimeter extends TSK_ViewGlobal {

  //
  // VARIABLES
  //

  // Internals
  // ... fields
  private var bTitleShow;
  private var iFieldEpoch;


  //
  // FUNCTIONS: TSK_ViewGlobal (override/implement)
  //

  function initialize() {
    TSK_ViewGlobal.initialize();

    // Internals
    // ... fields
    self.bTitleShow = true;
    self.iFieldEpoch = Time.now().value();
  }

  function prepare() {
    //Sys.println("DEBUG: TSK_ViewAltimeter.prepare()");
    TSK_ViewGlobal.prepare();

    // Set labels, units and colors
    // ... density altitude (dynamic color)
    View.findDrawableById("labelTopLeft").setText(Ui.loadResource(Rez.Strings.labelAltitudeDensity));
    View.findDrawableById("unitTopLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitElevation]));
    // ... temperature (dynamic color)
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelTemperature));
    View.findDrawableById("unitTopRight").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitTemperature]));
    // ... altitude
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelAltitude));
    View.findDrawableById("unitLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitElevation]));
    self.oRezValueLeft.setColor(self.iColorText);
    // ... ISA temperature offset
    View.findDrawableById("labelCenter").setText(Ui.loadResource(Rez.Strings.labelTemperatureISAOffset));
    self.oRezValueCenter.setColor(self.iColorText);
    // ... QNH
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelPressureQNH));
    View.findDrawableById("unitRight").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitPressure]));
    self.oRezValueRight.setColor(self.iColorText);
    // ... pressure altitude (FL)
    View.findDrawableById("labelBottomLeft").setText(Ui.loadResource(Rez.Strings.labelAltitudeISA));
    View.findDrawableById("unitBottomLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitElevation]));
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... QFE
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelPressureQFE));
    View.findDrawableById("unitBottomRight").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitPressure]));
    self.oRezValueBottomRight.setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewAltimeter));

    // Done
    return true;
  }

  function updateLayout() {
    //Sys.println("DEBUG: TSK_ViewAltimeter.updateLayout()");
    TSK_ViewGlobal.updateLayout(!self.bTitleShow);

    // Fields
    var iEpochNow = Time.now().value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
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
    // ... density altitude
    self.oRezValueTopLeft.setColor(!$.TSK_oProcessing.bAlertFuel and $.TSK_oProcessing.bAlertTemperature ? Gfx.COLOR_RED : self.iColorText);
    if($.TSK_oAltimeter.fAltitudeDensity != null) {
      fValue = $.TSK_oAltimeter.fAltitudeDensity * $.TSK_oSettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueTopLeft.setText(sValue);
    // ... temperature
    self.oRezValueTopRight.setColor(!$.TSK_oProcessing.bAlertFuel and $.TSK_oProcessing.bAlertTemperature ? Gfx.COLOR_RED : self.iColorText);
    if($.TSK_oAltimeter.fTemperatureActual != null) {
      fValue = $.TSK_oAltimeter.fTemperatureActual * $.TSK_oSettings.fUnitTemperatureCoefficient + $.TSK_oSettings.fUnitTemperatureOffset;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueTopRight.setText(sValue);
    // ... altitude
    self.oRezDrawableGlobal.setColorAlertLeft(iColorFieldBackground);
    self.oRezLabelLeft.setColor(iColorFieldText);
    self.oRezUnitLeft.setColor(iColorFieldText);
    if($.TSK_oAltimeter.fAltitudeActual != null) {
      fValue = $.TSK_oAltimeter.fAltitudeActual * $.TSK_oSettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueLeft.setText(sValue);
    // ... ISA temperature offset
    self.oRezDrawableGlobal.setColorAlertCenter(iColorFieldBackground);
    self.oRezLabelCenter.setColor(iColorFieldText);
    if($.TSK_oAltimeter.fTemperatureActual != null and $.TSK_oAltimeter.fTemperatureISA != null) {
      fValue = ($.TSK_oAltimeter.fTemperatureActual-$.TSK_oAltimeter.fTemperatureISA) * $.TSK_oSettings.fUnitTemperatureCoefficient;
      sValue = fValue.format("%+.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN2;
    }
    self.oRezValueCenter.setText(sValue);
    // ... QNH
    self.oRezDrawableGlobal.setColorAlertRight(iColorFieldBackground);
    self.oRezLabelRight.setColor(iColorFieldText);
    self.oRezUnitRight.setColor(iColorFieldText);
    if($.TSK_oAltimeter.fQNH != null) {
      fValue = $.TSK_oAltimeter.fQNH * $.TSK_oSettings.fUnitPressureCoefficient;
      if(fValue < 100.0f) {
        sValue = fValue.format("%.2f");
      }
      else {
        sValue = fValue.format("%.0f");
      }
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueRight.setText(sValue);
    // ... pressure altitude
    if($.TSK_oAltimeter.fAltitudeISA != null) {
      fValue = $.TSK_oAltimeter.fAltitudeISA * $.TSK_oSettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueBottomLeft.setText(sValue);
    // ... QFE
    if($.TSK_oAltimeter.fQFE != null) {
      fValue = $.TSK_oAltimeter.fQFE * $.TSK_oSettings.fUnitPressureCoefficient;
      if(fValue < 100.0f) {
        sValue = fValue.format("%.2f");
      }
      else {
        sValue = fValue.format("%.0f");
      }
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueBottomRight.setText(sValue);
  }

}

class TSK_ViewAltimeterDelegate extends TSK_ViewGlobalDelegate {

  function initialize() {
    TSK_ViewGlobalDelegate.initialize();
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: TSK_ViewAltimeterDelegate.onPreviousPage()");
    Ui.switchToView(new TSK_ViewTimer(), new TSK_ViewTimerDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: TSK_ViewAltimeterDelegate.onNextPage()");
    Ui.switchToView(new TSK_ViewSpeed(), new TSK_ViewSpeedDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
