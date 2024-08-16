
-- Created the 4 roles 
	Create user Meetkumar with password 'asdfg16captainm';
	Create user Customer WITH PASSWORD 'Customer';
	Create user Employee WITH PASSWORD 'Employee';
	Create user Manager WITH PASSWORD 'Manager';
------------------------------------------------------------------------------------------------------------------------------------------------	
	--TO DROP 
	--DROP TABLE Customer CASCADE;
------------------------------------------------------------------------------------------------------------------------------------------------	
	-- Create the Customer table
	CREATE TABLE Customer (
		CustomerID serial PRIMARY KEY,
		FirstName varchar(50) NOT NULL,
		LastName varchar(50) NOT NULL,
		DateOfBirth date NOT NULL,
		Gender varchar(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
		ContactNumber varchar(15),
		Email varchar(150) UNIQUE,
		Username varchar(50) UNIQUE,
		Password varchar(255) NOT NULL,
		LastLoginDateTime timestamp,
		RegistrationDateTime timestamp DEFAULT NOW(),
		KYCStatus varchar(20) DEFAULT 'Not Verified'
	);
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
	-- Function to validate email format
	CREATE OR REPLACE FUNCTION is_valid_email(email varchar) RETURNS boolean AS $$
	BEGIN
	RETURN email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$';
	END;
	$$ LANGUAGE plpgsql;
------------------------------------------------------------------------------------------------------------------------------------------------
	-- Function to validate phone number format (10 digits)
	CREATE OR REPLACE FUNCTION is_valid_phone(phone varchar) RETURNS boolean AS $$
	BEGIN
		RETURN phone ~ '^\d{10}$';
	END;
	$$ LANGUAGE plpgsql;
------------------------------------------------------------------------------------------------------------------------------------------------
	-- Function to validate password format (1 upper, 1 lower, 1 digit, 1 special character, 8-15 characters)
	CREATE OR REPLACE FUNCTION is_valid_password(password varchar) RETURNS boolean AS $$
	BEGIN
		RETURN password ~ '^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!])[A-Za-z\d@#$%^&+=!]{8,15}$';
	END;
	$$ LANGUAGE plpgsql;
	------------------------------------------------------------------------------------------------------------------------------------------------
	CREATE OR REPLACE FUNCTION username_exists(c_username VARCHAR) RETURNS BOOLEAN AS $$
	BEGIN
		RETURN NOT EXISTS (SELECT 1 FROM Customer WHERE Customer.Username = c_username);
	END;
	$$ LANGUAGE plpgsql;
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------	
	--Drop Function
	DROP FUNCTION create_customer;
	DROP FUNCTION username_exists(c_username VARCHAR);
	DROP FUNCTION Add_branch;
------------------------------------------------------------------------------------------------------------------------------------------------	
------------------------------------------------------------------------------------------------------------------------------------------------
----> Function to Add The Customer's with Validation
	CREATE OR REPLACE FUNCTION create_customer (
			c_first_name VARCHAR,
			c_last_name VARCHAR,
			c_date_of_birth DATE,
			c_gender VARCHAR,
			c_contact_number VARCHAR,
			c_email VARCHAR,
			c_username VARCHAR,
			c_password VARCHAR
	)
	RETURNS INTEGER AS $$
	DECLARE
		new_customer_id INTEGER;
		user_valid  boolean;
		email_valid boolean;
		phone_valid boolean;
		password_valid boolean;
	BEGIN
			-- Check if the user already Exists or not
			user_valid := username_exists(c_username);
			-- Check if the email is valid
    		email_valid := is_valid_email(c_email);
			-- Check if the phone number is valid
    		phone_valid := is_valid_phone(c_contact_number);
			 -- Check if the password is valid
    		password_valid := is_valid_password(c_password);
		-- If any validation fails, return -1 as an error code
		IF NOT (user_valid AND email_valid AND phone_valid AND password_valid) THEN
			RETURN -1;
		END IF;

		-- Insert the customer record
		 INSERT INTO Customer (FirstName,LastName,DateOfBirth,Gender,ContactNumber,Email,Username,Password,RegistrationDateTime)
		 VALUES (c_first_name,c_last_name,c_date_of_birth,c_gender,c_contact_number,c_email,c_username,c_password, NOW())-- Use NOW() to get the current timestamp
		 RETURNING CustomerID INTO new_customer_id;
		
		RETURN new_customer_id;
		
	END;
	$$ LANGUAGE plpgsql;	
	
	SELECT * FROM CUSTOMER;
------------------------------------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------------------------------------------
---->INSERTING DATA INTO CUSTOMER TABLE USIG STORED PROCEDURE
	SELECT create_customer('Deep'	,'Patel'	,'1990-01-15'	,'Male'	,'1234567890'	,'deep@lju.com','DpPatel','P@ssw0rd');
	SELECT create_customer('Meet'	,'Chavda'	,'2005-08-07'	,'Male'	,'9275106954'	,'meet@gmail.com','M1E2T1','M16log100@');
	SELECT create_customer('Riya'	,'Chavda'	,'2005-08-07'	,'Female','8000696354'	,'riyaah@gmail.com','riya143','Riya143$');
	SELECT create_customer('Mansi'	,'Patel'	,'2004-02-27'	,'Female','7689656354'	,'mansiP@yahoo.com','Mp4227','mansi1P27#');
	SELECT create_customer('Rajesh'	,'Kumar'	,'1995-04-10'	,'Male'	,'9874043410'	,'rajeshK@ljku.edu.in','RajK','Rajraj1#'),
       create_customer('Neha'	,'Sharma'	,'2000-07-22'	,'Female'	,'8765432109'	,'neha@ljku.edu.in','NehaS','N@e@Has1'),
       create_customer('Amit'	,'Verma'	,'1988-12-05'	,'Male'		,'7654321098'	,'amit@outlook.com','AmitV','Verma%123'),
       create_customer('Priya'	,'Singh'	,'1999-03-15'	,'Female'	,'6543210987'	,'priya@gmail.com','PriyaS','PriyaK@45'),
       create_customer('Sandeep','Mishra'	,'2001-09-25'	,'Male'		,'7432109876'	,'sandeep@ljku.edu.in','SandeepM','SanD25&P'),
       create_customer('Kavita' ,'Gupta'	,'1994-11-30'	,'Female'	,'9321098765'	,'kavita@gmail.com','KavitaG','KavitG1#5'),
       create_customer('Anil'	,'Yadav'	,'2000-06-12'	,'Male'		,'9210987654'	,'anil@example.com','AnilY','%@5an$ilIM'),
       create_customer('Pooja'	,'Joshi'	 ,'1998-08-18'	,'Female'	,'9909876543'	,'pooja@ljku.edu.in','PoojaJ','P@@jAJ00shi'),
       create_customer('Sanjay' ,'Srivastava','1996-10-05'	,'Male'		,'9798765432'	,'sanjay@example.com','SanjayS','P@ssw0rd9'),
       create_customer('Meera'	,'Pandey'	,'2003-02-28'	,'Female'	,'9988776655'	,'meera@example.com','MeeraP','PanD@ay16'),
       create_customer('Vikram'	,'Rajput'	,'1992-01-12'	,'Male'		,'8893746675'	,'vikram@outlook.com','VikramR','VR#w0rd11'),
       create_customer('Deepa'	,'Gupta'	,'1987-08-05'	,'Female'	,'9798636745'	,'deepa@deepu.com','DeepaG','DeGp$123'),
       create_customer('Neeta'	,'Shukla'	,'2003-03-07'	,'Female'	,'9565324533'	,'neeta@example.com','NeetaS','Neetu!42@'),
       create_customer('Rajat'	,'Tiwari'	,'1989-11-15'	,'Male'		,'6493353272'	,'rajat@outlook.com','RajatT','P@ssRajat15'),
       create_customer('Simran'	,'Malik'	,'1998-06-30'	,'Female'	,'9798721465'	,'simran@outlook.com','SimranM','P@ssw0rd16'),
       create_customer('Alok'	,'Shah'		,'1994-04-25'	,'Male'		,'7762190560'	,'alok@gmail.com','AlokS','P17Alok@!@#'),
       create_customer('Aarti'	,'Nair'		,'2002-09-17'	,'Female'	,'9798639869'	,'aarti@gmail.com','AartiN','@@ratI114'),
       create_customer('Sushil'	,'Rastogi'	,'1990-12-08'	,'Male'		,'9399838747'	,'sushil@ljku.edu.in','SushilR','S1ushilR#'),
       create_customer('Lata'	,'Menon'	,'1996-02-14'	,'Female'	,'8977822896'	,'lata@gmail.com','LataM','P@ssw0rdLata');
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	Drop table Branch CASCADE;
-- Create the Branch table
	CREATE TABLE Branch (
		BranchID INTEGER PRIMARY KEY,
		BranchName VARCHAR(100),
		Location VARCHAR(255),
		ContactNumber VARCHAR(15),
		ManagerID INTEGER
	);
	-- Add a foreign key constraint to the Branch table to reference the Employee table's EmployeeID
	ALTER TABLE Branch 
	ADD CONSTRAINT fk_branch_manager
	FOREIGN KEY (ManagerID)
	REFERENCES Employee(EmployeeID);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---> CREATED FUNCTION TO TACLE DUBLICASY OF BRANCES
CREATE OR REPLACE FUNCTION is_branch_exists(b_branch_name VARCHAR) RETURNS BOOLEAN AS $$
	BEGIN
		RETURN NOT EXISTS (SELECT 1 FROM Branch WHERE Branch.BranchName = b_branch_name);
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--->Created a Function to add Branche

CREATE OR REPLACE FUNCTION Add_branch(
	b_branchID INTEGER,
    b_branch_name VARCHAR,
    b_location VARCHAR,
    b_contact_number VARCHAR
)
RETURNS INTEGER AS $$
	DECLARE
		new_branch_id INTEGER;
		phone_valid boolean;
		banch_valid boolean;
	BEGIN
		--Check if the branch already exists or not 
		banch_valid :=is_branch_exists(b_branch_name);
		-- Check if the phone number is valid
		phone_valid := is_valid_phone(b_contact_number);
		IF NOT (banch_valid AND phone_valid) THEN
			RETURN -1;
		END IF;
		-- Insert the new branch
		INSERT INTO Branch (BranchID,BranchName, Location, ContactNumber)
		VALUES (b_branchID,b_branch_name, b_location, b_contact_number)
		RETURNING BranchID INTO new_branch_id;

		RETURN new_branch_id;
END;$$ 
LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TRUNCATE Branch CASCADE;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--->Adding Branches
SELECT Add_branch (1	,'Axis_Ahmedabad'		, 'Bopal' 			,'9898157899');
SELECT Add_branch (2	,'SBI_Ahmedabad'		, 'Sarkhej' 		,'9978452345'),
		Add_branch (3	,'SBI_Surat'			, 'Parle Point' 	,'9860468999'),
		Add_branch (4	,'ICIC_Ahmedabad'		, 'Bapunagar' 		,'9678153369'),
		Add_branch (5	,'IDFC_Surat'			, 'Dumas Beach' 	,'8765432109'),
		Add_branch (6	,'IDFC_Ahmedabad'		, 'Bopal'			,'8765832179'),
		Add_branch (7	,'Kotak_Ahmedabad'		, 'Bopal' 			,'9798721465'),
		Add_branch (8	,'Kotak_Surat'			, 'Parle Point' 	,'7845903424'),
		Add_branch (9	,'Axis_Surat'			, 'Ghod Dod Road'	,'9734997899'),
		Add_branch (10	,'PNB_Ahmedabad'		, 'Kankaria Lake' 	,'9498457859'),
		Add_branch (11	,'Yes_Bank_Ahmedabad'	, 'Law Garden' 		,'9248154499'),
		Add_branch (12	,'BOB_Ahmedabad'		, 'Lal Darwaja' 	,'7895137394'),
		Add_branch (13	,'HDFC_Ahmedabad'		, 'Lal Darwaja' 	,'6898487899'),
		Add_branch (14	,'UCO_Ahmedabad'		, 'Lal Darwaja' 	,'6401535995'),
		Add_branch (15	,'BOB_Surat'			, 'Chowk Bazaar' 	,'7898147899'),
		Add_branch (16	,'BOI_Surat'			, 'Dumas Beach' 	,'7598157468'),
		Add_branch (17	,'PNB_Surat'			, 'Parle Point' 	,'9425157834'),
		Add_branch (18	,'Bandhan_Bank_Surat'	, 'Parle Point' 	,'9815467899');
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------					 
	SELECT * FROM Branch ORDER BY branchID;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create the Account table
	CREATE TABLE Account (
		AccountID SERIAL PRIMARY KEY,
		AccountNumber VARCHAR(20) UNIQUE,
		AccountType VARCHAR(20) CHECK(AccountType IN ('Saving', 'Current', 'Fix-Deposite')),
		CustomerID INTEGER REFERENCES Customer(CustomerID),
		BranchID INTEGER REFERENCES Branch(BranchID),
		Balance DECIMAL(10, 2) Default 0,
		Status VARCHAR(20) Default 'Active' ,
		OpenedDate timestamp DEFAULT NOW(),
		ClosedDate timestamp,
		InterestRate DECIMAL(5, 2) Default 6.8,
		LastTransactionDateTime TIMESTAMP
	);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SELECT * FROM Account ORDER BY AccountID;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------					 
--->FUNCTION TO CREATE ACCOUNT 
	CREATE OR REPLACE FUNCTION Add_Account(
		p_AccountNumber VARCHAR(20),
		p_AccountType VARCHAR(20),
		p_CustomerID INTEGER,
		p_BranchID INTEGER,
		p_Balance DECIMAL(10, 2) DEFAULT 0,
		p_Status VARCHAR(20) DEFAULT 'Active',
		p_InterestRate DECIMAL(5, 2) DEFAULT 6.8
	)
	RETURNS INTEGER AS
	$$
	DECLARE
		account_id INTEGER;
	BEGIN
		-- Insert a new account into the Account table
		INSERT INTO Account (AccountNumber, AccountType, CustomerID, BranchID, Balance, Status)
		VALUES (p_AccountNumber, p_AccountType, p_CustomerID, p_BranchID, p_Balance, p_Status)
		RETURNING AccountID INTO account_id;
		-- Return the ID of the newly added account
		RETURN account_id;
	END;
	$$
	LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->INSERING DATA IN ACCOUNT TABLE

	SELECT Add_Account('ACC123456', 'Saving', 1, 1, 5000.00, 'Active');
	SELECT 	Add_Account('ACC123457', 'Saving', 2, 2, 50000.00, 'Active'),
			Add_Account('ACC123458', 'Saving', 2, 3, 15000.00, 'Active'),
			Add_Account('ACC123459', 'Saving', 3, 4, 53000.00, 'Active');
--			
	SELECT 	Add_Account('ACC122457', 'Current', 1, 11, 500000.00, 'Active'),
			Add_Account('ACC122458', 'Current', 1, 10, 1500.00, 'Active'),
			Add_Account('ACC122459', 'Saving', 1, 8, 5240.00, 'Active'),
			Add_Account('ACC124657', 'Fix-Deposite', 10, 11, 100.00, 'Active'),
			Add_Account('ACC122468', 'Saving', 2, 10, 15200.00, 'Active'),
			Add_Account('ACC132458', 'Current', 11, 10, 113500.00, 'Active'),
			Add_Account('ACC132659', 'Saving', 1, 8, 524270.00, 'Active'),
			Add_Account('ACC136657', 'Fix-Deposite', 10, 11, 102680.00, 'Active'),
			Add_Account('ACC134468', 'Fix-Deposite', 2, 10, 100200.00, 'Active'),
			Add_Account('ACC134349', 'Current', 11, 8, 429940.00, 'Active');
--
	SELECT 	Add_Account('ACC142457', 'Current', 3, 11, 150000.00, 'Active'),
			Add_Account('ACC142458', 'Current', 4, 10, 1500.00, 'Active'),
			Add_Account('ACC142459', 'Saving', 3, 11, 6000.00, 'Active'),
			Add_Account('ACC144657', 'Fix-Deposite', 3, 11, 100000.00, 'Active'),
			Add_Account('ACC142468', 'Saving', 7, 1, 15200.00, 'Active'),
			Add_Account('ACC142559', 'Current', 4, 9, 23500.00, 'Active'),
			Add_Account('ACC142659', 'Saving', 8, 8, 524270.00, 'Active'),
			Add_Account('ACC146657', 'Fix-Deposite', 10, 11, 102680.00, 'Active'),
			Add_Account('ACC144468', 'Fix-Deposite', 4, 9, 1000200.00, 'Active'),
			Add_Account('ACC144349', 'Current', 12, 8, 78940.00, 'Active');
			
--
	SELECT 	Add_Account('ACC152457', 'Current', 2, 14, 150000.00, 'Active'),
			Add_Account('ACC152458', 'Current', 2, 14, 1500.00, 'Active'),
			Add_Account('ACC152459', 'Saving', 5, 14, 6000.00, 'Active'),
			Add_Account('ACC154657', 'Fix-Deposite', 3, 14, 100000.00, 'Active'),
			Add_Account('ACC152468', 'Saving', 3, 14, 15200.00, 'Active'),
			Add_Account('ACC152559', 'Current', 4, 14, 23500.00, 'Active'),
			Add_Account('ACC152659', 'Saving',1 , 14, 524270.00, 'Active'),
			Add_Account('ACC156657', 'Fix-Deposite', 11, 14, 102680.00, 'Active'),
			Add_Account('ACC154468', 'Fix-Deposite', 4, 10, 1000200.00, 'Active'),
			Add_Account('ACC154349', 'Current', 5, 14, 78940.00, 'Active');
--			
	SELECT 	Add_Account('ACC162457', 'Current', 9, 9, 1502000.00, 'Active'),
			Add_Account('ACC162458', 'Current', 5, 6, 15000.00, 'Active'),
			Add_Account('ACC162459', 'Saving', 5, 6, 76000.00, 'Active'),
			Add_Account('ACC164657', 'Fix-Deposite', 9, 19, 1070000.00, 'Active'),
			Add_Account('ACC162468', 'Saving', 6, 7, 15200.00, 'Active'),
			Add_Account('ACC162559', 'Current', 6, 7, 23500.00, 'Active'),
			Add_Account('ACC162659', 'Saving', 12, 14, 524270.00, 'Active'),
			Add_Account('ACC166657', 'Fix-Deposite', 5, 6, 102680.00, 'Active'),
			Add_Account('ACC164468', 'Fix-Deposite', 12, 10, 1000200.00, 'Active'),
			Add_Account('ACC164349', 'Current', 12, 1, 78940.00, 'Active');
			
	SELECT 	Add_Account('ACC1762457', 'Current', 17, 9, 1502000.00, 'Active'),
			Add_Account('ACC1762458', 'Current', 15, 6, 15000.00, 'Active'),
			Add_Account('ACC1762459', 'Saving', 17, 6, 76000.00, 'Active'),
			Add_Account('ACC1764657', 'Fix-Deposite', 17, 4, 1070000.00, 'Active'),
			Add_Account('ACC1762468', 'Saving', 15, 9, 15200.00, 'Active'),
			Add_Account('ACC1762559', 'Current', 16, 7, 23500.00, 'Active'),
			Add_Account('ACC1762659', 'Saving', 10, 11, 524270.00, 'Active'),
			Add_Account('ACC1766657', 'Fix-Deposite', 3, 9, 102680.00, 'Active'),
			Add_Account('ACC1764468', 'Fix-Deposite', 15, 10, 1000200.00, 'Active'),
			Add_Account('ACC1764349', 'Current', 12, 11, 78940.00, 'Active');
			
	SELECT	Add_Account('ACC1862559', 'Fix-Deposite', 9, 10, 223500.00, 'Active'),
			Add_Account('ACC1862659', 'Current', 10, 11, 5241270.00, 'Active'),
			Add_Account('ACC1866657', 'Fix-Deposite', 5, 14, 102680.00, 'Active'),
			Add_Account('ACC1864468', 'Fix-Deposite', 6, 7, 10002200.00, 'Active'),
			Add_Account('ACC1864349', 'Fix-Deposite', 12, 3, 78940.00, 'Active');
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> PROCEDURE TO DO DEPOSITE
	CREATE OR REPLACE PROCEDURE DepositToAccount(
		IN account_number VARCHAR(20),
		IN deposit_amount DECIMAL(10, 2)
	) AS $$
	BEGIN
		-- Update the account balance by depositing the specified amount
		UPDATE Account
		SET Balance = Balance + deposit_amount, LastTransactionDateTime = NOW()
		WHERE AccountNumber = account_number;
	END;
	$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	CALL DepositToAccount ('ACC123457' , 5000);
	SELECT * FROM Account ORDER BY AccountID;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> PROCEDURE TO DO	Withdrawal
	CREATE OR REPLACE PROCEDURE WithdrawFromAccount(
		IN account_number VARCHAR(20),
		IN withdrawal_amount DECIMAL(10, 2)
	) AS $$
	BEGIN
		-- Check if the account has sufficient balance for withdrawal
		IF EXISTS (SELECT 1 FROM Account
				   WHERE AccountNumber = account_number 
				   AND Balance >= withdrawal_amount
		) THEN
			-- Update the account balance by withdrawing the specified amount
			UPDATE Account
			SET Balance = Balance - withdrawal_amount, LastTransactionDateTime = NOW()
			WHERE AccountNumber = account_number;
		END IF;
	END;
	$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	CALL WithdrawFromAccount ('ACC123456' , 5000);
	SELECT * FROM Account ORDER BY AccountID;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> PROCEDURE TO DO Transfer
	CREATE OR REPLACE PROCEDURE TransferBetweenAccounts(
		IN from_account_number VARCHAR(20),
		IN to_account_number VARCHAR(20),
		IN transfer_amount DECIMAL(10, 2)
	) AS $$
	BEGIN
		-- Check if the source account has sufficient balance for the transfer
		IF EXISTS (
			SELECT 1
			FROM Account
			WHERE AccountNumber = from_account_number AND Balance >= transfer_amount
		) THEN
			-- Withdraw the specified amount from the source account
			UPDATE Account
			SET Balance = Balance - transfer_amount, LastTransactionDateTime = NOW()
			WHERE AccountNumber = from_account_number;

			-- Deposit the specified amount into the destination account
			UPDATE Account
			SET Balance = Balance + transfer_amount, LastTransactionDateTime = NOW()
			WHERE AccountNumber = to_account_number;
		END IF;
	END;
	$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------				 
CALL TransferBetweenAccounts('ACC123457','ACC123456',5000);
SELECT * FROM Account ORDER BY AccountID;			
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create the Employee table
	CREATE TABLE Employee (
		EmployeeID SERIAL PRIMARY KEY,
		FirstName VARCHAR(50),
		LastName VARCHAR(50),
		DateOfBirth DATE,
		Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
		Role VARCHAR(20),
		Salary DECIMAL(10, 2),
		ContactNumber VARCHAR(15),
		Email VARCHAR(100) UNIQUE,
		Username VARCHAR(50) UNIQUE,
		Password VARCHAR(255),
		BranchID INTEGER REFERENCES Branch(BranchID),		
		HireDate DATE
	);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	CREATE OR REPLACE FUNCTION username_exists_2(e_username VARCHAR) RETURNS BOOLEAN AS $$
		BEGIN
			RETURN NOT EXISTS (SELECT 1 FROM Employee WHERE Employee.Username = e_username);
	END;
	$$ LANGUAGE plpgsql;
--------> 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Created a function to Add Employee
-- AND ALSO INSERTS MANAGER INTO BRANCH TABLE
	CREATE OR REPLACE FUNCTION Add_Employee(
		e_first_name VARCHAR,
		e_last_name VARCHAR,
		e_date_of_birth DATE,
		e_gender VARCHAR,
		e_role VARCHAR,
		e_salary DECIMAL,
		e_contact_number VARCHAR,
		e_email VARCHAR,
		e_username VARCHAR,
		e_password VARCHAR,
		e_branch_id INTEGER,
		e_hire_date DATE
	)
	RETURNS INTEGER AS $$
		DECLARE
			new_employee_id INTEGER;
			user_valid  boolean;
			email_valid boolean;
			phone_valid boolean;
			password_valid boolean;
		BEGIN
				-- Check if the user already Exists or not
				user_valid := username_exists_2(e_username);
				-- Check if the email is valid
				email_valid := is_valid_email(e_email);
				-- Check if the phone number is valid
				phone_valid := is_valid_phone(e_contact_number);
				 -- Check if the password is valid
				password_valid := is_valid_password(e_password);
			-- If any validation fails, return -1 as an error code
			IF NOT (user_valid AND email_valid AND phone_valid AND password_valid) THEN
				RETURN -1;
			END IF;
			
			 -- Insert the new employee
			INSERT INTO Employee (FirstName,LastName,DateOfBirth,Gender,Role,Salary,ContactNumber,Email,Username,Password,BranchID,HireDate)
			VALUES 
			(e_first_name,e_last_name,e_date_of_birth,e_gender,e_role,e_salary,e_contact_number,e_email,e_username,e_password,e_branch_id,e_hire_date)
			RETURNING EmployeeID INTO new_employee_id;
				--> For Manager Adding in Branches 
				IF(e_role = 'Manager') Then
					UPDATE Branch
					SET ManagerID = new_employee_id
					WHERE BranchID = e_branch_id;
				END IF;
					
			RETURN new_employee_id;

	END;$$ 
	LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->Insering Data into EmployeeTable

	-- Insert Employees for Axis_Ahmedabad branch
	SELECT Add_Employee ('Rajesh', 'Sharma', '1985-05-10', 'Male', 'Cashier', 45000.00, '9899979119', 'rajesh.sharma@email.com', 'rajesh123', 'P@ssword123', 1, '2023-01-15'),
			Add_Employee('Meera', 'Patel', '1990-03-20', 'Female', 'Loan Officer', 52000.00, '9779972319', 'meera.patel@email.com', 'meera456', 'Securep@ss1', 1, '2022-11-20'),
			Add_Employee('Amit', 'Singh', '1988-08-15', 'Male', 'Manager', 75000.00, '9899972319', 'amit.singh@email.com', 'amit789', 'str0ngP@ssword', 1, '2022-03-05');
	-- Insert Employees for 'SBI_Ahmedabad'
	SELECT Add_Employee('Neha', 'Gupta', '1987-12-01', 'Female', 'Cashier', 42000.00, '8646125107', 'neha.gupta@email.com', 'neha001', 'P@ssw0123rd', 2, '2023-02-10'),
			Add_Employee('Vikram', 'Yadav', '1992-04-25', 'Male', 'Loan Officer', 50000.00, '9096307182', 'vikram.yadav@email.com', 'vikram007', 'sec@Cass123', 2, '2022-09-15'),
			Add_Employee('Rani', 'Mishra', '1986-06-18', 'Female', 'Manager', 80000.00, '7491856984', 'rani.mishra@email.com', 'rani123', 'm@nagerPas2', 2, '2021-12-05');
	-- Insert Employees for "SBI_Surat"
	SELECT Add_Employee('Sneha', 'Gupta', '1997-12-01', 'Female', 'Manager', 420000.00, '8781368815', 'Sneha.gupta@email.com', 'SSneha001', 'P@ssw01SSneh', 3, '2003-02-15'),
			Add_Employee('kiram', 'Jadav', '1982-04-15', 'Male', 'Loan Officer', 50000.00, '8124214018', 'ikiram.jadav@email.com', 'iikiram007', 'sec@Caram007', 3, '2002-09-05'),
			Add_Employee('Rani', 'Pandit', '1982-06-15', 'Female', 'Cashier', 80000.00, '8684458437', 'rani.Pandit@email.com', 'rani156', 'rR@jini12', 3, '2001-12-25');
	-- Insert Employees for "ICIC_Ahmedabad"
	SELECT Add_Employee('Deepa', 'Patel', '2001-12-01', 'Female', 'Manager', 500000.00, '8345048810', 'd.patel@email.com', 'deepa1431', 'P@eepa143neh', 4, '2013-02-15'),
			Add_Employee('Ram', 'Yadavv', '1999-04-15', 'Male', 'Loan Officer', 100000.00, '6892726343', 'ramramY@email.com', 'ram007', 'ram007@Cam007', 4, '2022-09-15'),
			Add_Employee('Rina', 'Patel', '1992-06-15', 'Female', 'Cashier', 60000.00, '7658980317', 'riup@email.com', 'rinaemail', 'rRpate$l12', 4, '2011-12-20');	
	-- Insert Employees for "IDFC_Surat"
	SELECT Add_Employee('Meet'	,'Chavda'	,'2005-08-07'	,'Male'	, 'Manager', 700000.00,'9275106954','meet@gmail.com','M1E2T1','M16log100@' , 5 , '2023-02-15'),
			Add_Employee('Riya'	,'Chavda'	,'2005-08-07'	,'Female','Loan Officer',10000.00,'8000696354'	,'riyaah@gmail.com','riya143','Riya143$',5,'2021-12-25'),
			Add_Employee('Mansi'	,'Patel'	,'2004-02-27'	,'Female', 'Cashier', 60000, '7689656354'	,'mansiP@yahoo.com','Mp4227','mansi1P27#',5,'2020-10-15');
	-- Insert Employees for "IDFC_Ahmedabad"
	SELECT Add_Employee('Rajesh','Kumar'	,'1995-04-10'	,'Male'	,'Loan Officer',15000.00,'9874043410','rajeshK@ljku.edu.in','RajK','Rajraj1#',6 ,'2015-12-10'),
       		Add_Employee('Neha'	,'Sharma'	,'2000-07-22'	,'Female', 'Manager', 500000.00,'8765432109','Nneha@ljku.edu.in','NehaS','N@e@Has1',6,'2020-01-12'),
			Add_Employee('Neha'	,'Sharma'	,'1990-07-22'	,'Female', 'Cashier', 50000.00	,'8935432909','ineha@ljku.edu.in','iNehaS','N@e@Has1',6,'2020-07-22');
	-- Insert Employees for "Kotak_Ahmedabad"
	SELECT Add_Employee('Priya'	,'Singh'	,'1999-03-15'	,'Female'	, 'Loan Officer', 500000.00,'6543210987'	,'priya@gmail.com','PriyaS','PriyaK@45',7,'2001-06-22'),
     		Add_Employee('Priyam'	,'Gupta'	,'1989-03-15'	,'Male'	, 'Manager', 1500000.00,'6543210987'	,'priyamG@gmail.com','PriyaSG','PriyaK@45',7,'2001-10-02'),
     		Add_Employee('Priyesh'	,'Chavda'	,'1979-03-15'	,'Male'	, 'Cashier', 50000.00,'6543210987'	,'priyeshC@gmail.com','PriyaSCH','PriyaK@45',7,'2011-01-12');
     
	-- Insert Employees for "Kotak_Surat"
	SELECT Add_Employee('riya'	,'Pingh'	,'1999-03-15'	,'Female'	, 'Loan Officer', 100000.00,'7074120934'	,'Rpriya@gmail.com','imriyaS','PriyaK@45',8,'2021-06-12'),
     		Add_Employee('riyam'	,'SemGupta'	,'1989-03-15'	,'Male'	, 'Manager', 1200000.00,'6743244813'	,'SemriyamG@gmail.com','semriyamSG','PriyamK@45',8,'2011-11-22'),
     		Add_Employee('riyesh'	,'Cendra'	,'1979-03-15'	,'Male'	, 'Cashier', 40000.00,'7568373211'	,'CendariyeshC@gmail.com','cendariySCH','riySCH@45',8,'2001-11-02');
     
	-- Insert Employees for "Axis_Surat"
	 SELECT Add_Employee('Sandeep','Mishra'	,'2001-09-25'	,'Male'	, 'Manager', 1200000.00	,'7432109876'	,'sandeep@ljku.edu.in','SandeepM','SanD25&P',9,'2021-06-12'),
      		 Add_Employee('Kavita' ,'Gupta'	,'1994-11-30'	,'Female'	,'Loan Officer', 100000.00,'9321098765'	, 'kavita@gmail.com','KavitaG','KavitG1#5',9,'2011-03-20');
      
	-- Insert Employees for "PNB_Ahmedabad"
	 SELECT Add_Employee('Aarti'	,'Nair'		,'2002-09-17'	,'Female'	,'Loan Officer', 100000.00,'9798639869'	,'aarti@gmail.com','AartiN','@@ratI114',10,'2021-11-10'),
       		Add_Employee('Sushil'	,'Rastogi'	,'1990-12-08'	,'Male'	, 'Manager', 1200000.00	,'9399838747'	,'sushil@ljku.edu.in','SushilR','S1ushilR#',10,'2020-01-15');
  
	-- Insert Employees for "Yes_Bank_Ahmedabad"
	-- No employee
	-- Insert Employees for "BOB_Ahmedabad"
	SELECT Add_Employee('Anil'	,'Yadav'	,'2000-06-12'	,'Male'	,'Loan Officer', 135000.00	,'9210987654'	,'anil@example.com','AnilY','%@5an$ilIM',12,'2021-12-15'),
      		 Add_Employee('Pooja'	,'Joshi' ,'1998-08-18'	,'Female', 'Cashier', 40000.00	,'9909876543'	,'pooja@ljku.edu.in','PoojaJ','P@@jAJ00shi',12,'2018-12-05');
	
	-- Insert Employees for "HDFC_Ahmedabad"
	SELECT Add_Employee('Vikram','Rajput'	,'1992-01-12'	,'Male'	,'Loan Officer', 115000.00	,'8893746675'	,'vikram@outlook.com','VikramR','VR#w0rd11',13,'2019-02-10');
      
	-- Insert Employees for "UCO_Ahmedabad"
	SELECT Add_Employee('Deepa'	,'Gupta'	,'1987-08-05'	,'Female'	, 'Manager', 155000.00,'9798636745'	,'deepa@deepu.com','DeepaG','DeGp$123',14,'2006-02-10'),
      		 Add_Employee('Neeta'	,'Shukla'	,'2003-03-07'	,'Female', 'Cashier', 40000.00	,'9565324533'	,'neeta@example.com','NeetaS','Neetu!42@',14,'2023-12-11'),
       		Add_Employee('Rajat'	,'Tiwari'	,'1989-11-15'	,'Male'	,'Loan Officer', 135000.00		,'6493353272'	,'rajat@outlook.com','RajatT','P@ssRajat15',14,'2006-12-17');
      
	-- Insert Employees for "BOB_Surat"
	 SELECT Add_Employee('Simran'	,'Malik'	,'1998-06-30'	,'Female', 'Cashier', 40000.00,'9798721465'	,'simran@outlook.com','SimranM','P@ssw0rd16',15,'2023-12-11');
      
	-- Insert Employees for "BOI_Surat"
	SELECT Add_Employee('Alok'	,'Shah'		,'1994-04-25'	,'Male'		,'Manager', 115000.00,'7762190560'	,'alok@gmail.com','AlokS','P17Alok@!@#',16,'2006-10-07');
      
	-- Insert Employees for "PNB_Surat"
	 SELECT  Add_Employee('Amit'	,'Verma'	,'1988-12-05'	,'Male'		,'Manager', 135000.00,'7654321098'	,'amit@outlook.com','AmitV','Verma%123',17,'2006-07-07');

	-- Insert Employees for "Bandhan_Bank_Surat"
	---NO EPMLOYEE
/*
		Cashier
		Loan Officers
		Manager
*/
SELECT * FROM Employee ;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------					 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--SOME SQL QUERES

--1).Group the Customers by the Gender;
SELECT Gender, COUNT(*) AS NumberOfCustomers
FROM Customer
GROUP BY Gender;
--2).Printing detail of Customer who have maximum number of accouts
SELECT
    C.CustomerID,
    C.FirstName,
    C.LastName,
    C.DateOfBirth,
    C.Gender,
    COUNT(A.CustomerID) AS NumberOfAccounts
