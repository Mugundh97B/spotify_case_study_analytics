show databases;
create database spotify_case_study;
use spotify_case_study;
show tables;
ALTER TABLE songs_master
ADD PRIMARY KEY (Song_Id);

ALTER TABLE platform_metrics
ADD CONSTRAINT fk_platform_song
FOREIGN KEY (Song_Id) REFERENCES songs_master(Song_Id);

ALTER TABLE audio_features
ADD CONSTRAINT fk_audio_song
FOREIGN KEY (Song_Id) REFERENCES songs_master(Song_Id);

ALTER TABLE popularity_metrics
ADD CONSTRAINT fk_popularity_song
FOREIGN KEY (Song_Id) REFERENCES songs_master(Song_Id);



-- Query 1 — TOP 10 MOST POPULAR SONGS
SELECT s.track_name, s.`artist(s)_name`, p.streams
FROM songs_master s
JOIN popularity_metrics p ON s.Song_Id = p.Song_Id
ORDER BY p.streams DESC
LIMIT 10;

-- Query 2 — PLAYLIST IMPACT ON POPULARITY
SELECT 
    AVG(p.streams) AS avg_streams,
    AVG(pm.in_spotify_playlists) AS avg_spotify_playlist
FROM popularity_metrics p
JOIN platform_metrics pm ON p.Song_Id = pm.Song_Id;

-- Query 3 — YEAR-WISE TREND
SELECT 
    s.released_year,
    AVG(p.streams) AS avg_streams
FROM songs_master s
JOIN popularity_metrics p ON s.Song_Id = p.Song_Id
GROUP BY s.released_year
ORDER BY s.released_year;

-- Query 4 — TOP ARTISTS BY AVG STREAMS
SELECT 
    s.`artist(s)_name`,
    AVG(p.streams) AS avg_streams
FROM songs_master s
JOIN popularity_metrics p ON s.Song_Id = p.Song_Id
GROUP BY s.`artist(s)_name`
ORDER BY avg_streams DESC
LIMIT 10;

-- Query 5 — HIGH PLAYLIST = HIGH STREAMS
SELECT 
    CASE 
        WHEN pm.in_spotify_playlists > 1000 THEN 'High Playlist'
        ELSE 'Low Playlist'
    END AS playlist_category,
    AVG(p.streams) AS avg_streams
FROM platform_metrics pm
JOIN popularity_metrics p ON pm.Song_Id = p.Song_Id
GROUP BY playlist_category;