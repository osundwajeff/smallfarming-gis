#NAMING CONVENTION:

***SQL*** statements and syntax should be ***upper case*** for example:

``SELECT * FROM electricity_line;``

***Entity Names*** should be ***Singular*** for example:

```electricity_line_type``` not ```electricity_line_types```

***Entity Names*** should be ***lower case***, underscore separated (_), for example:

```water_point``` not ```WaterPoint```

Lookup Table names should be in lower case, for example:

```electricity_line_condition``` not ```ElectricityLineCondition```

#ADDITIONAL INFORMATION

- uuid, last_update and last_update_by the colour grey

- geometry stays black, above the greyed attributes

- foreign keys should be last in the tables, highlighted in green

- each table should start with name(s), type, notes, in that order where applicable

- all lengths, depths are assumed to be in meters

- current is measured in amperes

- voltage to be measured in volts

- text to be inserted as a field value in the *image* field to provide path to the image 

- constraints and the fields they apply too should be in blue



[farming] 
host=postgis.kartoza.com
user=timlinux
password=
port=32321
dbname=farming
sslmode=require
# or gis and various others

