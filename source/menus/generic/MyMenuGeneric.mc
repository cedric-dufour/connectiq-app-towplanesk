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
using Toybox.WatchUi as Ui;

class MyMenuGeneric extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize(_menu as Symbol) {
    Menu.initialize();

    if(_menu == :menuGlobal) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.AppName) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftGlider) as String, :menuGlider);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftTowplane) as String, :menuTowplane);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettings) as String, :menuSettings);
    }

    else if(_menu == :menuSettings) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettings) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsAltimeter) as String, :menuSettingsAltimeter);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsTemperature) as String, :menuSettingsTemperature);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsWind) as String, :menuSettingsWind);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsTimer) as String, :menuSettingsTimer);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsNotifications) as String, :menuSettingsNotifications);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsGeneral) as String, :menuSettingsGeneral);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsUnits) as String, :menuSettingsUnits);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorage) as String, :menuStorage);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAbout) as String, :menuAbout);
    }

    else if(_menu == :menuSettingsAltimeter) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsAltimeter) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibration) as String, :menuAltimeterCalibration);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterAlert) as String, :menuAltimeterAlert);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrection) as String, :menuAltimeterCorrection);
    }
    else if(_menu == :menuAltimeterCalibration) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAltimeterCalibration) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibrationQNH) as String, :menuAltimeterCalibrationQNH);
      if($.oMyAltimeter.fAltitudeActual != null) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibrationElevation) as String, :menuAltimeterCalibrationElevation);
      }
    }
    else if(_menu == :menuAltimeterCorrection) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAltimeterCorrection) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrectionAbsolute) as String, :menuAltimeterCorrectionAbsolute);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrectionRelative) as String, :menuAltimeterCorrectionRelative);
    }

    else if(_menu == :menuSettingsTemperature) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsTemperature) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTemperatureCalibration) as String, :menuTemperatureCalibration);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTemperatureAlert) as String, :menuTemperatureAlert);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTemperatureAuto) as String, :menuTemperatureAuto);
    }

    else if(_menu == :menuSettingsWind) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsWind) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleWindSpeed) as String, :menuWindSpeed);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleWindDirection) as String, :menuWindDirection);
    }

    else if(_menu == :menuSettingsTimer) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsTimer) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerAutoLog) as String, :menuTimerAutoLog);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerAutoActivity) as String, :menuTimerAutoActivity);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerThreshold) as String, :menuTimerThreshold);
    }
    else if(_menu == :menuTimerThreshold) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleTimerThreshold) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerThresholdGround) as String, :menuTimerThresholdGround);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerThresholdAirborne) as String, :menuTimerThresholdAirborne);
    }

    else if(_menu == :menuSettingsNotifications) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsNotifications) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleNotificationsAltimeter) as String, :menuNotificationsAltimeter);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleNotificationsTemperature) as String, :menuNotificationsTemperature);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleNotificationsFuel) as String, :menuNotificationsFuel);
    }

    else if(_menu == :menuSettingsGeneral) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsGeneral) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleGeneralBackgroundColor) as String, :menuGeneralBackgroundColor);
    }

    else if(_menu == :menuSettingsUnits) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsUnits) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitDistance) as String, :menuUnitDistance);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitElevation) as String, :menuUnitElevation);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitWeight) as String, :menuUnitWeight);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitFuel) as String, :menuUnitFuel);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitPressure) as String, :menuUnitPressure);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitTemperature) as String, :menuUnitTemperature);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitTimeUTC) as String, :menuUnitTimeUTC);
    }

    else if(_menu == :menuStorage) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleStorage) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageImportData) as String, :menuStorageImportData);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageClearTowplanes) as String, :menuStorageClearTowplanes);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageClearGliders) as String, :menuStorageClearGliders);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageClearLogs) as String, :menuStorageClearLogs);
    }

    else if(_menu == :menuTowplane) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftTowplane) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageLoad) as String, :menuTowplaneLoad);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageEdit) as String, :menuTowplaneEdit);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageSave) as String, :menuTowplaneSave);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageDelete) as String, :menuTowplaneDelete);
    }
    else if(_menu == :menuTowplaneEdit) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleStorageEdit) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuel) as String, :menuTowplaneFuel);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeight) as String, :menuTowplaneWeight);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeed) as String, :menuTowplaneSpeed);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftCallsign) as String, :menuTowplaneCallsign);
    }
    else if(_menu == :menuTowplaneFuel) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftFuel) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelQuantity) as String, :menuTowplaneFuelQuantity);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelAlert) as String, :menuTowplaneFuelAlert);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelFlow) as String, :menuTowplaneFuelFlow);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelDensity) as String, :menuTowplaneFuelDensity);
    }
    else if(_menu == :menuTowplaneFuelFlow) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftFuelFlow) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowGround) as String, :menuTowplaneFuelFlowGround);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowAirborne) as String, :menuTowplaneFuelFlowAirborne);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowTowing) as String, :menuTowplaneFuelFlowTowing);
    }
    else if(_menu == :menuTowplaneWeight) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftWeight) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightPayload) as String, :menuTowplaneWeightPayload);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightEmpty) as String, :menuTowplaneWeightEmpty);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTakeoff) as String, :menuTowplaneWeightMaxTakeoff);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTowing) as String, :menuTowplaneWeightMaxTowing);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTowed) as String, :menuTowplaneWeightMaxTowed);
    }
    else if(_menu == :menuTowplaneSpeed) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftSpeed) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedOffBlock) as String, :menuTowplaneSpeedOffBlock);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedTakeoff) as String, :menuTowplaneSpeedTakeoff);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedLanding) as String, :menuTowplaneSpeedLanding);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedMaxTowing) as String, :menuTowplaneSpeedMaxTowing);
    }

    else if(_menu == :menuGlider) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftGlider) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageLoad) as String, :menuGliderLoad);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageEdit) as String, :menuGliderEdit);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageSave) as String, :menuGliderSave);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageDelete) as String, :menuGliderDelete);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftClear) as String, :menuGliderClear);
    }
    else if(_menu == :menuGliderEdit) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleStorageEdit) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeight) as String, :menuGliderWeight);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeed) as String, :menuGliderSpeed);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftCallsign) as String, :menuGliderCallsign);
    }
    else if(_menu == :menuGliderWeight) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftWeight) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightPayload) as String, :menuGliderWeightPayload);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightBallast) as String, :menuGliderWeightBallast);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightEmpty) as String, :menuGliderWeightEmpty);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTakeoff) as String, :menuGliderWeightMaxTakeoff);
    }
    else if(_menu == :menuGliderSpeed) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftSpeed) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedTowing) as String, :menuGliderSpeedTowing);
    }

    else if(_menu == :menuAbout) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAbout) as String);
      Menu.addItem(format("$1$: $2$", [Ui.loadResource(Rez.Strings.titleVersion), Ui.loadResource(Rez.Strings.AppVersion)]), :aboutVersion);
      Menu.addItem(format("$1$: GPL 3.0", [Ui.loadResource(Rez.Strings.titleLicense)]), :aboutLicense);
      Menu.addItem(format("$1$: Cédric Dufour", [Ui.loadResource(Rez.Strings.titleAuthor)]), :aboutAuthor);
    }

    else if(_menu == :menuActivity) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleActivity) as String);
      if($.oMyActivity != null) {
        if(($.oMyActivity as MyActivity).isRecording()) {
          Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityPause) as String, :menuActivityPause);
        }
        else {
          Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityResume) as String, :menuActivityResume);
        }
        if($.oMyTimer.iState == MyTimer.STATE_STANDBY) {
          Menu.addItem(Ui.loadResource(Rez.Strings.titleActivitySave) as String, :menuActivitySave);
        }
        Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityDiscard) as String, :menuActivityDiscard);
      }
    }

    else if(_menu == :menuTimer) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleTimer) as String);
      if($.oMyTimer.iState <= MyTimer.STATE_OFFBLOCK or ($.oMyTimer.iState == MyTimer.STATE_ONBLOCK and $.oMyTimer.oTimeTakeoff == null)) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerReset) as String, :menuTimerReset);
      }
      else if($.oMyTimer.iState == MyTimer.STATE_ONBLOCK and $.oMyTimer.oTimeTakeoff != null) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerSave) as String, :menuTimerSave);
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerDiscard) as String, :menuTimerDiscard);
      }
      if($.oMyTimer.oTimeTakeoff != null) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerAddCycle) as String, :menuTimerAddCycle);
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerUndoCycle) as String, :menuTimerUndoCycle);
      }
      if($.oMyActivity == null) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleExit) as String, :menuExit);
      }
    }

  }

}

