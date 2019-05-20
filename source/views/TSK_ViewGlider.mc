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

class TSK_ViewGlider extends TSK_ViewGlobal {

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
    //Sys.println("DEBUG: TSK_ViewGlider.prepare()");
    TSK_ViewGlobal.prepare();

    // Set labels, units and colors
    View.findDrawableById("valueFooter").setText(Ui.loadResource(Rez.Strings.titleAircraftGlider));
    self.oRezValueFooter.setColor(self.iColorText);
    // ... empty weight
    View.findDrawableById("labelTopLeft").setText(Ui.loadResource(Rez.Strings.labelWeightEmpty));
    View.findDrawableById("unitTopLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitWeight]));
    self.oRezValueTopLeft.setColor(self.iColorText);
    // ... payload weight
    View.findDrawableById("labelTopRight").setText(Ui.loadResource(Rez.Strings.labelWeightPayload));
    View.findDrawableById("unitTopRight").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitWeight]));
    self.oRezValueTopRight.setColor(self.iColorText);
    // ... total weight
    View.findDrawableById("labelLeft").setText(Ui.loadResource(Rez.Strings.labelWeightTotal));
    View.findDrawableById("unitLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitWeight]));
    self.oRezValueLeft.setColor(self.iColorText);
    // ... callsign
    View.findDrawableById("labelCenter").setText(Ui.loadResource(Rez.Strings.labelCallsign));
    self.oRezValueCenter.setColor(self.iColorText);
    // ... max. takeoff weight
    View.findDrawableById("labelRight").setText(Ui.loadResource(Rez.Strings.labelWeightMaxTakeoff));
    View.findDrawableById("unitRight").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitWeight]));
    self.oRezValueRight.setColor(self.iColorText);
    // ... ballast weight
    View.findDrawableById("labelBottomLeft").setText(Ui.loadResource(Rez.Strings.labelWeightBallast));
    View.findDrawableById("unitBottomLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitWeight]));
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... tow speed
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelTowSpeed));
    View.findDrawableById("unitBottomRight").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitHorizontalSpeed]));
    self.oRezValueBottomRight.setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewGlider));

    // Done
    return true;
  }

  function updateLayout() {
    //Sys.println("DEBUG: TSK_ViewGlider.updateLayout()");
    TSK_ViewGlobal.updateLayout(!self.bTitleShow);

    // Fields
    var iEpochNow = Time.now().value();
    if(iEpochNow - self.iFieldEpoch >= 2) {
      self.bTitleShow = false;
      self.iFieldEpoch = iEpochNow;
    }

    // No glider ?
    if($.TSK_oGlider == null) {
      self.oRezValueTopLeft.setText($.TSK_NOVALUE_LEN3);
      self.oRezValueTopRight.setText($.TSK_NOVALUE_LEN3);
      self.oRezDrawableGlobal.setColorAlertLeft(Gfx.COLOR_TRANSPARENT);
      self.oRezLabelLeft.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezUnitLeft.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezValueLeft.setText($.TSK_NOVALUE_LEN3);
      self.oRezDrawableGlobal.setColorAlertCenter(Gfx.COLOR_TRANSPARENT);
      self.oRezLabelCenter.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezValueCenter.setText($.TSK_NOVALUE_LEN2);
      self.oRezDrawableGlobal.setColorAlertRight(Gfx.COLOR_TRANSPARENT);
      self.oRezLabelRight.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezUnitRight.setColor(Gfx.COLOR_DK_GRAY);
      self.oRezValueRight.setText($.TSK_NOVALUE_LEN3);
      self.oRezValueBottomLeft.setText($.TSK_NOVALUE_LEN3);
      self.oRezValueBottomRight.setText($.TSK_NOVALUE_LEN3);
      return;
    }

    // Colors
    // ... alert fields
    var iColorFieldBackground = Gfx.COLOR_TRANSPARENT;
    var iColorFieldText = Gfx.COLOR_DK_GRAY;
    var fWeightMaxTakeoff = $.TSK_oTowplane.fWeightMaxTowed < $.TSK_oGlider.fWeightMaxTakeoff ? $.TSK_oTowplane.fWeightMaxTowed : $.TSK_oGlider.fWeightMaxTakeoff;
    if($.TSK_oGlider.fWeightTotal > fWeightMaxTakeoff) {  // over-weight
      iColorFieldBackground = Gfx.COLOR_RED;
      iColorFieldText = self.iColorText;
    }
    else if($.TSK_oGlider.fWeightTotal > fWeightMaxTakeoff * 0.95f) {  // within 5% of MTOW
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
    fValue = $.TSK_oGlider.fWeightEmpty * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueTopLeft.setText(sValue);
    // ... payload weight
    fValue = $.TSK_oGlider.fWeightPayload * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueTopRight.setText(sValue);
    // ... total weight
    self.oRezDrawableGlobal.setColorAlertLeft(iColorFieldBackground);
    self.oRezLabelLeft.setColor(iColorFieldText);
    self.oRezUnitLeft.setColor(iColorFieldText);
    fValue = $.TSK_oGlider.fWeightTotal * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueLeft.setText(sValue);
    // ... callsign
    self.oRezDrawableGlobal.setColorAlertCenter(iColorFieldBackground);
    self.oRezLabelCenter.setColor(iColorFieldText);
    sValue = $.TSK_oGlider.sCallsign;
    self.oRezValueCenter.setText(sValue);
    // ... max. takeoff weight
    self.oRezDrawableGlobal.setColorAlertRight(iColorFieldBackground);
    self.oRezLabelRight.setColor(iColorFieldText);
    self.oRezUnitRight.setColor(iColorFieldText);
    fValue = fWeightMaxTakeoff * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueRight.setText(sValue);
    // ... ballast weight
    fValue = $.TSK_oGlider.fWeightBallast * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueBottomLeft.setText(sValue);
    // ... tow speed
    fValue = $.TSK_oGlider.fSpeedTowing * $.TSK_oSettings.fUnitHorizontalSpeedCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueBottomRight.setText(sValue);
  }

}

class TSK_ViewGliderDelegate extends TSK_ViewGlobalDelegate {

  function initialize() {
    TSK_ViewGlobalDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: TSK_ViewGliderDelegate.onMenu()");
    Ui.pushView(new TSK_MenuGeneric(:menuGlider), new TSK_MenuGenericDelegate(:menuGlider), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: TSK_ViewGliderDelegate.onPreviousPage()");
    Ui.switchToView(new TSK_ViewTowplane(), new TSK_ViewTowplaneDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: TSK_ViewGliderDelegate.onNextPage()");
    Ui.switchToView(new TSK_ViewLog(), new TSK_ViewLogDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
