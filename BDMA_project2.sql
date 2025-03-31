-- Create the Library Management Database
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Bio TEXT
);

-- Publishers Table
CREATE TABLE Publishers (
    PublisherID INT AUTO_INCREMENT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Phone VARCHAR(20)
);

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE NOT NULL
);

-- Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    PublicationYear YEAR,
    PublisherID INT,
    CategoryID INT,
    Summary TEXT,
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID) ON DELETE SET NULL,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL
);

-- BookAuthors Table (Many-to-Many relationship between Books and Authors)
CREATE TABLE BookAuthors (
    BookID INT,
    AuthorID INT,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) ON DELETE CASCADE
);

-- LibraryBranches Table
CREATE TABLE LibraryBranches (
    BranchID INT AUTO_INCREMENT PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) UNIQUE
);

-- BookCopies Table (Tracking copies of books in different branches)
CREATE TABLE BookCopies (
    CopyID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    BranchID INT,
    Status ENUM('Available', 'On Loan', 'Reserved', 'Lost') NOT NULL DEFAULT 'Available',
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (BranchID) REFERENCES LibraryBranches(BranchID) ON DELETE CASCADE
);

-- Members Table (Library users)
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Address VARCHAR(255) NOT NULL,
    MembershipDate DATE NOT NULL 

);

