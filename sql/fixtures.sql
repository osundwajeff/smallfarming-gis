-- readings
INSERT INTO readings(last_update_by, name) VALUES ('Mondli', 'Moisture Testers');

-- fence type
INSERT INTO fence_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Barbed wire', 1);
INSERT INTO fence_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Chain link', 2);
INSERT INTO fence_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Electric fence', 3);
INSERT INTO fence_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Split rail', 4);
INSERT INTO fence_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Wall', 5);
INSERT INTO fence_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Wood', 6);
INSERT INTO fence_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Wrought fence', 7);

-- point of interest type
INSERT INTO point_of_interest_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Bridge', 1);
INSERT INTO point_of_interest_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Electric', 2);
INSERT INTO point_of_interest_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Fence', 3);
INSERT INTO point_of_interest_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Gate', 4);
INSERT INTO point_of_interest_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Ruin', 5);
INSERT INTO point_of_interest_type (last_update_by, name, sort_order) VALUES ('Jeff', 'Water point', 6);

-- condition
INSERT INTO "condition"  (last_update_by, name) VALUES ('Jeff', 'Fixed');
INSERT INTO "condition"  (last_update_by, name) VALUES ('Jeff', 'Broken');
