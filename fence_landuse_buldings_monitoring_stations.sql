-- CREATE database farming;
   -- --/C: farming #connects to the database

----------------------------------------MONITORING STATIONS-------------------------------------

-- MONITORING READING UNIT --
CREATE TABLE IF NOT EXISTS monitoring_reading_unit (
   id SERIAL PRIMARY KEY,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   reading_unit_name TEXT NOT NULL
);

COMMENT ON TABLE monitoring_reading_unit IS 'Look up table for monitoring station reading unit';
COMMENT ON COLUMN monitoring_reading_unit.id IS 'The unique monitoring reading unit type ID. This is the Primary Key.';
COMMENT ON COLUMN monitoring_reading_unit.reading_unit_name IS 'The name is unique to the monitoring reading unit table.';
COMMENT ON COLUMN monitoring_reading_unit.uuid IS 'Globally Unique Identifier.';


-- EQUIPMENT SUPPLIER --
CREATE TABLE IF NOT EXISTS equipment_supplier (
   id SERIAL PRIMARY KEY,
   supplier_name TEXT,
   supplier_url TEXT NOT NULL,
   phone TEXT NOT NULL,
   notes TEXT,
   supplier_logo TEXT NOT NULL,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid()
);

COMMENT ON COLUMN equipment_supplier.id IS 'The equipment_supplier ID. This is the Primary Key.';
COMMENT ON COLUMN equipment_supplier.supplier_name IS 'The name is unique to the monitoring reading unit table.';
COMMENT ON COLUMN equipment_supplier.supplier_url IS 'The URL is unique to the monitoring reading unit table.';
COMMENT ON COLUMN equipment_supplier.phone IS 'The phone is unique to the monitoring reading unit table.';
COMMENT ON COLUMN equipment_supplier.notes IS 'Where we make comments and a description about the equipment_supplier.';
COMMENT ON COLUMN equipment_supplier.supplier_logo IS 'Where the logo of the equipment_supplier is stored.';
COMMENT ON COLUMN equipment_supplier.uuid IS 'Globally Unique Identifier.';


-- MONITORING EQUIPMENT TYPE --
CREATE TABLE IF NOT EXISTS monitoring_equipment_type (
   id SERIAL PRIMARY KEY,
   equipment_type_name TEXT NOT NULL,
   equipment_type_image TEXT NOT NULL,
   notes TEXT,
   model TEXT NOT NULL,
   supplier_product_url TEXT NOT NULL,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   monitoring_equipment_type_uuid UUID NOT NULL REFERENCES equipment_supplier (uuid)
);

COMMENT ON COLUMN monitoring_equipment_type.id IS 'The monitoring_equipment_type ID. This is the Primary Key.';
COMMENT ON COLUMN monitoring_equipment_type.equipment_type_name IS 'Where we make comments and a description about the monitoring_equipment_type.';
COMMENT ON COLUMN monitoring_equipment_type.equipment_type_image IS 'The image link associated with the monitoring_equipment_type.';
COMMENT ON COLUMN monitoring_equipment_type.notes IS 'Where we make comments and a description about the monitoring_equipment_type.';
COMMENT ON COLUMN monitoring_equipment_type.model IS 'Where we make comments and a description about the monitoring_equipment_type.';
COMMENT ON COLUMN monitoring_equipment_type.supplier_product_url IS 'The URL is unique to the monitoring_equipment_type.';
COMMENT ON COLUMN monitoring_equipment_type.uuid IS 'Globally Unique Identifier.';
COMMENT ON COLUMN monitoring_equipment_type.monitoring_equipment_type_uuid IS 'Globally Unique Identifier.';

-- ASSOCIATION TABLE --
-- MONITORING STATION --
CREATE TABLE IF NOT EXISTS monitoring_station (
   id SERIAL PRIMARY KEY,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   monitoring_station_name TEXT,
   monitoring_station_image TEXT,
   notes TEXT,
   reading_value FLOAT NOT NULL,
   geometry GEOMETRY (POINT, 4326) NOT NULL,
   last_update TIMESTAMP DEFAULT now() NOT NULL,
   last_update_by TEXT NOT NULL,
   monitoring_reading_unit_uuid UUID NOT NULL REFERENCES monitoring_reading_unit (uuid),
   monitoring_equipment_type_uuid UUID NOT NULL REFERENCES monitoring_equipment_type (uuid)
);