-- Issue Table (Tracks book loans)
CREATE TABLE Issue (
    IssueID INT AUTO_INCREMENT PRIMARY KEY,
    CopyID INT,
    MemberID INT,
    LoanDate DATE NOT NULL ,
    DueDate DATE NOT NULL,
    ReturnDate DATE DEFAULT NULL,
    FOREIGN KEY (CopyID) REFERENCES BookCopies(CopyID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);

-- Reservations Table (Tracks book reservations)
CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    CopyID INT,
    MemberID INT,
    ReservationDate DATE NOT NULL,
    Status ENUM('Active', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Active',
    FOREIGN KEY (CopyID) REFERENCES BookCopies(CopyID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);

-- Fines Table (Tracks fines for overdue books)
CREATE TABLE Fines (
    FineID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    IssueID INT,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    DateIssued DATE NOT NULL,
    DatePaid DATE DEFAULT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE,
    FOREIGN KEY (IssueID) REFERENCES Issue(IssueID) ON DELETE CASCADE
);

-- Librarians Table (Library Staff)
CREATE TABLE Librarians (
    LibrarianID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES LibraryBranches(BranchID) ON DELETE SET NULL
);

-- BookReviews Table (Members can review books)
CREATE TABLE BookReviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);

USE LibraryManagement;

-- Authors (20 Records)
INSERT INTO Authors (AuthorID, FirstName, LastName, Bio) VALUES
(1, 'George', 'Orwell', 'English novelist and essayist.'),
(2, 'Jane', 'Austen', 'English novelist known for romance.'),
(3, 'J.K.', 'Rowling', 'British author of Harry Potter.'),
(4, 'Harper', 'Lee', 'Author of "To Kill a Mockingbird".'),
(5, 'F. Scott', 'Fitzgerald', 'Wrote "The Great Gatsby".'),
(6, 'Mark', 'Twain', 'American humorist and novelist.'),
(7, 'Ernest', 'Hemingway', 'American novelist.'),
(8, 'Leo', 'Tolstoy', 'Russian writer.'),
(9, 'Charles', 'Dickens', 'English novelist.'),
(10, 'Agatha', 'Christie', 'Famous for mystery novels.'),
(11, 'Isaac', 'Asimov', 'Science fiction writer.'),
(12, 'Stephen', 'King', 'Horror and supernatural fiction.'),
(13, 'Arthur', 'Conan Doyle', 'Created Sherlock Holmes.'),
(14, 'H.G.', 'Wells', 'Pioneer of science fiction.'),
(15, 'Emily', 'Bronte', 'Author of "Wuthering Heights".'),
(16, 'Victor', 'Hugo', 'Wrote "Les Misérables".'),
(17, 'Jules', 'Verne', 'Father of science fiction.'),
(18, 'Herman', 'Melville', 'Wrote "Moby-Dick".'),
(19, 'George', 'Eliot', 'English novelist.'),
(20, 'Mary', 'Shelley', 'Wrote "Frankenstein".');

-- Publishers (20 Records)
INSERT INTO Publishers (PublisherID, PublisherName, Address, Phone) VALUES
(1, 'Penguin Books', 'London, UK', '123-456-7890'),
(2, 'HarperCollins', 'New York, USA', '234-567-8901'),
(3, 'Oxford Press', 'Oxford, UK', '345-678-9012'),
(4, 'Macmillan', 'New York, USA', '456-789-0123'),
(5, 'Random House', 'Berlin, Germany', '567-890-1234'),
(6, 'Simon & Schuster', 'New York, USA', '678-901-2345'),
(7, 'Hachette', 'Paris, France', '789-012-3456'),
(8, 'Bloomsbury', 'London, UK', '890-123-4567'),
(9, 'Scholastic', 'New York, USA', '901-234-5678'),
(10, 'Vintage Books', 'New York, USA', '012-345-6789'),
(11, 'Tor Books', 'New York, USA', '111-222-3333'),
(12, 'Bantam Books', 'New York, USA', '222-333-4444'),
(13, 'Dover Publications', 'New York, USA', '333-444-5555'),
(14, 'Gollancz', 'London, UK', '444-555-6666'),
(15, 'Scribner', 'New York, USA', '555-666-7777'),
(16, 'W.W. Norton', 'New York, USA', '666-777-8888'),
(17, 'Knopf', 'New York, USA', '777-888-9999'),
(18, 'Del Rey', 'New York, USA', '888-999-0000'),
(19, 'Baen Books', 'New York, USA', '999-000-1111'),
(20, 'Ace Books', 'New York, USA', '000-111-2222');

-- Categories (20 Records)
INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Fiction'), (2, 'Science Fiction'), (3, 'Romance'), (4, 'Mystery'),
(5, 'Fantasy'), (6, 'Biography'), (7, 'History'), (8, 'Philosophy'),
(9, 'Horror'), (10, 'Classic'), (11, 'Adventure'), (12, 'Psychology'),
(13, 'Self-help'), (14, 'Thriller'), (15, 'Drama'), (16, 'Poetry'),
(17, 'Children'), (18, 'Young Adult'), (19, 'Graphic Novel'), (20, 'Travel');

-- Books (20 Records)
ALTER TABLE Books MODIFY COLUMN PublicationYear SMALLINT(4) NOT NULL;

INSERT INTO Books (BookID, Title, ISBN, PublicationYear, PublisherID, CategoryID, Summary) VALUES
(1, '1984', '978-0451524935', 1949, 1, 1, 'Dystopian novel about surveillance.'),
(2, 'Pride and Prejudice', '978-1503290563', 1813, 2, 3, 'Romantic novel about manners.'),
(3, 'Harry Potter and the Sorcerer''s Stone', '978-0439708180', 1997, 8, 5, 'Fantasy novel about a young wizard.'),
(4, 'To Kill a Mockingbird', '978-0061120084', 1960, 3, 1, 'Novel about racial injustice.'),
(5, 'The Great Gatsby', '978-0743273565', 1925, 4, 10, 'Classic novel about the Jazz Age.'),
(6, 'Moby-Dick', '978-1503280786', 1851, 5, 11, 'A novel about a man’s obsession with a whale.'),
(7, 'The Catcher in the Rye', '978-0316769488', 1951, 6, 1, 'A novel about teenage rebellion.'),
(8, 'Brave New World', '978-0060850524', 1932, 7, 2, 'Dystopian novel about a futuristic society.'),
(9, 'The Hobbit', '978-0618260300', 1937, 8, 5, 'Fantasy novel about Bilbo Baggins’ adventure.'),
(10, 'Frankenstein', '978-0486282114', 1818, 9, 9, 'A novel about a scientist creating a monster.'),
(11, 'The Picture of Dorian Gray', '978-0141439570', 1890, 10, 10, 'Novel about beauty and corruption.'),
(12, 'The War of the Worlds', '978-0451530653', 1898, 11, 2, 'Sci-fi novel about a Martian invasion.'),
(13, 'Crime and Punishment', '978-0486415871', 1866, 12, 15, 'A novel about psychological struggle.'),
(14, 'The Brothers Karamazov', '978-0374528379', 1880, 13, 15, 'A novel about moral struggles.'),
(15, 'Wuthering Heights', '978-0486292565', 1847, 14, 3, 'A novel about passionate but destructive love.'),
(16, 'Dracula', '978-0486411095', 1897, 15, 9, 'Horror novel about vampires.'),
(17, 'The Call of the Wild', '978-0486264729', 1903, 16, 11, 'Adventure novel about a sled dog.'),
(18, 'Les Misérables', '978-0451419439', 1862, 17, 15, 'Historical novel about social justice.'),
(19, 'A Tale of Two Cities', '978-0451530578', 1859, 18, 10, 'A novel about the French Revolution.'),
(20, 'The Divine Comedy', '978-0140448955', 1320, 19, 16, 'Epic poem about a journey through Hell, Purgatory, and Heaven.');

INSERT INTO BookAuthors (BookID, AuthorID) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 18), (7, 6), (8, 7), (9, 8), (10, 20),
(11, 19), (12, 14), (13, 9), (14, 9), (15, 15), (16, 10), (17, 11), (18, 16), (19, 13), (20, 12);

