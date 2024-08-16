	-- Create the Authors table to store information about authors.
	CREATE TABLE Authors (
		AuthorID serial PRIMARY KEY,
		FirstName varchar(50) NOT NULL,
		LastName varchar(50) NOT NULL
	);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Create the Books table to store information about books.
	CREATE TABLE Books (
		BookID serial PRIMARY KEY,
		Title varchar(255) NOT NULL,
		ISBN varchar(20) UNIQUE NOT NULL,
		AuthorID integer REFERENCES Authors(AuthorID),
		PublicationYear integer,
		AvailableCopies integer DEFAULT 1
	);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create the Members table to store information about library members.
	CREATE TABLE Members (
		MemberID serial PRIMARY KEY,
		FirstName varchar(50) NOT NULL,
		LastName varchar(50) NOT NULL,
		Email varchar(100) UNIQUE NOT NULL,
		PhoneNumber varchar(15),
		RegistrationDate timestamp DEFAULT NOW()
	);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Create the Transactions table to track book borrow and return activities.
	CREATE TABLE Transactions (
		TransactionID serial PRIMARY KEY,
		MemberID integer REFERENCES Members(MemberID),
		BookID integer REFERENCES Books(BookID),
		BorrowDate timestamp NOT NULL,
		ReturnDate timestamp
	);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->	Create a method to add new authors to the "Authors" table.
	-- Example SQL function to add an author
	CREATE OR REPLACE FUNCTION add_author(
		first_name varchar(50),
		last_name varchar(50)
	) RETURNS void AS $$
	BEGIN
		INSERT INTO Authors (FirstName, LastName) VALUES (first_name, last_name);
	END;
	$$ LANGUAGE plpgsql;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> add multiple authors to the Authors table
SELECT add_author('Jane', 'Austen');
SELECT add_author('Charles', 'Dickens'),add_author('Mark', 'Twain'),add_author('J.K.', 'Rowling'),add_author('George', 'Orwell'),add_author('Ernest', 'Hemingway'),
	   add_author('F. Scott', 'Fitzgerald'),add_author('Agatha', 'Christie'),add_author('Leo', 'Tolstoy'),add_author('Stephen', 'King'),add_author('Emily', 'Bronte'),
	   add_author('William', 'Shakespeare'),add_author('Arthur', 'Conan Doyle'),add_author('H.G.', 'Wells'),add_author('Virginia', 'Woolf'),add_author('Oscar', 'Wilde'),
	   add_author('John', 'Steinbeck'),add_author('George', 'Eliot'),add_author('Mary', 'Shelley'),add_author('Harper', 'Lee'),add_author('Jules', 'Verne'),add_author('Gabriel Garcia', 'Marquez'),
	   add_author('Salman', 'Rushdie'),add_author('Toni', 'Morrison'),add_author('Kurt', 'Vonnegut'),add_author('Edgar Allan', 'Poe'),add_author('Aldous', 'Huxley'),
	   add_author('Franz', 'Kafka'),add_author('Albert', 'Camus'),add_author('Maya', 'Angelou');
SELECT * FROM Authors;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	Create a method to add new books to the "Books" table.
	
*/
Drop function add_book;
	CREATE OR REPLACE FUNCTION add_book(
		title varchar(255),
		isbn varchar(20),
		author_id integer,
		publication_year integer,
		copies_available integer
	) RETURNS integer AS $$
	DECLARE
		book_id integer;
	BEGIN
		-- Insert the book into the Books table and return its ID
		INSERT INTO Books (Title, ISBN, AuthorID, PublicationYear, AvailableCopies)
		VALUES (title, isbn, author_id, publication_year, copies_available)
		RETURNING BookID INTO book_id;

		-- Return the ID of the newly inserted book
		RETURN book_id;
	END;
	$$ LANGUAGE plpgsql;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->ADDING BOOKS
