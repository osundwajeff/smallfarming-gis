create database farming;
		-- add connect statement here

		

create extension postgis;

----------------------------------------INFRASTRUCTURE-------------------------------------
-- INFRASTRUCTURE TYPE
CREATE TABLE infrastructure_type (
    	id SERIAL NOT NULL PRIMARY KEY, 
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE
); 
COMMENT ON TABLE infrastructure_type IS 'Lookup table for the types of infrastructure available, e.g. Furniture .';
COMMENT ON COLUMN infrastructure_type.id is 'The unique infrastructure type ID. This is the Primary Key.';
COMMENT ON COLUMN infrastructure_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN infrastructure_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN infrastructure_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN infrastructure_type.name is 'The infrastructure type name.';
COMMENT ON COLUMN infrastructure_type.notes is 'Additional information of the infrastructure type.';
COMMENT ON COLUMN infrastructure_type.image is 'Image of the infrastructure type.';
COMMENT ON COLUMN infrastructure_type.sort_order is 'Defines the pattern of how infrastructure type are to be sorted.';


-- INFRASTRUCTURE ITEM
CREATE TABLE infrastructure_item(
    	id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
    	geometry GEOMETRY (POINT, 4326), 
    	infrastructure_type_uuid UUID NOT NULL REFERENCES infrastructure_type(uuid)
);
COMMENT ON TABLE infrastructure_item IS 'Infrastructure item refers to any physical components found in the area, e.g. desk, chair.';
COMMENT ON COLUMN infrastructure_item.id is 'The unique infrastructure item ID. Primary Key.';
COMMENT ON COLUMN infrastructure_item.uuid is 'The unique user ID.';
COMMENT ON COLUMN infrastructure_item.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN infrastructure_item.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN infrastructure_item.name is 'The name of the infrastructure item.';
COMMENT ON COLUMN infrastructure_item.notes is 'Additional information of the infrastructure item.';
COMMENT ON COLUMN infrastructure_item.image is 'Image of the infrastructure item.';
COMMENT ON COLUMN infrastructure_item.sort_order is 'Defines the pattern of how infrastructure items are to be sorted.';
COMMENT ON COLUMN infrastructure_item.geometry is 'The centroid location of the infrastructure item. Follows EPSG: 4326.';


-- INFRASTRUCTURE LOG ACTION
CREATE TABLE infrastructure_log_action(
    	id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
);
COMMENT ON TABLE infrastructure_log_action IS 'Infrastructure log action refers to the actions taken to maintain infrastructure items, e.g. Screwing, Painting, Welding.';
COMMENT ON COLUMN infrastructure_log_action.id is 'The unique log action ID. Primary Key.';
COMMENT ON COLUMN infrastructure_log_action.uuid is 'The unique user ID.';
COMMENT ON COLUMN infrastructure_log_action.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN infrastructure_log_action.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN infrastructure_log_action.name is 'The name of the action taken.';
COMMENT ON COLUMN infrastructure_log_action.notes is 'Additional information of the action taken.';
COMMENT ON COLUMN infrastructure_log_action.image is 'Image of the action taken.';
COMMENT ON COLUMN infrastructure_log_action.sort_order is 'Defines the pattern of how actions are to be sorted.';


-- INFRASTRUCTURE MANAGEMENT LOG 
CREATE TABLE infrastructure_management_log(
    	id SERIAL NOT NULL PRIMARY KEY, 
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
    	condition TEXT NOT NULL, 
    	infrastructure_item_uuid UUID NOT NULL REFERENCES infrastructure_item(uuid),
    	infrastructure_log_action_uuid UUID NOT NULL REFERENCES infrastructure_log_action (uuid)
);
COMMENT ON TABLE infrastructure_management_log IS 'Infrastructure management log refers to the process of task that needs to be done on an infrastructure item, e.g. Repair.';
COMMENT ON COLUMN infrastructure_management_log.id is 'The unique management log ID. Primary Key.';
COMMENT ON COLUMN infrastructure_management_log.uuid is 'The unique user ID.';
COMMENT ON COLUMN infrastructure_management_log.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN infrastructure_management_log.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN infrastructure_management_log.name is 'The name of the process.';
COMMENT ON COLUMN infrastructure_management_log.notes is 'Additional information of the process.';
COMMENT ON COLUMN infrastructure_management_log.image is 'Image of the work flow.';
COMMENT ON COLUMN infrastructure_management_log.sort_order is 'Defines the pattern of processes are to be sorted.';
COMMENT ON COLUMN infrastructure_management_log.condition is 'Circumstances or factors affecting the infrastructure item type.';


