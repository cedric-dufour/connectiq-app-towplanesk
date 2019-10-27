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

using Toybox.WatchUi as Ui;

class TSK_MenuGeneric extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize(_menu) {
    Menu.initialize();

    if(_menu == :menuGlobal) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.AppName));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettings), :menuSettings);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftTowplane), :menuTowplane);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftGlider), :menuGlider);
    }

    else if(_menu == :menuSettings) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettings));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsAltimeter), :menuSettingsAltimeter);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsTemperature), :menuSettingsTemperature);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsWind), :menuSettingsWind);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsTimer), :menuSettingsTimer);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsNotifications), :menuSettingsNotifications);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsGeneral), :menuSettingsGeneral);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsUnits), :menuSettingsUnits);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorage), :menuStorage);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAbout), :menuAbout);
    }

    else if(_menu == :menuSettingsAltimeter) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsAltimeter));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibration), :menuAltimeterCalibration);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterAlert), :menuAltimeterAlert);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrection), :menuAltimeterCorrection);
    }
    else if(_menu == :menuAltimeterCalibration) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAltimeterCalibration));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibrationQNH), :menuAltimeterCalibrationQNH);
      if($.TSK_oAltimeter.fAltitudeActual != null) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibrationElevation), :menuAltimeterCalibrationElevation);
      }
    }
    else if(_menu == :menuAltimeterCorrection) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAltimeterCorrection));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrectionAbsolute), :menuAltimeterCorrectionAbsolute);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrectionRelative), :menuAltimeterCorrectionRelative);
    }

    else if(_menu == :menuSettingsTemperature) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsTemperature));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTemperatureCalibration), :menuTemperatureCalibration);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTemperatureAlert), :menuTemperatureAlert);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTemperatureAuto), :menuTemperatureAuto);
    }

    else if(_menu == :menuSettingsWind) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsWind));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleWindSpeed), :menuWindSpeed);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleWindDirection), :menuWindDirection);
    }

    else if(_menu == :menuSettingsTimer) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsTimer));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerAutoLog), :menuTimerAutoLog);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerAutoActivity), :menuTimerAutoActivity);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerThreshold), :menuTimerThreshold);
    }
    else if(_menu == :menuTimerThreshold) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleTimerThreshold));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerThresholdGround), :menuTimerThresholdGround);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerThresholdAirborne), :menuTimerThresholdAirborne);
    }

    else if(_menu == :menuSettingsNotifications) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsNotifications));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleNotificationsAltimeter), :menuNotificationsAltimeter);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleNotificationsTemperature), :menuNotificationsTemperature);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleNotificationsFuel), :menuNotificationsFuel);
    }

    else if(_menu == :menuSettingsGeneral) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsGeneral));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleGeneralBackgroundColor), :menuGeneralBackgroundColor);
    }

    else if(_menu == :menuSettingsUnits) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsUnits));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitDistance), :menuUnitDistance);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitElevation), :menuUnitElevation);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitWeight), :menuUnitWeight);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitFuel), :menuUnitFuel);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitPressure), :menuUnitPressure);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitTemperature), :menuUnitTemperature);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitTimeUTC), :menuUnitTimeUTC);
    }

    else if(_menu == :menuStorage) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleStorage));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageImportData), :menuStorageImportData);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageClear), :menuStorageClear);
    }

    else if(_menu == :menuTowplane) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftTowplane));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageEdit), :menuTowplaneEdit);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageLoad), :menuTowplaneLoad);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageSave), :menuTowplaneSave);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageDelete), :menuTowplaneDelete);
    }
    else if(_menu == :menuTowplaneEdit) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleStorageEdit));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeight), :menuTowplaneWeight);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuel), :menuTowplaneFuel);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeed), :menuTowplaneSpeed);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftCallsign), :menuTowplaneCallsign);
    }
    else if(_menu == :menuTowplaneWeight) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftWeight));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightPayload), :menuTowplaneWeightPayload);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightEmpty), :menuTowplaneWeightEmpty);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTakeoff), :menuTowplaneWeightMaxTakeoff);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTowing), :menuTowplaneWeightMaxTowing);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTowed), :menuTowplaneWeightMaxTowed);
    }
    else if(_menu == :menuTowplaneFuel) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftFuel));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelQuantity), :menuTowplaneFuelQuantity);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelAlert), :menuTowplaneFuelAlert);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelFlow), :menuTowplaneFuelFlow);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelDensity), :menuTowplaneFuelDensity);
    }
    else if(_menu == :menuTowplaneFuelFlow) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftFuelFlow));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowGround), :menuTowplaneFuelFlowGround);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowAirborne), :menuTowplaneFuelFlowAirborne);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftFuelFlowTowing), :menuTowplaneFuelFlowTowing);
    }
    else if(_menu == :menuTowplaneSpeed) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftSpeed));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedOffBlock), :menuTowplaneSpeedOffBlock);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedTakeoff), :menuTowplaneSpeedTakeoff);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedLanding), :menuTowplaneSpeedLanding);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedMaxTowing), :menuTowplaneSpeedMaxTowing);
    }

    else if(_menu == :menuGlider) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftGlider));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageEdit), :menuGliderEdit);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageLoad), :menuGliderLoad);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageSave), :menuGliderSave);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleStorageDelete), :menuGliderDelete);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftClear), :menuGliderClear);
    }
    else if(_menu == :menuGliderEdit) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleStorageEdit));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeight), :menuGliderWeight);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeed), :menuGliderSpeed);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftCallsign), :menuGliderCallsign);
    }
    else if(_menu == :menuGliderWeight) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftWeight));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightPayload), :menuGliderWeightPayload);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightBallast), :menuGliderWeightBallast);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightEmpty), :menuGliderWeightEmpty);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftWeightMaxTakeoff), :menuGliderWeightMaxTakeoff);
    }
    else if(_menu == :menuGliderSpeed) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAircraftSpeed));
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAircraftSpeedTowing), :menuGliderSpeedTowing);
    }

    else if(_menu == :menuAbout) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAbout));
      Menu.addItem(Lang.format("$1$: $2$", [Ui.loadResource(Rez.Strings.titleVersion), Ui.loadResource(Rez.Strings.AppVersion)]), :aboutVersion);
      Menu.addItem(Lang.format("$1$: GPL 3.0", [Ui.loadResource(Rez.Strings.titleLicense)]), :aboutLicense);
      Menu.addItem(Lang.format("$1$: Cédric Dufour", [Ui.loadResource(Rez.Strings.titleAuthor)]), :aboutAuthor);
    }

    else if(_menu == :menuActivity) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleActivity));
      if($.TSK_oActivity != null) {
        if($.TSK_oActivity.isRecording()) {
          Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityPause), :menuActivityPause);
        }
        else {
          Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityResume), :menuActivityResume);
        }
        Menu.addItem(Ui.loadResource(Rez.Strings.titleActivitySave), :menuActivitySave);
        Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityDiscard), :menuActivityDiscard);
      }
    }

    else if(_menu == :menuTimer) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleTimer));
      if($.TSK_oTimer.iState <= TSK_Timer.STATE_OFFBLOCK or ($.TSK_oTimer.iState == TSK_Timer.STATE_ONBLOCK and $.TSK_oTimer.oTimeTakeoff == null)) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerReset), :menuTimerReset);
      }
      else if($.TSK_oTimer.iState == TSK_Timer.STATE_ONBLOCK and $.TSK_oTimer.oTimeTakeoff != null) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerSave), :menuTimerSave);
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerDiscard), :menuTimerDiscard);
      }
      if($.TSK_oTimer.oTimeTakeoff != null) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerAddCycle), :menuTimerAddCycle);
        Menu.addItem(Ui.loadResource(Rez.Strings.titleTimerUndoCycle), :menuTimerUndoCycle);
      }
      if($.TSK_oActivity == null) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleExit), :menuExit);
      }
    }

  }

}

