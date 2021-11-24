DELETE FROM album
    WHERE albumID NOT IN (SELECT albumID FROM sang);