----------------------------------------ELECTRICITY-------------------------------------
-- ELECTRICITY LINE TYPE
CREATE TABLE electricity_line_type (
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		-- Add unique together constraint for voltage and current
		current_a FLOAT NOT NULL,
		voltage_v FLOAT NOT NULL,
		-- Unique together constraint for voltage and current
		UNIQUE(current_a, voltage_v)
);
COMMENT ON TABLE electricity_line_type IS 'Look up table for the types of electricity lines, e.g. Low-voltage line, High-voltage line etc.';
COMMENT ON COLUMN electricity_line_type.id is 'The unique electricity line type ID. Primary key.';
COMMENT ON COLUMN electricity_line_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN electricity_line_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN electricity_line_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN electricity_line_type.name is 'The name of the electricity line type.';
COMMENT ON COLUMN electricity_line_type.notes is 'Additional information of the electricity line type.';
COMMENT ON COLUMN electricity_line_type.image is 'Image of the electricity line type';
COMMENT ON COLUMN electricity_line_type.sort_order is 'Defines the pattern of how electricity line types are to be sorted.';
COMMENT ON COLUMN electricity_line_type.current_a is 'The electricity line current.';
COMMENT ON COLUMN electricity_line_type.voltage_v is 'The electricity line voltage.';


-- ELECTRICITY LINE
CREATE TABLE electricity_line (
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		geometry GEOMETRY(LINESTRING, 4326) NOT NULL,
		electricity_line_type_uuid UUID NOT NULL REFERENCES electricity_line_type(uuid)
);
COMMENT ON TABLE electricity_line IS 'Electricity line refers to the geolocated wire or conductor used for transmitting or supplying electricity.';
COMMENT ON COLUMN electricity_line.id is 'The unique electricity line ID. Primary key.';
COMMENT ON COLUMN electricity_line.uuid is 'The unique user ID.';
COMMENT ON COLUMN electricity_line.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN electricity_line.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN electricity_line.name is 'The name of the electricity line.';
COMMENT ON COLUMN electricity_line.notes is 'Additional information of the electricity line.';
COMMENT ON COLUMN electricity_line.image is 'Image of the electricity line';
COMMENT ON COLUMN electricity_line.sort_order is 'Defines the pattern of how electricity lines are to be sorted.';
COMMENT ON COLUMN electricity_line.geometry is 'The location of the electricity line. Follows EPSG: 4326.';