COMMENT ON COLUMN monitoring_station.id IS 'The monitoring_station ID. This is the Primary Key.';
COMMENT ON COLUMN monitoring_station.monitoring_station_name IS 'Where we make comments and a description about the monitoring_station_image.';
COMMENT ON COLUMN monitoring_station.monitoring_station_image IS 'The image link associated with the monitoring_station_image.';
COMMENT ON COLUMN monitoring_station.notes IS 'Where we make comments and a description about the monitoring_station.';
COMMENT ON COLUMN monitoring_station.geometry IS 'The geometry of the building (point, line, or polygon) and the projection system used.';
COMMENT ON COLUMN monitoring_station.reading_value IS 'The reading value that the monitoring station will have';
COMMENT ON COLUMN monitoring_station.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN monitoring_station.last_update_by IS 'The name of the person who updated the table last.';
COMMENT ON COLUMN monitoring_station.uuid IS 'Globally Unique Identifier.';
COMMENT ON COLUMN monitoring_station.monitoring_reading_unit_uuid IS 'Globally Unique Identifier.';
COMMENT ON COLUMN monitoring_station.monitoring_equipment_type_uuid IS 'Globally Unique Identifier.'




---------------------------------------- LAND USE BUILDINGS -------------------------------------

-- BUILDING TYPE --
CREATE TABLE IF NOT EXISTS building_type(
   id serial PRIMARY KEY, -- We said this should be serial, not int. Also 'id', not 'building_type_id'
   name VARCHAR UNIQUE NOT NULL, --this was named 'name' in the erd, not 'type_name'. Must be unique
   notes TEXT,
   image TEXT,
   last_update TIMESTAMP DEFAULT now()NOT NULL,
   last_update_by TEXT NOT NULL,
   uuid uuid UNIQUE NOT NULL DEFAULT gen_random_uuid());

COMMENT ON TABLE building_type IS 'Look up table for the types of buildings available, e.g barns, cottages, etc.';
COMMENT ON COLUMN building_type.id IS 'The unique building type ID. This is the Primary Key.';
COMMENT ON COLUMN building_type.name IS 'The name is unique to the buildings table.';
COMMENT ON COLUMN building_type.notes IS 'Where we make comments and a description about the building_type.';
COMMENT ON COLUMN building_type.image IS 'The image link associated with the building type.';
COMMENT ON COLUMN building_type.last_update IS 'The timestamp shown for when the building type table has been updated.';
COMMENT ON COLUMN building_type.last_update_by IS 'The name of the person who updated the table last.';
COMMENT ON COLUMN building_type.uuid IS 'Globally Unique Identifier.';


-- BUILDINGS --
CREATE TABLE IF NOT EXISTS building(
   id SERIAL PRIMARY KEY,
   name VARCHAR NOT NULL,
   notes TEXT NOT NULL,
   address TEXT NOT NULL,	
   image TEXT,
   geometry GEOMETRY(Polygon, 4326),
   area_square_meter FLOAT NOT NULL,
   height_meter FLOAT NOT NULL,	
   last_update TIMESTAMP DEFAULT now() NOT NULL,
   last_update_by TEXT NOT NULL,
   uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
   building_type_uuid UUID  NOT NULL REFERENCES building_type(uuid),
   building_land_use_uuid UUID NOT NULL REFERENCES building_land_use(uuid));

COMMENT ON TABLE building IS 'Look up table for the types of buildings available, e.g residential';
COMMENT ON COLUMN building.id IS 'The unique building type ID. This is the Primary Key.';
COMMENT ON COLUMN building.name IS 'The name is unique for the building table.';
COMMENT ON COLUMN building.notes IS 'Where we make comments and a description about the building_type.';
COMMENT ON COLUMN building.address IS 'The address of the building to locate it in space.';
COMMENT ON COLUMN building.image IS 'The image link associated with the building_type.';
COMMENT ON COLUMN building.geometry IS 'The geometry of building (point, line or polygon) and the projection system used.';
COMMENT ON COLUMN building.area_square_meter IS 'The area covered by the building on the ground in m^2.';
COMMENT ON COLUMN building.height_meter IS 'The height of building which can be influenced by the shadow it casts over the nearby area depending on the position of the sun.';
COMMENT ON COLUMN building.last_update IS 'The timestamp shown for when the table has been updated.';
COMMENT ON COLUMN building.last_update_by IS 'The name of the person who upated the table last.';
COMMENT ON COLUMN building.uuid IS 'Globally Unique Identifier.';
COMMENT ON COLUMN building.building_type_uuid IS 'The foreign key which references the uuid from the building type table.';
COMMENT ON COLUMN building.building_land_use_uuid IS 'The foreign key which references the uuid from the building land use table';

