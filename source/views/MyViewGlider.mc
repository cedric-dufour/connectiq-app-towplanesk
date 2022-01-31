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

class MyViewGlider extends MyViewGlobal {

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
    //Sys.println("DEBUG: MyViewGlider.prepare()");
    MyViewGlobal.prepare();

    // Set labels, units and colors
    View.findDrawableById("valueFooter").setText(Ui.loadResource(Rez.Strings.titleAircraftGlider));
    self.oRezValueFooter.setColor(self.iColorText);
    // ... empty weight
    View.findDrawableById("labelTopLeft").setText(Ui.loadResource(Rez.Strings.labelWeightEmpty));
    View.findDrawableById("unitTopLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitWeight]));
    self.oRezValueTopLeft.setColor(self.iColorText);
    // ... payload weight
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelWeightPayload));
    View.findDrawableById("unitTopRight").setText(Lang.format("[$1$]", [$.oMySettings.sUnitWeight]));
    self.oRezValueTopRight.setColor(self.iColorText);
    // ... total weight
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelWeightTotal));
    View.findDrawableById("unitLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitWeight]));
    self.oRezValueLeft.setColor(self.iColorText);
    // ... callsign
    View.findDrawableById("labelCenter").setText(Ui.loadResource(Rez.Strings.labelCallsign));
    self.oRezValueCenter.setColor(self.iColorText);
    // ... max. takeoff weight
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelWeightMaxTakeoff));
    View.findDrawableById("unitRight").setText(Lang.format("[$1$]", [$.oMySettings.sUnitWeight]));
    self.oRezValueRight.setColor(self.iColorText);
    // ... ballast weight
    View.findDrawableById("labelBottomLeft").setText(Ui.loadResource(Rez.Strings.labelWeightBallast));
    View.findDrawableById("unitBottomLeft").setText(Lang.format("[$1$]", [$.oMySettings.sUnitWeight]));
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... tow speed
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelTowSpeed));
    View.findDrawableById("unitBottomRight").setText(Lang.format("[$1$]", [$.oMySettings.sUnitHorizontalSpeed]));
    self.oRezValueBottomRight.setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewGlider));

    // Done
    return true;
  }

  function updateLayout() {
    //Sys.println("DEBUG: MyViewGlider.updateLayout()");
    MyViewGlobal.updateLayout(!self.bTitleShow);

    // Fields
    var iEpochNow = Time.now().value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
      self.iFieldEpoch = iEpochNow;
    }

    // No glider ?
    if($.oMyGlider == null) {
      self.oRezValueTopLeft.setText($.MY_NOVALUE_LEN3);
      self.oRezValueTopRight.setText($.MY_NOVALUE_LEN3);
      self.oRezDrawableGlobal.setColorAlertLeft(Gfx.COLOR_TRANSPARENT);
      self.oRezLabelLeft.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezUnitLeft.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezValueLeft.setText($.MY_NOVALUE_LEN3);
      self.oRezDrawableGlobal.setColorAlertCenter(Gfx.COLOR_TRANSPARENT);
      self.oRezLabelCenter.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezValueCenter.setText($.MY_NOVALUE_LEN2);
      self.oRezDrawableGlobal.setColorAlertRight(Gfx.COLOR_TRANSPARENT);
      self.oRezLabelRight.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezUnitRight.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezValueRight.setText($.MY_NOVALUE_LEN3);
      self.oRezValueBottomLeft.setText($.MY_NOVALUE_LEN3);
      self.oRezValueBottomRight.setText($.MY_NOVALUE_LEN3);
      return;
    }

    // Colors
    // ... alert fields
    var iColorFieldBackground = Gfx.COLOR_TRANSPARENT;
    var iColorFieldText = Gfx.COLOR_DK_GRAY;
    var fWeightMaxTakeoff = $.oMyTowplane.fWeightMaxTowed < $.oMyGlider.fWeightMaxTakeoff ? $.oMyTowplane.fWeightMaxTowed : $.oMyGlider.fWeightMaxTakeoff;
    if($.oMyGlider.fWeightTotal > fWeightMaxTakeoff) {  // over-weight
      iColorFieldBackground = Gfx.COLOR_RED;
      iColorFieldText = self.iColorText;
    }
    else if($.oMyGlider.fWeightTotal > fWeightMaxTakeoff * 0.95f) {  // within 5% of MTOW
      iColorFieldBackground = Gfx.COLOR_ORANGE;
      iColorFieldText = self.iColorText;
    }
    else {
      iColorFieldBackground = Gfx.COLOR_DK_GREEN;
      iColorFieldText = self.iColorText;
    }

    // Set values
    var fValue;
    var sValue;
    // ... empty weight
    fValue = $.oMyGlider.fWeightEmpty * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueTopLeft.setText(sValue);
    // ... payload weight
    fValue = $.oMyGlider.fWeightPayload * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueTopRight.setText(sValue);
    // ... total weight
    self.oRezDrawableGlobal.setColorAlertLeft(iColorFieldBackground);
    self.oRezLabelLeft.setColor(iColorFieldText);
    self.oRezUnitLeft.setColor(iColorFieldText);
    fValue = $.oMyGlider.fWeightTotal * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueLeft.setText(sValue);
    // ... callsign
    self.oRezDrawableGlobal.setColorAlertCenter(iColorFieldBackground);
    self.oRezLabelCenter.setColor(iColorFieldText);
    sValue = $.oMyGlider.sCallsign;
    self.oRezValueCenter.setText(sValue);
    // ... max. takeoff weight
    self.oRezDrawableGlobal.setColorAlertRight(iColorFieldBackground);
    self.oRezLabelRight.setColor(iColorFieldText);
    self.oRezUnitRight.setColor(iColorFieldText);
    fValue = fWeightMaxTakeoff * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueRight.setText(sValue);
    // ... ballast weight
    fValue = $.oMyGlider.fWeightBallast * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueBottomLeft.setText(sValue);
    // ... tow speed
    fValue = $.oMyGlider.fSpeedTowing * $.oMySettings.fUnitHorizontalSpeedCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueBottomRight.setText(sValue);
  }

}

class MyViewGliderDelegate extends MyViewGlobalDelegate {

  function initialize() {
    MyViewGlobalDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: MyViewGliderDelegate.onMenu()");
    Ui.pushView(new MyMenuGeneric(:menuGlider),
                new MyMenuGenericDelegate(:menuGlider),
                Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: MyViewGliderDelegate.onPreviousPage()");
    Ui.switchToView(new MyViewTowplane(),
                    new MyViewTowplaneDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: MyViewGliderDelegate.onNextPage()");
    Ui.switchToView(new MyViewLog(),
                    new MyViewLogDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