FROM Customer C
Inner JOIN Account A ON C.CustomerID = A.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName, C.DateOfBirth, C.Gender
HAVING COUNT(A.CustomerID) = (
    SELECT MAX(AccountCount)
    FROM (
        SELECT COUNT(CustomerID) AS AccountCount
        FROM Account
        GROUP BY CustomerID
    ) AS AccountCounts
);
--3).Account Ordered by Customer ID
SELECT * FROM Account order by customerid;

--4).Account holde having Saving , FD , Curent Account is same Branch
SELECT
    C.CustomerID,
    C.FirstName,
    C.LastName,
    A.BranchID,
    B.BranchName
FROM Customer C
JOIN Account A ON C.CustomerID = A.CustomerID
JOIN Branch B ON A.BranchID = B.BranchID
WHERE A.AccountType IN ('Saving', 'Current', 'Fix-Deposite')
GROUP BY C.CustomerID, C.FirstName, C.LastName, A.BranchID, B.BranchName
HAVING COUNT(DISTINCT A.AccountType) = 3;

--4).Account holde having Saving , FD , Curent Account is DIFFRENT Branch
SELECT DISTINCT
    C.CustomerID,
    C.FirstName,
    C.LastName
FROM Customer C
JOIN Account AS A1 ON C.CustomerID = A1.CustomerID
JOIN Account AS A2 ON C.CustomerID = A2.CustomerID
JOIN Account AS A3 ON C.CustomerID = A3.CustomerID
WHERE A1.AccountType = 'Saving'
  AND A2.AccountType = 'Fix-Deposite'
  AND A3.AccountType = 'Current'
  AND A1.BranchID <> A2.BranchID
  AND A2.BranchID <> A3.BranchID
  AND A1.BranchID <> A3.BranchID;