class MyMenuGenericDelegate extends Ui.MenuInputDelegate {

  //
  // VARIABLES
  //

  private var menu as Symbol = :menuNone;


  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize(_menu as Symbol) {
    MenuInputDelegate.initialize();
    self.menu = _menu;
  }

  function onMenuItem(_item) {
    if(self.menu == :menuGlobal) {
      if(_item == :menuSettings) {
        Ui.pushView(new MyMenuGeneric(:menuSettings),
                    new MyMenuGenericDelegate(:menuSettings),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplane) {
        Ui.pushView(new MyMenuGeneric(:menuTowplane),
                    new MyMenuGenericDelegate(:menuTowplane),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGlider) {
        Ui.pushView(new MyMenuGeneric(:menuGlider),
                    new MyMenuGenericDelegate(:menuGlider),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettings) {
      if(_item == :menuSettingsAltimeter) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsAltimeter),
                    new MyMenuGenericDelegate(:menuSettingsAltimeter),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsTemperature) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsTemperature),
                    new MyMenuGenericDelegate(:menuSettingsTemperature),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsWind) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsWind),
                    new MyMenuGenericDelegate(:menuSettingsWind),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsTimer) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsTimer),
                    new MyMenuGenericDelegate(:menuSettingsTimer),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsNotifications) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsNotifications),
                    new MyMenuGenericDelegate(:menuSettingsNotifications),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsGeneral) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsGeneral),
                    new MyMenuGenericDelegate(:menuSettingsGeneral),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsUnits) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsUnits),
                    new MyMenuGenericDelegate(:menuSettingsUnits),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuStorage) {
        Ui.pushView(new MyMenuGeneric(:menuStorage),
                    new MyMenuGenericDelegate(:menuStorage),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAbout) {
        Ui.pushView(new MyMenuGeneric(:menuAbout),
                    new MyMenuGenericDelegate(:menuAbout),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsAltimeter) {
      if(_item == :menuAltimeterCalibration) {
        Ui.pushView(new MyMenuGeneric(:menuAltimeterCalibration),
                    new MyMenuGenericDelegate(:menuAltimeterCalibration),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCorrection) {
        Ui.pushView(new MyMenuGeneric(:menuAltimeterCorrection),
                    new MyMenuGenericDelegate(:menuAltimeterCorrection),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterAlert) {
        Ui.pushView(new MyPickerGenericElevation(:contextSettings, :itemAltimeterAlert),
                    new MyPickerGenericElevationDelegate(:contextSettings, :itemAltimeterAlert),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuAltimeterCalibration) {
      if(_item == :menuAltimeterCalibrationQNH) {
        Ui.pushView(new MyPickerGenericPressure(:contextSettings, :itemAltimeterCalibration),
                    new MyPickerGenericPressureDelegate(:contextSettings, :itemAltimeterCalibration),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCalibrationElevation) {
        Ui.pushView(new MyPickerGenericElevation(:contextSettings, :itemAltimeterCalibration),
                    new MyPickerGenericElevationDelegate(:contextSettings, :itemAltimeterCalibration),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuAltimeterCorrection) {
      if(_item == :menuAltimeterCorrectionAbsolute) {
        Ui.pushView(new MyPickerGenericPressure(:contextSettings, :itemAltimeterCorrection),
                    new MyPickerGenericPressureDelegate(:contextSettings, :itemAltimeterCorrection),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCorrectionRelative) {
        Ui.pushView(new MyPickerAltimeterCorrectionRelative(),
                    new MyPickerAltimeterCorrectionRelativeDelegate(),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsTemperature) {
      if(_item == :menuTemperatureAuto) {
        Ui.pushView(new MyPickerTemperatureAuto(),
                    new MyPickerTemperatureAutoDelegate(),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTemperatureCalibration) {
        Ui.pushView(new MyPickerGenericTemperature(:contextSettings, :itemTemperatureCalibration),
                    new MyPickerGenericTemperatureDelegate(:contextSettings, :itemTemperatureCalibration),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTemperatureAlert) {
        Ui.pushView(new MyPickerGenericTemperature(:contextSettings, :itemTemperatureAlert),
                    new MyPickerGenericTemperatureDelegate(:contextSettings, :itemTemperatureAlert),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsWind) {
      if(_item == :menuWindSpeed) {
        Ui.pushView(new MyPickerGenericSpeed(:contextSettings, :itemWindSpeed),
                    new MyPickerGenericSpeedDelegate(:contextSettings, :itemWindSpeed),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuWindDirection) {
        Ui.pushView(new MyPickerGenericHeading(:contextSettings, :itemWindDirection),
                    new MyPickerGenericHeadingDelegate(:contextSettings, :itemWindDirection),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsTimer) {
      if(_item == :menuTimerAutoLog) {
        Ui.pushView(new MyPickerGenericOnOff(:contextSettings, :itemTimerAutoLog),
                    new MyPickerGenericOnOffDelegate(:contextSettings, :itemTimerAutoLog),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerAutoActivity) {
        Ui.pushView(new MyPickerGenericOnOff(:contextSettings, :itemTimerAutoActivity),
                    new MyPickerGenericOnOffDelegate(:contextSettings, :itemTimerAutoActivity),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerThreshold) {
        Ui.pushView(new MyMenuGeneric(:menuTimerThreshold),
                    new MyMenuGenericDelegate(:menuTimerThreshold),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTimerThreshold) {
      if(_item == :menuTimerThresholdGround) {
        Ui.pushView(new MyPickerGenericSettings(:contextTimer, :itemThresholdGround),
                    new MyPickerGenericSettingsDelegate(:contextTimer, :itemThresholdGround),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerThresholdAirborne) {
        Ui.pushView(new MyPickerGenericSettings(:contextTimer, :itemThresholdAirborne),
                    new MyPickerGenericSettingsDelegate(:contextTimer, :itemThresholdAirborne),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsNotifications) {
      if(_item == :menuNotificationsAltimeter) {
        Ui.pushView(new MyPickerGenericOnOff(:contextSettings, :itemNotificationsAltimeter),
                    new MyPickerGenericOnOffDelegate(:contextSettings, :itemNotificationsAltimeter),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuNotificationsTemperature) {
        Ui.pushView(new MyPickerGenericOnOff(:contextSettings, :itemNotificationsTemperature),
                    new MyPickerGenericOnOffDelegate(:contextSettings, :itemNotificationsTemperature),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuNotificationsFuel) {
        Ui.pushView(new MyPickerGenericOnOff(:contextSettings, :itemNotificationsFuel),
                    new MyPickerGenericOnOffDelegate(:contextSettings, :itemNotificationsFuel),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsGeneral) {
      if(_item == :menuGeneralBackgroundColor) {
        Ui.pushView(new MyPickerGenericSettings(:contextGeneral, :itemBackgroundColor),
                    new MyPickerGenericSettingsDelegate(:contextGeneral, :itemBackgroundColor),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsUnits) {
      if(_item == :menuUnitDistance) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemDistance),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemDistance),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitElevation) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemElevation),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemElevation),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitWeight) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemWeight),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemWeight),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitFuel) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemFuel),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemFuel),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitPressure) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemPressure),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemPressure),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitTemperature) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemTemperature),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemTemperature),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitTimeUTC) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemTimeUTC),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemTimeUTC),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuStorage) {
      if(_item == :menuStorageImportData) {
        Ui.pushView(new MyPickerGenericText(:contextStorage, :itemImportData),
                    new MyPickerGenericTextDelegate(:contextStorage, :itemImportData),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuStorageClearTowplanes) {
        Ui.pushView(new MyMenuGenericConfirm(:contextStorage, :actionClearTowplanes),
                    new MyMenuGenericConfirmDelegate(:contextStorage, :actionClearTowplanes, false),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuStorageClearGliders) {
        Ui.pushView(new MyMenuGenericConfirm(:contextStorage, :actionClearGliders),
                    new MyMenuGenericConfirmDelegate(:contextStorage, :actionClearGliders, false),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuStorageClearLogs) {
        Ui.pushView(new MyMenuGenericConfirm(:contextStorage, :actionClearLogs),
                    new MyMenuGenericConfirmDelegate(:contextStorage, :actionClearLogs, false),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuTowplane) {
      if(_item == :menuTowplaneLoad) {
        Ui.pushView(new MyPickerGenericStorage(:storageTowplane, :actionLoad),
                    new MyPickerGenericStorageDelegate(:storageTowplane, :actionLoad),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneEdit) {
        Ui.pushView(new MyMenuGeneric(:menuTowplaneEdit),
                    new MyMenuGenericDelegate(:menuTowplaneEdit),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSave) {
        Ui.pushView(new MyPickerGenericStorage(:storageTowplane, :actionSave),
                    new MyPickerGenericStorageDelegate(:storageTowplane, :actionSave),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneDelete) {
        Ui.pushView(new MyPickerGenericStorage(:storageTowplane, :actionDelete),
                    new MyPickerGenericStorageDelegate(:storageTowplane, :actionDelete),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneEdit) {
      if(_item == :menuTowplaneFuel) {
        Ui.pushView(new MyMenuGeneric(:menuTowplaneFuel),
                    new MyMenuGenericDelegate(:menuTowplaneFuel),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeight) {
        Ui.pushView(new MyMenuGeneric(:menuTowplaneWeight),
                    new MyMenuGenericDelegate(:menuTowplaneWeight),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSpeed) {
        Ui.pushView(new MyMenuGeneric(:menuTowplaneSpeed),
                    new MyMenuGenericDelegate(:menuTowplaneSpeed),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneCallsign) {
        Ui.pushView(new MyPickerGenericText(:contextTowplane, :itemCallsign),
                    new MyPickerGenericTextDelegate(:contextTowplane, :itemCallsign),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneWeight) {
      if(_item == :menuTowplaneWeightEmpty) {
        Ui.pushView(new MyPickerGenericWeight(:contextTowplane, :itemWeightEmpty),
                    new MyPickerGenericWeightDelegate(:contextTowplane, :itemWeightEmpty),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeightPayload) {
        Ui.pushView(new MyPickerGenericWeight(:contextTowplane, :itemWeightPayload),
                    new MyPickerGenericWeightDelegate(:contextTowplane, :itemWeightPayload),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeightMaxTakeoff) {
        Ui.pushView(new MyPickerGenericWeight(:contextTowplane, :itemWeightMaxTakeoff),
                    new MyPickerGenericWeightDelegate(:contextTowplane, :itemWeightMaxTakeoff),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeightMaxTowing) {
        Ui.pushView(new MyPickerGenericWeight(:contextTowplane, :itemWeightMaxTowing),
                    new MyPickerGenericWeightDelegate(:contextTowplane, :itemWeightMaxTowing),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeightMaxTowed) {
        Ui.pushView(new MyPickerGenericWeight(:contextTowplane, :itemWeightMaxTowed),
                    new MyPickerGenericWeightDelegate(:contextTowplane, :itemWeightMaxTowed),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneFuel) {
      if(_item == :menuTowplaneFuelQuantity) {
        Ui.pushView(new MyPickerGenericFuel(:contextTowplane, :itemFuelQuantity),
                    new MyPickerGenericFuelDelegate(:contextTowplane, :itemFuelQuantity),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelDensity) {
        Ui.pushView(new MyPickerGenericFuelDensity(:contextTowplane, :itemFuelDensity),
                    new MyPickerGenericFuelDensityDelegate(:contextTowplane, :itemFuelDensity),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelFlow) {
        Ui.pushView(new MyMenuGeneric(:menuTowplaneFuelFlow),
                    new MyMenuGenericDelegate(:menuTowplaneFuelFlow),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelAlert) {
        Ui.pushView(new MyPickerGenericFuel(:contextTowplane, :itemFuelAlert),
                    new MyPickerGenericFuelDelegate(:contextTowplane, :itemFuelAlert),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneFuelFlow) {
      if(_item == :menuTowplaneFuelFlowGround) {
        Ui.pushView(new MyPickerGenericFuelFlow(:contextTowplane, :itemFuelFlowGround),
                    new MyPickerGenericFuelFlowDelegate(:contextTowplane, :itemFuelFlowGround),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelFlowAirborne) {
        Ui.pushView(new MyPickerGenericFuelFlow(:contextTowplane, :itemFuelFlowAirborne),
                    new MyPickerGenericFuelFlowDelegate(:contextTowplane, :itemFuelFlowAirborne),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelFlowTowing) {
        Ui.pushView(new MyPickerGenericFuelFlow(:contextTowplane, :itemFuelFlowTowing),
                    new MyPickerGenericFuelFlowDelegate(:contextTowplane, :itemFuelFlowTowing),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneSpeed) {
      if(_item == :menuTowplaneSpeedOffBlock) {
        Ui.pushView(new MyPickerGenericSpeed(:contextTowplane, :itemSpeedOffBlock),
                    new MyPickerGenericSpeedDelegate(:contextTowplane, :itemSpeedOffBlock),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSpeedTakeoff) {
        Ui.pushView(new MyPickerGenericSpeed(:contextTowplane, :itemSpeedTakeoff),
                    new MyPickerGenericSpeedDelegate(:contextTowplane, :itemSpeedTakeoff),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSpeedLanding) {
        Ui.pushView(new MyPickerGenericSpeed(:contextTowplane, :itemSpeedLanding),
                    new MyPickerGenericSpeedDelegate(:contextTowplane, :itemSpeedLanding),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSpeedMaxTowing) {
        Ui.pushView(new MyPickerGenericSpeed(:contextTowplane, :itemSpeedMaxTowing),
                    new MyPickerGenericSpeedDelegate(:contextTowplane, :itemSpeedMaxTowing),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuGlider) {
      if(_item == :menuGliderLoad) {
        Ui.pushView(new MyPickerGenericStorage(:storageGlider, :actionLoad),
                    new MyPickerGenericStorageDelegate(:storageGlider, :actionLoad),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderEdit) {
        Ui.pushView(new MyMenuGeneric(:menuGliderEdit),
                    new MyMenuGenericDelegate(:menuGliderEdit),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderSave) {
        Ui.pushView(new MyPickerGenericStorage(:storageGlider, :actionSave),
                    new MyPickerGenericStorageDelegate(:storageGlider, :actionSave),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderDelete) {
        Ui.pushView(new MyPickerGenericStorage(:storageGlider, :actionDelete),
                    new MyPickerGenericStorageDelegate(:storageGlider, :actionDelete),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderClear) {
        Ui.pushView(new MyMenuGenericConfirm(:contextGlider, :actionClear),
                    new MyMenuGenericConfirmDelegate(:contextGlider, :actionClear, true),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuGliderEdit) {
      if(_item == :menuGliderWeight) {
        Ui.pushView(new MyMenuGeneric(:menuGliderWeight),
                    new MyMenuGenericDelegate(:menuGliderWeight),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderSpeed) {
        Ui.pushView(new MyMenuGeneric(:menuGliderSpeed),
                    new MyMenuGenericDelegate(:menuGliderSpeed),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderCallsign) {
        Ui.pushView(new MyPickerGenericText(:contextGlider, :itemCallsign),
                    new MyPickerGenericTextDelegate(:contextGlider, :itemCallsign),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuGliderWeight) {
      if(_item == :menuGliderWeightEmpty) {
        Ui.pushView(new MyPickerGenericWeight(:contextGlider, :itemWeightEmpty),
                    new MyPickerGenericWeightDelegate(:contextGlider, :itemWeightEmpty),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderWeightPayload) {
        Ui.pushView(new MyPickerGenericWeight(:contextGlider, :itemWeightPayload),
                    new MyPickerGenericWeightDelegate(:contextGlider, :itemWeightPayload),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderWeightBallast) {
        Ui.pushView(new MyPickerGenericWeight(:contextGlider, :itemWeightBallast),
                    new MyPickerGenericWeightDelegate(:contextGlider, :itemWeightBallast),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderWeightMaxTakeoff) {
        Ui.pushView(new MyPickerGenericWeight(:contextGlider, :itemWeightMaxTakeoff),
                    new MyPickerGenericWeightDelegate(:contextGlider, :itemWeightMaxTakeoff),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuGliderSpeed) {
      if(_item == :menuGliderSpeedTowing) {
        Ui.pushView(new MyPickerGenericSpeed(:contextGlider, :itemSpeedTowing),
                    new MyPickerGenericSpeedDelegate(:contextGlider, :itemSpeedTowing),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    //else if(self.menu == :menuAbout) {
    //  // Nothing to do here
    //}

    else if(self.menu == :menuActivity) {
      if(_item == :menuActivityResume) {
        if($.oMyActivity != null) {
          ($.oMyActivity as MyActivity).resume();
        }
      }
      else if(_item == :menuActivityPause) {
        if($.oMyActivity != null) {
          ($.oMyActivity as MyActivity).pause();
        }
      }
      else if(_item == :menuActivitySave) {
        Ui.pushView(new MyMenuGenericConfirm(:contextActivity, :actionSave),
                    new MyMenuGenericConfirmDelegate(:contextActivity, :actionSave, true),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuActivityDiscard) {
        Ui.pushView(new MyMenuGenericConfirm(:contextActivity, :actionDiscard),
                    new MyMenuGenericConfirmDelegate(:contextActivity, :actionDiscard, true),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuTimer) {
      if(_item == :menuTimerReset) {
        Ui.pushView(new MyMenuGenericConfirm(:contextTimer, :actionReset),
                    new MyMenuGenericConfirmDelegate(:contextTimer, :actionReset, true),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerAddCycle) {
        Ui.pushView(new MyMenuGenericConfirm(:contextTimer, :actionAddCycle),
                    new MyMenuGenericConfirmDelegate(:contextTimer, :actionAddCycle, true),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerUndoCycle) {
        Ui.pushView(new MyMenuGenericConfirm(:contextTimer, :actionUndoCycle),
                    new MyMenuGenericConfirmDelegate(:contextTimer, :actionUndoCycle, true),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerSave) {
        Ui.pushView(new MyMenuGenericConfirm(:contextTimer, :actionSave),
                    new MyMenuGenericConfirmDelegate(:contextTimer, :actionSave, true),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerDiscard) {
        Ui.pushView(new MyMenuGenericConfirm(:contextTimer, :actionDiscard),
                    new MyMenuGenericConfirmDelegate(:contextTimer, :actionDiscard, true),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuExit) {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
      }
    }

  }

}