--BUILDING MATERIAL--
CREATE TABLE IF NOT EXISTS building_material(
id serial PRIMARY KEY,
name VARCHAR UNIQUE NOT NULL, --look up table names must be unique
notes TEXT,
image TEXT,
last_update TIMESTAMP DEFAULT now()NOT NULL,
last_update_by TEXT NOT NULL,
uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
building_uuid UUID  NOT NULL REFERENCES building(uuid));

COMMENT ON TABLE building_material IS 'Look up table for the types of building materials e.g. wood, concrete, aluminuim sheets etc.';
COMMENT ON COLUMN building_material.id IS 'The unique building material type ID. This is the Primary Key.';
COMMENT ON COLUMN building_material.name IS 'The name is unique to the buildings table since it is a look up table.';
COMMENT ON COLUMN building_material.notes IS 'Where we make comments and a description about the building material.';
COMMENT ON COLUMN building_material.image IS 'The image link associated with the building material.';
COMMENT ON COLUMN building_material.last_update IS 'The timestamp shown for when the building material table has been updated.';
COMMENT ON COLUMN building_material.last_update_by IS 'The name of the person who upated the table last.';
COMMENT ON COLUMN building_material.uuid IS 'Globally Unique Identifier.';

-- BUILDING CONDITIONS --
CREATE TABLE IF NOT EXISTS building_conditions_type(
id serial PRIMARY KEY,
name VARCHAR UNIQUE NOT NULL, --look up table names must be unique
notes TEXT,
image TEXT,
last_update TIMESTAMP DEFAULT now()NOT NULL,
last_update_by TEXT NOT NULL,
uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid());

COMMENT ON TABLE building_conditions_type IS 'Look up table for the types of buildings available and the condition its in.';
COMMENT ON COLUMN building_conditions_type.id IS 'The unique building conditions type ID. This is the Primary Key.';
COMMENT ON COLUMN building_conditions_type.name IS 'The name is unique to the buildings table since it is a look up table.';
COMMENT ON COLUMN building_conditions_type.notes IS 'Where we make comments and a description about the building conditions type.';
COMMENT ON COLUMN building_conditions_type.image IS 'The image link associated with the building conditions type.';
COMMENT ON COLUMN building_conditions_type.last_update IS 'The timestamp shown for when the building conditions type table has been updated.';
COMMENT ON COLUMN building_conditions_type.last_update_by IS 'The name of the person who upated the table last.';
COMMENT ON COLUMN building_conditions_type.uuid IS 'Globally Unique Identifier.';

-- LAND USE BUILDINGS --
CREATE TABLE IF NOT EXISTS building_conditions( --should be conditions, to indicate association table
uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),	
last_update TIMESTAMP DEFAULT now() NOT NULL,
last_update_by TEXT NOT NULL,
name TEXT NOT NULL,
notes TEXT,
image TEXT,
date DATE NOT NULL,	
building_conditions_type_uuid UUID NOT NULL REFERENCES building_conditions_type(uuid),
building_uuid UUID NOT NULL REFERENCES building(uuid),
PRIMARY KEY (building_conditions_type_uuid, building_uuid,date), --composite keys
UNIQUE (building_conditions_type_uuid, building_uuid,date));

COMMENT ON TABLE building_conditions IS 'An association table between building and building conditions type.';
COMMENT ON COLUMN building_conditions.uuid IS 'Globally Unique Identifier.';
COMMENT ON COLUMN building_conditions.last_update IS 'The timestamp shown for when the table has been updated.';
COMMENT ON COLUMN building_conditions.last_update_by IS 'The name of the person who upated the table last.';
COMMENT ON COLUMN building_conditions.name IS 'The name is unique to the conditions of the building.';
COMMENT ON COLUMN building_conditions.notes IS 'Where we make comments and a description about the building conditions.';
COMMENT ON COLUMN building_conditions.image IS 'The image link associated with the building conditions.';
COMMENT ON COLUMN building_conditions.date IS 'The datetime alteration of the conditions. This is the Primary and Composite Key';
COMMENT ON COLUMN building_conditions.building_conditions_type_uuid IS 'The foreign key which is referenced from the building conditions type table.';
COMMENT ON COLUMN building_conditions.building_uuid IS 'The foreign key referenced from the building table.';


