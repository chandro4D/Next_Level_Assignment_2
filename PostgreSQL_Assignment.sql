--                                      Problem:1
INSERT INTO rangers VALUES( 4,'Derek Fox' , 'Coastal Plains');

--                                      Problem:2
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

--                                      Problem:3
SELECT * FROM sightings
  WHERE location LIKE '%Pass'

--                                      Problem:4
SELECT name, COUNT(sighting_id) AS total_sightings
FROM rangers 
LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY name
ORDER BY name;

--                                      Problem:5
SELECT common_name
FROM species 
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.species_id IS NULL;


--                                      Problem:6
SELECT common_name, sighting_time ,name
FROM sightings 
JOIN rangers  ON sightings.ranger_id = rangers.ranger_id
JOIN species  ON sightings.species_id = species.species_id
ORDER BY sightings.sighting_time DESC
LIMIT 2;

--                                      Problem:7
UPDATE species
set conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01'

UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

--                                      Problem:8
SELECT sighting_id,
  CASE 
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 16 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings
ORDER BY sighting_id;


--                                      Problem:9
DELETE FROM rangers
WHERE NOT EXISTS (
  SELECT * FROM sightings WHERE sightings.ranger_id = rangers.ranger_id
);



--                                       CREATE DATABASE 
CREATE DATABASE conservation_db
--                                  Create Table 1: rangers
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);
--                                 Create Table 2: species
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) CHECK (conservation_status IN ('Historic','Endangered', 'Vulnerable', 'Critically Endangered', 'Least Concern', 'Near Threatened')) NOT NULL
);
--                                   Create Table 2: sightings
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    species_id INT REFERENCES species(species_id) ON DELETE CASCADE,
    sighting_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(150) NOT NULL,
    notes TEXT
);
--                                       Insert data into rangers
INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');
--                                     Insert data into species
INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');
--                                   Insert data into sightings
INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);