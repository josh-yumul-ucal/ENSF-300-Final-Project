DROP DATABASE IF EXISTS Museum;
CREATE DATABASE Museum;
USE Museum;

DROP TABLE IF EXISTS ARTOBJECTS;
CREATE TABLE ARTOBJECTS(
	ArtID			int not null,
    Title			varchar(100) not null,
    Year			smallint,
	Epoch			varchar(100),
    Country			varchar(100),
    Description		text,
    primary key (ArtID)
    );


DROP TABLE IF EXISTS EXHIBITIONS;
CREATE TABLE EXHIBITIONS(
	ExName			varchar(100) not null,
    StartDate		date,
    EndDate			date,
    primary key (ExName)
    );



-- EndDate >= StartDate Insert Trigger
DELIMITER **
CREATE TRIGGER exhibition_start_end_dates
BEFORE INSERT ON EXHIBITIONS
FOR EACH ROW
Begin
	IF NEW.EndDate < NEW.StartDate THEN
		SIGNAL SQLSTATE "22007"
			SET MESSAGE_TEXT = "End date occurs before start date, please retry";
	END IF;
END**

DELIMITER ;

DROP TABLE IF EXISTS MUSEUM;
CREATE TABLE MUSEUM(
	Name 		varchar(100) not null,
    Location	varchar(100) not null,
    primary key (Name)
    );



DROP TABLE IF EXISTS ARTIST;
CREATE TABLE ARTIST(
	Name 		varchar(100) not null,
    Style		varchar(100),
    BirthDate	date,
    DeathDate	date,
    Origin		varchar(100),
    Epoch		varchar(100),
    Description		text,
    primary key (Name)
    );


DROP TABLE IF EXISTS OTHERCOLLECTIONS;
CREATE TABLE OTHERCOLLECTIONS(
	Name		varchar(100) not null,
    Type		varchar(100),
    Description		text,
    Address		varchar(100),
    ContactPerson		varchar(100),
    primary key (Name)
    );
    
DROP TABLE IF EXISTS PHONENUM;
CREATE TABLE PHONENUM(
	Name	varchar(100) not null,
    PhoneNum	varchar(100) not null,
    primary key (Name, PhoneNum),
    foreign key (Name) references OTHERCOLLECTIONS (Name)
    );

-- Specialization time

DROP TABLE IF EXISTS PERMANENTART;
CREATE TABLE PERMANENTART(
	ID			int not null,
    Cost		decimal(12,2),
    Status		varchar(100),
    DateAcquired	date,
    primary key (ID),
    foreign key (ID) references ARTOBJECTS(ArtID)
    );
-- Create Cost > 0 Insert Trigger
DELIMITER **
CREATE TRIGGER check_art_cost
BEFORE INSERT ON PERMANENTART
FOR EACH ROW
BEGIN
	IF NEW.Cost < 0 THEN
		SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Cost must be greater than $0";
	END IF;
END **
DELIMITER ;

-- Cost > 0 Update Trigger
DELIMITER **
CREATE TRIGGER check_art_costs
BEFORE UPDATE ON PERMANENTART
FOR EACH ROW
BEGIN
	IF NEW.Cost < 0 THEN
		SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Cost must be greater than $0";
	END IF;
END **
DELIMITER ;
    
DROP TABLE IF EXISTS BORROWEDART;
CREATE TABLE BORROWEDART(
	ID		int not null,
    CollectionName		varchar(100) not null,
    DateBorrowed	date,
    DateReturned	date,
    primary key (ID, CollectionName),
    foreign key (ID) references ARTOBJECTS(ArtID),
    foreign key (CollectionName) references OTHERCOLLECTIONS(Name)
    );
    
DROP TABLE IF EXISTS STATUE;
CREATE TABLE STATUE(
	ID		int not null,
    Height		decimal(8,2),
    Weight		decimal(8,2),
    Material	varchar(100),
    Style		varchar(100),
    primary key (ID),
    foreign key (ID) references ARTOBJECTS(ArtID)
    );
    
