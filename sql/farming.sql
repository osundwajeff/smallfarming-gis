

create database farming;
-- add connect statement here

create extension postgis;


-- ----------------------------------

CREATE TABLE water_source_type (
  id SERIAL NOT NULL PRIMARY KEY,
  last_update TIMESTAMP DEFAULT now() NOT NULL,
  last_update_by TEXT NOT NULL,
  uuid TEXT UNIQUE NOT NULL,
  name TEXT UNIQUE NOT NULL,
  notes TEXT NULL
);
COMMENT ON TABLE water_source_type IS 
'This is a lookup table for sources of water. e.g. borehole, mains, well, river etc.';

CREATE INDEX water_source_type__uuid_idx ON water_source_type(uuid);

INSERT INTO water_source_type (
	last_update,
	last_update_by,
	uuid,
	name	
) values (
	now(),
	'db-init',
	'{71646565-a4d8-47eb-8531-4e61341573da}',
	'other'
);

-- ----------------------------------

CREATE TABLE water_point_type (
  id SERIAL NOT NULL PRIMARY KEY,
  last_update TIMESTAMP DEFAULT now() NOT NULL,
  last_update_by TEXT NOT NULL,
  uuid TEXT UNIQUE NOT NULL,  
  name TEXT UNIQUE NOT NULL,
  notes TEXT NULL
);

COMMENT ON TABLE water_point_type IS 
'This is a lookup table types of water point. e.g. tap, drinking trough etc.';

CREATE INDEX water_point_type__uuid_idx ON water_point_type(uuid);

INSERT INTO water_point_type (
	last_update,
	last_update_by,
	uuid,
	name	
) values (
	now(),
	'db-init',
	'{71646565-a4d8-47eb-8531-4e61341573da}',
	'other'
);

-- ----------------------------------

CREATE TABLE water_point (
  id SERIAL NOT NULL PRIMARY KEY,
  last_update TIMESTAMP DEFAULT now() NOT NULL,
  last_update_by TEXT NOT NULL,
  uuid TEXT NOT NULL,
  geometry GEOGRAPHY(POINT,4326),
  notes TEXT NULL,
  image TEXT NULL,
  water_source_type_uuid TEXT NOT NULL REFERENCES water_source_type(uuid),
  water_point_type_uuid TEXT NOT NULL REFERENCES water_point_type(uuid)
);

COMMENT ON TABLE water_point_type IS 
'This is a table to store water points.';

CREATE INDEX water_point__geometry_idx ON water_point USING GIST (geometry);



CREATE TABLE water_line_type (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    uuid TEXT UNIQUE NOT NULL,
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL
);
COMMENT ON TABLE water_line_type IS
'Description of water lines eg. river, irrigaton.';
CREATE INDEX water_line_type__uuid_idx ON
water_line_type(uuid);
INSERT INTO water_line_type (
    name,
    uuid,
    last_update,
    last_update_by
) VALUES (
    'db-init',
    '{c1803802-0d65-416c-98cd-b691efc7e164}',
    now(),
    'name'
);
CREATE TABLE water_lines (
    id SERIAL NOT NULL PRIMARY KEY,
    notes TEXT NULL,
    last_update TIMESTAMP DEFAULT now() NOT NULL,
    last_update_by TEXT NOT NULL,
    uuid TEXT UNIQUE NOT NULL,
    image TEXT NULL,
    water_line_type_uuid TEXT NOT NULL REFERENCES water_line_type(uuid),
    water_source_uuid TEXT NOT NULL REFERENCES water_source_type(uuid)
);
COMMENT ON TABLE water_lines IS
    'This is the path of the water lines follow.';
CREATE INDEX water_lines__uuid_idx ON water_lines(uuid);
INSERT INTO water_lines (
    last_update,
    last_update_by,
    uuid,
    water_line_type_uuid,
    water_source_uuid
) VALUES (
    now(),
    'db-init',
    '{ca3f82ce-d8bf-4ac4-9727-270179976667}',
    '{25c807a1-be4e-4c46-89d6-c4bcda470840}',
    '{71646565-a4d8-47eb-8531-4e61341573da}'
);

-- ----------------------------------
