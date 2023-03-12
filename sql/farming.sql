

create database farming;
-- add connect statement here

create extension postgis;

-- ----------------------------------

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

-- INFRASTRUCTURE TYPE
CREATE TABLE infrastructure_type (
    id SERIAL NOT NULL PRIMARY KEY, 
    name TEXT UNIQUE NOT NULL, 
    notes TEXT NULL,
-- Constraint are not carried when doing inheritance, as they should be specified. 
    CONSTRAINT unique_infrastructure_type_key UNIQUE (uuid)
) INHERITS (user_update); 
COMMENT ON TABLE infrastructure_type IS 'Stores information on infrastrcuture types avaialbe. ';
COMMENT ON COLUMN infrastructure_type.id is 'The unique infrastructure type ID. Primary key. ';
COMMENT ON COLUMN infrastructure_type.name is 'The infrastructure type name, e.g. Furniture, Electronics. ';
COMMENT ON COLUMN infrastructure_type.notes is 'Addtional information on the infrastructure type. ';

-- INFRASTRUCTURE ITEM
CREATE TABLE infrastructure_item(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT UNIQUE NULL, 
    notes TEXT, 
    geometry GEOMETRY (POINT,4326), 
    CONSTRAINT unique_infrastructure_item_key UNIQUE (uuid),
    infrastructure_type_uuid UUID NOT NULL REFERENCES infrastructure_type(uuid)
) INHERITS (user_update);
COMMENT ON TABLE infrastructure_item IS 'Lookup table of the type of infrastructure type. ';
COMMENT ON COLUMN infrastructure_item.id is 'The unique infrastructure item ID. Primary Key. ';
COMMENT ON COLUMN infrastructure_item.name is 'The infrastructure item name, e.g. Chair. ';
COMMENT ON COLUMN infrastructure_item.notes is 'Additional information on the infrastructure item type. ';
COMMENT ON COLUMN infrastructure_item.geometry is 'Then centroid location of the water polygon. Folows EPSG: 4326. ';

-- INFRASTRUCTURE LOG ACTION
CREATE TABLE infrastructure_log_action(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL, 
    notes TEXT,
    CONSTRAINT unique_infrastructure_log_action_key UNIQUE (uuid)
) INHERITS (user_update);
COMMENT ON TABLE infrastructure_log_action IS 'Stores information on actions taken to maintain infrastructure items, ';
COMMENT ON COLUMN infrastructure_log_action.id is 'The unique log action ID. Primary Key. ';
COMMENT ON COLUMN infrastructure_log_action.name is 'The log action name, e.g.  screwing. ';
COMMENT ON COLUMN infrastructure_log_action.notes is 'Any Additional information aoub the log action. ';

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
COMMENT ON TABLE infrastructure_management_log IS 'Store information on the process of task that needs to be done on an infrastructure item. ';
COMMENT ON COLUMN infrastructure_management_log.id is 'The unique managment log ID. Primary Key. ';
COMMENT ON COLUMN infrastructure_management_log.name is 'The management log  name. ';
COMMENT ON COLUMN infrastructure_management_log.notes is 'Any additional information about the management information log. ';
COMMENT ON COLUMN infrastructure_management_log.condition is 'Circumstances or factors affecting the ifrastructure type item. ';
COMMENT ON COLUMN infrastructure_management_log.image is 'Image of the infrastructure item. ';

-- ----------------------------------

CREATE TABLE electricity_line_type (
  id SERIAL NOT NULL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  notes TEXT,
-- add unique together constraint for voltage and current
  current_amps FLOAT UNIQUE NOT NULL,
  voltage_volts FLOAT UNIQUE NOT NULL,
  constraint electricity_line_type_unique_key unique (uuid)
) INHERITS (user_update);
COMMENT ON TABLE electricity_line_type IS 'Look up table for electricity line type.';
COMMENT ON COLUMN electricity_line_type.id is 'The unique electricity line type ID. Primary key.';
COMMENT ON COLUMN electricity_line_type.name is 'The electricity line type name.';
COMMENT ON COLUMN electricity_line_type.notes is 'The electricity line type notes.';
COMMENT ON COLUMN electricity_line_type.current_amps is 'The electricity line current.';
COMMENT ON COLUMN electricity_line_type.voltage_volts is 'The electricity line voltage.';

CREATE TABLE electricity_line (
  id SERIAL NOT NULL PRIMARY KEY,
	name TEXT UNIQUE,
  notes TEXT NULL,
	geometry GEOMETRY(LINESTRING, 4326) NOT NULL,
  electricity_line_type_uuid UUID NOT NULL REFERENCES electricity_line_type(uuid),
  constraint electricity_line_unique_key unique (uuid)
) INHERITS (user_update);
COMMENT ON TABLE electricity_line IS 'Stores information on electricity lines available.';
COMMENT ON COLUMN electricity_line.id is 'The unique electricity line ID. Primary key.';
COMMENT ON COLUMN electricity_line.notes is 'The electricity line notes.';
COMMENT ON COLUMN electricity_line.geometry is 'The electricity line geometry.';

CREATE TABLE electricity_line_condition (
  id SERIAL NOT NULL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  notes TEXT,
  constraint electricity_line_condition_unique_key unique (uuid)
) INHERITS (user_update);
COMMENT ON TABLE electricity_line_condition IS 'Look up table for electricity line condition.';
COMMENT ON COLUMN electricity_line_condition.id is 'The unique electricity line condition ID. Primary key.';
COMMENT ON COLUMN electricity_line_condition.notes is 'The additional information on electricity line condition.';

-- association table

CREATE TABLE electricity_line_conditions (
  date DATE NOT NULL,
  electricity_line_uuid UUID NOT NULL REFERENCES electricity_line(uuid),
  electricity_line_condition_uuid UUID NOT NULL REFERENCES electricity_line_condition(uuid),
  -- Unique together
  PRIMARY KEY (electricity_line_uuid, electricity_line_condition_uuid),
  constraint electricity_line_conditions_unique_key unique (uuid)
) INHERITS (user_update);
COMMENT ON TABLE electricity_line_conditions IS 'Associative table which stores the electricity line and condition.';
COMMENT ON COLUMN electricity_line_conditions.date is 'The electricity line inspection date.';      
