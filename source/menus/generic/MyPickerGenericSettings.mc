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

import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class MyPickerGenericSettings extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize(_context as Symbol, _item as Symbol) {
    if(_context == :contextTimer) {
      if(_item == :itemThresholdGround) {

        var iTimerThresholdGround = $.oMySettings.loadTimerThresholdGround();
        var oFactory = new PickerFactoryDictionary([5, 10, 15, 30, 45, 60, 90, 120, 180, 300],
                                                   ["5", "10", "15", "30", "45", "60", "90", "120", "180", "300"],
                                                   null);
        var iIndex = oFactory.indexOfKey(iTimerThresholdGround);
        if(iIndex < 0) {
          iIndex = 3;  // 30 seconds
        }
        Picker.initialize({
            :title => new Ui.Text({
                :text => format("$1$ [s]", [Ui.loadResource(Rez.Strings.titleTimerThresholdGround)]),
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [iIndex]});

      }
      else if(_item == :itemThresholdAirborne) {

        var iTimerThresholdAirborne = $.oMySettings.loadTimerThresholdAirborne();
        var oFactory = new PickerFactoryDictionary([5, 10, 15, 30, 45, 60, 90, 120, 180, 300],
                                                   ["5", "10", "15", "30", "45", "60", "90", "120", "180", "300"],
                                                   null);
        var iIndex = oFactory.indexOfKey(iTimerThresholdAirborne);
        if(iIndex < 0) {
          iIndex = 5;  // 60 seconds
        }
        Picker.initialize({
            :title => new Ui.Text({
                :text => format("$1$ [s]", [Ui.loadResource(Rez.Strings.titleTimerThresholdAirborne)]),
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

        var iColor = $.oMySettings.loadGeneralBackgroundColor();
        var oFactory = new PickerFactoryDictionary([Gfx.COLOR_WHITE, Gfx.COLOR_BLACK],
                                                   [Ui.loadResource(Rez.Strings.valueColorWhite),
                                                    Ui.loadResource(Rez.Strings.valueColorBlack)],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleGeneralBackgroundColor) as String,
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

        var iUnitDistance = $.oMySettings.loadUnitDistance();
        var oFactory = new PickerFactoryDictionary([-1, 0, 1 ,2],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "km", "sm", "nm"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitDistance) as String,
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitDistance)]});

      }
      else if(_item == :itemElevation) {

        var iUnitElevation = $.oMySettings.loadUnitElevation();
        var oFactory = new PickerFactoryDictionary([-1, 0, 1],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "m", "ft"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitElevation) as String,
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitElevation)]});

      }
      else if(_item == :itemWeight) {

        var iUnitWeight = $.oMySettings.loadUnitWeight();
        var oFactory = new PickerFactoryDictionary([-1, 0, 1],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "kg", "lb"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitWeight) as String,
                  :font => Gfx.FONT_TINY,
                  :locX => Ui.LAYOUT_HALIGN_CENTER,
                  :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                  :color => Gfx.COLOR_BLUE}),
              :pattern => [oFactory],
              :defaults => [oFactory.indexOfKey(iUnitWeight)]});

      }
      else if(_item == :itemFuel) {

        var iUnitFuel = $.oMySettings.loadUnitFuel();
        var oFactory = new PickerFactoryDictionary([-1, 0, 1 ,2],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "l", "gal", "kWh"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitFuel) as String,
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitFuel)]});

      }
      else if(_item == :itemPressure) {

        var iUnitPressure = $.oMySettings.loadUnitPressure();
        var oFactory = new PickerFactoryDictionary([-1, 0, 1],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "mb", "inHg"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitPressure) as String,
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitPressure)]});

      }
      else if(_item == :itemTemperature) {

        var iUnitTemperature = $.oMySettings.loadUnitTemperature();
        var oFactory = new PickerFactoryDictionary([-1, 0, 1],
                                                   [Ui.loadResource(Rez.Strings.valueAuto), "°C", "°F"],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitTemperature) as String,
                :font => Gfx.FONT_TINY,
                :locX => Ui.LAYOUT_HALIGN_CENTER,
                :locY => Ui.LAYOUT_VALIGN_BOTTOM,
                :color => Gfx.COLOR_BLUE}),
            :pattern => [oFactory],
            :defaults => [oFactory.indexOfKey(iUnitTemperature)]});

      }
      else if(_item == :itemTimeUTC) {

        var bUnitTimeUTC = $.oMySettings.loadUnitTimeUTC();
        var oFactory = new PickerFactoryDictionary([false, true],
                                                   [Ui.loadResource(Rez.Strings.valueUnitTimeLT),
                                                    Ui.loadResource(Rez.Strings.valueUnitTimeUTC)],
                                                   null);
        Picker.initialize({
            :title => new Ui.Text({
                :text => Ui.loadResource(Rez.Strings.titleUnitTimeUTC) as String,
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

  private var context as Symbol = :contextNone;
  private var item as Symbol = :itemNone;


  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize(_context as Symbol, _item as Symbol) {
    PickerDelegate.initialize();
    self.context = _context;
    self.item = _item;
  }

  function onAccept(_amValues) {
    if(self.context == :contextTimer) {

      if(self.item == :itemThresholdGround) {
        $.oMySettings.saveTimerThresholdGround(_amValues[0] as Number);
      }
      else if(self.item == :itemThresholdAirborne) {
        $.oMySettings.saveTimerThresholdAirborne(_amValues[0] as Number);
      }

    }
    else if(self.context == :contextGeneral) {

      if(self.item == :itemBackgroundColor) {
        $.oMySettings.saveGeneralBackgroundColor(_amValues[0] as Number);
      }

    }
    else if(self.context == :contextUnit) {

      if(self.item == :itemDistance) {
        $.oMySettings.saveUnitDistance(_amValues[0] as Number);
      }
      else if(self.item == :itemElevation) {
        $.oMySettings.saveUnitElevation(_amValues[0] as Number);
      }
      else if(self.item == :itemWeight) {
        $.oMySettings.saveUnitWeight(_amValues[0] as Number);
      }
      else if(self.item == :itemFuel) {
        $.oMySettings.saveUnitFuel(_amValues[0] as Number);
      }
      else if(self.item == :itemPressure) {
        $.oMySettings.saveUnitPressure(_amValues[0] as Number);
      }
      else if(self.item == :itemTemperature) {
        $.oMySettings.saveUnitTemperature(_amValues[0] as Number);
      }
      else if(self.item == :itemTimeUTC) {
        $.oMySettings.saveUnitTimeUTC(_amValues[0] as Boolean);
      }
      $.oMySettings.load();  // ... use proper units in settings

    }
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