DROP TABLE IF EXISTS SCULPTURE;
CREATE TABLE SCULPTURE(
	ID		int not null,
    Height		decimal(8,2),
    Weight		decimal(8,2),
    Material	varchar(100),
    Style		varchar(100),
    primary key (ID),
    foreign key (ID) references ARTOBJECTS(ArtID)
);

DROP TABLE IF EXISTS PAINTING;
CREATE TABLE PAINTING(
	ID		int not null,
    Style		varchar(100),
    Material	varchar(100),
    PaintType	varchar(100),
    primary key (ID),
    foreign key (ID) references ARTOBJECTS(ArtID)
    );

    
DROP TABLE IF EXISTS OTHERART;
CREATE TABLE OTHERART(
	ArtID		int not null,
    ArtistName	varchar(100) not null,
    Type		varchar(100),
    Style		varchar(100),
    primary key (ArtID, ArtistName),
    foreign key (ArtID) references ARTOBJECTS(ArtID),
    foreign key (ArtistName) references ARTIST(Name)
    );
    
-- relationship tables
DROP TABLE IF EXISTS CREATEDBY;
CREATE TABLE CREATEDBY(
	ArtID		int not null,
	ArtistName		varchar(100),
    primary key (ArtID, ArtistName),
    foreign key (ArtID) references ARTOBJECTS(ArtID),
    foreign key (ArtistName) references ARTIST(Name)
    );


    
DROP TABLE IF EXISTS ONDISPLAY;
CREATE TABLE ONDISPLAY(
	ExName		varchar(100) not null,
    ArtID		int not null,
    primary key (ExName, ArtID),
    foreign key (ExName) references EXHIBITIONS(ExName),
    foreign key (ArtID) references ARTOBJECTS(ArtID)
    );
    

DROP TABLE IF EXISTS BORROWEDFROM;
CREATE TABLE BORROWEDFROM(
	ArtID		int not null,
    CollectionName		varchar(100) not null,
    primary key (ArtID, CollectionName),
    foreign key (ArtID) references ARTOBJECTS(ArtID),
    foreign key (CollectionName) references OTHERCOLLECTIONS(Name)
    );
    
-- Met Items (Permanent Art)
    
INSERT INTO MUSEUM (Name, Location)
VALUES ('The Metropolitan Museum of Art', 'New York, NY, USA');

-- Permanent Items
INSERT INTO ARTIST (Name, Style, BirthDate, DeathDate, Origin, Epoch, Description)
VALUES
('Duccio di Buoninsegna', 'Painting', '1255-01-01', '1319-01-01',
 'Siena, Italy', 'Proto-Renaissance',
 'Influential Sienese painter, author of the small devotional panel Madonna and Child in the Met collection.'),
('Johannes Vermeer', 'Painting', '1632-10-31', '1675-12-15',
 'Delft, Netherlands', 'Dutch Golden Age',
 'Dutch genre painter known for quiet domestic interiors such as Young Woman with a Water Pitcher.'),
('Mi Fu', 'Calligraphy', '1051-01-01', '1107-01-01',
 'China', 'Northern Song',
 'Song-dynasty calligrapher, creator of the handscroll Poem Written in a Boat on the Wu River.'),
('Katsushika Hokusai', 'Ukiyo-e', '1760-01-01', '1849-01-01',
 'Edo, Japan', 'Edo period',
 'Japanese printmaker whose woodblock print Under the Wave off Kanagawa (The Great Wave) is in the Met collection.');


INSERT INTO ARTOBJECTS (ArtID, Title, Year, Epoch, Country, Description)
VALUES
(1001, 'Madonna and Child', 1300, 'Proto-Renaissance', 'Italy',
 'Small tempera and gold devotional panel of the Virgin and Child by Duccio, a landmark of early European painting in the Met collection.'),
(1002, 'Young Woman with a Water Pitcher', 1662, 'Dutch Golden Age', 'Netherlands',
 'Interior scene by Johannes Vermeer showing a woman opening a window while holding a water pitcher, an example of his quiet domestic genre painting.'),

