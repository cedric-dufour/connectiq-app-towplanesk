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

using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class MyPickerGenericSettings extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize(_context, _item) {
    if(_context == :contextTimer) {
      if(_item == :itemThresholdGround) {

        var iTimerThresholdGround = App.Properties.getValue("userTimerThresholdGround");
        var oFactory = new PickerFactoryDictionary([5, 10, 15, 30, 45, 60, 90, 120, 180, 300],
                                                   ["5", "10", "15", "30", "45", "60", "90", "120", "180", "300"],
                                                   null);
        var iIndex = oFactory.indexOfKey(iTimerThresholdGround);
        if(iIndex < 0) {
          iIndex = 3;  // 30 seconds
        }
        Picker.initialize({
            :title => new Ui.Text({
                :text => Lang.format("$1$ [s]", [Ui.loadResource(Rez.Strings.titleTimerThresholdGround)]),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [iIndex]});

      }
      else if(_item == :itemThresholdAirborne) {

        var iTimerThresholdAirborne = App.Properties.getValue("userTimerThresholdAirborne");
        var oFactory = new PickerFactoryDictionary([5, 10, 15, 30, 45, 60, 90, 120, 180, 300],
                                                   ["5", "10", "15", "30", "45", "60", "90", "120", "180", "300"],
                                                   null);
        var iIndex = oFactory.indexOfKey(iTimerThresholdAirborne);
        if(iIndex < 0) {
          iIndex = 5;  // 60 seconds
        }
        Picker.initialize({
            :title => new Ui.Text({
                :text => Lang.format("$1$ [s]", [Ui.loadResource(Rez.Strings.titleTimerThresholdAirborne)]),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [iIndex]});

      }
    }
    else if(_context == :contextGeneral) {
      if(_item == :itemBackgroundColor) {

        var iColor = App.Properties.getValue("userGeneralBackgroundColor");
        var oFactory = new PickerFactoryDictionary([Gfx.COLOR_WHITE, Gfx.COLOR_BLACK],
                                                   [Ui.loadResource(Rez.Strings.valueColorWhite),
                                                    Ui.loadResource(Rez.Strings.valueColorBlack)],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleGeneralBackgroundColor),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iColor)]});

      }
    }
    else if(_context == :contextUnit) {
      if(_item == :itemDistance) {

        var iUnitDistance = App.Properties.getValue("userUnitDistance");
        var oFactory = new PickerFactoryDictionary([-1, 0, 1 ,2],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "km", "sm", "nm"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitDistance),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitDistance)]});

      }
      else if(_item == :itemElevation) {

        var iUnitElevation = App.Properties.getValue("userUnitElevation");
        var oFactory = new PickerFactoryDictionary([-1, 0, 1],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "m", "ft"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitElevation),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitElevation)]});

      }
      else if(_item == :itemWeight) {

        var iUnitWeight = App.Properties.getValue("userUnitWeight");
        var oFactory = new PickerFactoryDictionary([-1, 0, 1],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "kg", "lb"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitWeight),
                  :font => Gfx.FONT_TINY,
                  :locX => Ui.LAYOUT_HALIGN_CENTER,
                  :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                  :color => Gfx.COLOR_BLUE}),
              :pattern => [oFactory],
              :defaults => [oFactory.indexOfKey(iUnitWeight)]});

      }
      else if(_item == :itemFuel) {

        var iUnitFuel = App.Properties.getValue("userUnitFuel");
        var oFactory = new PickerFactoryDictionary([-1, 0, 1 ,2],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "l", "gal", "kWh"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitFuel),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitFuel)]});

      }
      else if(_item == :itemPressure) {

        var iUnitPressure = App.Properties.getValue("userUnitPressure");
        var oFactory = new PickerFactoryDictionary([-1, 0, 1],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "mb", "inHg"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitPressure),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitPressure)]});

      }
      else if(_item == :itemTemperature) {

        var iUnitTemperature = App.Properties.getValue("userUnitTemperature");
        var oFactory = new PickerFactoryDictionary([-1, 0, 1],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "°C", "°F"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitTemperature),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitTemperature)]});

      }
      else if(_item == :itemTimeUTC) {

        var bUnitTimeUTC = App.Properties.getValue("userUnitTimeUTC");
        var oFactory = new PickerFactoryDictionary([false, true],
                                                   [Ui.loadResource(Rez.Strings.valueUnitTimeLT),
                                                    Ui.loadResource(Rez.Strings.valueUnitTimeUTC)],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitTimeUTC),
                  :font => Gfx.FONT_TINY,
                  :locX => Ui.LAYOUT_HALIGN_CENTER,
                  :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                  :color => Gfx.COLOR_BLUE}),
              :pattern => [oFactory],
              :defaults => [oFactory.indexOfKey(bUnitTimeUTC)]});

      }
    }
  }

}

class MyPickerGenericSettingsDelegate extends Ui.PickerDelegate {

  //
  // VARIABLES
  //

  private var context;
  private var item;


  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize(_context, _item) {
    PickerDelegate.initialize();
    self.context = _context;
    self.item = _item;
  }

  function onAccept(_amValues) {
    if(self.context == :contextTimer) {
      if(self.item == :itemThresholdGround) {
        App.Properties.setValue("userTimerThresholdGround", _amValues[0]);
      }
      else if(self.item == :itemThresholdAirborne) {
        App.Properties.setValue("userTimerThresholdAirborne", _amValues[0]);
      }
    }
    else if(self.context == :contextGeneral) {
      if(self.item == :itemBackgroundColor) {
        App.Properties.setValue("userGeneralBackgroundColor", _amValues[0]);
      }
    }
    else if(self.context == :contextUnit) {
      if(self.item == :itemDistance) {
        App.Properties.setValue("userUnitDistance", _amValues[0]);
      }
      else if(self.item == :itemElevation) {
        App.Properties.setValue("userUnitElevation", _amValues[0]);
      }
      else if(self.item == :itemWeight) {
        App.Properties.setValue("userUnitWeight", _amValues[0]);
      }
      else if(self.item == :itemFuel) {
        App.Properties.setValue("userUnitFuel", _amValues[0]);
      }
      else if(self.item == :itemPressure) {
        App.Properties.setValue("userUnitPressure", _amValues[0]);
      }
      else if(self.item == :itemTemperature) {
        App.Properties.setValue("userUnitTemperature", _amValues[0]);
      }
      else if(self.item == :itemTimeUTC) {
        App.Properties.setValue("userUnitTimeUTC", _amValues[0]);
      }
      $.oMySettings.load();  // ... use proper units in settings
    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }

}
