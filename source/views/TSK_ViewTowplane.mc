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
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// CLASS
//

class TSK_ViewTowplane extends TSK_ViewGlobal {

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
    //Sys.println("DEBUG: TSK_ViewTowplane.prepare()");
    TSK_ViewGlobal.prepare();

    // Set labels, units and colors
    View.findDrawableById("valueFooter").setText(Ui.loadResource(Rez.Strings.titleAircraftTowplane));
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
    // ... fuel quantity
    View.findDrawableById("labelBottomLeft").setText(Ui.loadResource(Rez.Strings.labelFuelQuantity));
    View.findDrawableById("unitBottomLeft").setText(Lang.format("[$1$]", [$.TSK_oSettings.sUnitFuel]));
    self.oRezValueBottomLeft.setColor(self.iColorText);
    // ... fuel flow
    View.findDrawableById("labelBottomRight").setText(Ui.loadResource(Rez.Strings.labelFuelFlow));
    View.findDrawableById("unitBottomRight").setText(Lang.format("[$1$/h]", [$.TSK_oSettings.sUnitFuel]));
    self.oRezValueBottomRight.setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    self.oRezValueFooter.setColor(Gfx.COLOR_DK_GRAY);
    self.oRezValueFooter.setText(Ui.loadResource(Rez.Strings.titleViewTowplane));

    // Done
    return true;
  }

  function updateLayout() {
    //Sys.println("DEBUG: TSK_ViewTowplane.updateLayout()");
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
    var fWeightMaxTakeoff = $.TSK_oGlider != null ? $.TSK_oTowplane.fWeightMaxTowing : TSK_oTowplane.fWeightMaxTakeoff;
    if($.TSK_oTowplane.fWeightTotal > fWeightMaxTakeoff) {  // over-weight
      iColorFieldBackground = Gfx.COLOR_RED;
      iColorFieldText = self.iColorText;
    }
    else if($.TSK_oTowplane.fWeightTotal > fWeightMaxTakeoff * 0.95f) {  // within 5% of MTOW
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
    fValue = $.TSK_oTowplane.fWeightEmpty * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueTopLeft.setText(sValue);
    // ... payload weight
    fValue = $.TSK_oTowplane.fWeightPayload * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueTopRight.setText(sValue);
    // ... total weight
    self.oRezDrawableGlobal.setColorAlertLeft(iColorFieldBackground);
    self.oRezLabelLeft.setColor(iColorFieldText);
    self.oRezUnitLeft.setColor(iColorFieldText);
    fValue = $.TSK_oTowplane.fWeightTotal * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueLeft.setText(sValue);
    // ... callsign
    self.oRezDrawableGlobal.setColorAlertCenter(iColorFieldBackground);
    self.oRezLabelCenter.setColor(iColorFieldText);
    sValue = $.TSK_oTowplane.sCallsign;
    self.oRezValueCenter.setText(sValue);
    // ... max. takeoff weight
    self.oRezDrawableGlobal.setColorAlertRight(iColorFieldBackground);
    self.oRezLabelRight.setColor(iColorFieldText);
    self.oRezUnitRight.setColor(iColorFieldText);
    fValue = fWeightMaxTakeoff * $.TSK_oSettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueRight.setText(sValue);
    // ... fuel quantity
    fValue = $.TSK_oTowplane.fFuelQuantity * $.TSK_oSettings.fUnitFuelCoefficient;
    sValue = fValue.format("%.0f");
    self.oRezValueBottomLeft.setText(sValue);
    // ... fuel flow
    if($.TSK_oProcessing.fFuelFlow != null) {
      fValue = $.TSK_oProcessing.fFuelFlow * $.TSK_oSettings.fUnitFuelCoefficient * -3600.0f;
      sValue = fValue.format("%+.1f");
    }
    else {
      sValue = $.TSK_NOVALUE_LEN3;
    }
    self.oRezValueBottomRight.setText(sValue);
  }

}

class TSK_ViewTowplaneDelegate extends TSK_ViewGlobalDelegate {

  function initialize() {
    TSK_ViewGlobalDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: TSK_ViewTowplaneDelegate.onMenu()");
    Ui.pushView(new TSK_MenuGeneric(:menuTowplane), new TSK_MenuGenericDelegate(:menuTowplane), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: TSK_ViewTowplaneDelegate.onPreviousPage()");
    Ui.switchToView(new TSK_ViewAltimeter(), new TSK_ViewAltimeterDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: TSK_ViewTowplaneDelegate.onNextPage()");
    Ui.switchToView(new TSK_ViewGlider(), new TSK_ViewGliderDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