---------------------------------------- FENCES -------------------------------------

-- conditions
CREATE TABLE IF NOT EXISTS condition (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name TEXT UNIQUE NOT NULL,
    notes TEXT,
    image TEXT
);
COMMENT ON TABLE condition  IS 'Look up table for condition, e.g. good, bad.';
COMMENT ON COLUMN condition.id IS 'The unique condition item id. Primary key.';
COMMENT ON COLUMN condition.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN condition.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN condition.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN condition.name IS 'The name of the condition item.';
COMMENT ON COLUMN condition.notes IS 'Additional information of the condition item.';
COMMENT ON COLUMN condition.image IS 'Image of the condition item.';


--Fence_type
CREATE TABLE IF NOT EXISTS fence_type (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name TEXT UNIQUE NOT NULL,
    notes TEXT,
    image TEXT,
    sort_order INT UNIQUE
);
COMMENT ON TABLE fence_type IS 'Look up table for fence types, e.g. electric, chain_link.';
COMMENT ON COLUMN fence_type.id IS 'The unique fence type item id. Primary key.';
COMMENT ON COLUMN fence_type.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN fence_type.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN fence_type.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN fence_type.name IS 'The name of the fence type item.';
COMMENT ON COLUMN fence_type.notes IS 'Additional information of the fence type item.';
COMMENT ON COLUMN fence_type.image IS 'Image of the fence type item.';


-- Fence Line
CREATE TABLE IF NOT EXISTS fence (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    notes TEXT,
    image TEXT,
    height_m FLOAT,
    installation_date DATE NOT NULL,
    is_date_estimated BOOLEAN,
    geometry GEOMETRY(LINESTRING, 4326) NOT NULL,
    fence_type_uuid UUID NOT NULL REFERENCES fence_type(uuid)
);
COMMENT ON TABLE fence IS 'The fence item refers to any geolocated line acting as boundary in the area, e.g. fence lines';
COMMENT ON COLUMN fence.id IS 'The unique fence item id. Primary key.';
COMMENT ON COLUMN fence.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN fence.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN fence.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN fence.notes IS 'Additional information of the fence item.';
COMMENT ON COLUMN fence.image IS 'Image of the fence item.';
COMMENT ON COLUMN fence.height_m IS 'Height of the fence in meters';
COMMENT ON COLUMN fence.installation_date IS 'The date the fence was installed.';
COMMENT ON COLUMN fence.is_date_estimated IS 'Is the fence item date of construction estimated?';
COMMENT ON COLUMN fence.geometry IS 'The location of the fence line. Follows EPSG: 4326.';

-- association table
-- fence_condtions
CREATE TABLE IF NOT EXISTS fence_conditions (
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    notes TEXT,
    image TEXT,
    DATE DATE NOT NULL,
    fence_uuid UUID NOT NULL REFERENCES fence(uuid),
    condition_uuid UUID NOT NULL REFERENCES condition(uuid),
    -- composite primary key
    PRIMARY key (fence_uuid, condition_uuid, DATE),
    -- unique together
    UNIQUE(fence_uuid, condition_uuid, DATE)
);
COMMENT ON TABLE fence_conditions IS 'An Association table showing the fence conditions, e.g. good, bad.';
COMMENT ON COLUMN fence_conditions.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN fence_conditions.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN fence_conditions.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN fence_conditions.notes IS 'Additional information of the fence conditions item.';
COMMENT ON COLUMN fence_conditions.image IS 'Image of the fence conditions item.';
COMMENT ON COLUMN fence_conditions."date" IS 'The date of the current conditions are marked as changed';

-- point_of_interest_type (point_of_interest_type)
CREATE TABLE IF NOT EXISTS point_of_interest_type (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name TEXT UNIQUE NOT NULL,
    notes TEXT,
    image TEXT,
    sort_order INT UNIQUE
);
COMMENT ON TABLE point_of_interest_type IS 'Look up tables for point of interest types, e.g. types of gates';
COMMENT ON COLUMN point_of_interest_type.id IS 'The unique point of interest type item id. Primary key.';
COMMENT ON COLUMN point_of_interest_type.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN point_of_interest_type.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN point_of_interest_type.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN point_of_interest_type.name IS 'The name of the point of interest type.';
COMMENT ON COLUMN point_of_interest_type.notes IS 'Additional information of the point of interest type.';
COMMENT ON COLUMN point_of_interest_type.image IS 'Image of the point of interest type.';
COMMENT ON COLUMN point_of_interest_type.sort_order IS 'The pattern of how point of interest types are to be sorted.';