--5)Manager Who has Account in his/her Branch

SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    B.BranchName
FROM Employee E
JOIN Branch B ON E.BranchID = B.BranchID
WHERE E.EmployeeID IN (
    SELECT DISTINCT
        E2.EmployeeID
    FROM Employee E2
    JOIN Account A ON E2.BranchID = A.BranchID
);


--6).Manager having salary Greater thaen Avge salary of Employee
SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Salary,
    B.BranchName
FROM Employee E
JOIN Branch B ON E.BranchID = B.BranchID
WHERE E.Role = 'Manager'
  AND E.Salary > (
    SELECT AVG(Salary) 
    FROM Employee
);

--7).Employee who has the second-highest salary 

SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Salary,
    E.HireDate
FROM Employee E
WHERE E.Salary = (
    SELECT MAX(Salary)FROM Employee WHERE Salary < (SELECT MAX(Salary)FROM Employee)
);

--8).Top 5 Employee who has worked the highest number of days from their joining date
SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.HireDate
FROM Employee E
ORDER BY Age(CURRENT_DATE, E.HireDate) DESC
LIMIT 5;

--9).Count the number of accounts for each branch
SELECT
    B.BranchID,
    B.BranchName,
    COUNT(A.AccountID) AS NumberOfAccounts
FROM Branch B
Left JOIN Account A ON B.BranchID = A.BranchID
GROUP BY B.BranchID, B.BranchName
ORDER BY B.BranchID;

