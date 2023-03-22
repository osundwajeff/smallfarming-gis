-- vegetation
--months of the year
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'January', 1);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'February', 2);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'March', 3);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'April', 4);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'May', 5);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'June', 6);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'July', 7);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'August', 8);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'September', 9);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'October', 10);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'November', 11);
INSERT INTO month(last_update_by, name, sort_order) values ('Luna', 'December',12);

--plant growth activities type
INSERT INTO plant_growth_activity_type(last_update_by, name, sort_order) VALUES ('Luna', 'Sprouting', 1);
INSERT INTO plant_growth_activity_type(last_update_by, name, sort_order) VALUES ('Luna', 'Seeding', 2);
INSERT INTO plant_growth_activity_type(last_update_by, name, sort_order) VALUES ('Luna', 'Vegetative', 3);
INSERT INTO plant_growth_activity_type(last_update_by, name, sort_order) VALUES ('Luna', 'Budding', 4);
INSERT INTO plant_growth_activity_type(last_update_by, name, sort_order) VALUES ('Luna', 'Flowering', 5);
INSERT INTO plant_growth_activity_type(last_update_by, name, sort_order) VALUES ('Luna', 'Ripening', 6);

--plant usage
INSERT INTO plant_usage(last_update_by, name) VALUES ('Luna', 'Food Plant');
INSERT INTO plant_usage(last_update_by, name) VALUES ('Luna', 'Fodder Plant');
INSERT INTO plant_usage(last_update_by, name) VALUES ('Luna', 'Commercial Plant');


-- electricity
--electricity line type
INSERT INTO electricity_line_type(last_update_by, name, sort_order, current_a, voltage_v) VALUES ('Ashleigh', 'Low Voltage', 1, 50, 230);
INSERT INTO electricity_line_type(last_update_by, name, sort_order, current_a, voltage_v) VALUES ('Ashleigh', 'Medium Voltage', 2, 75, 11000);
INSERT INTO electricity_line_type(last_update_by, name, sort_order, current_a, voltage_v) VALUES ('Ashleigh', 'High Voltage', 3, 100, 33000);
INSERT INTO electricity_line_type(last_update_by, name, sort_order, current_a, voltage_v) VALUES ('Ashleigh', 'Extra-High Voltage', 4, 120, 365000);
INSERT INTO electricity_line_type(last_update_by, name, sort_order, current_a, voltage_v) VALUES ('Ashleigh', 'Ultra-High Voltage', 5, 150, 800000 );

--electricity line condition type
INSERT INTO electricity_line_condition_type(last_update_by, name) VALUES ('Ashleigh', 'Working');   
INSERT INTO electricity_line_condition_type(last_update_by, name) VALUES ('Ashleigh', 'Broken');    


-- water
-- water source
INSERT INTO water_source (last_update_by, name) VALUES ('Polly', 'Aquifer');
INSERT INTO water_source (last_update_by, name) VALUES ('Polly', 'River');
INSERT INTO water_source (last_update_by, name) VALUES ('Polly', 'Reservoir');
INSERT INTO water_source (last_update_by, name) VALUES ('Polly', 'Rainwater');

-- water polygon type
INSERT INTO water_polygon_type (last_update_by, name) VALUES ('Polly', 'Wetland');
INSERT INTO water_polygon_type (last_update_by, name) VALUES ('Polly', 'Lake');
INSERT INTO water_polygon_type (last_update_by, name) VALUES ('Polly', 'Reservoir');
INSERT INTO water_polygon_type (last_update_by, name) VALUES ('Polly', 'Pond');

-- water point type
INSERT INTO water_point_type (last_update_by, name) VALUES ('Polly', 'Drinking Trough'); 
INSERT INTO water_point_type (last_update_by, name) VALUES ('Polly', 'Tap'); 
INSERT INTO water_point_type (last_update_by, name) VALUES ('Polly', 'Borehole');
INSERT INTO water_point_type (last_update_by, name) VALUES ('Polly', 'Water Tank');  

-- water line type
INSERT INTO water_line_type (last_update_by, name, sort_order) VALUES ('Polly', 'River', 1);
INSERT INTO water_line_type (last_update_by, name, sort_order) VALUES ('Polly', 'Stream', 2);