-- point_of_interest
CREATE TABLE IF NOT EXISTS point_of_interest (
    id serial NOT NULL PRIMARY key,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name TEXT,
    notes TEXT,
    image TEXT,
    height_m FLOAT,
    installation_date DATE,
    is_date_estimated BOOLEAN,
    geometry GEOMETRY(POINT, 4326) NOT NULL,
    point_of_interest_type_uuid UUID NOT NULL REFERENCES point_of_interest_type(uuid)
);
COMMENT ON TABLE point_of_interest IS 'The point of interest item refers to any geolocated point features found in the area, e.g. gate, ruin.';
COMMENT ON COLUMN point_of_interest.id IS 'The unique point of interest item id. Primary key.';
COMMENT ON COLUMN point_of_interest.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN point_of_interest.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN point_of_interest.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN point_of_interest.name IS 'The name of the point of interest item.';
COMMENT ON COLUMN point_of_interest.notes IS 'Additional information of the point of interest item.';
COMMENT ON COLUMN point_of_interest.image IS 'Image of the point of interest item.';
COMMENT ON COLUMN point_of_interest.height_m IS 'The height in meters of the point of interest.';
COMMENT ON COLUMN point_of_interest.installation_date IS 'The date the point of interest feature was installed/constructed.';
COMMENT ON COLUMN point_of_interest.is_date_estimated IS 'Is the point of interest date of construction estimated?';
COMMENT ON COLUMN point_of_interest.geometry IS 'The centroid location of the point of interest item. Follows EPSG: 4326.';

-- association table
-- point_of_interest_conditions (point_of_interest_conditions)
CREATE TABLE IF NOT EXISTS point_of_interest_conditions (
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    notes TEXT,
    image TEXT,
    DATE DATE NOT NULL,
    point_of_interest_uuid UUID NOT NULL REFERENCES point_of_interest(uuid),
    condition_uuid UUID NOT NULL REFERENCES condition(uuid),
    -- composite primary key
    PRIMARY key (point_of_interest_uuid, condition_uuid, DATE),
    -- unique together
    UNIQUE(point_of_interest_uuid, condition_uuid, DATE)
);
COMMENT ON TABLE point_of_interest_conditions IS 'An Association table for point of interest conditions, e.g. good, bad.';
COMMENT ON COLUMN point_of_interest_conditions.uuid IS 'Global Unique Identifier.';
COMMENT ON COLUMN point_of_interest_conditions.last_update IS 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN point_of_interest_conditions.last_update_by IS 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN point_of_interest_conditions.notes IS 'Additional information of the point of interest conditions item.';
COMMENT ON COLUMN point_of_interest_conditions.image IS 'Image of the point of interest conditions item.';
COMMENT ON COLUMN point_of_interest_conditions."date" IS 'The points of interest inspection date.';


----------------------------------------LANDUSE AREA -------------------------------------

-- LANDUSE AREA TYPE --
CREATE TABLE IF NOT EXISTS landuse_area_type
(
    id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name VARCHAR UNIQUE NOT NULL,
	notes TEXT,
	image TEXT,
    building_uuid UUID  NOT NULL REFERENCES building_(uuid)
);

COMMENT ON TABLE landuse_area_type is 'Lookup table for the landuse area type. Eg: Agricultural, residential, recreational, commercial, transportation etc';
COMMENT ON COLUMN landuse_area_type.id is 'The unique landuse area type ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area_type.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_type.name is 'The landuse area type field name. This is unique.';
COMMENT ON COLUMN landuse_area_type.notes is 'Additional information of the landuse area type.';
COMMENT ON COLUMN landuse_area_type.image is 'Image of the landuse area type.';
COMMENT ON COLUMN landuse_area_type.building_uuid is 'The foreign key which references the uuid from the building  table.';


--LANDUSE AREA OWNERSHIP--
CREATE TABLE IF NOT EXISTS landuse_area_ownership
(
    id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name VARCHAR UNIQUE NOT NULL,
	notes TEXT,
	image TEXT,
	owners_name TEXT,
	owners_address TEXT
   
);

