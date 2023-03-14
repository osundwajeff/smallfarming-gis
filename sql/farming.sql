
create database farming;
		-- add connect statement here

create extension postgis;

---------------------------------------- BASE TABLES --------------------------------------
-- BASE TABLE, STORES uuid, last_update_by and last_update 
CREATE TABLE base(
    	uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL
);
COMMENT ON TABLE base IS 'Stores user information and when data was updated by user.';
COMMENT ON COLUMN base.uuid is 'The unique user ID.';
COMMENT ON COLUMN base.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN base.last_update_by is 'The name of the user responsible for the latest update.';


-- LOOKUP BASE
CREATE TABLE lookup_base(
		name TEXT UNIQUE NOT NULL, 
		notes TEXT NULL, 
		image TEXT
) INHERITS (base);
COMMENT ON TABLE lookup_base IS 'Stores information on name, notes and image.';
COMMENT ON COLUMN lookup_base.name is 'The name of the of the object stored in the table.';
COMMENT ON COLUMN lookup_base.notes is 'Additional information of the object stored.';
COMMENT ON COLUMN lookup_base.image is 'Image of the object stored.';


-- ORDERED LOOKUP BASE
CREATE TABLE ordered_lookup_base(
		sort_order INT UNIQUE
) INHERITS (lookup_base);
COMMENT ON TABLE ordered_lookup_base IS 'Store information on how objects in the table should be sorted.';
COMMENT ON COLUMN ordered_lookup_base.sort_order is 'Defines the pattern of how items are to be sorted.';


----------------------------------------INFRASTRUCTURE-------------------------------------
-- INFRASTRUCTURE TYPE
CREATE TABLE infrastructure_type (
    	id SERIAL NOT NULL PRIMARY KEY, 
	-- Constraints are not inherited from the parent class, as such they are specified again in sub-classes.
    	CONSTRAINT unique_infrastructure_type_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base); 
COMMENT ON TABLE infrastructure_type IS 'Lookup table for the infrastructure types available.';
COMMENT ON COLUMN infrastructure_type.id is 'The unique infrastructure type ID. This is the Primary Key.';


