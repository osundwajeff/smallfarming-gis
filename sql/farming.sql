
create database farming;
-- add connect statement here

create extension postgis;

----------------------------------------USER UPDATE--------------------------------------
-- BASE TABLE, STORES uuid, last_update_by and last_update 
CREATE TABLE user_update(
    	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL
);
COMMENT ON TABLE user_update IS 'Stores user information and when data was updated by user. ';
COMMENT ON COLUMN user_update.uuid is 'The unique user ID.';
COMMENT ON COLUMN user_update.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN user_update.last_update_by is 'The name of the user responsible for the latest update.';


----------------------------------------INFRASTRUCTURE-------------------------------------
-- INFRASTRUCTURE TYPE
CREATE TABLE infrastructure_type (
    	id SERIAL NOT NULL PRIMARY KEY, 
    	name TEXT UNIQUE NOT NULL, 
    	notes TEXT NULL,
	-- Constraints are not inherited from the parent class, as such they are specified again in sub-classes.
    	CONSTRAINT unique_infrastructure_type_key UNIQUE (uuid)
) INHERITS (user_update); 
COMMENT ON TABLE infrastructure_type IS 'Stores information on infrastructure types available.';
COMMENT ON COLUMN infrastructure_type.id is 'The unique infrastructure type ID. This is the Primary Key.';
COMMENT ON COLUMN infrastructure_type.name is 'The infrastructure type name, e.g. Furniture, Electronics.';
COMMENT ON COLUMN infrastructure_type.notes is 'Additional information on the infrastructure type.';


-- INFRASTRUCTURE ITEM
CREATE TABLE infrastructure_item(
    	id SERIAL NOT NULL PRIMARY KEY,
    	name TEXT UNIQUE NULL, 
    	notes TEXT, 
    	geometry GEOMETRY (POINT, 4326), 
    	CONSTRAINT unique_infrastructure_item_key UNIQUE (uuid),
    	infrastructure_type_uuid UUID NOT NULL REFERENCES infrastructure_type(uuid)
) INHERITS (user_update);
COMMENT ON TABLE infrastructure_item IS 'Lookup table of the type of infrastructure type.';
COMMENT ON COLUMN infrastructure_item.id is 'The unique infrastructure item ID. Primary Key.';
COMMENT ON COLUMN infrastructure_item.name is 'The infrastructure item name, e.g. Chair.';
COMMENT ON COLUMN infrastructure_item.notes is 'Additional information on the infrastructure item type.';
COMMENT ON COLUMN infrastructure_item.geometry is 'Then centroid location of the infrastructure item. Follows EPSG: 4326.';