(1003, 'Marble statue of a kouros (youth)', -580, 'Archaic Greek', 'Greece',
 'Life-size Naxian marble statue of a standing nude youth (kouros) from Attica, once marking the grave of an Athenian aristocrat.'),
(1004, 'Marble statue of an old market woman', 50, 'Roman Imperial', 'Roman Empire',
 'Pentelic marble figure of an elderly woman carrying poultry and fruit, a Roman copy of a Hellenistic original, part of the Met Greek and Roman collection.'),

(1005, 'Bronze statuette of a veiled and masked dancer', -250, 'Hellenistic', 'Greece',
 'Small Hellenistic bronze figure of a veiled dancer with swirling drapery, now in the Met''s Greek and Roman galleries.'),
(1006, 'Terracotta neck-amphora (jar)', -530, 'Archaic Greek', 'Greece',
 'Attic terracotta neck-amphora attributed to an artist near Exekias, decorated in black-figure technique.'),

(1007, 'Poem Written in a Boat on the Wu River', 1095, 'Northern Song', 'China',
 'Handscroll of cursive script calligraphy by Mi Fu, ink on paper, Northern Song dynasty.'),
(1008, 'Under the Wave off Kanagawa (The Great Wave)', 1831, 'Edo period', 'Japan',
 'Ukiyo-e woodblock print by Katsushika Hokusai from the series Thirty-six Views of Mount Fuji, often called The Great Wave.');


INSERT INTO PERMANENTART (ID, Cost, Status, DateAcquired)
VALUES
(1001, 45000000.00, 'On display', '2004-01-01'),
(1002,  5000000.00, 'On display', '1887-01-01'),
(1003,  3000000.00, 'On display', '1932-01-01'),
(1004,  2500000.00, 'On display', '1907-01-01'),
(1005,  1500000.00, 'On display', '1971-01-01'),
(1006,   800000.00, 'On display', '1898-01-01'),
(1007,  2000000.00, 'On display', '1984-01-01'),
(1008,  1000000.00, 'On display', '1910-01-01');

INSERT INTO PAINTING (ID, Style, Material, PaintType)
VALUES
(1001, 'Tempera panel painting', 'Wood panel', 'Tempera and gold'),
(1002, 'Genre interior', 'Canvas', 'Oil');

INSERT INTO STATUE (ID, Height, Weight, Material, Style)
VALUES
(1003, 194.60, 800.00, 'Naxian marble', 'Archaic kouros'),
(1004, 125.98, 250.00, 'Pentelic marble', 'Roman copy of Hellenistic original');

INSERT INTO SCULPTURE (ID, Height, Weight, Material, Style)
VALUES
(1005, 20.50, 1.86, 'Bronze', 'Hellenistic bronze figurine'),
(1006, 41.30, 5.00, 'Terracotta', 'Archaic black-figure vase');

INSERT INTO OTHERART (ArtID, ArtistName, Type, Style)
VALUES
(1007, 'Mi Fu', 'Handscroll', 'Cursive script calligraphy'),
(1008, 'Katsushika Hokusai', 'Woodblock print', 'Ukiyo-e landscape');


INSERT INTO CREATEDBY (ArtID, ArtistName)
VALUES
(1001, 'Duccio di Buoninsegna'),
(1002, 'Johannes Vermeer'),
(1007, 'Mi Fu'),
(1008, 'Katsushika Hokusai');


INSERT INTO EXHIBITIONS (ExName, StartDate, EndDate)
VALUES
('Look Again: European Paintings 1300-1800', '2023-11-20', NULL),

('Chroma: Ancient Sculpture in Color', '2022-07-05', '2023-03-26');


INSERT INTO ONDISPLAY (ExName, ArtID)
VALUES
('Look Again: European Paintings 1300-1800', 1001),
('Look Again: European Paintings 1300-1800', 1002),
('Look Again: European Paintings 1300-1800', 1003),
('Look Again: European Paintings 1300-1800', 1004),
('Look Again: European Paintings 1300-1800', 1005),
('Look Again: European Paintings 1300-1800', 1006),
('Look Again: European Paintings 1300-1800', 1007),
('Look Again: European Paintings 1300-1800', 1008);

