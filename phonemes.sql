------------------------------------
--          PHONEMES.SQL          --
-- File that generates the tables --
-- required for phoneme lookup.   --
------------------------------------

-- Connect and create
\c postgres
DROP DATABASE IF EXISTS phonemes;
CREATE DATABASE phonemes;
\c phonemes;

-- Possible voicing levels
CREATE TYPE voice_level AS ENUM (
	'Voiceless',
	'Breathy',
	'Slack',
	'Voiced',
	'Stiff',
	'Creaky'
);

-- Possible places of articulation
CREATE TYPE poa AS ENUM (
	'Bilabial',
	'Labiodental',
	'Labial-Velar',
	'Dental',
	'Alveolar',
	'Palato-Alveolar',
	'Retroflex',
	'Palatal',
	'Labial-Palatal',
	'Velar',
	'Uvular',
	'Pharyngeal',
	'Epiglottal',
	'Glottal'
);

-- Possible manners of articulation
CREATE TYPE moa AS ENUM (
	'Nasal',
	'Stop',
	'Fricative',
	'Affricate',
	'Approximant',
	'Flap',
	'Trill',
	'Oral' -- For clicks
);

CREATE TYPE sub_moa AS ENUM (
	'None',
	'Sibilant',
	'Lateral',
);

-- Possible airstream mechanisms
CREATE TYPE air_mech AS ENUM (
	'Pulmonic',
	'Click',
	'Implosive'
);

CREATE TYPE vowel_height AS ENUM (
	'Close',
	'Near-Close',
	'Close-Mid',
	'Mid',
	'Open-Mid',
	'Near-Open',
	'Open'
);

CREATE TYPE vowel_backness AS ENUM (
	'Front',
	'Near-Front',
	'Central',
	'Near-Back',
	'Back'
);

DROP TABLE IF EXISTS consonants;
CREATE TABLE consonants
(
	Symbol		VARCHAR(3) UNIQUE NOT NULL, --IPA
	Voice		VOICE_LEVEL NOT NULL,
	Place		POA NOT NULL,
	Airstream	AIR_MECH NOT NULL,
	Manner		MOA NOT NULL,
	SubManner   SUB_MOA NOT NULL,
	PRIMARY KEY (Symbol)
);

DROP TABLE IF EXISTS vowels;
CREATE TABLE vowels (
	Symbol		VARCHAR(2) UNIQUE NOT NULL, --IPA
	Voice		VOICE_LEVEL NOT NULL DEFAULT 'Voiced',
	Height		VOWEL_HEIGHT NOT NULL,
	Backness	VOWEL_BACKNESS NOT NULL,
	Rounded		BOOLEAN NOT NULL,
	PRIMARY KEY (Symbol)
);

DROP TABLE IF EXISTS diphthongs;
CREATE TABLE diphthongs (
	StartSymbol	VARCHAR(2) NOT NULL,
	EndSymbol	VARCHAR(2) NOT NULL,
	Falling		BOOLEAN NOT NULL, --FALSE = rising diphthong
	Closing		BOOLEAN NOT NULL, --FALSE = opening diphthong
	PRIMARY KEY (StartSymbol, EndSymbol),
	FOREIGN KEY (StartSymbol) REFERENCES vowels(Symbol),
	FOREIGN KEY (EndSymbol) REFERENCES vowels(Symbol)
);

------------------------------
-- Now let's add all of IPA --
------------------------------

-- Bilabial Consonants
INSERT INTO consonants ('m', 'Voiced', 'Bilabial', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('p', 'Voiceless', 'Bilabial', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('b', 'Voiced', 'Bilabial', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ɸ', 'Voiceless', 'Bilabial', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('β', 'Voiced', 'Bilabial', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('pɸ', 'Voiceless', 'Bilabial', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('bβ', 'Voiced', 'Bilabial', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ʙ', 'Voiced', 'Bilabial', 'Pulmonic', 'Trill', 'None')
INSERT INTO consonants ('ɓ', 'Voiced', 'Bilabial', 'Implosive', 'Stop', 'None');

--Labiodental Consonants
INSERT INTO consonants ('ɱ', 'Voiced', 'Labiodental', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('f', 'Voiceless', 'Labiodental', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('v', 'Voiced', 'Labiodental', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ʋ', 'Voiced', 'Labiodental', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('ⱱ', 'Voiced', 'Labiodental', 'Pulmonic', 'Flap', 'None');

--Labial-Velar/Labiovelar Consonants
INSERT INTO consonants ('kp', 'Voiceless', 'Labial-Velar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('gb', 'Voiced', 'Labial-Velar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ʍ', 'Voiceless', 'Labial-Velar', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('w', 'Voiced', 'Labial-Velar', 'Pulmonic', 'Approximant', 'None');

--Dental Consonants
INSERT INTO consonants ('θ', 'Voiceless', 'Dental', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ð', 'Voiced', 'Dental', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('tθ', 'Voiceless', 'Dental', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('dð', 'Voiced', 'Dental', 'Pulmonic', 'Affricate', 'None');

--Alveolar Consonants
INSERT INTO consonants ('n', 'Voiced', 'Alveolar', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('t', 'Voiceless', 'Alveolar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('d', 'Voiced', 'Alveolar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('s', 'Voiceless', 'Alveolar', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('z', 'Voiced', 'Alveolar', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('ts', 'Voiceless', 'Alveolar', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('dz', 'Voiceless', 'Alveolar', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('ɹ', 'Voiced', 'Alveolar', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('ɾ', 'Voiced', 'Alveolar', 'Pulmonic', 'Flap', 'None');
INSERT INTO consonants ('r', 'Voiced', 'Alveolar', 'Pulmonic', 'Trill', 'None');
INSERT INTO consonants ('ɬ', 'Voiceless', 'Alveolar', 'Pulmonic', 'Fricative', 'Lateral');
INSERT INTO consonants ('ɮ', 'Voiced', 'Alveolar', 'Pulmonic', 'Fricative', 'Lateral');
INSERT INTO consonants ('tɬ', 'Voiceless', 'Alveolar', 'Pulmonic', 'Affricate', 'Lateral');
INSERT INTO consonants ('dɮ', 'Voiced', 'Alveolar', 'Pulmonic', 'Affricate', 'Lateral');
INSERT INTO consonants ('l', 'Voiced', 'Alveolar', 'Pulmonic', 'Approximant', 'Lateral');
INSERT INTO consonants ('ɺ', 'Voiced', 'Alveolar', 'Pulmonic', 'Flap', 'Lateral');