INSERT INTO LibraryBranches (BranchID, BranchName, Address, Phone) VALUES
(1, 'Central Library', '123 Main St, Cityville', '111-111-1111'),
(2, 'Downtown Library', '456 Elm St, Cityville', '222-222-2222'),
(3, 'Westside Library', '789 Oak St, Cityville', '333-333-3333'),
(4, 'Eastside Library', '101 Maple Ave, Cityville', '444-444-4444'),
(5, 'Uptown Library', '202 Pine St, Cityville', '555-555-5555');

INSERT INTO BookCopies (CopyID, BookID, BranchID, Status) VALUES
(1, 1, 1, 'Available'), (2, 1, 2, 'On Loan'), (3, 2, 1, 'Available'), (4, 2, 3, 'Lost'),
(5, 3, 2, 'Available'), (6, 3, 3, 'On Loan'), (7, 4, 4, 'Available'), (8, 4, 5, 'Reserved'),
(9, 5, 1, 'Available'), (10, 5, 2, 'Available'), (11, 6, 3, 'On Loan'), (12, 6, 4, 'Lost'),
(13, 7, 1, 'Available'), (14, 7, 5, 'On Loan'), (15, 8, 3, 'Reserved'), (16, 8, 4, 'Available'),
(17, 9, 2, 'On Loan'), (18, 9, 5, 'Available'), (19, 10, 4, 'Available'), (20, 10, 1, 'On Loan');

INSERT INTO Members (MemberID, FirstName, LastName, Email, Phone, Address, MembershipDate) VALUES
(1, 'Alice', 'Smith', 'alice@example.com', '9876543210', '12 Green St, Cityville', '2023-01-01'),
(2, 'Bob', 'Jones', 'bob@example.com', '8765432109', '34 Oak St, Cityville', '2023-02-15'),
(3, 'Charlie', 'Brown', 'charlie@example.com', '7654321098', '56 Pine St, Cityville', '2023-03-10'),
(4, 'Diana', 'Williams', 'diana@example.com', '6543210987', '78 Maple Ave, Cityville', '2023-04-20'),
(5, 'Ethan', 'Harris', 'ethan@example.com', '5432109876', '90 Elm St, Cityville', '2023-05-05');
delete from Members;
INSERT INTO Issue (IssueID, CopyID, MemberID, LoanDate, DueDate, ReturnDate) VALUES
(1, 2, 1, '2024-03-01', '2024-03-15', NULL),
(2, 6, 2, '2024-02-20', '2024-03-05', '2024-03-06'),
(3, 11, 3, '2024-03-10', '2024-03-25', NULL),
(4, 14, 4, '2024-02-25', '2024-03-11', '2024-03-10'),
(5, 17, 5, '2024-03-05', '2024-03-20', NULL);
delete from Issue;
INSERT INTO Reservations (ReservationID, CopyID, MemberID, ReservationDate, Status) VALUES
(1, 8, 3, '2024-03-01', 'Active'),
(2, 15, 7, '2024-02-28', 'Completed'),
(3, 12, 9, '2024-03-05', 'Cancelled');
delete from Reservations;
INSERT INTO Fines (FineID, MemberID, IssueID, Amount, DateIssued, DatePaid) VALUES
(1, 1, 1, 50.00, '2024-03-16', NULL),
(2, 3, 3, 30.00, '2024-03-26', NULL),
(3, 5, 5, 20.00, '2024-03-21', '2024-03-22');
delete from Fines;
INSERT INTO Librarians (LibrarianID, FirstName, LastName, Email, Phone, BranchID) VALUES
(1, 'Liam', 'Anderson', 'liam@example.com', '555-000-0001', 1),
(2, 'Emma', 'Johnson', 'emma@example.com', '555-000-0002', 2),
(3, 'Noah', 'White', 'noah@example.com', '555-000-0003', 3),
(4, 'Olivia', 'Martinez', 'olivia@example.com', '555-000-0004', 4),
(5, 'William', 'Brown', 'william@example.com', '555-000-0005', 5);

