#!/bin/bash

# Database setup script for the calendar app

# Database file
DB_FILE="calendar_app.db"

# SQLite3 command
SQLITE3="sqlite3 $DB_FILE"

# Define SQL statements
CREATE_USERS_TABLE="CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL
);"

CREATE_CALENDARS_TABLE="CREATE TABLE IF NOT EXISTS calendars (
    calendar_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    name TEXT NOT NULL,
    color TEXT,
    visibility TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);"

CREATE_EVENTS_TABLE="CREATE TABLE IF NOT EXISTS events (
    event_id INTEGER PRIMARY KEY,
    calendar_id INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    recurrence_info TEXT,
    reminder_settings TEXT,
    FOREIGN KEY (calendar_id) REFERENCES calendars(calendar_id)
);"

# Execute SQL statements
$SQLITE3 "$CREATE_USERS_TABLE"
$SQLITE3 "$CREATE_CALENDARS_TABLE"
$SQLITE3 "$CREATE_EVENTS_TABLE"

# Output success message
echo "Database setup completed. Database file: $DB_FILE"

