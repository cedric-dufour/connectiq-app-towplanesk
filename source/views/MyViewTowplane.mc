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
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// CLASS
//

class MyViewTowplane extends MyView {

  //
  // FUNCTIONS: MyView (override/implement)
  //

  function initialize() {
    MyView.initialize();
  }

  function prepare() {
    //Sys.println("DEBUG: MyViewTowplane.prepare()");
    MyView.prepare();

    // Set labels, units and colors
    (self.oRezValueFooter as Ui.Text).setText(Ui.loadResource(Rez.Strings.titleAircraftTowplane) as String);
    (self.oRezValueFooter as Ui.Text).setColor(self.iColorText);
    // ... empty weight
    (View.findDrawableById("labelTopLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelWeightEmpty) as String);
    (View.findDrawableById("unitTopLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitWeight]));
    (self.oRezValueTopLeft as Ui.Text).setColor(self.iColorText);
    // ... payload weight
    (View.findDrawableById("labelTopRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelWeightPayload) as String);
    (View.findDrawableById("unitTopRight") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitWeight]));
    (self.oRezValueTopRight as Ui.Text).setColor(self.iColorText);
    // ... total weight
    (View.findDrawableById("labelLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelWeightTotal) as String);
    (View.findDrawableById("unitLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitWeight]));
    (self.oRezValueLeft as Ui.Text).setColor(self.iColorText);
    // ... callsign
    (View.findDrawableById("labelCenter") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelCallsign) as String);
    (self.oRezValueCenter as Ui.Text).setColor(self.iColorText);
    // ... max. takeoff weight
    (View.findDrawableById("labelRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelWeightMaxTakeoff) as String);
    (View.findDrawableById("unitRight") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitWeight]));
    (self.oRezValueRight as Ui.Text).setColor(self.iColorText);
    // ... fuel quantity
    (View.findDrawableById("labelBottomLeft") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelFuelQuantity) as String);
    (View.findDrawableById("unitBottomLeft") as Ui.Text).setText(format("[$1$]", [$.oMySettings.sUnitFuel]));
    (self.oRezValueBottomLeft as Ui.Text).setColor(self.iColorText);
    // ... fuel flow
    (View.findDrawableById("labelBottomRight") as Ui.Text).setText(Ui.loadResource(Rez.Strings.labelFuelFlow) as String);
    (View.findDrawableById("unitBottomRight") as Ui.Text).setText(format("[$1$/h]", [$.oMySettings.sUnitFuel]));
    (self.oRezValueBottomRight as Ui.Text).setColor(self.iColorText);
    // ... title
    self.bTitleShow = true;
    (self.oRezValueFooter as Ui.Text).setColor(Gfx.COLOR_DK_GRAY);
    (self.oRezValueFooter as Ui.Text).setText(Ui.loadResource(Rez.Strings.titleViewTowplane) as String);
  }

  function updateLayout(_b) {
    //Sys.println("DEBUG: MyViewTowplane.updateLayout()");
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
    var fWeightMaxTakeoff = $.oMyGlider != null ? $.oMyTowplane.fWeightMaxTowing : oMyTowplane.fWeightMaxTakeoff;
    if($.oMyTowplane.fWeightTotal > fWeightMaxTakeoff) {  // over-weight
      iColorFieldBackground = Gfx.COLOR_RED;
      iColorFieldText = self.iColorText;
    }
    else if($.oMyTowplane.fWeightTotal > fWeightMaxTakeoff * 0.95f) {  // within 5% of MTOW
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
    fValue = $.oMyTowplane.fWeightEmpty * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    (self.oRezValueTopLeft as Ui.Text).setText(sValue);
    // ... payload weight
    fValue = $.oMyTowplane.fWeightPayload * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    (self.oRezValueTopRight as Ui.Text).setText(sValue);
    // ... total weight
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertLeft(iColorFieldBackground);
    (self.oRezLabelLeft as Ui.Text).setColor(iColorFieldText);
    (self.oRezUnitLeft as Ui.Text).setColor(iColorFieldText);
    fValue = $.oMyTowplane.fWeightTotal * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    (self.oRezValueLeft as Ui.Text).setText(sValue);
    // ... callsign
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertCenter(iColorFieldBackground);
    (self.oRezLabelCenter as Ui.Text).setColor(iColorFieldText);
    sValue = $.oMyTowplane.sCallsign;
    (self.oRezValueCenter as Ui.Text).setText(sValue);
    // ... max. takeoff weight
    (self.oRezDrawableGlobal as MyDrawableGlobal).setColorAlertRight(iColorFieldBackground);
    (self.oRezLabelRight as Ui.Text).setColor(iColorFieldText);
    (self.oRezUnitRight as Ui.Text).setColor(iColorFieldText);
    fValue = fWeightMaxTakeoff * $.oMySettings.fUnitWeightCoefficient;
    sValue = fValue.format("%.0f");
    (self.oRezValueRight as Ui.Text).setText(sValue);
    // ... fuel quantity
    fValue = $.oMyTowplane.fFuelQuantity * $.oMySettings.fUnitFuelCoefficient;
    sValue = fValue.format("%.0f");
    (self.oRezValueBottomLeft as Ui.Text).setText(sValue);
    // ... fuel flow
    if(LangUtils.notNaN($.oMyProcessing.fFuelFlow)) {
      fValue = $.oMyProcessing.fFuelFlow * $.oMySettings.fUnitFuelCoefficient * -3600.0f;
      sValue = fValue.format("%+.1f");
    }
    else {
      sValue = $.MY_NOVALUE_LEN3;
    }
    (self.oRezValueBottomRight as Ui.Text).setText(sValue);
  }

}

class MyViewTowplaneDelegate extends MyViewDelegate {

  function initialize() {
    MyViewDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: MyViewTowplaneDelegate.onMenu()");
    Ui.pushView(new MyMenuGeneric(:menuTowplane),
                new MyMenuGenericDelegate(:menuTowplane),
                Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: MyViewTowplaneDelegate.onPreviousPage()");
    Ui.switchToView(new MyViewAltimeter(),
                    new MyViewAltimeterDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: MyViewTowplaneDelegate.onNextPage()");
    Ui.switchToView(new MyViewGlider(),
                    new MyViewGliderDelegate(),
                    Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
