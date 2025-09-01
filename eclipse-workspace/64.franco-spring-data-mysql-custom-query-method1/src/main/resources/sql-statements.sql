-- Create the database
DROP DATABASE IF EXISTS franco_database;
CREATE DATABASE franco_database;

-- Use the created database
USE franco_database;

-- Create the franco_student table
CREATE TABLE franco_student (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Insert sample records into the franco_student table
INSERT INTO franco_student (name) VALUES
('Franco'),
('Jane'),
('Peter'),
('Mary'),
('Amy');

SELECT * from franco_student;
