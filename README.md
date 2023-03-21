# Naming conventions:

SQL Statements should write reserved works in ALL CAPS for example:

``SELECT * FROM foo;``

Entity names should be singular for example:

``water_point`` not ``water_points``

Entity names should be lower case, underscore separated, for example:

``water_point`` not ``WaterPoint``

Lookup table names should be in lower case, for example:

``other`` not ``Other``

Any columns with units should include units

```crown_radius_m``` not ```crown_radius```

# ERD conventions

- Foreign keys should be last in the tables, highlighted in green.
- Each table should start with name(s), type, notes, in that order where applicable.
- All lengths, depths are assumed to be in meters. 
- Current is measured in amperes.
- Voltage to be measured in volts.
- Text to be inserted as a field value in the *image* field to provide path to the image. 
- Constraints and the fields they apply too should be in blue.
- Association tables are shown in blue.

[farming] 
host=postgis.kartoza.com
user=timlinux
password=
port=32321
dbname=farming
sslmode=require
# or gis and various others