INSERT INTO BookReviews (ReviewID, BookID, MemberID, Rating, Comment, ReviewDate) VALUES
(1, 1, 1, 5, 'An excellent read on dystopian society.', '2024-03-10'),
(2, 3, 2, 4, 'Magical and adventurous!', '2024-03-12'),
(3, 5, 3, 3, 'A bit overrated but well-written.', '2024-03-15'),
(4, 8, 4, 5, 'A futuristic masterpiece.', '2024-03-18'),
(5, 10, 5, 4, 'A chilling horror story.', '2024-03-22');

delete from BookReviews;
SELECT @@sql_mode;
SELECT VERSION();
select * from Reservations;
delete from BookAuthors;
delete from authors;
delete from bookauthors;
delete from bookcopies;
delete from bookreviews;
delete from categories;
delete from books;
delete from librarians;
delete from librarybranches;
delete from members;
delete from issue;
delete from fines;
delete from publishers;
delete from reservations;

SELECT * FROM Members WHERE MemberID = 1;
SELECT * FROM BookCopies WHERE CopyID = 1;
INSERT INTO Reservations (ReservationID, CopyID, MemberID, ReservationDate, Status) VALUES
(1, 1, 1, '2024-03-01', 'Active'),
(2, 2, 2, '2024-02-28', 'Completed'),
(3, 3, 3, '2024-03-05', 'Cancelled');

USE LibraryManagement;
-- Stress Testing for 1NF
--  Step 1: Check for Multi-Valued Attributes

-- Books Table (Checking for multi-valued attributes in Summary)
SELECT * FROM Books WHERE Summary LIKE '%,%';
UPDATE Books 
SET Summary = REPLACE(Summary, ',', '') 
WHERE BookID = 20;

-- Authors Table (Checking for multi-valued names or bio issues)
SELECT * FROM Authors WHERE FirstName LIKE '%,%' OR LastName LIKE '%,%' OR Bio LIKE '%,%';



-- Publishers Table (Checking for multiple contact details)
SELECT * FROM Publishers WHERE Phone LIKE '%,%' OR Address LIKE '%,%';
SELECT PublisherID, PublisherName, Address FROM Publishers;

-- Categories Table (Ensuring categories are atomic)
SELECT * FROM Categories WHERE CategoryName LIKE '%,%';

-- BookAuthors Table (Checking for multi-valued author-book relations)
SELECT * FROM BookAuthors WHERE BookID LIKE '%,%' OR AuthorID LIKE '%,%';

-- LibraryBranches Table (Checking for multiple addresses or contacts)
SELECT * FROM LibraryBranches WHERE Address LIKE '%,%' OR Phone LIKE '%,%';
ALTER TABLE LibraryBranches ADD COLUMN City VARCHAR(100);
UPDATE LibraryBranches
SET City = TRIM(SUBSTRING_INDEX(Address, ',', -1))
WHERE Address LIKE '%,%';
UPDATE LibraryBranches
SET Address = TRIM(SUBSTRING_INDEX(Address, ',', 1))
WHERE Address LIKE '%,%';
SELECT BranchID, BranchName, Address, City, Phone FROM LibraryBranches;



