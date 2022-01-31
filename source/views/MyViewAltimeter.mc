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

class MyViewAltimeter extends MyViewGlobal {

  //
  // VARIABLES
  //

  // Internals
  // ... fields
  private var bTitleShow;
  private var iFieldEpoch;


  //
  // FUNCTIONS: MyViewGlobal (override/implement)
  //

  function initialize() {
    MyViewGlobal.initialize();

    // Internals
    // ... fields
    self.bTitleShow = true;
    self.iFieldEpoch = Time.now().value();
  }

  function prepare() {
    //Sys.println("DEBUG: MyViewAltimeter.prepare()");
    MyViewGlobal.prepare();

    // Set labels, units and colors
    // ... density altitude (dynamic color)
    View.findDrawableById("labelTopLeft").setText(Ui.loadResource(Rez.Strings.labelAltitudeDensity));
    View.findDrawableById("unitTopLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitElevation]));
    // ... temperature (dynamic color)
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelTemperature));
    View.findDrawableById("unitTopRight").setText(Lang.format("[$1$]", [$.oMySettings.sUnitTemperature]));
    // ... altitude
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelAltitude));
    View.findDrawableById("unitLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitElevation]));
    self.oRezValueLeft.setColor(self.iColorText);
    // ... ISA temperature offset
    View.findDrawableById("labelCenter").setText(Ui.loadResource(Rez.Strings.labelTemperatureISAOffset));
    self.oRezValueCenter.setColor(self.iColorText);
    // ... QNH
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelPressureQNH));
    View.findDrawableById("unitRight").setText(Lang.format("[$1$]", [$.oMySettings.sUnitPressure]));
    self.oRezValueRight.setColor(self.iColorText);
    // ... pressure altitude (FL)
    View.findDrawableById("labelBottomLeft").setText(Ui.loadResource(Rez.Strings.labelAltitudeISA));
    View.findDrawableById("unitBottomLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitElevation]));
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... QFE
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelPressureQFE));
    View.findDrawableById("unitBottomRight").setText(Lang.format("[$1$]", [$.oMySettings.sUnitPressure]));
    self.oRezValueBottomRight.setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewAltimeter));

    // Done
    return true;
  }

  function updateLayout() {
    //Sys.println("DEBUG: MyViewAltimeter.updateLayout()");
    MyViewGlobal.updateLayout(!self.bTitleShow);

    // Fields
    var iEpochNow = Time.now().value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
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
    // ... density altitude
    self.oRezValueTopLeft.setColor(!$.oMyProcessing.bAlertFuel and $.oMyProcessing.bAlertTemperature ? Gfx.COLOR_RED : self.iColorText);
    if($.oMyAltimeter.fAltitudeDensity != null) {
      fValue = $.oMyAltimeter.fAltitudeDensity * $.oMySettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueTopLeft.setText(sValue);
    // ... temperature
    self.oRezValueTopRight.setColor(!$.oMyProcessing.bAlertFuel and $.oMyProcessing.bAlertTemperature ? Gfx.COLOR_RED : self.iColorText);
    if($.oMyAltimeter.fTemperatureActual != null) {
      fValue = $.oMyAltimeter.fTemperatureActual * $.oMySettings.fUnitTemperatureCoefficient + $.oMySettings.fUnitTemperatureOffset;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueTopRight.setText(sValue);
    // ... altitude
    self.oRezDrawableGlobal.setColorAlertLeft(iColorFieldBackground);
    self.oRezLabelLeft.setColor(iColorFieldText);
    self.oRezUnitLeft.setColor(iColorFieldText);
    if($.oMyAltimeter.fAltitudeActual != null) {
      fValue = $.oMyAltimeter.fAltitudeActual * $.oMySettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueLeft.setText(sValue);
    // ... ISA temperature offset
    self.oRezDrawableGlobal.setColorAlertCenter(iColorFieldBackground);
    self.oRezLabelCenter.setColor(iColorFieldText);
    if($.oMyAltimeter.fTemperatureActual != null and $.oMyAltimeter.fTemperatureISA != null) {
      fValue = ($.oMyAltimeter.fTemperatureActual-$.oMyAltimeter.fTemperatureISA) * $.oMySettings.fUnitTemperatureCoefficient;
      sValue = fValue.format("%+.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN2;
    }
    self.oRezValueCenter.setText(sValue);
    // ... QNH
    self.oRezDrawableGlobal.setColorAlertRight(iColorFieldBackground);
    self.oRezLabelRight.setColor(iColorFieldText);
    self.oRezUnitRight.setColor(iColorFieldText);
    if($.oMyAltimeter.fQNH != null) {
      fValue = $.oMyAltimeter.fQNH * $.oMySettings.fUnitPressureCoefficient;
      if(fValue < 100.0f) {
        sValue = fValue.format("%.2f");
      }
      else {
        sValue = fValue.format("%.0f");
      }
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueRight.setText(sValue);
    // ... pressure altitude
    if($.oMyAltimeter.fAltitudeISA != null) {
      fValue = $.oMyAltimeter.fAltitudeISA * $.oMySettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueBottomLeft.setText(sValue);
    // ... QFE
    if($.oMyAltimeter.fQFE != null) {
      fValue = $.oMyAltimeter.fQFE * $.oMySettings.fUnitPressureCoefficient;
      if(fValue < 100.0f) {
        sValue = fValue.format("%.2f");
      }
      else {
        sValue = fValue.format("%.0f");
      }
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    self.oRezValueBottomRight.setText(sValue);
  }

}

class MyViewAltimeterDelegate extends MyViewGlobalDelegate {

  function initialize() {
    MyViewGlobalDelegate.initialize();
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: MyViewAltimeterDelegate.onPreviousPage()");
    Ui.switchToView(new MyViewSpeed(),
                    new MyViewSpeedDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: MyViewAltimeterDelegate.onNextPage()");
    Ui.switchToView(new MyViewTowplane(),
                    new MyViewTowplaneDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