SELECT add_book('Pride and Prejudice', '9780141439518', 1, 1813, 5);
SELECT add_book('Great Expectations', '9780141439563', 2, 1861, 8);
SELECT add_book('The Adventures of Tom Sawyer', '9780199216263', 3, 1876, 10);
SELECT add_book('Harry Potter and the Sorcerer''s Stone', '9780590353427', 4, 1997, 12);
SELECT add_book('1984', '9780451524935', 5, 1949, 6);
SELECT add_book('The Old Man and the Sea', '9780684801223', 6, 1952, 7);
SELECT add_book('The Great Gatsby', '9780743273565', 7, 1925, 9);
SELECT add_book('Murder on the Orient Express', '9780062693662', 8, 1934, 5);
SELECT add_book('War and Peace', '9780062095661', 9, 1869, 8);
SELECT add_book('The Shining', '9780307743657', 10, 1977, 6);
SELECT add_book('Wuthering Heights', '9780141439556', 11, 1847, 5);
SELECT add_book('Hamlet', '9780743477123', 12, 1603, 7);
SELECT add_book('The Hound of the Baskervilles', '9780486282145', 13, 1902, 4);
SELECT add_book('The War of the Worlds', '9780486295060', 14, 1898, 6);
SELECT add_book('Mrs. Dalloway', '9780151009985', 15, 1925, 3);
SELECT add_book('The Picture of Dorian Gray', '9780141442464', 16, 1890, 7);
SELECT add_book('Of Mice and Men', '9780140186420', 17, 1937, 5);
SELECT add_book('Middlemarch', '9780141439549', 18, 1871, 8);
SELECT add_book('Frankenstein', '9780486282114', 19, 1818, 6);
SELECT add_book('To Kill a Mockingbird', '9780061120084', 20, 1960, 9);
SELECT add_book('Twenty Thousand Leagues Under the Sea', '9780140449273', 21, 1870, 7);
SELECT add_book('Love in the Time of Cholera', '9780307389732', 22, 1985, 5);
SELECT add_book('Midnight''s Children', '9780099578512', 23, 1981, 7);
SELECT add_book('Beloved', '9781400033416', 24, 1987, 4);
SELECT add_book('Moby-Dick', '9780142437247', 25, 1851, 6);
SELECT add_book('The Catcher in the Rye', '9780316769488', 26, 1951, 7);
SELECT add_book('The Raven', '9780486269993', 27, 1845, 3);
SELECT add_book('Brave New World', '9780060850524', 28, 1932, 8);
SELECT add_book('The Metamorphosis', '9780553213690', 29, 1915, 4);
SELECT add_book('The Stranger', '9780679720201', 30, 1942, 5);

SELECT * FROM Books ORDER BY bookID;
SELECT * FROM Transactions ORDER BY TransactionID;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->Create a method to register new library members in the "Members" table.

	CREATE OR REPLACE FUNCTION register_member(
		first_name varchar(50),
		last_name varchar(50),
		email varchar(100),
		phone_number varchar(15)
	) RETURNS void AS $$
	BEGIN
		INSERT INTO Members (FirstName, LastName, Email, PhoneNumber)
		VALUES (first_name, last_name, email, phone_number);
	END;
	$$ LANGUAGE plpgsql;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Adding Members in table 
SELECT register_member('Meetkumar', 'Chavda', 'meetkumar.chavda@gmail.com', '9275106954');
SELECT register_member('Rajesh', 'Sharma', 'rajesh.sharma@example.com', '1234567890');
SELECT register_member('Priya', 'Verma', 'priya.verma@example.com', '9876543210');
SELECT register_member('Amit', 'Patel', 'amit.patel@example.com', '5555555555');
SELECT register_member('Anjali', 'Gupta', 'anjali.gupta@example.com', '6666666666');
SELECT register_member('Nitin', 'Kumar', 'nitin.kumar@example.com', '7777777777');
SELECT register_member('Sneha', 'Singh', 'sneha.singh@example.com', '8888888888');
SELECT register_member('Rahul', 'Rajput', 'rahul.rajput@example.com', '9999999999');
SELECT register_member('Kavita', 'Yadav', 'kavita.yadav@example.com', '1111111111');
SELECT register_member('Manish', 'Shukla', 'manish.shukla@example.com', '2222222222');
SELECT register_member('Renuka', 'Mishra', 'renuka.mishra@example.com', '3333333333');
SELECT register_member('Vikram', 'Garg', 'vikram.garg@example.com', '4444444444');
SELECT register_member('Pooja', 'Sharma', 'pooja.sharma@example.com', '5555555555');
SELECT register_member('Rohit', 'Verma', 'rohit.verma@example.com', '6666666666');
SELECT register_member('Shivani', 'Gupta', 'shivani.gupta@example.com', '7777777777');
SELECT register_member('Deepak', 'Patel', 'deepak.patel@example.com', '8888888888');
SELECT register_member('Swati', 'Soni', 'swati.soni@example.com', '9999999999');
SELECT register_member('Anil', 'Yadav', 'anil.yadav@example.com', '1111111111');
SELECT register_member('Madhu', 'Shukla', 'madhu.shukla@example.com', '2222222222');
SELECT register_member('Raj', 'Mishra', 'raj.mishra@example.com', '3333333333');
SELECT register_member('Aarti', 'Garg', 'aarti.garg@example.com', '4444444444');
SELECT register_member('Sanjay', 'Kumar', 'sanjay.kumar@example.com', '5555555555');
SELECT register_member('Anita', 'Gupta', 'anita.gupta@example.com', '6666666666');
SELECT register_member('Vivek', 'Verma', 'vivek.verma@example.com', '7777777777');
SELECT register_member('Neetu', 'Sharma', 'neetu.sharma@example.com', '8888888888');
SELECT register_member('Vikas', 'Yadav', 'vikas.yadav@example.com', '9999999999');
SELECT register_member('Sarita', 'Soni', 'sarita.soni@example.com', '1111111111');
SELECT register_member('Ajay', 'Kumar', 'ajay.kumar@example.com', '2222222222');
SELECT register_member('Rita', 'Gupta', 'rita.gupta@example.com', '3333333333');
SELECT register_member('Sunil', 'Verma', 'sunil.verma@example.com', '4444444444');
SELECT register_member('Anjana', 'Sharma', 'anjana.sharma@example.com', '5555555555');
SELECT register_member('Suresh', 'Yadav', 'suresh.yadav@example.com', '6666666666');