-- INFRASTRUCTURE ITEM
CREATE TABLE infrastructure_item(
    	id SERIAL NOT NULL PRIMARY KEY,
    	geometry GEOMETRY (POINT, 4326), 
    	CONSTRAINT unique_infrastructure_item_key UNIQUE (uuid),
    	infrastructure_type_uuid UUID NOT NULL REFERENCES infrastructure_type(uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE infrastructure_item IS 'Lookup table for the infrastructure item.';
COMMENT ON COLUMN infrastructure_item.id is 'The unique infrastructure item ID. Primary Key.';
COMMENT ON COLUMN infrastructure_item.geometry is 'The centroid location of the infrastructure item. Follows EPSG: 4326.';


-- INFRASTRUCTURE LOG ACTION
CREATE TABLE infrastructure_log_action(
    	id SERIAL NOT NULL PRIMARY KEY,
    	CONSTRAINT unique_infrastructure_log_action_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE infrastructure_log_action IS 'Stores information on actions taken to maintain infrastructure items.';
COMMENT ON COLUMN infrastructure_log_action.id is 'The unique log action ID. Primary Key.';


-- INFRASTRUCTURE MANAGEMENT LOG 
CREATE TABLE infrastructure_management_log(
    	id SERIAL NOT NULL PRIMARY KEY, 
    	condition TEXT NOT NULL, 
    	CONSTRAINT unique_infrastructure_management_log_key UNIQUE (uuid),
    	infrastructure_item_uuid UUID NOT NULL REFERENCES infrastructure_item(uuid),
    	infrastructure_log_action_uuid UUID NOT NULL REFERENCES infrastructure_log_action (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE infrastructure_management_log IS 'Store information on the process of task that needs to be done on an infrastructure item.';
COMMENT ON COLUMN infrastructure_management_log.id is 'The unique management log ID. Primary Key.';
COMMENT ON COLUMN infrastructure_management_log.condition is 'Circumstances or factors affecting the infrastructure item type.';


----------------------------------------ELECTRICITY-------------------------------------
-- ELECTRICITY LINE TYPE
CREATE TABLE electricity_line_type (
		id SERIAL NOT NULL PRIMARY KEY,
		-- Add unique together constraint for voltage and current
		current_a FLOAT NOT NULL,
		voltage_v FLOAT NOT NULL,
		-- Unique together constraint for voltage and current
		UNIQUE(current_a, voltage_v),
		-- Constraints are not inherited from the parent class, as such they are specified again in sub-classes.
		CONSTRAINT unique_electricity_line_type_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE electricity_line_type IS 'Look up table for electricity line type.';
COMMENT ON COLUMN electricity_line_type.id is 'The unique electricity line type ID. Primary key.';
COMMENT ON COLUMN electricity_line_type.current_a is 'The electricity line current.';
COMMENT ON COLUMN electricity_line_type.voltage_v is 'The electricity line voltage.';


-- ELECTRICITY LINE
CREATE TABLE electricity_line (
		id SERIAL NOT NULL PRIMARY KEY,
		geometry GEOMETRY(LINESTRING, 4326) NOT NULL,
		electricity_line_type_uuid UUID NOT NULL REFERENCES electricity_line_type(uuid),
		CONSTRAINT unique_electricity_line_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE electricity_line IS 'Stores information on electricity lines available.';
COMMENT ON COLUMN electricity_line.id is 'The unique electricity line ID. Primary key.';
COMMENT ON COLUMN electricity_line.geometry is 'The location of the electricity line. Follows EPSG: 4326.';


-- ELECTRICITY LINE CONDITION
CREATE TABLE electricity_line_condition (
		id SERIAL NOT NULL PRIMARY KEY,
		CONSTRAINT unique_electricity_line_condition_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE electricity_line_condition IS 'Look up table for electricity line condition.';
COMMENT ON COLUMN electricity_line_condition.id is 'The unique electricity line condition ID. Primary key.';


-- ASSOCIATION TABLES
-- ELECTRICITY LINE CONDITION
CREATE TABLE electricity_line_conditions (
		date DATE NOT NULL,
		electricity_line_uuid UUID NOT NULL REFERENCES electricity_line(uuid),
		electricity_line_condition_uuid UUID NOT NULL REFERENCES electricity_line_condition(uuid),
		-- Composite primary key
		PRIMARY KEY (electricity_line_uuid, electricity_line_condition_uuid, date),
		UNIQUE(electricity_line_uuid, electricity_line_condition_uuid),
		CONSTRAINT electricity_line_conditions_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE electricity_line_conditions IS 'Associative table which stores the electricity line and condition.';
COMMENT ON COLUMN electricity_line_conditions.date is 'The electricity line inspection date.';      


----------------------------------------WATER-------------------------------------
-- WATER SOURCE
CREATE TABLE water_source(
		id SERIAL NOT NULL PRIMARY KEY,
		-- Constraints are not inherited from the parent class, as such they are specified again in sub-classes.
		CONSTRAINT unique_water_source_key UNIQUE(uuid) 
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE water_source IS 'Stores information regarding water bodies that provide drinking water.';
COMMENT ON COLUMN water_source.id is 'The unique water source ID. This is the Primary Key.';



-- WATER POLYGON TYPE
CREATE TABLE water_polygon_type(
		id SERIAL NOT NULL PRIMARY KEY,
		CONSTRAINT unique_water_polygon_type_key UNIQUE(uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE water_polygon_type IS 'Lookup table of the type of water polygon.';
COMMENT ON COLUMN water_polygon_type.id is 'The unique water polygon ID. Primary Key.';


-- WATER POLYGON
CREATE TABLE water_polygon(
		id SERIAL NOT NULL PRIMARY KEY,
		estimated_depth_m FLOAT,
		-- 	Estimated depth of water polygon constraint (0m < Estimated Depth < 20m).
		CONSTRAINT depth_check check(
			estimated_depth_m >= 0 and estimated_depth_m <= 20),
		geometry GEOMETRY(POLYGON, 4326),
		CONSTRAINT unique_water_polygon_key UNIQUE(uuid),
		water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
		water_polygon_type_uuid UUID NOT NULL REFERENCES water_polygon_type(uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE water_polygon IS 'Stores information on land areas that are covered in water, either intermittently or constantly.';
COMMENT ON COLUMN water_polygon.id is 'The unique water polygon ID. Primary Key.';
COMMENT ON COLUMN water_polygon.estimated_depth_m is 'The approximate depth of the water polygon in meters.';
COMMENT ON COLUMN water_polygon.geometry is 'The location of the water polygon. Follows EPSG: 4326.';


-- WATER POINT TYPE
CREATE TABLE water_point_type (
		id SERIAL NOT NULL PRIMARY KEY,
		CONSTRAINT unique_water_point_type_key UNIQUE(uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE water_point_type is 'Lookup table on the types of water points.';
COMMENT ON COLUMN water_point_type.id is 'The unique water point type ID. Primary Key.';


-- WATER POINT 
CREATE TABLE water_point(
		id SERIAL NOT NULL PRIMARY KEY,
		geometry GEOMETRY (POINT, 4326),
		CONSTRAINT unique_water_point_key UNIQUE(uuid),
		water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
		water_point_type_uuid UUID NOT NULL REFERENCES water_point_type(uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE water_point is 'Stores individual locations on places where water is available for use.';
COMMENT ON COLUMN water_point.id is 'The unique water point ID. Primary Key.';
COMMENT ON COLUMN water_point.geometry is 'The coordinates of the water point. Follows EPSG: 4326.';


-- WATER LINE TYPE
CREATE TABLE water_line_type (
		id SERIAL NOT NULL PRIMARY KEY,
		pipe_length_m FLOAT,
		pipe_diameter_m FLOAT,
		-- Pipe length & pipe diameter constraint (length, diameter > 0)
		CONSTRAINT pipe_length_and_diameter_check check(
			pipe_length_m >= 0 AND pipe_diameter_m >= 0),
		-- Unique together
		UNIQUE(pipe_length_m, pipe_diameter_m),
		CONSTRAINT unique_water_line_type_key UNIQUE(uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE water_line_type IS 'Description of lines through which water flows.';
COMMENT ON COLUMN water_line_type.id is 'The unique water line type ID. Primary Key.';
COMMENT ON COLUMN water_line_type.pipe_length_m is 'The water line length in meters.';
COMMENT ON COLUMN water_line_type.pipe_diameter_m is 'The water line diameter in meters.';


-- WATER LINE
CREATE TABLE water_line(
		id SERIAL NOT NULL PRIMARY KEY,
		estimated_depth_m FLOAT,
		--Estimated depth of water line (depth > 0)
		CONSTRAINT estimated_depth_m check(
			estimated_depth_m >= 0),
		geometry GEOMETRY(LINESTRING, 4326),
		CONSTRAINT unique_water_line_key UNIQUE(uuid),
		water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
		water_line_type_uuid UUID NOT NULL REFERENCES water_line_type(uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE water_line is 'This is the path the water lines follow.';
COMMENT ON COLUMN water_line.id is 'The unique water line ID. Primary Key.';
COMMENT ON COLUMN water_line.estimated_depth_m is 'The approximate depth of the water line in meters.';
COMMENT ON COLUMN water_line.geometry is 'The location of the water line. Follows EPSG: 4326';


----------------------------------------VEGETATION-------------------------------------

-- PLANT GROWTH ACTIVITY TYPE
CREATE TABLE plant_growth_activity_type (
		id SERIAL NOT NULL PRIMARY KEY,
		-- Constraints are not inherited from the parent class, as such they are specified again in sub-classes.
		CONSTRAINT unique_plant_growth_activity_type_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE plant_growth_activity_type IS 
'Stores plant growth activity properties.';
COMMENT ON COLUMN plant_growth_activity_type.id IS 'The unique plant growth activity ID. This is the Primary Key.';

-- PLANT TYPE
CREATE TABLE plant_type(
		id SERIAL NOT NULL PRIMARY KEY,
		common_name TEXT UNIQUE NOT NULL,
		scientific_name TEXT UNIQUE,
		plant_image TEXT,
		flower_image TEXT,
		fruit_image TEXT,
		variety TEXT,
		info_url TEXT,  
		CONSTRAINT unique_plant_type_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE plant_type IS 
'Look up table of different plant types e.g. Oaktree.';
COMMENT ON COLUMN plant_type.id IS 'The unique plant type ID. This is the Primary Key.';
COMMENT ON COLUMN plant_type.common_name IS 'Common name of the plant type e.g. Oaktree.';
COMMENT ON COLUMN plant_type.scientific_name IS 'Scientific name of the plant type e.g. Quercus.';
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
)INHERITS (ordered_lookup_base);
COMMENT ON TABLE month IS 
'Look up table for different months of the year';
COMMENT ON COLUMN month.id IS 'The unique month ID. This is the Primary Key.';
COMMENT ON COLUMN month.month IS 'Name of the different months in the year e.g. January';


-- PLANT USAGE
CREATE TABLE plant_usage(
		id SERIAL NOT NULL PRIMARY KEY,
		CONSTRAINT unique_plant_usage_key UNIQUE (uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE plant_usage IS 
'Look up table for different usages of the plants e.g. food plant, commercial plant etc.';
COMMENT ON COLUMN plant_usage.id IS 'The unique plant usage ID. This is the Primary Key.';


-- VEGETATION POINT
CREATE TABLE vegetation_point(
		id SERIAL NOT NULL PRIMARY KEY,
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
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE vegetation_point IS 
'Stores individual plant locations and the properties of that plant.';
COMMENT ON COLUMN vegetation_point.id IS 'The unique vegetation point ID. This is the Primary Key.';
COMMENT ON COLUMN vegetation_point.estimated_crown_radius_m IS 'Estimated radius of the plant''s crown in meters.';
COMMENT ON COLUMN vegetation_point.estimated_height_m IS 'Estimated height of plant in meters.';
COMMENT ON COLUMN vegetation_point.estimated_planting_year IS 'The year the plant was planted. The year must be in the range of 0 to current year.';
COMMENT ON COLUMN vegetation_point.geometry IS 'The coordinates of the vegetation point. Follows EPSG 4326.';


-- PRUNING ACTIVITY
CREATE TABLE pruning_activity(
		id SERIAL NOT NULL PRIMARY KEY,
		date DATE NOT NULL,
		before_image TEXT,
		after_image TEXT,
		vegetation_point_uuid UUID NOT NULL REFERENCES vegetation_point(uuid)
)INHERITS (ordered_lookup_base);
COMMENT ON TABLE pruning_activity IS 
'Stores information on the trimming of unwanted parts of a plant.';
COMMENT ON COLUMN pruning_activity.id IS 'The unique pruning activity ID. This is the Primary Key.';
COMMENT ON COLUMN pruning_activity.date IS 'The date of the pruning activity (yyyy:mm:dd).';
COMMENT ON COLUMN pruning_activity.before_image IS 'Path to image before the pruning activity was done.';
COMMENT ON COLUMN pruning_activity.after_image IS 'Path to image after the pruning activity was done.';


-- HARVEST ACTIVITY
CREATE TABLE harvest_activity(
		id SERIAL NOT NULL PRIMARY KEY,
		date DATE NOT NULL,
		quantity_kg FLOAT,
		vegetation_point_uuid UUID NOT NULL REFERENCES vegetation_point(uuid)
) INHERITS (ordered_lookup_base);
COMMENT ON TABLE harvest_activity IS 
'Stores information on the gathering of ripe crop or fruits.';
COMMENT ON COLUMN harvest_activity.id IS 'The unique harvest activity ID. This is the Primary Key.';
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
