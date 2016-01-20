#!/bin/bash

# This would be more robust (and 100 lines longer) if I used xpath voodoo.

sed -i -e \
's/\(input \)\(ref="Band_Number_Measure"\)/\1faims_attribute_type="measure" \2 faims_attribute_name="Band Number"/g' \
module/ui_schema.xml
