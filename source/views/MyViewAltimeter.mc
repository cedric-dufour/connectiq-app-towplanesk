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

class MyViewAltimeter extends MyView {

  //
  // FUNCTIONS: MyView (override/implement)
  //

  function initialize() {
    MyView.initialize();
  }

  function prepare() {
    //Sys.println("DEBUG: MyViewAltimeter.prepare()");
    MyView.prepare();

    // Set labels, units and colors
    // ... density altitude (dynamic color)
    (View.findDrawableById("labelTopLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelAltitudeDensity) as String);
    (View.findDrawableById("unitTopLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitElevation]));
    // ... temperature (dynamic color)
    (View.findDrawableById("labelTopRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelTemperature) as String);
    (View.findDrawableById("unitTopRight") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitTemperature]));
    // ... altitude
    (View.findDrawableById("labelLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelAltitude) as String);
    (View.findDrawableById("unitLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitElevation]));
    (self.oRezValueLeft as Ui.Text).setColor(self.iColorText);
    // ... ISA temperature offset
    (View.findDrawableById("labelCenter") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelTemperatureISAOffset) as String);
    (self.oRezValueCenter as Ui.Text).setColor(self.iColorText);
    // ... QNH
    (View.findDrawableById("labelRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelPressureQNH) as String);
    (View.findDrawableById("unitRight") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitPressure]));
    (self.oRezValueRight as Ui.Text).setColor(self.iColorText);
    // ... pressure altitude (FL)
    (View.findDrawableById("labelBottomLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelAltitudeISA) as String);
    (View.findDrawableById("unitBottomLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitElevation]));
    (self.oRezValueBottomLeft as Ui.Text).setColor(self.iColorText);
    // ... QFE
    (View.findDrawableById("labelBottomRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelPressureQFE) as String);
    (View.findDrawableById("unitBottomRight") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitPressure]));
    (self.oRezValueBottomRight as Ui.Text).setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    (self.oRezValueFooter as Ui.Text).setColor(Gfx.COLOR_DK_GRAY);
    (self.oRezValueFooter as Ui.Text).setText(Ui.loadResource(Rez.Strings.titleViewAltimeter) as String);
  }

  function updateLayout(_b) {
    //Sys.println("DEBUG: MyViewAltimeter.updateLayout()");
    MyView.updateLayout(!self.bTitleShow);

    // Fields
    var iEpochNow = Time.now().value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
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
    // ... density altitude
    (self.oRezValueTopLeft as Ui.Text).setColor(!$.oMyProcessing.bAlertFuel and $.oMyProcessing.bAlertTemperature ? Gfx.COLOR_RED : self.iColorText);
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeDensity)) {
      fValue = $.oMyAltimeter.fAltitudeDensity * $.oMySettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueTopLeft as Ui.Text).setText(sValue);
    // ... temperature
    (self.oRezValueTopRight as Ui.Text).setColor(!$.oMyProcessing.bAlertFuel and $.oMyProcessing.bAlertTemperature ? Gfx.COLOR_RED : self.iColorText);
    if(LangUtils.notNaN($.oMyAltimeter.fTemperatureActual)) {
      fValue = $.oMyAltimeter.fTemperatureActual * $.oMySettings.fUnitTemperatureCoefficient + $.oMySettings.fUnitTemperatureOffset;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueTopRight as Ui.Text).setText(sValue);
    // ... altitude
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertLeft(iColorFieldBackground);
    (self.oRezLabelLeft as Ui.Text).setColor(iColorFieldText);
    (self.oRezUnitLeft as Ui.Text).setColor(iColorFieldText);
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeActual)) {
      fValue = $.oMyAltimeter.fAltitudeActual * $.oMySettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueLeft as Ui.Text).setText(sValue);
    // ... ISA temperature offset
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertCenter(iColorFieldBackground);
    (self.oRezLabelCenter as Ui.Text).setColor(iColorFieldText);
    if(LangUtils.notNaN($.oMyAltimeter.fTemperatureActual) and LangUtils.notNaN($.oMyAltimeter.fTemperatureISA)) {
      fValue = ($.oMyAltimeter.fTemperatureActual-$.oMyAltimeter.fTemperatureISA) * $.oMySettings.fUnitTemperatureCoefficient;
      sValue = fValue.format("%+.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN2;
    }
    (self.oRezValueCenter as Ui.Text).setText(sValue);
    // ... QNH
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertRight(iColorFieldBackground);
    (self.oRezLabelRight as Ui.Text).setColor(iColorFieldText);
    (self.oRezUnitRight as Ui.Text).setColor(iColorFieldText);
    if(LangUtils.notNaN($.oMyAltimeter.fQNH)) {
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
    (self.oRezValueRight as Ui.Text).setText(sValue);
    // ... pressure altitude
    if(LangUtils.notNaN($.oMyAltimeter.fAltitudeISA)) {
      fValue = $.oMyAltimeter.fAltitudeISA * $.oMySettings.fUnitElevationCoefficient;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueBottomLeft as Ui.Text).setText(sValue);
    // ... QFE
    if(LangUtils.notNaN($.oMyAltimeter.fQFE)) {
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
    (self.oRezValueBottomRight as Ui.Text).setText(sValue);
  }

}

class MyViewAltimeterDelegate extends MyViewDelegate {

  function initialize() {
    MyViewDelegate.initialize();
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