INSERT INTO ONDISPLAY (ExName, ArtID)
VALUES
('Chroma: Ancient Sculpture in Color', 1001),
('Chroma: Ancient Sculpture in Color', 1002),
('Chroma: Ancient Sculpture in Color', 1003),
('Chroma: Ancient Sculpture in Color', 1004),
('Chroma: Ancient Sculpture in Color', 1005),
('Chroma: Ancient Sculpture in Color', 1006),
('Chroma: Ancient Sculpture in Color', 1007),
('Chroma: Ancient Sculpture in Color', 1008);


-- Louvre Items

INSERT INTO OTHERCOLLECTIONS (Name, Type, Description, Address, ContactPerson)
VALUES
('Musée du Louvre',
 'Museum',
 'Major art museum in Paris housing works from ancient civilizations to the 19th century.',
 'Rue de Rivoli, 75001 Paris, France',
 'Laurence des Cars');


INSERT INTO ARTIST (Name, Style, BirthDate, DeathDate, Origin, Epoch, Description)
VALUES
('Leonardo da Vinci', 'Painting', '1452-04-15', '1519-05-02',
 'Vinci, Italy', 'High Renaissance',
 'Italian polymath whose portrait Mona Lisa is the Louvre''s most famous painting.'),
('Paolo Veronese', 'Painting', '1528-01-01', '1588-01-01',
 'Verona, Italy', 'Late Renaissance / Mannerism',
 'Venetian painter of grand banquet scenes such as The Wedding Feast at Cana.'),
('Unknown Greek Sculptor (Hellenistic)', 'Sculpture', NULL, NULL,
 'Greece', 'Hellenistic',
 'Conventional designation for anonymous Greek sculptors of the Hellenistic period.'),
('Unknown Egyptian Sculptor', 'Sculpture', NULL, NULL,
 'Egypt', 'Old/Middle Kingdom',
 'Conventional designation for anonymous sculptors of pharaonic Egypt.'),
('Unknown Babylonian Master', 'Inscriptions', NULL, NULL,
 'Mesopotamia', 'Old Babylonian',
 'Anonymous master responsible for the inscribed law stele of Hammurabi.'),
('Unknown Akkadian Master', 'Relief sculpture', NULL, NULL,
 'Mesopotamia', 'Akkadian',
 'Anonymous sculptor of the victory stele of Naram-Sin.');


INSERT INTO ARTOBJECTS (ArtID, Title, Year, Epoch, Country, Description)
VALUES
(2001, 'Mona Lisa', 1503, 'High Renaissance', 'Italy',
 'Half-length portrait by Leonardo da Vinci, painted in the early 16th century and now the most famous painting in the Louvre.'),
(2002, 'The Wedding Feast at Cana', 1563, 'Late Renaissance / Mannerism', 'Italy',
 'Monumental banquet scene by Paolo Veronese depicting Christ''s first miracle at Cana, the largest painting in the Louvre.'),

(2003, 'Venus de Milo', -130, 'Hellenistic', 'Greece',
 'Marble statue of Aphrodite from the island of Milos, a celebrated example of Hellenistic sculpture in the Louvre.'),
(2004, 'Winged Victory of Samothrace', -190, 'Hellenistic', 'Greece',
 'Monumental marble figure of Nike (Victory) alighting on a ship''s prow, a highlight of the Louvre''s Daru staircase.'),

(2005, 'The Seated Scribe', -2500, 'Old Kingdom', 'Egypt',
 'Painted limestone figure of a seated scribe from Saqqara, one of the Louvre''s best-known Egyptian sculptures.'),
(2006, 'Great Sphinx of Tanis', -2000, 'Middle Kingdom (reinscribed later)', 'Egypt',
 'Large pink granite sphinx combining a lion''s body and human head, guarding the Louvre''s Crypt of the Sphinx.'),