-- ELECTRICITY LINE CONDITION
CREATE TABLE electricity_line_condition_type (
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE electricity_line_condition_type IS 'Look up table for the types of electricity line conditions, e.g. Working, Broken etc.';
COMMENT ON COLUMN electricity_line_condition_type.id is 'The unique electricity line condition ID. Primary key.';
COMMENT ON COLUMN electricity_line_condition_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN electricity_line_condition_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN electricity_line_condition-type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN electricity_line_condition_type.name is 'The name of the electricity line condition.';
COMMENT ON COLUMN electricity_line_condition_type.notes is 'Additional information of the electricity line condition.';
COMMENT ON COLUMN electricity_line_condition_type.image is 'Image of the electricity line condition.';
COMMENT ON COLUMN electricity_line_condition_type.sort_order is 'Defines the pattern of how  electricity line conditions are to be sorted.';


-- ASSOCIATION TABLES
-- ELECTRICITY LINE CONDITION
CREATE TABLE electricity_line_conditions (
	    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		date DATE NOT NULL,
		electricity_line_uuid UUID NOT NULL REFERENCES electricity_line(uuid),
		electricity_line_condition_uuid UUID NOT NULL REFERENCES electricity_line_condition(uuid),
		-- Composite primary key
		PRIMARY KEY (electricity_line_uuid, electricity_line_condition_uuid, date),
		-- Unique together
		UNIQUE(electricity_line_uuid, electricity_line_condition_uuid, date)
);
COMMENT ON TABLE electricity_line_conditions IS 'Associative table which stores the electricity line and condition.';
COMMENT ON COLUMN electricity_line_conditions.uuid is 'The unique user ID.';
COMMENT ON COLUMN electricity_line_conditions.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN electricity_line_conditions.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN electricity_line_conditions.name is 'The name of the of the electricity line and condition.';
COMMENT ON COLUMN electricity_line_conditions.notes is 'Additional information of the electricity line and condition.';
COMMENT ON COLUMN electricity_line_conditions.image is 'Image of the electricity line and condition.';
COMMENT ON COLUMN electricity_line_conditions.sort_order is 'Defines the pattern of how  electricity lines and conditions are to be sorted.';
COMMENT ON COLUMN electricity_line_conditions.date is 'The electricity line inspection date.';      


----------------------------------------WATER-------------------------------------
-- WATER SOURCE
CREATE TABLE water_source(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE water_source IS 'Water source refers to the geolocated water bodies that provide drinking water, e.g. --insert example--.';
COMMENT ON COLUMN water_source.id is 'The unique water source ID. This is the Primary Key.';
COMMENT ON COLUMN water_source.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_source.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_source.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_source.name is 'The name of the water source.';
COMMENT ON COLUMN water_source.notes is 'Additional information of the water body.';
COMMENT ON COLUMN water_source.image is 'Image of the water body.';
COMMENT ON COLUMN water_source.sort_order is 'Defines the pattern of how water sources are to be sorted.';



-- WATER POLYGON TYPE
CREATE TABLE water_polygon_type(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE water_polygon_type IS 'Lookup table of the type of water polygon.';
COMMENT ON COLUMN water_polygon_type.id is 'The unique water polygon ID. Primary Key.';
COMMENT ON COLUMN water_polygon_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_polygon_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_polygon_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_polygon_type.name is 'The name of the water polygon type.';
COMMENT ON COLUMN water_polygon_type.notes is 'Additional information of the water polygon type.';
COMMENT ON COLUMN water_polygon_type.image is 'Image of the water polygon type.';
COMMENT ON COLUMN water_polygon_type.sort_order is 'Defines the pattern of how water polygon types are to be sorted.';


-- WATER POLYGON
CREATE TABLE water_polygon(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		estimated_depth_m FLOAT,
		-- 	Estimated depth of water polygon constraint (0m < Estimated Depth < 20m).
		CONSTRAINT depth_check check(
			estimated_depth_m >= 0 and estimated_depth_m <= 20),
		geometry GEOMETRY(POLYGON, 4326),
		water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
		water_polygon_type_uuid UUID NOT NULL REFERENCES water_polygon_type(uuid)
);
COMMENT ON TABLE water_polygon IS 'Water polygon refers to the geolocated land areas that are covered in water, either intermittently or constantly, e.g. --insert example--.';
COMMENT ON COLUMN water_polygon.id is 'The unique water polygon ID. Primary Key.';
COMMENT ON COLUMN water_polygon.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_polygon.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_polygon.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_polygon.name is 'The name of the water polygon.';
COMMENT ON COLUMN water_polygon.notes is 'Additional information of the water polygon.';
COMMENT ON COLUMN water_polygon.image is 'Image of the water polygon.';
COMMENT ON COLUMN water_polygon.sort_order is 'Defines the pattern of how  water polygons are to be sorted.';
COMMENT ON COLUMN water_polygon.estimated_depth_m is 'The approximate depth of the water polygon in meters.';
COMMENT ON COLUMN water_polygon.geometry is 'The location of the water polygon. Follows EPSG: 4326.';


-- WATER POINT TYPE
CREATE TABLE water_point_type (
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
);
COMMENT ON TABLE water_point_type is 'Lookup table on the types of water points, e.g. --insert example--.';
COMMENT ON COLUMN water_point_type.id is 'The unique water point type ID. Primary Key.';
COMMENT ON COLUMN water_point_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_point_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_point_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_point_type.name is 'The name of the water point type.';
COMMENT ON COLUMN water_point_type.notes is 'Additional information of the water point type.';
COMMENT ON COLUMN water_point_type.image is 'Image of the water point type.';
COMMENT ON COLUMN water_point_type.sort_order is 'Defines the pattern of how water point types are to be sorted.';


-- WATER POINT 
CREATE TABLE water_point(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		geometry GEOMETRY (POINT, 4326),
		water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
		water_point_type_uuid UUID NOT NULL REFERENCES water_point_type(uuid)
);
COMMENT ON TABLE water_point is 'Water point refers to the geolocated water site that is available for use.';
COMMENT ON COLUMN water_point.id is 'The unique water point ID. Primary Key.';
COMMENT ON COLUMN water_point.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_point.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_point.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_point.name is 'The name of the water point.';
COMMENT ON COLUMN water_point.notes is 'Additional information of the water point.';
COMMENT ON COLUMN water_point.image is 'Image of the water point.';
COMMENT ON COLUMN water_point.sort_order is 'Defines the pattern of how water points are to be sorted.';
COMMENT ON COLUMN water_point.geometry is 'The coordinates of the water point. Follows EPSG: 4326.';


-- WATER LINE TYPE
CREATE TABLE water_line_type (
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		pipe_length_m FLOAT,
		pipe_diameter_m FLOAT,
		-- Pipe length & pipe diameter constraint (length, diameter > 0)
		CONSTRAINT pipe_length_and_diameter_check check(
			pipe_length_m >= 0 AND pipe_diameter_m >= 0),
		-- Unique together
		UNIQUE(pipe_length_m, pipe_diameter_m)
);
COMMENT ON TABLE water_line_type IS 'Description of lines through which water flows.';
COMMENT ON COLUMN water_line_type.id is 'The unique water line type ID. Primary Key.';
COMMENT ON COLUMN water_line_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_line_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_line_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_line_type.name is 'The name of the water line type.';
COMMENT ON COLUMN water_line_type.notes is 'Additional information of the water line type.';
COMMENT ON COLUMN water_line_type.image is 'Image of the water line type.';
COMMENT ON COLUMN water_line_type.sort_order is 'Defines the pattern of how water line types are to be sorted.';
COMMENT ON COLUMN water_line_type.pipe_length_m is 'The water line length in meters.';
COMMENT ON COLUMN water_line_type.pipe_diameter_m is 'The water line diameter in meters.';


-- WATER LINE
CREATE TABLE water_line(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		estimated_depth_m FLOAT,
		--Estimated depth of water line (depth > 0)
		CONSTRAINT estimated_depth_m check(
			estimated_depth_m >= 0),
		geometry GEOMETRY(LINESTRING, 4326),
		water_source_uuid UUID NOT NULL REFERENCES water_source(uuid),
		water_line_type_uuid UUID NOT NULL REFERENCES water_line_type(uuid)
);
COMMENT ON TABLE water_line is 'This is the geolocated path the water lines follow.';
COMMENT ON COLUMN water_line.id is 'The unique water line ID. Primary Key.';
COMMENT ON COLUMN water_line.uuid is 'The unique user ID.';
COMMENT ON COLUMN water_line.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN water_line.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN water_line.name is 'The name of the water line.';
COMMENT ON COLUMN water_line.notes is 'Additional information of the water line path.';
COMMENT ON COLUMN water_line.image is 'Image of the water line path.';
COMMENT ON COLUMN water_line.sort_order is 'Defines the pattern of how water lines are to be sorted.';
COMMENT ON COLUMN water_line.estimated_depth_m is 'The approximate depth of the water line in meters.';
COMMENT ON COLUMN water_line.geometry is 'The location of the water line. Follows EPSG: 4326';


----------------------------------------VEGETATION-------------------------------------

-- PLANT GROWTH ACTIVITY TYPE
CREATE TABLE plant_growth_activity_type (
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE plant_growth_activity_type IS 'Plant growth activity type refers to the different growth stages of plants, e.g. Sprouting, Seeding etc.';
COMMENT ON COLUMN plant_growth_activity_type.id IS 'The unique plant growth activity ID. This is the Primary Key.';
COMMENT ON COLUMN plant_growth_activity_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN plant_growth_activity_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN plant_growth_activity_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN plant_growth_activity_type.name is 'The name of the plant growth activity type.';
COMMENT ON COLUMN plant_growth_activity_type.notes is 'Additional information of the plant growth activity type.';
COMMENT ON COLUMN plant_growth_activity_type.image is 'Image of the plant growth activity type.';
COMMENT ON COLUMN plant_growth_activity_type.sort_order is 'Defines the pattern of how plant growth activity types are to be sorted.';

-- PLANT TYPE
CREATE TABLE plant_type(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		common_name TEXT UNIQUE NOT NULL,
		scientific_name TEXT UNIQUE,
		plant_image TEXT,
		flower_image TEXT,
		fruit_image TEXT,
		variety TEXT,
		info_url TEXT
);
COMMENT ON TABLE plant_type IS 'Look up table of different types of plants, e.g. Oaktree.';
COMMENT ON COLUMN plant_type.id IS 'The unique plant type ID. This is the Primary Key.';
COMMENT ON COLUMN plant_type.uuid is 'The unique user ID.';
COMMENT ON COLUMN plant_type.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN plant_type.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN plant_type.name is 'The name of the plant type.';
COMMENT ON COLUMN plant_type.notes is 'Additional information of the plant type.';
COMMENT ON COLUMN plant_type.image is 'Image of the plant type.';
COMMENT ON COLUMN plant_type.sort_order is 'Defines the pattern of how plant types are to be sorted.';
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
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE month IS 'Look up table for different months of the year, e.g. January, February etc';
COMMENT ON COLUMN month.id IS 'The unique month ID. This is the Primary Key.';
COMMENT ON COLUMN month.uuid is 'The unique user ID.';
COMMENT ON COLUMN month.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN month.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN month.name is 'Name of the different months in the year e.g. January';
COMMENT ON COLUMN month.notes is 'Additional information of the month.';
COMMENT ON COLUMN month.image is 'Image of the object stored.';
COMMENT ON COLUMN month.sort_order is 'Defines the pattern of how months are to be sorted.';


-- PLANT USAGE
CREATE TABLE plant_usage(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE
);
COMMENT ON TABLE plant_usage IS 'Look up table for different usages of the plants e.g. Food plant, Commercial plant etc.';
COMMENT ON COLUMN plant_usage.id IS 'The unique plant usage ID. This is the Primary Key.';
COMMENT ON COLUMN plant_usage.uuid is 'The unique user ID.';
COMMENT ON COLUMN plant_usage.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN plant_usage.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN plant_usage.name is 'The name of the plant usage.';
COMMENT ON COLUMN plant_usage.notes is 'Additional information of the plant usage.';
COMMENT ON COLUMN plant_usage.image is 'Image of the plant stored.';
COMMENT ON COLUMN plant_usage.sort_order is 'Defines the pattern of how plant usages are to be sorted.';


-- VEGETATION POINT
CREATE TABLE vegetation_point(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
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
		plant_type_uuid UUID NOT NULL REFERENCES plant_type(uuid)
);
COMMENT ON TABLE vegetation_point IS 
'Vegetation point refers a geolocated plant. Table stores the individual plant location and the properties.';
COMMENT ON COLUMN vegetation_point.id IS 'The unique vegetation point ID. This is the Primary Key.';
COMMENT ON COLUMN vegetation_point.uuid is 'The unique user ID.';
COMMENT ON COLUMN vegetation_point.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN vegetation_point.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN vegetation_point.name is 'The name of the vegetation point.';
COMMENT ON COLUMN vegetation_point.notes is 'Additional information of the vegetation point.';
COMMENT ON COLUMN vegetation_point.image is 'Image of the vegetation point.';
COMMENT ON COLUMN vegetation_point.sort_order is 'Defines the pattern of how vegetation points are to be sorted.';
COMMENT ON COLUMN vegetation_point.estimated_crown_radius_m IS 'Estimated radius of the plant''s crown in meters.';
COMMENT ON COLUMN vegetation_point.estimated_height_m IS 'Estimated height of plant in meters.';
COMMENT ON COLUMN vegetation_point.estimated_planting_year IS 'The year the plant was planted. The year must be in the range of 0 to current year.';
COMMENT ON COLUMN vegetation_point.geometry IS 'The coordinates of the vegetation point. Follows EPSG 4326.';


-- PRUNING ACTIVITY
CREATE TABLE pruning_activity(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		date DATE NOT NULL,
		before_image TEXT,
		after_image TEXT,
		vegetation_point_uuid UUID NOT NULL REFERENCES vegetation_point(uuid)
);
COMMENT ON TABLE pruning_activity IS 'Pruning activity refers to the trimming of unwanted parts of a plant.';
COMMENT ON COLUMN pruning_activity.id IS 'The unique pruning activity ID. This is the Primary Key.';
COMMENT ON COLUMN pruning_activity.uuid is 'The unique user ID.';
COMMENT ON COLUMN pruning_activity.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN pruning_activity.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN pruning_activity.name is 'The name of the pruning activity.';
COMMENT ON COLUMN pruning_activity.notes is 'Additional information of the  pruning activity.';
COMMENT ON COLUMN pruning_activity.image is 'Image of the  pruning activity.';
COMMENT ON COLUMN pruning_activity.sort_order is 'Defines the pattern of how  pruning activities are to be sorted.';
COMMENT ON COLUMN pruning_activity.date IS 'The date of the pruning activity (yyyy:mm:dd).';
COMMENT ON COLUMN pruning_activity.before_image IS 'Path to image before the pruning activity was done.';
COMMENT ON COLUMN pruning_activity.after_image IS 'Path to image after the pruning activity was done.';


-- HARVEST ACTIVITY
CREATE TABLE harvest_activity(
		id SERIAL NOT NULL PRIMARY KEY,
		uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    	last_update TIMESTAMP DEFAULT now() NOT NULL,
    	last_update_by TEXT NOT NULL,
        name TEXT UNIQUE NOT NULL, 
		notes TEXT, 
		image TEXT,
        sort_order INT UNIQUE,
		date DATE NOT NULL,
		quantity_kg FLOAT,
		vegetation_point_uuid UUID NOT NULL REFERENCES vegetation_point(uuid)
);
COMMENT ON TABLE harvest_activity IS 'Harvest activity refers to the gathering of ripe crop or fruits.';
COMMENT ON COLUMN harvest_activity.id IS 'The unique harvest activity ID. This is the Primary Key.';
COMMENT ON COLUMN harvest_activity.uuid is 'The unique user ID.';
COMMENT ON COLUMN harvest_activity.last_update is 'The date that the last update was made (yyyy-mm-dd hh:mm:ss).';
COMMENT ON COLUMN harvest_activity.last_update_by is 'The name of the user responsible for the latest update.';
COMMENT ON COLUMN harvest_activity.name is 'The name of the harvest activity.';
COMMENT ON COLUMN harvest_activity.notes is 'Additional information of the harvest activity.';
COMMENT ON COLUMN harvest_activity.image is 'Image of the harvest activity.';
COMMENT ON COLUMN harvest_activity.sort_order is 'Defines the pattern of how harvest activities are to be sorted.';
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