--10). Group branches by the total sum of the amount they have across all accounts

SELECT
    B.BranchID,
    B.BranchName,
    SUM(A.Balance) AS TotalAmount
FROM Branch B
Inner JOIN Account A ON B.BranchID = A.BranchID
GROUP BY B.BranchID, B.BranchName
ORDER BY TotalAmount DESC;

--11).Find branches without managers

SELECT
    B.BranchID,
    B.BranchName
FROM Branch B
WHERE B.BranchID NOT IN (
    SELECT DISTINCT E.BranchID
    FROM Employee E
    WHERE E.Role = 'Manager'
);

--11).create a view of female employees have a salary higher than the average salary of female employees

CREATE VIEW FemaleEmployeesWithHigherSalary AS
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employee
WHERE Gender = 'Female'
  AND Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE Gender = 'Female'
  );

SELECT * FROM FemaleEmployeesWithHigherSalary;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	The `RETURNING` clause in the SQL `INSERT` statement allows you to retrieve the values of specific columns after an `INSERT` operation.
					 In the context of the `add_customer` function, 
					 it's used to retrieve the `CustomerID` of the newly inserted customer record and store it in the `customer_id` variable.
					 This can be useful for various reasons:

1. **Obtaining the Generated ID:** In many database systems, when you insert a new record into a table with an auto-incrementing or serial column (in your case, `CustomerID` is a serial column), the database generates a unique ID for the new record. By using `RETURNING`, you can capture this generated ID and use it for further operations or return it to the caller.

2. **Confirmation and Logging:** You may want to confirm that the insert operation was successful and log the newly created `CustomerID` for auditing or debugging purposes. By storing it in a variable, you can easily access it.

3. **Subsequent Operations:** You might need the `CustomerID` for additional operations, such as associating the customer with other data or performing further database operations that depend on the customer's ID.

In the `add_customer` function, capturing the `CustomerID` via `RETURNING` allows you to maintain a reference to the newly added customer, making it easier to work with the data associated with that customer in subsequent steps of your application.				 
					 
					 */
	