(2007, 'Law Code of Hammurabi', -1750, 'Old Babylonian', 'Mesopotamia',
 'Basalt stele inscribed with the law code of Hammurabi, king of Babylon, now in the Louvre''s Ancient Near Eastern collection.'),
(2008, 'Victory Stele of Naram-Sin', -2250, 'Akkadian', 'Mesopotamia',
 'Akkadian victory stele celebrating King Naram-Sin''s triumph, carved in relief and housed in the Louvre.');


INSERT INTO PAINTING (ID, Style, Material, PaintType)
VALUES
(2001, 'Portrait', 'Poplar panel', 'Oil'),
(2002, 'History / banquet scene', 'Canvas', 'Oil');

INSERT INTO STATUE (ID, Height, Weight, Material, Style)
VALUES
(2003, 204.00, 900.00, 'Marble', 'Hellenistic female nude'),
(2004, 328.00, 2700.00, 'Marble', 'Hellenistic victory figure');

INSERT INTO SCULPTURE (ID, Height, Weight, Material, Style)
VALUES
(2005, 53.00, 20.00, 'Painted limestone', 'Egyptian Old Kingdom statue'),
(2006, 183.00, 9500.00, 'Pink granite', 'Egyptian sphinx');

INSERT INTO OTHERART (ArtID, ArtistName, Type, Style)
VALUES
(2007, 'Unknown Babylonian Master', 'Law stele', 'Babylonian legal inscription'),
(2008, 'Unknown Akkadian Master', 'Victory stele', 'Akkadian relief sculpture');


INSERT INTO CREATEDBY (ArtID, ArtistName)
VALUES
(2001, 'Leonardo da Vinci'),
(2002, 'Paolo Veronese'),
(2003, 'Unknown Greek Sculptor (Hellenistic)'),
(2004, 'Unknown Greek Sculptor (Hellenistic)'),
(2005, 'Unknown Egyptian Sculptor'),
(2006, 'Unknown Egyptian Sculptor'),
(2007, 'Unknown Babylonian Master'),
(2008, 'Unknown Akkadian Master');


INSERT INTO BORROWEDFROM (ArtID, CollectionName)
VALUES
(2001, 'Musée du Louvre'),
(2002, 'Musée du Louvre'),
(2003, 'Musée du Louvre'),
(2004, 'Musée du Louvre'),
(2005, 'Musée du Louvre'),
(2006, 'Musée du Louvre'),
(2007, 'Musée du Louvre'),
(2008, 'Musée du Louvre');


INSERT INTO EXHIBITIONS (ExName, StartDate, EndDate)
VALUES
('Louvre Masterpieces: Renaissance to Antiquity', '2019-01-01', NULL),
('Ancient Worlds: Egypt and Mesopotamia', '2018-05-01', '2021-12-31');

INSERT INTO ONDISPLAY (ExName, ArtID)
VALUES
('Louvre Masterpieces: Renaissance to Antiquity', 2001),
('Louvre Masterpieces: Renaissance to Antiquity', 2002),
('Louvre Masterpieces: Renaissance to Antiquity', 2003),
('Louvre Masterpieces: Renaissance to Antiquity', 2004),
('Louvre Masterpieces: Renaissance to Antiquity', 2005),
('Louvre Masterpieces: Renaissance to Antiquity', 2006),
('Louvre Masterpieces: Renaissance to Antiquity', 2007),
('Louvre Masterpieces: Renaissance to Antiquity', 2008);

INSERT INTO ONDISPLAY (ExName, ArtID)
VALUES
('Ancient Worlds: Egypt and Mesopotamia', 2001),
('Ancient Worlds: Egypt and Mesopotamia', 2002),
('Ancient Worlds: Egypt and Mesopotamia', 2003),
('Ancient Worlds: Egypt and Mesopotamia', 2004),
('Ancient Worlds: Egypt and Mesopotamia', 2005),
('Ancient Worlds: Egypt and Mesopotamia', 2006),
('Ancient Worlds: Egypt and Mesopotamia', 2007),
('Ancient Worlds: Egypt and Mesopotamia', 2008);


    