-- BookCopies Table (Ensuring single-value status)
SELECT * FROM BookCopies WHERE Status LIKE '%,%';

-- Members Table (Checking for multiple contact details)
SELECT * FROM Members WHERE Phone LIKE '%,%' OR Email LIKE '%,%' OR Address LIKE '%,%';
ALTER TABLE Members ADD COLUMN City VARCHAR(100);
UPDATE Members
SET City = TRIM(SUBSTRING_INDEX(Address, ',', -1))
WHERE Address LIKE '%,%';
UPDATE Members
SET Address = TRIM(SUBSTRING_INDEX(Address, ',', 1))
WHERE Address LIKE '%,%';
SELECT MemberID, FirstName, LastName, Email, Phone, Address, City, MembershipDate FROM Members;



-- Issue Table (Checking if Status column allows multiple values)
SELECT * FROM Issue WHERE ReturnDate LIKE '%,%';

-- Reservations Table (Checking for multiple status values)
SELECT * FROM Reservations WHERE Status LIKE '%,%';

-- Fines Table (Checking for multiple Amount values)
SELECT * FROM Fines WHERE Amount LIKE '%,%';

-- Librarians Table (Checking for multiple roles or contacts)
SELECT * FROM Librarians WHERE Phone LIKE '%,%' OR Email LIKE '%,%';

-- BookReviews Table (Ensuring a single review per row)
SELECT * FROM BookReviews WHERE Rating LIKE '%,%' OR Comment LIKE '%,%';

-- Step 2: Check for Missing Primary Keys
-- This ensures that all tables have a Primary Key to uniquely identify each row.
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'LibraryManagement'
AND TABLE_NAME NOT IN (
    SELECT DISTINCT TABLE_NAME
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
    WHERE CONSTRAINT_NAME = 'PRIMARY'
);
-- Primary Key Check (Step 1):

-- You executed a query to check for tables without a primary key.

-- The result is empty, which means all tables have primary keys. ✅
-- Step 3: Check for Repeating Groups
-- This ensures no table contains columns ending in _1, _2, _3, which indicates repeating groups (violating 1NF).
-- Expected Result: If this query returns no results, then 1NF is not violated
SELECT COLUMN_NAME, TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'LibraryManagement'
AND COLUMN_NAME REGEXP '_[0-9]$';

SELECT COLUMN_NAME, TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'LibraryManagement'
AND COLUMN_NAME NOT IN (
    SELECT COLUMN_NAME
    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = 'LibraryManagement'
);

-- Check if any AuthorID is dependent only on BookID (for BookAuthors table)

SELECT *
FROM BookAuthors
WHERE BookID IN (
    SELECT BookID FROM BookAuthors 
    GROUP BY BookID 
    HAVING COUNT(DISTINCT AuthorID) > 1
);


SELECT CopyID 
FROM Reservations 
GROUP BY CopyID 
HAVING COUNT(DISTINCT ReservationDate) > 1;

SELECT CopyID 
FROM Issue 
GROUP BY CopyID 
HAVING COUNT(DISTINCT ReturnDate) > 1;

-- Output:

-- "0 rows returned" → No CopyID has multiple return dates.

-- 🔍 Interpretation & 2NF Analysis:
-- Issue(CopyID, MemberID) suggests a many-to-many relationship between CopyID (a specific copy of a book) and MemberID (who issued it).

-- If no CopyID has multiple ReturnDate values, it means:

-- ReturnDate is not varying independently for the same CopyID (at least in this dataset).

-- No partial dependency on CopyID, implying no immediate 2NF violation based on this check

-- =============================================
-- Stress Test Script for Library Management Database
-- Includes Bulk INSERT, UPDATE, DELETE & Cascade Tests
-- =============================================

-- =============================================
-- Step 1: Insert 20 Records into Each Table
-- =============================================

-- Insert operations for various tables
INSERT INTO Authors (AuthorID, FirstName, LastName, Bio) VALUES
(1, 'John', 'Doe', 'Fiction writer'),
(2, 'Jane', 'Smith', 'Sci-fi author');