class TSK_MenuGenericDelegate extends Ui.MenuInputDelegate {

  //
  // VARIABLES
  //

  private var menu;


  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize(_menu) {
    MenuInputDelegate.initialize();
    self.menu = _menu;
  }

  function onMenuItem(_item) {
    if(self.menu == :menuGlobal) {
      if(_item == :menuSettings) {
        Ui.pushView(new TSK_MenuGeneric(:menuSettings), new TSK_MenuGenericDelegate(:menuSettings), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplane) {
        Ui.pushView(new TSK_MenuGeneric(:menuTowplane), new TSK_MenuGenericDelegate(:menuTowplane), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGlider) {
        Ui.pushView(new TSK_MenuGeneric(:menuGlider), new TSK_MenuGenericDelegate(:menuGlider), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettings) {
      if(_item == :menuSettingsAltimeter) {
        Ui.pushView(new TSK_MenuGeneric(:menuSettingsAltimeter), new TSK_MenuGenericDelegate(:menuSettingsAltimeter), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsTemperature) {
        Ui.pushView(new TSK_MenuGeneric(:menuSettingsTemperature), new TSK_MenuGenericDelegate(:menuSettingsTemperature), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsWind) {
        Ui.pushView(new TSK_MenuGeneric(:menuSettingsWind), new TSK_MenuGenericDelegate(:menuSettingsWind), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsTimer) {
        Ui.pushView(new TSK_MenuGeneric(:menuSettingsTimer), new TSK_MenuGenericDelegate(:menuSettingsTimer), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsNotifications) {
        Ui.pushView(new TSK_MenuGeneric(:menuSettingsNotifications), new TSK_MenuGenericDelegate(:menuSettingsNotifications), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsGeneral) {
        Ui.pushView(new TSK_MenuGeneric(:menuSettingsGeneral), new TSK_MenuGenericDelegate(:menuSettingsGeneral), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsUnits) {
        Ui.pushView(new TSK_MenuGeneric(:menuSettingsUnits), new TSK_MenuGenericDelegate(:menuSettingsUnits), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuStorage) {
        Ui.pushView(new TSK_MenuGeneric(:menuStorage), new TSK_MenuGenericDelegate(:menuStorage), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAbout) {
        Ui.pushView(new TSK_MenuGeneric(:menuAbout), new TSK_MenuGenericDelegate(:menuAbout), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsAltimeter) {
      if(_item == :menuAltimeterCalibration) {
        Ui.pushView(new TSK_MenuGeneric(:menuAltimeterCalibration), new TSK_MenuGenericDelegate(:menuAltimeterCalibration), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCorrection) {
        Ui.pushView(new TSK_MenuGeneric(:menuAltimeterCorrection), new TSK_MenuGenericDelegate(:menuAltimeterCorrection), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterAlert) {
        Ui.pushView(new TSK_PickerGenericElevation(:contextSettings, :itemAltimeterAlert), new TSK_PickerGenericElevationDelegate(:contextSettings, :itemAltimeterAlert), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuAltimeterCalibration) {
      if(_item == :menuAltimeterCalibrationQNH) {
        Ui.pushView(new TSK_PickerGenericPressure(:contextSettings, :itemAltimeterCalibration), new TSK_PickerGenericPressureDelegate(:contextSettings, :itemAltimeterCalibration), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCalibrationElevation) {
        Ui.pushView(new TSK_PickerGenericElevation(:contextSettings, :itemAltimeterCalibration), new TSK_PickerGenericElevationDelegate(:contextSettings, :itemAltimeterCalibration), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuAltimeterCorrection) {
      if(_item == :menuAltimeterCorrectionAbsolute) {
        Ui.pushView(new TSK_PickerGenericPressure(:contextSettings, :itemAltimeterCorrection), new TSK_PickerGenericPressureDelegate(:contextSettings, :itemAltimeterCorrection), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCorrectionRelative) {
        Ui.pushView(new TSK_PickerAltimeterCorrectionRelative(), new TSK_PickerAltimeterCorrectionRelativeDelegate(), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsTemperature) {
      if(_item == :menuTemperatureAuto) {
        Ui.pushView(new TSK_PickerTemperatureAuto(), new TSK_PickerTemperatureAutoDelegate(), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTemperatureCalibration) {
        Ui.pushView(new TSK_PickerGenericTemperature(:contextSettings, :itemTemperatureCalibration), new TSK_PickerGenericTemperatureDelegate(:contextSettings, :itemTemperatureCalibration), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTemperatureAlert) {
        Ui.pushView(new TSK_PickerGenericTemperature(:contextSettings, :itemTemperatureAlert), new TSK_PickerGenericTemperatureDelegate(:contextSettings, :itemTemperatureAlert), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsWind) {
      if(_item == :menuWindSpeed) {
        Ui.pushView(new TSK_PickerGenericSpeed(:contextSettings, :itemWindSpeed), new TSK_PickerGenericSpeedDelegate(:contextSettings, :itemWindSpeed), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuWindDirection) {
        Ui.pushView(new TSK_PickerGenericHeading(:contextSettings, :itemWindDirection), new TSK_PickerGenericHeadingDelegate(:contextSettings, :itemWindDirection), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsTimer) {
      if(_item == :menuTimerAutoLog) {
        Ui.pushView(new TSK_PickerGenericOnOff(:contextSettings, :itemTimerAutoLog), new TSK_PickerGenericOnOffDelegate(:contextSettings, :itemTimerAutoLog), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerAutoActivity) {
        Ui.pushView(new TSK_PickerGenericOnOff(:contextSettings, :itemTimerAutoActivity), new TSK_PickerGenericOnOffDelegate(:contextSettings, :itemTimerAutoActivity), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerThreshold) {
        Ui.pushView(new TSK_MenuGeneric(:menuTimerThreshold), new TSK_MenuGenericDelegate(:menuTimerThreshold), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTimerThreshold) {
      if(_item == :menuTimerThresholdGround) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextTimer, :itemThresholdGround), new TSK_PickerGenericSettingsDelegate(:contextTimer, :itemThresholdGround), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerThresholdAirborne) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextTimer, :itemThresholdAirborne), new TSK_PickerGenericSettingsDelegate(:contextTimer, :itemThresholdAirborne), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsNotifications) {
      if(_item == :menuNotificationsAltimeter) {
        Ui.pushView(new TSK_PickerGenericOnOff(:contextSettings, :itemNotificationsAltimeter), new TSK_PickerGenericOnOffDelegate(:contextSettings, :itemNotificationsAltimeter), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuNotificationsTemperature) {
        Ui.pushView(new TSK_PickerGenericOnOff(:contextSettings, :itemNotificationsTemperature), new TSK_PickerGenericOnOffDelegate(:contextSettings, :itemNotificationsTemperature), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuNotificationsFuel) {
        Ui.pushView(new TSK_PickerGenericOnOff(:contextSettings, :itemNotificationsFuel), new TSK_PickerGenericOnOffDelegate(:contextSettings, :itemNotificationsFuel), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsGeneral) {
      if(_item == :menuGeneralBackgroundColor) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextGeneral, :itemBackgroundColor), new TSK_PickerGenericSettingsDelegate(:contextGeneral, :itemBackgroundColor), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsUnits) {
      if(_item == :menuUnitDistance) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextUnit, :itemDistance), new TSK_PickerGenericSettingsDelegate(:contextUnit, :itemDistance), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitElevation) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextUnit, :itemElevation), new TSK_PickerGenericSettingsDelegate(:contextUnit, :itemElevation), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitWeight) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextUnit, :itemWeight), new TSK_PickerGenericSettingsDelegate(:contextUnit, :itemWeight), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitFuel) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextUnit, :itemFuel), new TSK_PickerGenericSettingsDelegate(:contextUnit, :itemFuel), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitPressure) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextUnit, :itemPressure), new TSK_PickerGenericSettingsDelegate(:contextUnit, :itemPressure), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitTemperature) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextUnit, :itemTemperature), new TSK_PickerGenericSettingsDelegate(:contextUnit, :itemTemperature), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitTimeUTC) {
        Ui.pushView(new TSK_PickerGenericSettings(:contextUnit, :itemTimeUTC), new TSK_PickerGenericSettingsDelegate(:contextUnit, :itemTimeUTC), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuStorage) {
      if(_item == :menuStorageImportData) {
        Ui.pushView(new TSK_PickerGenericText(:contextStorage, :itemImportData), new TSK_PickerGenericTextDelegate(:contextStorage, :itemImportData), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuStorageClear) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextStorage, :actionClear), new TSK_MenuGenericConfirmDelegate(:contextStorage, :actionClear, true), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuTowplane) {
      if(_item == :menuTowplaneEdit) {
        Ui.pushView(new TSK_MenuGeneric(:menuTowplaneEdit), new TSK_MenuGenericDelegate(:menuTowplaneEdit), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneLoad) {
        Ui.pushView(new TSK_PickerGenericStorage(:storageTowplane, :actionLoad), new TSK_PickerGenericStorageDelegate(:storageTowplane, :actionLoad), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSave) {
        Ui.pushView(new TSK_PickerGenericStorage(:storageTowplane, :actionSave), new TSK_PickerGenericStorageDelegate(:storageTowplane, :actionSave), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneDelete) {
        Ui.pushView(new TSK_PickerGenericStorage(:storageTowplane, :actionDelete), new TSK_PickerGenericStorageDelegate(:storageTowplane, :actionDelete), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneEdit) {
      if(_item == :menuTowplaneWeight) {
        Ui.pushView(new TSK_MenuGeneric(:menuTowplaneWeight), new TSK_MenuGenericDelegate(:menuTowplaneWeight), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuel) {
        Ui.pushView(new TSK_MenuGeneric(:menuTowplaneFuel), new TSK_MenuGenericDelegate(:menuTowplaneFuel), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSpeed) {
        Ui.pushView(new TSK_MenuGeneric(:menuTowplaneSpeed), new TSK_MenuGenericDelegate(:menuTowplaneSpeed), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneCallsign) {
        Ui.pushView(new TSK_PickerGenericText(:contextTowplane, :itemCallsign), new TSK_PickerGenericTextDelegate(:contextTowplane, :itemCallsign), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneWeight) {
      if(_item == :menuTowplaneWeightEmpty) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextTowplane, :itemWeightEmpty), new TSK_PickerGenericWeightDelegate(:contextTowplane, :itemWeightEmpty), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeightPayload) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextTowplane, :itemWeightPayload), new TSK_PickerGenericWeightDelegate(:contextTowplane, :itemWeightPayload), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeightMaxTakeoff) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextTowplane, :itemWeightMaxTakeoff), new TSK_PickerGenericWeightDelegate(:contextTowplane, :itemWeightMaxTakeoff), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeightMaxTowing) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextTowplane, :itemWeightMaxTowing), new TSK_PickerGenericWeightDelegate(:contextTowplane, :itemWeightMaxTowing), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneWeightMaxTowed) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextTowplane, :itemWeightMaxTowed), new TSK_PickerGenericWeightDelegate(:contextTowplane, :itemWeightMaxTowed), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneFuel) {
      if(_item == :menuTowplaneFuelQuantity) {
        Ui.pushView(new TSK_PickerGenericFuel(:contextTowplane, :itemFuelQuantity), new TSK_PickerGenericFuelDelegate(:contextTowplane, :itemFuelQuantity), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelDensity) {
        Ui.pushView(new TSK_PickerGenericFuelDensity(:contextTowplane, :itemFuelDensity), new TSK_PickerGenericFuelDensityDelegate(:contextTowplane, :itemFuelDensity), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelFlow) {
        Ui.pushView(new TSK_MenuGeneric(:menuTowplaneFuelFlow), new TSK_MenuGenericDelegate(:menuTowplaneFuelFlow), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelAlert) {
        Ui.pushView(new TSK_PickerGenericFuel(:contextTowplane, :itemFuelAlert), new TSK_PickerGenericFuelDelegate(:contextTowplane, :itemFuelAlert), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneFuelFlow) {
      if(_item == :menuTowplaneFuelFlowGround) {
        Ui.pushView(new TSK_PickerGenericFuelFlow(:contextTowplane, :itemFuelFlowGround), new TSK_PickerGenericFuelFlowDelegate(:contextTowplane, :itemFuelFlowGround), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelFlowAirborne) {
        Ui.pushView(new TSK_PickerGenericFuelFlow(:contextTowplane, :itemFuelFlowAirborne), new TSK_PickerGenericFuelFlowDelegate(:contextTowplane, :itemFuelFlowAirborne), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneFuelFlowTowing) {
        Ui.pushView(new TSK_PickerGenericFuelFlow(:contextTowplane, :itemFuelFlowTowing), new TSK_PickerGenericFuelFlowDelegate(:contextTowplane, :itemFuelFlowTowing), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuTowplaneSpeed) {
      if(_item == :menuTowplaneSpeedOffBlock) {
        Ui.pushView(new TSK_PickerGenericSpeed(:contextTowplane, :itemSpeedOffBlock), new TSK_PickerGenericSpeedDelegate(:contextTowplane, :itemSpeedOffBlock), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSpeedTakeoff) {
        Ui.pushView(new TSK_PickerGenericSpeed(:contextTowplane, :itemSpeedTakeoff), new TSK_PickerGenericSpeedDelegate(:contextTowplane, :itemSpeedTakeoff), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSpeedLanding) {
        Ui.pushView(new TSK_PickerGenericSpeed(:contextTowplane, :itemSpeedLanding), new TSK_PickerGenericSpeedDelegate(:contextTowplane, :itemSpeedLanding), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTowplaneSpeedMaxTowing) {
        Ui.pushView(new TSK_PickerGenericSpeed(:contextTowplane, :itemSpeedMaxTowing), new TSK_PickerGenericSpeedDelegate(:contextTowplane, :itemSpeedMaxTowing), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuGlider) {
      if(_item == :menuGliderEdit) {
        Ui.pushView(new TSK_MenuGeneric(:menuGliderEdit), new TSK_MenuGenericDelegate(:menuGliderEdit), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderLoad) {
        Ui.pushView(new TSK_PickerGenericStorage(:storageGlider, :actionLoad), new TSK_PickerGenericStorageDelegate(:storageGlider, :actionLoad), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderSave) {
        Ui.pushView(new TSK_PickerGenericStorage(:storageGlider, :actionSave), new TSK_PickerGenericStorageDelegate(:storageGlider, :actionSave), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderDelete) {
        Ui.pushView(new TSK_PickerGenericStorage(:storageGlider, :actionDelete), new TSK_PickerGenericStorageDelegate(:storageGlider, :actionDelete), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderClear) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextGlider, :actionClear), new TSK_MenuGenericConfirmDelegate(:contextGlider, :actionClear, true), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuGliderEdit) {
      if(_item == :menuGliderWeight) {
        Ui.pushView(new TSK_MenuGeneric(:menuGliderWeight), new TSK_MenuGenericDelegate(:menuGliderWeight), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderSpeed) {
        Ui.pushView(new TSK_MenuGeneric(:menuGliderSpeed), new TSK_MenuGenericDelegate(:menuGliderSpeed), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderCallsign) {
        Ui.pushView(new TSK_PickerGenericText(:contextGlider, :itemCallsign), new TSK_PickerGenericTextDelegate(:contextGlider, :itemCallsign), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuGliderWeight) {
      if(_item == :menuGliderWeightEmpty) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextGlider, :itemWeightEmpty), new TSK_PickerGenericWeightDelegate(:contextGlider, :itemWeightEmpty), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderWeightPayload) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextGlider, :itemWeightPayload), new TSK_PickerGenericWeightDelegate(:contextGlider, :itemWeightPayload), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderWeightBallast) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextGlider, :itemWeightBallast), new TSK_PickerGenericWeightDelegate(:contextGlider, :itemWeightBallast), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuGliderWeightMaxTakeoff) {
        Ui.pushView(new TSK_PickerGenericWeight(:contextGlider, :itemWeightMaxTakeoff), new TSK_PickerGenericWeightDelegate(:contextGlider, :itemWeightMaxTakeoff), Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuGliderSpeed) {
      if(_item == :menuGliderSpeedTowing) {
        Ui.pushView(new TSK_PickerGenericSpeed(:contextGlider, :itemSpeedTowing), new TSK_PickerGenericSpeedDelegate(:contextGlider, :itemSpeedTowing), Ui.SLIDE_IMMEDIATE);
      }
    }

    //else if(self.menu == :menuAbout) {
    //  // Nothing to do here
    //}

    else if(self.menu == :menuActivity) {
      if(_item == :menuActivityResume) {
        if($.TSK_oActivity != null) {
          $.TSK_oActivity.resume();
        }
      }
      else if(_item == :menuActivityPause) {
        if($.TSK_oActivity != null) {
          $.TSK_oActivity.pause();
        }
      }
      else if(_item == :menuActivitySave) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextActivity, :actionSave), new TSK_MenuGenericConfirmDelegate(:contextActivity, :actionSave, true), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuActivityDiscard) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextActivity, :actionDiscard), new TSK_MenuGenericConfirmDelegate(:contextActivity, :actionDiscard, true), Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuTimer) {
      if(_item == :menuTimerReset) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextTimer, :actionReset), new TSK_MenuGenericConfirmDelegate(:contextTimer, :actionReset, true), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerAddCycle) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextTimer, :actionAddCycle), new TSK_MenuGenericConfirmDelegate(:contextTimer, :actionAddCycle, true), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerUndoCycle) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextTimer, :actionUndoCycle), new TSK_MenuGenericConfirmDelegate(:contextTimer, :actionUndoCycle, true), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerSave) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextTimer, :actionSave), new TSK_MenuGenericConfirmDelegate(:contextTimer, :actionSave, true), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuTimerDiscard) {
        Ui.pushView(new TSK_MenuGenericConfirm(:contextTimer, :actionDiscard), new TSK_MenuGenericConfirmDelegate(:contextTimer, :actionDiscard, true), Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuExit) {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
      }
    }

  }

}