SELECT * FROM Members;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->Start from here 
/*
	Create a method to allow members to borrow books.
	This method should update the "Transactions" table and 
	decrement the available copies in the "BookBranches" table.
*/

	CREATE OR REPLACE FUNCTION borrow_book(
		member_id integer,
		book_id integer,
		borrow_date timestamp
	) RETURNS void AS $$
	BEGIN
		 -- Check if there are available copies of the book
    IF (SELECT AvailableCopies FROM Books WHERE BookID = book_id) > 0 THEN
		 -- Insert the transaction record
		INSERT INTO Transactions (MemberID, BookID, BorrowDate)
		VALUES (member_id, book_id, borrow_date);
		-- Update the available copies count
		UPDATE Books
		SET AvailableCopies = AvailableCopies - 1
		WHERE BookID = book_id;
	ELSE
        -- Raise an exception or return an error message
        RAISE EXCEPTION 'No available copies of the book';
    END IF;
	END;
	$$ LANGUAGE plpgsql;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->Lets's Borrow some Books
SELECT borrow_book (1,41,'2023-08-04');
SELECT borrow_book (2,42,'2023-07-01');
SELECT borrow_book (3,42,'2023-10-04 15:30:00');
SELECT borrow_book (4,42,'2023-10-04 15:30:00');
SELECT borrow_book (5,42,'2023-10-04 15:30:00');
SELECT borrow_book (6,42,'2023-10-04 15:30:00');
SELECT borrow_book (7,43,'2023-10-04');
SELECT borrow_book (8,43,'2023-10-04 15:30:00');

SELECT * FROM Books ORDER BY bookID;
SELECT * FROM Transactions ORDER BY TransactionID;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
	Create a method to allow members to return books.
	This method should update the "Transactions" table and 
	increment the available copies in the "BookBranches" table.
*/

	CREATE OR REPLACE FUNCTION return_book(
		transaction_id integer,
		return_date timestamp
	) RETURNS void AS $$
	BEGIN
		
		UPDATE Transactions
		SET ReturnDate = return_date
		WHERE TransactionID = transaction_id;

		-- Update the available copies
		UPDATE Books
		SET AvailableCopies = AvailableCopies + 1
		WHERE BookID = (SELECT BookID FROM Transactions WHERE TransactionID = transaction_id);
	END;
	$$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->RETURNING THE BORROWED BOOK
SELECT return_book( 4 , '2023-08-22');
SELECT return_book( 5 , '2023-09-30');
SELECT return_book( 6 , '2023-10-04 20:33:00');
SELECT return_book( 7 , '2023-10-04 15:190:00');
SELECT return_book( 8 , '2023-10-04 19:30:00');
SELECT return_book( 9 , '2023-10-04 17:50:00');
SELECT return_book( 10 , '2023-10-04 15:20:00');


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------



