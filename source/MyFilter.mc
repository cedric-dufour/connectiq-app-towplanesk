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

using Toybox.Lang;
using Toybox.System as Sys;

//
// CLASS
//

// We use median filtering to filter-out sensors jitter
class MyFilter {

  //
  // CONSTANTS
  //

  // Filter size
  private const SIZE = 5;  // -> 2 seconds average delay
  private const INDEX = 2;  // index of the median value (floor(size/2))

  // Filters (<-> sensors)
  public const PRESSURE = 0;
  public const TEMPERATURE = 1;
  public const VERTICALSPEED = 2;
  public const GROUNDSPEED = 3;
  public const HEADING_X = 4;
  public const HEADING_Y = 5;
  private const FILTERS = 6;


  //
  // VARIABLES
  //

  // Filters
  private var aoFilters;
  private var amSort;


  //
  // FUNCTIONS: self
  //

  function initialize() {
    // Initialize the filters container array
    self.aoFilters = new [self.FILTERS];
    self.amSort = new [self.SIZE];

    // Loop through each filter
    for(var F=0; F<self.FILTERS; F++) {
      // Create the filter array, containing:
      // [0] current value index (starting from 0)
      // [1+] values history
      self.aoFilters[F] = new [self.SIZE+1];
      self.resetFilter(F);
    }
  }

  function resetFilter(_F) {
    //Sys.println(Lang.format("DEBUG: MyFilter.resetFilter($1$)", [_F]));

    // Reset the current value index
    self.aoFilters[_F][0] = 0;

    // Reset the values history
    for(var i=0; i<self.SIZE; i++) {
      self.aoFilters[_F][1+i] = null;
    }
  }

  function filterValue(_F, _mValue, _bStrict) {
    //Sys.println(Lang.format("DEBUG: MyFilter.filterValue($1$, $2$, $2$)", [_F, _mValue, _bStrict]));

    // Store the new value
    self.aoFilters[_F][1+self.aoFilters[_F][0]] = _mValue;

    // Increase the current value index
    self.aoFilters[_F][0] = (self.aoFilters[_F][0] + 1) % self.SIZE;

    // Return the median-filtered value
    // ... sort values; NOTE: we use Jon Bentley's optimized insertion sort algorithm; https://en.wikipedia.org/wiki/Insertion_sort
    var i;
    for(i=0; i<self.SIZE; i++) {
      self.amSort[i] = self.aoFilters[_F][1+i];
      if(self.amSort[i] == null) {
        return _bStrict ? null : _mValue;  // incomplete data
      }
    }
    i = 1;
    while(i<self.SIZE) {
      var mSwap = self.amSort[i];
      var j = i - 1;
      while(j >= 0 and self.amSort[j] > mSwap) {
        self.amSort[j+1] = self.amSort[j];
        j--;
      }
      self.amSort[j+1] = mSwap;
      i++;
    }
    // ... return median
    return self.amSort[self.INDEX];
  }

}