COMMENT ON TABLE landuse_area_ownership is 'Lookup table for the landuse area ownership. Eg: Public or private ';
COMMENT ON COLUMN landuse_area_ownership.id is 'The unique landuse area ownership ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area_ownership.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_ownership.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_ownership.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_ownership.name is 'The landuse area ownership field name. This is unique.';
COMMENT ON COLUMN landuse_area_ownership.notes is 'Additional information of the landuse area ownership.';
COMMENT ON COLUMN landuse_area_ownership.image is 'Image of the landuse area ownership.';
COMMENT ON COLUMN landuse_area_ownership.owners_name is 'Name of the owner of the landuse area.';
COMMENT ON COLUMN landuse_area_ownership.owners_address is 'Address of the owner of the landuse area.';




-- LANDUSE AREA --
CREATE TABLE IF NOT EXISTS landuse_area
(

    id SERIAL NOT NULL PRIMARY KEY,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name VARCHAR UNIQUE NOT NULL,
	notes TEXT,
	image TEXT,
    geometry GEOMETRY(POLYGON, 4326),
    landuse_area_type_uuid UUID  NOT NULL REFERENCES landuse_area_type(uuid),
    landuse_area_ownership_uuid UUID  NOT NULL REFERENCES landuse_area_ownership(uuid)


);


COMMENT ON TABLE landuse_area is 'Lookup table for the landuse area.';
COMMENT ON COLUMN landuse_area.id is 'The unique landuse area ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area.name is 'The landuse area name. This is unique.';
COMMENT ON COLUMN landuse_area.notes is 'Additional information of the landuse area.';
COMMENT ON COLUMN landuse_area.image is 'Image of the landuse area.';
COMMENT ON COLUMN landuse_area.geometry is 'The geometry of landuse (in this case a polygon) and the projection system used.';
COMMENT ON COLUMN landuse_area.landuse_area_type_uuid is 'The foreign key which references the uuid from the landuse area type table.';
COMMENT ON COLUMN landuse_area.landuse_area_ownership_uuid is 'The foreign key which references the uuid from the landuse area ownership table.';



-- LANDUSE AREA CONDITION TYPE --

CREATE TABLE IF NOT EXISTS landuse_area_condition_type
(
    id SERIAL NOT NULL PRIMARY KEY,
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name VARCHAR UNIQUE NOT NULL, --lookup names must be unique
	notes TEXT,
	image TEXT
);


COMMENT ON TABLE landuse_area_condition_type is 'Lookup table for the landuse area condition type.eg Bare, Occupied, Work in Progress';
COMMENT ON COLUMN landuse_area_condition_type.id is 'The unique landuse area condition type ID. This is the Primary Key.';
COMMENT ON COLUMN landuse_area_condition_type.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_condition_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_condition_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_condition_type.name is 'The landuse area condition type field name.';
COMMENT ON COLUMN landuse_area_condition_type.notes is 'Additional information of the landuse area condition type.';
COMMENT ON COLUMN landuse_area_condition_type.image is 'Image of the landuse area condition type.';


-- LANDUSE AREA CONDITIONS --

CREATE TABLE IF NOT EXISTS landuse_area_conditions --indicating the association table
(
	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    name VARCHAR UNIQUE NOT NULL,
	notes TEXT,
	image TEXT,
    date DATE NOT NULL,
    landuse_area_condition_type_uuid UUID NOT NULL REFERENCES landuse_area_condition_type(uuid),
    landuse_area_uuid UUID NOT NULL REFERENCES landuse_area(uuid),
    PRIMARY KEY (landuse_area_condition_type_uuid, landuse_area_uuid, date), --These are the composite keys
    UNIQUE (landuse_area_condition_type_uuid, landuse_area_uuid, date)

);


COMMENT ON TABLE landuse_area_conditions is 'Association table for the landuse area and landuse area condition type.';
COMMENT ON COLUMN landuse_area_conditions.uuid is 'Global Unique Identifier.';
COMMENT ON COLUMN landuse_area_conditions.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN landuse_area_conditions.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN landuse_area_conditions.name is 'The landuse area conditions name which is unique.';
COMMENT ON COLUMN landuse_area_conditions.notes is 'Additional information of the landuse area conditions.';
COMMENT ON COLUMN landuse_area_conditions.image is 'Image of the landuse area conditions.';
COMMENT ON COLUMN landuse_area_conditions.date iS 'The datetime alteration of the conditions. This is the Primary and Composite Key';
COMMENT ON COLUMN landuse_area_conditions.landuse_area_uuid is 'The foreign key which references the uuid from the landuse area table.';
COMMENT ON COLUMN landuse_area_conditions.landuse_area_condition_type_uuid is 'The foreign key which references the uuid from the landuse area condition type table.';
