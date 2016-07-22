#!/usr/bin/env bash

# This would be more robust (and 100 lines longer) if I used xpath voodoo.
sed -i -e \
's/\(input \)\(ref="Band_Number_Measure"\)/\1faims_attribute_type="measure" \2 faims_attribute_name="Band Number"/g' \
module/ui_schema.xml


cd module

string="(newMeasurements\\(\\){((?!\\n}).)+)"
replacement="\\1

  setMeasurementsTimestamp();
  setMeasurementsBandNumber();
  setMeasurementsBandNumberMeasure();"
perl -0777 -i.original -pe "s/$string/$replacement/igs" ui_logic.bsh

string="(newBird\\(\\){((?!\\n}).)+)"
replacement="\\1

  copyLocationName();
  copyBirdSpecies();
  copyBandNumber();"
perl -0777 -i.original -pe "s/$string/$replacement/igs" ui_logic.bsh

string="  if (tabgroupsToValidate.contains(tabgroup)) {"
replacement="  
  if (doAllowSamplingInNav) {
    addNavigationButton(\"measure\", new ActionButtonCallback() {
      actionOnLabel() {
        \"{Take_Next_Bird_s_Measurements}\";
      }
      actionOn() {
        takeNextMeasurementsBird();
      }
    }, \"default\");
  }
  if (tabgroupsToValidate.contains(tabgroup)) {"
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

string="  removeNavigationButton(\"validate\");"
replacement="  removeNavigationButton(\"measure\");
  removeNavigationButton(\"validate\");"
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

rm ui_logic.bsh.original

echo "No_measurements_to_take=No measurements to take" >> english.0.properties
