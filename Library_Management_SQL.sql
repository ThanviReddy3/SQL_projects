CREATE DATABASE project;
USE project;

CREATE TABLE publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress VARCHAR(255),
    publisher_PublisherPhone VARCHAR(255)
);


CREATE TABLE borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress VARCHAR(255),
    borrower_BorrowerPhone VARCHAR(255));


CREATE TABLE librarybranch (
    library_branch_BranchID INT PRIMARY KEY auto_increment,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress VARCHAR(255)
);


CREATE TABLE books (
    book_BookID INT PRIMARY KEY AUTO_INCREMENT,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName)
        REFERENCES publisher (publisher_PublisherName)
) AUTO_INCREMENT = 1;


CREATE TABLE authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID)
        REFERENCES books (book_BookID)
);


CREATE TABLE book_copies (
    book_copies_CopiesID INT PRIMARY KEY not null AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID)
        REFERENCES books (book_BookID),
    FOREIGN KEY (book_copies_BranchID)
        REFERENCES librarybranch(library_branch_BranchID)
);
select * from book_copies;

CREATE TABLE bookloans(
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID)
        REFERENCES books (book_BookID) ON DELETE CASCADE,
    FOREIGN KEY (book_loans_BranchID)
        REFERENCES librarybranch (library_branch_BranchID) ON DELETE CASCADE,
    FOREIGN KEY (book_loans_CardNo)
        REFERENCES borrower (borrower_CardNo) ON DELETE CASCADE
);

-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
SELECT b.book_bookID, b.book_title, c.book_copies_no_of_copies as noofcopies
FROM books AS b
JOIN book_copies AS c ON b.book_bookId = c.book_copies_bookid
JOIN librarybranch AS l ON c.book_copies_branchID = l.library_branch_branchid
WHERE b.book_title = 'The Lost Tribe' AND l.library_branch_branchname = 'Sharpstown'
GROUP BY b.book_bookID, b.book_title, c.book_copies_no_of_copies;

-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT book_bookid, book_copies_branchid, book_copies_no_of_copies
FROM books
JOIN book_copies ON book_bookid = book_copies_bookid
WHERE book_title = 'The Lost Tribe'
GROUP BY book_bookid, book_copies_branchid, book_copies_no_of_copies;

-- Retrieve the names of all borrowers who do not have any books checked out.
SELECT b.borrower_borrowername
FROM borrower AS b
WHERE NOT EXISTS (
    SELECT *
    FROM bookloans AS l
    WHERE b.borrower_cardno = l.book_loans_cardno
);

-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18(2018/2/3), retrieve the book title, the borrower's name, and the borrower's address. 
SELECT bk.book_title, bo.borrower_borrowerName, bo.borrower_borroweraddress, lb.library_branch_branchname
FROM bookloans AS bl
JOIN borrower AS bo ON bl.book_loans_cardno = bo.borrower_cardno
JOIN books AS bk ON bl.book_loans_bookid = bk.book_bookId
JOIN librarybranch AS lb ON bl.book_loans_branchId = lb.library_branch_branchid
WHERE lb.library_branch_branchname = 'Sharpstown' AND bl.book_loans_duedate = '2018-02-03';

-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select library_branch_branchname,count(*) as eachbranch from librarybranch
join bookloans on library_branch_branchid = book_loans_branchid
group by book_loans_branchid, library_branch_branchid;

-- Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select borrower_borrowername, borrower_borrowerAddress, book_loans_cardno, count(*) as countofbooks from borrower
join bookloans on borrower_cardno = book_loans_cardno
group by book_loans_cardno
having countofbooks > 5;


-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT book_title, library_branch_branchname, book_copies_no_of_copies * COUNT(*) as centralcopies
FROM authors
JOIN books ON book_authors_bookid = book_bookid
JOIN book_copies ON book_bookid = book_copies_bookid
JOIN librarybranch ON book_copies_branchid = library_branch_branchid
WHERE book_authors_authorname = 'Stephen King' AND library_branch_branchname = 'Central'
GROUP BY book_title, library_branch_branchname, book_copies_no_of_copies;