-- INFRASTRUCTURE LOG ACTION
CREATE TABLE infrastructure_log_action(
    	id SERIAL NOT NULL PRIMARY KEY,
    	name TEXT UNIQUE NOT NULL, 
    	notes TEXT,
    	CONSTRAINT unique_infrastructure_log_action_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE infrastructure_log_action IS 'Stores information on actions taken to maintain infrastructure items.';
COMMENT ON COLUMN infrastructure_log_action.id is 'The unique log action ID. Primary Key.';
COMMENT ON COLUMN infrastructure_log_action.name is 'The log action name, e.g. screwing.';
COMMENT ON COLUMN infrastructure_log_action.notes is 'Any additional information about the log action.';


-- INFRASTRUCTURE MANAGEMENT LOG 
CREATE TABLE infrastructure_management_log(
    	id SERIAL NOT NULL PRIMARY KEY, 
    	name TEXT UNIQUE NOT NULL, 
    	notes TEXT,
    	condition TEXT NOT NULL, 
    	image TEXT, 
    	CONSTRAINT unique_infrastructure_management_log UNIQUE (uuid),
    	infrastructure_item_uuid UUID NOT NULL REFERENCES infrastructure_item(uuid),
    	infrastructure_log_action_uuid UUID NOT NULL REFERENCES infrastructure_log_action (uuid)
) INHERITS (user_update);
COMMENT ON TABLE infrastructure_management_log IS 'Store information on the process of task that needs to be done on an infrastructure item.';
COMMENT ON COLUMN infrastructure_management_log.id is 'The unique managment log ID. Primary Key.';
COMMENT ON COLUMN infrastructure_management_log.name is 'The management log name.';
COMMENT ON COLUMN infrastructure_management_log.notes is 'Any additional information about the management information log.';
COMMENT ON COLUMN infrastructure_management_log.condition is 'Circumstances or factors affecting the infrastructure type item.';
COMMENT ON COLUMN infrastructure_management_log.image is 'Path to the image of the infrastructure item.';


----------------------------------------ELECTRICITY-------------------------------------
-- ELECTRICITY LINE TYPE
CREATE TABLE electricity_line_type (
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT UNIQUE NOT NULL,
	notes TEXT,
	-- Add unique together constraint for voltage and current
	current_amps FLOAT UNIQUE NOT NULL,
	voltage_volts FLOAT UNIQUE NOT NULL,
	-- Unique together
	UNIQUE(current_amps, voltage_volts),
	-- Constraints are not inherited from the parent class, as such they are specified again in sub-classes.
	CONSTRAINT electricity_line_type_unique_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE electricity_line_type IS 'Look up table for electricity line type.';
COMMENT ON COLUMN electricity_line_type.id is 'The unique electricity line type ID. Primary key.';
COMMENT ON COLUMN electricity_line_type.name is 'The electricity line type name.';
COMMENT ON COLUMN electricity_line_type.notes is 'The electricity line type notes.';
COMMENT ON COLUMN electricity_line_type.current_amps is 'The electricity line current.';
COMMENT ON COLUMN electricity_line_type.voltage_volts is 'The electricity line voltage.';


-- ELECTRICITY LINE
CREATE TABLE electricity_line (
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT UNIQUE,
	notes TEXT NULL,
	geometry GEOMETRY(LINESTRING, 4326) NOT NULL,
	electricity_line_type_uuid UUID NOT NULL REFERENCES electricity_line_type(uuid),
	CONSTRAINT electricity_line_unique_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE electricity_line IS 'Stores information on electricity lines available.';
COMMENT ON COLUMN electricity_line.id is 'The unique electricity line ID. Primary key.';
COMMENT ON COLUMN electricity_line.notes is 'The electricity line notes.';
COMMENT ON COLUMN electricity_line.geometry is 'The electricity line geometry.';


-- ELECTRICITY LINE CONDITION TYPE
CREATE TABLE electricity_line_condition_type (
  	id SERIAL NOT NULL PRIMARY KEY,
  	name TEXT UNIQUE NOT NULL,
  	notes TEXT,
  	CONSTRAINT electricity_line_condition_type_unique_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE electricity_line_condition_type IS 'Look up table for electricity line condition.';
COMMENT ON COLUMN electricity_line_condition_type.id is 'The unique electricity line condition ID. Primary key.';
COMMENT ON COLUMN electricity_line_condition_type.notes is 'The additional information on electricity line condition.';

-- ASSOCOCIATION TABLES
-- ELECTRICITY LINE CONDITION
CREATE TABLE electricity_line_condition (
  	date DATE NOT NULL,
  	electricity_line_uuid UUID NOT NULL REFERENCES electricity_line(uuid),
  	electricity_line_condition_type_uuid UUID NOT NULL REFERENCES electricity_line_condition_type(uuid),
  	-- Composite primary key
  	PRIMARY KEY (electricity_line_uuid, electricity_line_condition_type_uuid),
  	CONSTRAINT electricity_line_conditions_unique_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE electricity_line_condition IS 'Associative table which stores the electricity line and condition.';
COMMENT ON COLUMN electricity_line_condition.date is 'The electricity line inspection date.';      


----------------------------------------WATER-------------------------------------
-- WATER SOURCE
CREATE TABLE water_source(
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT NOT NULL,
	notes TEXT,
	-- Constraints are not inherited from the parent class, as such they are specified again in sub-classes.
	CONSTRAINT water_source_key UNIQUE(uuid) 
) INHERITS(user_update);
COMMENT ON TABLE water_source IS 'Stores information regarding water bodies that provide drinking water.';
COMMENT ON COLUMN water_source.id is 'The unique water source ID. This is the Primary Key.';
COMMENT ON COLUMN water_source.name is 'The water source name, e.g. river, lake, ground water.';
COMMENT ON COLUMN water_source.notes is 'Any additional notes on the water source.';


-- WATER POLYGON TYPE
CREATE TABLE water_polygon_type(
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT NOT NULL,
	notes TEXT,
	CONSTRAINT unique_polygon_type_key UNIQUE(uuid)
) INHERITS (user_update);
COMMENT ON TABLE water_polygon_type IS 'Lookup table of the type of water polygon.';
COMMENT ON COLUMN water_polygon_type.id is 'The unique water polygon ID. Primary Key.';
COMMENT ON COLUMN water_polygon_type.name is 'The water polygon type name, e.g. delta, swamp, reservoir.';

-- WATER POLYGON
CREATE TABLE water_polygon(
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT NOT NULL,
	notes TEXT,
	estimated_depth_m FLOAT,
-- 	Estimated depth of water polygon constraint (0m < Estimated Depth < 20m).
	CONSTRAINT depth_check check(
		estimated_depth_m >= 0 and estimated_depth_m <= 20),
	image TEXT,
	geometry GEOMETRY(POLYGON, 4326),
	CONSTRAINT unique_water_polygon_key UNIQUE(uuid),
	water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
	water_polygon_type_uuid UUID NOT NULL REFERENCES water_polygon_type(uuid)
) INHERITS (user_update);
COMMENT ON TABLE water_polygon IS 'Stores information on land areas that are covered in water, either intermittently or constantly.';
COMMENT ON COLUMN water_polygon.id is 'The unique water polygon ID. Primary Key.';
COMMENT ON COLUMN water_polygon.name is 'The water polygon name, e.g. dam.';
COMMENT ON COLUMN water_polygon.notes is 'Any additional information about the water polygon.';
COMMENT ON COLUMN water_polygon.estimated_depth_m is 'The approximate depth of the water polygon in meters.';
COMMENT ON COLUMN water_polygon.image is 'Path to an image of a water polygon.';
COMMENT ON COLUMN water_polygon.geometry is 'The location of the water polygon. Follows EPSG: 4326.';


-- WATER POINT TYPE
CREATE TABLE water_point_type (
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT UNIQUE NOT NULL,
	notes TEXT,
	CONSTRAINT water_point_type_key UNIQUE(uuid)
) INHERITS (user_update);
COMMENT ON TABLE water_point_type is 'Lookup table on the types of water points.';
COMMENT ON COLUMN water_point_type.id is 'The unique water point type ID. Primary Key.';
COMMENT ON COLUMN water_point_type.name is 'The water point type name, e.g. tap, drinking trough.';
COMMENT ON COLUMN water_point_type.notes is 'Any additional information about the water point type.';


-- WATER POINT 
CREATE TABLE water_point(
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT UNIQUE NOT NULL,
	notes TEXT,
	image TEXT,
	geometry GEOMETRY (POINT, 4326),
	CONSTRAINT unique_water_point_key UNIQUE(uuid),
	water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
	water_point_type_uuid UUID NOT NULL REFERENCES water_point_type(uuid)
) INHERITS (user_update);
COMMENT ON TABLE water_point is 'Stores individual locations on places where water is available for use.';
COMMENT ON COLUMN water_point.id is 'The unique water point ID. Primary Key.';
COMMENT ON COLUMN water_point.name is 'The water point name e.g. sink, tap.';
COMMENT ON COLUMN water_point.notes is 'Any additional information about the water point.';
COMMENT ON COLUMN water_point.image is 'Path to an image of a water point.';
COMMENT ON COLUMN water_point.geometry is 'The coordinates of the water point. Follows EPSG: 4326.';


-- WATER LINE TYPE
CREATE TABLE water_line_type (
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT UNIQUE NOT NULL,
	notes TEXT,
	pipe_length_m FLOAT,
	pipe_diameter_m FLOAT,
	-- Pipe length & pipe diameter constraint (length, diameter > 0)
	CONSTRAINT pipe_length_and_diameter_check check(
		pipe_length_m >= 0 AND pipe_diameter_m >= 0),
	-- Unique together
	UNIQUE(pipe_length_m, pipe_diameter_m),
	CONSTRAINT unique_water_line_type_key UNIQUE(uuid)
) INHERITS (user_update);
COMMENT ON TABLE water_line_type IS 'Description of lines through which water flows.';
COMMENT ON COLUMN water_line_type.id is 'The unique water line type ID. Primary Key.';
COMMENT ON COLUMN water_line_type.name is 'The water line type name, e.g. river, irrigaton.';
COMMENT ON COLUMN water_line_type.notes is 'Additional notes on the water line type.';
COMMENT ON COLUMN water_line_type.pipe_length_m is 'The water line length in meters.';
COMMENT ON COLUMN water_line_type.pipe_diameter_m is 'The water line diameter in meters.';


-- WATER LINE
CREATE TABLE water_line(
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT UNIQUE NOT NULL,
	notes TEXT,
	estimated_depth_m FLOAT,
	--Estimated depth of water line (depth > 0)
	CONSTRAINT estimated_depth_m check(
		estimated_depth_m >= 0),
	image TEXT,
	geometry GEOMETRY(LINESTRING, 4326),
	CONSTRAINT unique_water_line_key UNIQUE(uuid),
	water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
	water_line_type_uuid UUID NOT NULL REFERENCES water_line_type(uuid)
) INHERITS (user_update);
COMMENT ON TABLE water_line is 'This is the path the water lines follow.';
COMMENT ON COLUMN water_line.id is 'The unique water line ID. Primary Key.';
COMMENT ON COLUMN water_line.name is 'The unique water line name.';
COMMENT ON COLUMN water_line.notes is 'Any additional information about the water line.';
COMMENT ON COLUMN water_line.estimated_depth_m is 'The approximate depth of the water line in meters.';
COMMENT ON COLUMN water_line.image is 'Path to an image of a water line, if it exists.';
COMMENT ON COLUMN water_line.geometry is 'The location of the water line. Follows EPSG: 4326';


----------------------------------------VEGETATION-------------------------------------

-- PLANT GROWTH ACTIVITY TYPE
CREATE TABLE plant_growth_activity_type (
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT NOT NULL,
	notes TEXT,
	image TEXT,
	-- Constraints are not inherited from the parent class, as such they are specified again in sub-classes.
	CONSTRAINT unique_plant_growth_activity_type_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE plant_growth_activity_type IS 
'Stores plant growth activity properties.';
COMMENT ON COLUMN plant_growth_activity_type.id IS 'The unique plant growth activity ID. This is the Primary Key.';
COMMENT ON COLUMN plant_growth_activity_type.name IS 'Name of plant activity, e.g. seeding, sprouting etc.';
COMMENT ON COLUMN plant_growth_activity_type.notes IS 'Any additional information about the plant growth activity.';
COMMENT ON COLUMN plant_growth_activity_type.image IS 'Path to image of the associated plant activity.';


-- PLANT TYPE
CREATE TABLE plant_type(
	id SERIAL NOT NULL PRIMARY KEY,
	common_name TEXT UNIQUE NOT NULL,
	scientific_name TEXT UNIQUE,
	notes TEXT,	
	plant_image TEXT,
	flower_image TEXT,
	fruit_image TEXT,
	variety TEXT,
	info_url TEXT,  
	CONSTRAINT unique_plant_type_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE plant_type IS 
'Look up table of different plant types e.g. Oaktree.';
COMMENT ON COLUMN plant_type.id IS 'The unique plant type ID. This is the Primary Key.';
COMMENT ON COLUMN plant_type.common_name IS 'Common name of the plant type e.g. Oaktree.';
COMMENT ON COLUMN plant_type.scientific_name IS 'Scientific name of the plant type e.g. Quercus.';
COMMENT ON COLUMN plant_type.notes IS 'Any additional information about the specific plant type.';
COMMENT ON COLUMN plant_type.plant_image IS 'Path to image of plant.';
COMMENT ON COLUMN plant_type.flower_image IS 'Path to image of flower.';
COMMENT ON COLUMN plant_type.fruit_image IS 'Path to image of fruit.';
COMMENT ON COLUMN plant_type.variety IS 'Other variety of this plant type.';
COMMENT ON COLUMN plant_type.info_url IS 'URL link to more information about this specific plant type.';


-- MONTH
CREATE TABLE month(
	id SERIAL NOT NULL PRIMARY KEY,
	month TEXT NOT NULL,
	CONSTRAINT unique_month_key UNIQUE (uuid)
)INHERITS (user_update);
COMMENT ON TABLE month IS 
'Look up table for different months of the year';
COMMENT ON COLUMN month.id IS 'The unique month ID. This is the Primary Key.';
COMMENT ON COLUMN month.month IS 'Name of the different months in the year e.g. January';


-- PLANT USAGE
CREATE TABLE plant_usage(
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT UNIQUE NOT NULL,
	notes TEXT,
	CONSTRAINT unique_plant_usage_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE plant_usage IS 
'Look up table for different usages of the plants e.g. food plant, commercial plant etc.';
COMMENT ON COLUMN plant_usage.id IS 'The unique plant usage ID. This is the Primary Key.';
COMMENT ON COLUMN plant_usage.name IS 'Name of the usage of plant e.g food plant, commercial plant etc.';
COMMENT ON COLUMN plant_usage.notes IS 'Any additional information for the indiviual plant usage.';


-- VEGETATION POINT
CREATE TABLE vegetation_point(
	id SERIAL NOT NULL PRIMARY KEY,
	notes TEXT,
	image TEXT,
	estimated_crown_radius_m FLOAT,
	--Must be positive number
	constraint radius_check check(
		estimated_crown_radius_m >= 0),
	--Takes 4 digits only
	estimated_planting_year decimal(4,0),
	--Must be before or equal this year
	constraint year_check check(
		estimated_planting_year >= 0),
	constraint year_check2 check(
		estimated_planting_year <= DATE_PART('Year', NOW())),
	estimated_height_m FLOAT,
	--Must be positive number
	constraint height_check check(
		estimated_height_m >= 0),
	geometry GEOMETRY(POINT, 4326) NOT NULL, 
	CONSTRAINT unique_vegetation_point_uuid UNIQUE (uuid),
	plant_type_uuid UUID NOT NULL REFERENCES plant_type(uuid)
) INHERITS (user_update);
COMMENT ON TABLE vegetation_point IS 
'Stores individual plant locations and the properties of that plant.';
COMMENT ON COLUMN vegetation_point.id IS 'The unique vegetation point ID. This is the Primary Key.';
COMMENT ON COLUMN vegetation_point.notes IS 'Any additional information on the individual plant.';
COMMENT ON COLUMN vegetation_point.image IS 'Path to image of the individual plant.';
COMMENT ON COLUMN vegetation_point.estimated_crown_radius_m IS 'Estimated radius of the plant''s crown in meters.';
COMMENT ON COLUMN vegetation_point.estimated_height_m IS 'Estimated height of plant in meters.';
COMMENT ON COLUMN vegetation_point.estimated_planting_year IS 'The year the plant was planted. The year must be in the range of 0 to current year.';
COMMENT ON COLUMN vegetation_point.geometry IS 'The coordinates of the vegetation point. Follows EPSG 4326.';


-- PRUNING ACTIVITY
CREATE TABLE pruning_activity(
	id SERIAL NOT NULL PRIMARY KEY,
	notes TEXT,
	date DATE NOT NULL,
	before_image TEXT,
	after_image TEXT,
	vegetation_point_uuid UUID NOT NULL REFERENCES vegetation_point(uuid)
)INHERITS (user_update);
COMMENT ON TABLE pruning_activity IS 
'Stores information on the trimming of unwanted parts of a plant.';
COMMENT ON COLUMN pruning_activity.id IS 'The unique pruning activity ID. This is the Primary Key.';
COMMENT ON COLUMN pruning_activity.notes IS 'Any additional information on the specific pruning activity.';
COMMENT ON COLUMN pruning_activity.date IS 'The date of the pruning activity (yyyy:mm:dd).';
COMMENT ON COLUMN pruning_activity.before_image IS 'Path to image before the pruning activity was done.';
COMMENT ON COLUMN pruning_activity.after_image IS 'Path to image after the pruning activity was done.';


-- HARVEST ACTIVITY
CREATE TABLE harvest_activity(
	id SERIAL NOT NULL PRIMARY KEY,
	notes TEXT,
	date DATE NOT NULL,
	quantity_kg FLOAT,
	vegetation_point_uuid UUID NOT NULL REFERENCES vegetation_point(uuid)
) INHERITS (user_update);
COMMENT ON TABLE harvest_activity IS 
'Stores information on the gathering of ripe crop or fruits.';
COMMENT ON COLUMN harvest_activity.id IS 'The unique harvest activity ID. This is the Primary Key.';
COMMENT ON COLUMN harvest_activity.notes IS 'Any additional information on the specific harvest activity.';
COMMENT ON COLUMN harvest_activity.date IS 'The date of the harvest activity (yyyy:mm:dd).';
COMMENT ON COLUMN harvest_activity.quantity_kg IS 'The quantity of harvest in kilograms.';


-- ASSOCIATION TABLES
-- PLANT GROWTH ACTIVITIES
CREATE TABLE plant_growth_activities(
	fk_plant_activity_uuid UUID  NOT NULL REFERENCES plant_growth_activity_type(uuid),
	fk_plant_type_uuid UUID NOT NULL REFERENCES plant_type(uuid),
	fk_month_uuid UUID  NOT NULL REFERENCES month(uuid),
-- 	Composite primary key using the three foreign keys above
	PRIMARY KEY (fk_plant_activity_uuid, fk_plant_type_uuid, fk_month_uuid)
);
COMMENT ON TABLE plant_growth_activities IS 
'Associative table to store the plant growth activities and plant types at different months in the year e.g. January_activity.';
COMMENT ON COLUMN plant_growth_activities.fk_plant_activity_uuid IS 'The foreign key linking to plant growth activity type table''s UUID.';
COMMENT ON COLUMN plant_growth_activities.fk_plant_type_uuid IS 'The foreign key linking to plant type table''s UUID.';
COMMENT ON COLUMN plant_growth_activities.fk_month_uuid IS 'The foreign key linking to month table''s UUID.';

-- PLANT TYPE USAGES
CREATE TABLE plant_type_usages(
	fk_plant_usage_uuid UUID NOT NULL REFERENCES plant_usage(uuid),
	fk_plant_type_uuid UUID NOT NULL REFERENCES plant_type(uuid),
	PRIMARY KEY (fk_plant_usage_uuid, fk_plant_type_uuid)
);
COMMENT ON TABLE plant_type_usages IS 
'Associative table to store the different plant usages and plant types ';
COMMENT ON COLUMN plant_type_usages.fk_plant_usage_uuid IS 'The foreign key linking to plant usage table''s UUID.';
COMMENT ON COLUMN plant_type_usages.fk_plant_type_uuid IS 'The foreign key linking to plant type table''s UUID.';
