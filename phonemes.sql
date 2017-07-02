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
	'Labial-Alveolar',
	'Labial-Palatal',
	'Labial-Velar',
	'Dental',
	'Alveolar',
	'Palato-Alveolar',
	'Retroflex',
	'Palatal',
	'Velar',
	'Uvular',
	'Pharyngeal', --Also includes Epiglottal
	'Glottal',
	'Lateral' --Apparently lateral clicks have no other poa
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
INSERT INTO consonants ('ʘ', 'Voiceless', 'Bilabial', 'Click', 'Oral', 'None');

--Labiodental Consonants
INSERT INTO consonants ('ɱ', 'Voiced', 'Labiodental', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('f', 'Voiceless', 'Labiodental', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('v', 'Voiced', 'Labiodental', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ʋ', 'Voiced', 'Labiodental', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('ⱱ', 'Voiced', 'Labiodental', 'Pulmonic', 'Flap', 'None');

--Labial-X Consonants
INSERT INTO consonants ('nm', 'Voiced', 'Labial-Alveolar', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('tp', 'Voiceless', 'Labial-Alveolar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('db', 'Voiced', 'Labial-Alveolar', 'Pulmonic', 'Stop', 'None');

INSERT INTO consonants ('ɥ', 'Voiced', 'Labial-Palatal', 'Pulmonic', 'Approximant', 'None');

INSERT INTO consonants ('ŋm', 'Voiced', 'Labial-Velar', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('kp', 'Voiceless', 'Labial-Velar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('gb', 'Voiced', 'Labial-Velar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ʍ', 'Voiceless', 'Labial-Velar', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('w', 'Voiced', 'Labial-Velar', 'Pulmonic', 'Approximant', 'None');

--Dental Consonants
INSERT INTO consonants ('θ', 'Voiceless', 'Dental', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ð', 'Voiced', 'Dental', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('tθ', 'Voiceless', 'Dental', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('dð', 'Voiced', 'Dental', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ǀ', 'Voiceless', 'Dental', 'Click', 'Oral', 'None');

--Alveolar Consonants
INSERT INTO consonants ('n', 'Voiced', 'Alveolar', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('t', 'Voiceless', 'Alveolar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('d', 'Voiced', 'Alveolar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('s', 'Voiceless', 'Alveolar', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('z', 'Voiced', 'Alveolar', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('ts', 'Voiceless', 'Alveolar', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('dz', 'Voiced', 'Alveolar', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('ɹ', 'Voiced', 'Alveolar', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('ɾ', 'Voiced', 'Alveolar', 'Pulmonic', 'Flap', 'None');
INSERT INTO consonants ('r', 'Voiced', 'Alveolar', 'Pulmonic', 'Trill', 'None');
INSERT INTO consonants ('ɬ', 'Voiceless', 'Alveolar', 'Pulmonic', 'Fricative', 'Lateral');
INSERT INTO consonants ('ɮ', 'Voiced', 'Alveolar', 'Pulmonic', 'Fricative', 'Lateral');
INSERT INTO consonants ('tɬ', 'Voiceless', 'Alveolar', 'Pulmonic', 'Affricate', 'Lateral');
INSERT INTO consonants ('dɮ', 'Voiced', 'Alveolar', 'Pulmonic', 'Affricate', 'Lateral');
INSERT INTO consonants ('l', 'Voiced', 'Alveolar', 'Pulmonic', 'Approximant', 'Lateral');
INSERT INTO consonants ('ɺ', 'Voiced', 'Alveolar', 'Pulmonic', 'Flap', 'Lateral');
INSERT INTO consonants ('ɗ', 'Voiced', 'Alveolar', 'Implosive', 'Stop', 'None');
INSERT INTO consonants ('ǃ', 'Voiceless', 'Alveolar', 'Click', 'Oral', 'None');

--Palato-Alveolar Consonants
INSERT INTO consonants ('ʃ', 'Voiceless', 'Palato-Alveolar', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('ʒ', 'Voiced', 'Palato-Alveolar', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('tʃ', 'Voiceless', 'Palato-Alveolar', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('dʒ', 'Voiced', 'Palato-Alveolar', 'Pulmonic', 'Affricate', 'Sibilant');

--Retroflex Consonants 
INSERT INTO consonants ('ɳ', 'Voiced', 'Retroflex', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('ʈ', 'Voiceless', 'Retroflex', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ɖ', 'Voiced', 'Retroflex', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ʂ', 'Voiceless', 'Retroflex', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('ʐ', 'Voiced', 'Retroflex', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('ʈʂ', 'Voiceless', 'Retroflex', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('ɖʐ', 'Voiced', 'Retroflex', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('ɻ', 'Voiced', 'Retroflex', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('ɽ', 'Voiced', 'Retroflex', 'Pulmonic', 'Flap', 'None');
INSERT INTO consonants ('ɽr', 'Voiced', 'Retroflex', 'Pulmonic', 'Trill', 'None');
INSERT INTO consonants ('ɭ', 'Voiced', 'Retroflex', 'Pulmonic', 'Approximant', 'Lateral');
INSERT INTO consonants ('ᶑ', 'Voiced', 'Retroflex', 'Implosive', 'Stop', 'None');

--Palatal Consonants   
INSERT INTO consonants ('ɲ', 'Voiced', 'Palatal', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('c', 'Voiceless', 'Palatal', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ɟ', 'Voiced', 'Palatal', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ç', 'Voiceless', 'Palatal', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ʝ', 'Voiced', 'Palatal', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('cç', 'Voiceless', 'Palatal', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ɟʝ', 'Voiced', 'Palatal', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ɕ', 'Voiceless', 'Palatal', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('ʑ', 'Voiced', 'Palatal', 'Pulmonic', 'Fricative', 'Sibilant');
INSERT INTO consonants ('tɕ', 'Voiceless', 'Palatal', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('dʑ', 'Voiced', 'Palatal', 'Pulmonic', 'Affricate', 'Sibilant');
INSERT INTO consonants ('j', 'Voiced', 'Palatal', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('ʎ', 'Voiced', 'Palatal', 'Pulmonic', 'Approximant', 'Lateral');
INSERT INTO consonants ('ʄ', 'Voiced', 'Palatal', 'Implosive', 'Stop', 'None');
INSERT INTO consonants ('ǂ', 'Voiceless', 'Palatal', 'Click', 'Oral', 'None');

--Velar Consonants
INSERT INTO consonants ('ŋ', 'Voiced', 'Velar', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('k', 'Voiceless', 'Velar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('g', 'Voiced', 'Velar', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('x', 'Voiceless', 'Velar', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ɣ', 'Voiced', 'Velar', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('kx', 'Voiceless', 'Velar', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('gɣ', 'Voiced', 'Velar', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ɰ', 'Voiced', 'Velar', 'Pulmonic', 'Approximant', 'None');
INSERT INTO consonants ('ʟ', 'Voiced', 'Velar', 'Pulmonic', 'Approximant', 'Lateral');
INSERT INTO consonants ('ɠ', 'Voiced', 'Velar', 'Implosive', 'Stop', 'None');

--Uvular Consonants
INSERT INTO consonants ('ɴ', 'Voiced', 'Uvular', 'Pulmonic', 'Nasal', 'None');
INSERT INTO consonants ('q', 'Voiceless', 'Uvular', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ɢ', 'Voiced', 'Uvular', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('χ', 'Voiceless', 'Uvular', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ʁ', 'Voiced', 'Uvular', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('qχ', 'Voiceless', 'Uvular', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ɢʁ', 'Voiced', 'Uvular', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ʀ', 'Voiced', 'Uvular', 'Pulmonic', 'Trill', 'None');
INSERT INTO consonants ('ʛ', 'Voiced', 'Uvular', 'Implosive', 'Stop', 'None');

--Pharyngeal Consonants
INSERT INTO consonants ('ʡ', 'Voiceless', 'Pharyngeal', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('ħ', 'Voiceless', 'Pharyngeal', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ʕ', 'Voiced', 'Pharyngeal', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ʡħ', 'Voiceless', 'Pharyngeal', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ʡʢ', 'Voiced', 'Pharyngeal', 'Pulmonic', 'Affricate', 'None');
INSERT INTO consonants ('ʜ', 'Voiceless', 'Pharyngeal', 'Pulmonic', 'Trill', 'None');
INSERT INTO consonants ('ʢ', 'Voiced', 'Pharyngeal', 'Pulmonic', 'Trill', 'None');

--Glottal Consonants
INSERT INTO consonants ('ʔ', 'Voiceless', 'Glottal', 'Pulmonic', 'Stop', 'None');
INSERT INTO consonants ('h', 'Voiceless', 'Glottal', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ɦ', 'Breathy', 'Glottal', 'Pulmonic', 'Fricative', 'None');
INSERT INTO consonants ('ʔh', 'Voiceless', 'Glottal', 'Pulmonic', 'Affricate', 'None');

--Other Consonants
INSERT INTO consonants ('ǁ', 'Voiceless', 'Lateral', 'Click', 'Oral', 'Lateral');