INSERT INTO Publishers (PublisherID, PublisherName, Address, Phone) VALUES
(1, 'Pearson', '123 Main St', '1234567890');

INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Fiction'),
(2, 'Science Fiction');

-- changing the AuthorID, PublisherID and CategoryID
INSERT INTO Authors (AuthorID, FirstName, LastName, Bio) VALUES
(23, 'John', 'Doe', 'Fiction writer'),
(25, 'Jane', 'Smith', 'Sci-fi author');
select * from Authors;

INSERT INTO Publishers (PublisherID, PublisherName, Address, Phone) VALUES
(30, 'Pearson', '123 Main St', '1234567890');
select * from Publishers;

INSERT INTO Categories (CategoryID, CategoryName) VALUES
(24, 'Sci-fi'),
(27, 'Literature');
select * from Categories;



-- UPDATE stress test
-- UPDATE Books SET Summary = 'Updated Fictional Story' WHERE BookID = 1;
-- Step 1: Update Summary in Books Table
UPDATE Books 
SET Summary = 'Updated Fictional Story' 
WHERE BookID = 1;

-- Step 2: Display Updated Record from Books Table
SELECT * FROM Books WHERE BookID = 1;

-- Step 3: Display Relevant Child Records Referencing BookID
-- Check BookCopies table if it has BookID
SELECT BC.*, B.Summary 
FROM BookCopies BC
JOIN Books B ON BC.BookID = B.BookID
WHERE BC.BookID = 1;

-- Check Issue table if it references BookID (if applicable)
SELECT I.*, B.Summary 
FROM Issue I
JOIN BookCopies BC ON I.CopyID = BC.CopyID
JOIN Books B ON BC.BookID = B.BookID
WHERE B.BookID = 1;



-- DELETE specific records
DELETE FROM Reservations WHERE ReservationID = 1;
DELETE FROM Issue WHERE IssueID = 1;

-- Display changes after deletion in Reservations and Issue tables
SELECT * FROM Reservations WHERE ReservationID = 1;  -- Should return 0 rows
SELECT * FROM Issue WHERE IssueID = 1;  -- Should return 0 rows

-- DELETE a book and check cascade effect
DELETE FROM Books WHERE BookID = 1;

-- Display changes in Books table (to confirm deletion)
SELECT * FROM Books WHERE BookID = 1;  -- Should return 0 rows

-- Display changes in BookCopies (child table)
SELECT * FROM BookCopies WHERE BookID = 1;  -- Should return 0 rows if cascading worked

-- Display changes in BookAuthors (child table)
SELECT * FROM BookAuthors WHERE BookID = 1;  -- Should return 0 rows if cascading worked

-- Display remaining Books, BookCopies, and BookAuthors records
SELECT * FROM Books;
SELECT * FROM BookCopies;
SELECT * FROM BookAuthors;

-- Most Borrowed Books
-- Find the top 5 most issued books in the library.
SELECT B.Title, COUNT(I.IssueID) AS Total_Issues
FROM Issue I
JOIN BookCopies BC ON I.CopyID = BC.CopyID
JOIN Books B ON BC.BookID = B.BookID
GROUP BY B.Title
ORDER BY Total_Issues DESC
LIMIT 5;

-- Books That Are Reserved but Never Issued
-- Identify books that have been reserved but never actually borrowed.
SELECT B.Title, COUNT(R.ReservationID) AS Total_Reservations
FROM Reservations R
JOIN BookCopies BC ON R.CopyID = BC.CopyID
JOIN Books B ON BC.BookID = B.BookID
WHERE R.CopyID NOT IN (SELECT DISTINCT CopyID FROM Issue)
GROUP BY B.Title
ORDER BY Total_Reservations DESC;

-- Category-wise Book Distribution
-- Find how many books belong to each category.
SELECT C.CategoryName, COUNT(B.BookID) AS Total_Books
FROM Books B
JOIN Categories C ON B.CategoryID = C.CategoryID
GROUP BY C.CategoryName
ORDER BY Total_Books DESC;


