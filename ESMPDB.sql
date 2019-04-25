CREATE DATABASE PESM CHARACTER SET utf8 COLLATE utf8_general_ci;

USE PESM;

CREATE TABLE MUsers(
	UserId INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	UserType CHAR(1) NOT NULL,
	UserName VARCHAR(255) NOT NULL,
	UserPass VARCHAR(32) NOT NULL
);

CREATE TABLE CProyects(
	ProyectNumber INT(8) NOT NULL PRIMARY KEY,
	ProyectName VARCHAR(255) NOT NULL,
	ProyectTitular VARCHAR(255) NOT NULL
);

CREATE TABLE CIncomes(
	IncomeId INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ProyectNumber INT(8),
	Concept VARCHAR(255),	
	ExpenseCategory CHAR(5),
	ExpenseSubCategory CHAR(3),
	Amount DECIMAL(11,2),
	FOREIGN KEY (ProyectNumber) REFERENCES CProyects(ProyectNumber) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE COutcomes(
	OutcomeId INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ProyectNumber INT(8),
	Concept VARCHAR(255),
	ExpenseCategory CHAR(5),
	OperationType CHAR(1),
	OrderDate DATE,
	OrderNumber INT(8),
	TransferDate DATE,
	TransferNumber VARCHAR(255),
	StartingNumber VARCHAR(255),
	InvoiceNumber VARCHAR(255),
	PolicyNumber VARCHAR(255),
	Amount DECIMAL(11,2),	
	FOREIGN KEY (ProyectNumber) REFERENCES CProyects(ProyectNumber) ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER //

CREATE PROCEDURE getConacytProyects()
BEGIN
	SELECT * FROM CProyects;
END//

CREATE PROCEDURE addConacytProyect(
	IN _ProyectNumber INT(8),
	IN _ProyectName VARCHAR(255),
	IN _ProyectTitular VARCHAR(255)
)
BEGIN
	INSERT INTO CProyects (
		ProyectNumber, 
		ProyectTitular
	) VALUES (
		_ProyectNumber, 
		_ProyectTitular
	); 
END//

CREATE PROCEDURE updateConacytProyect(
	IN _OldProyectNumber INT(8),
	IN _NewProyectNumber INT(8),
	IN _ProyectName VARCHAR(255),
	IN _ProyectTitular VARCHAR(255)
)
BEGIN 
	UPDATE 
		CProyects 
	SET 
		ProyectNumber = _NewProyectNumber, 
		ProyectName = _ProyectName,
		ProyectTitular = _ProyectTitular 
	WHERE 
		ProyectNumber = _OldProyectNumber;
END//

CREATE PROCEDURE deleteConacytProyect(
	IN _ProyectNumber INT(8)
)
BEGIN
	DELETE FROM CProyects WHERE ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE getConacytIncomes(
	IN _ProyectNumber INT(8)
)
BEGIN 
	SELECT * FROM CIncomes WHERE ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE addConacytIncome(
	IN _ProyectNumber INT(8),
	IN _Concept VARCHAR(255),
	IN _ExpenseCategory CHAR(5),
	IN _ExpenseSubCategory CHAR(3),
	IN _Amount DECIMAL(11,2)
)
BEGIN
	INSERT INTO CIncomes (
		ProyectNumber, 
		Concept,
		ExpenseCategory, 
		ExpenseSubCategory,  
		Amount
	) VALUES (
		_ProyectNumber, 
		_Concept, 
		_ExpenseCategory, 
		_ExpenseSubCategory, 
		_Amount
	);
END//

CREATE PROCEDURE updateConacytIncome(
	IN _IncomeId INT(8),
	IN _Concept VARCHAR(255),
	IN _ExpenseCategory CHAR(5),
	IN _ExpenseSubCategory CHAR(3),
	IN _Amount DECIMAL(11,2)	
)
BEGIN
	UPDATE 
		CIncomes 
	SET 
		Concept = _Concept,
		ExpenseCategory = _ExpenseCategory,
		ExpenseSubCategory = _ExpenseSubCategory,
		Amount = _Amount
	WHERE
		IncomeId = _IncomeId; 
END//

CREATE PROCEDURE deleteConacytIncome(
	IN _IncomeId INT(8)
)
BEGIN
	DELETE FROM CIncomes WHERE IncomeId = _IncomeId;
END//

CREATE PROCEDURE getConacytOutcomes(
	IN _ProyectNumber INT(8)
)
BEGIN
	SELECT * FROM COutcomes WHERE ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE addConacytOutcome(
	IN _ProyectNumber INT(8),
	IN _Concept VARCHAR(255),
	IN _ExpenseCategory CHAR(5),
	IN _OperationType CHAR(1),
	IN _OrderDate DATE,
	IN _OrderNumber VARCHAR(255),
	IN _TransferDate DATE,
	IN _TransferNumber VARCHAR(255),
	IN _StartingNumber VARCHAR(255),	
	IN _InvoiceNumber VARCHAR(255),
	IN _PolicyNumber VARCHAR(255),	
	IN _Amount DECIMAL(11,2)
)
BEGIN
	INSERT INTO COutcomes (
		ProyectNumber,
		Concept,
		ExpenseCategory,
		OperationType,
		OrderDate,
		OrderNumber,
		TransferDate,
		TransferNumber,
		StartingNumber,
		InvoiceNumber,
		PolicyNumber,
		Amount	
	) VALUES (
		_ProyectNumber,
		_Concept,
		_OperationType,
		_OrderDate,
		_StartingNumber,
		_ExpenseCategory,
		_Amount,
		_InvoiceNumber,
		_TransferNumber,
		_PolicyNumber,
		_TransferDate		
	);
END//

CREATE PROCEDURE updateConacytOutcome(
	IN _OutcomeId INT(8),
	IN _Concept VARCHAR(255),
	IN _ExpenseCategory CHAR(5),
	IN _OperationType CHAR(1),
	IN _OrderDate DATE,
	IN _OrderNumber VARCHAR(255)
	IN _TransferDate DATE,
	IN _TransferNumber VARCHAR(255),
	IN _StartingNumber VARCHAR(255),	
	IN _InvoiceNumber VARCHAR(255),
	IN _PolicyNumber VARCHAR(255),
	IN _Amount DECIMAL(11,2)
)
BEGIN
	UPDATE 
		COutcomes
	SET
		Concept = _Concept,
		ExpenseCategory = _ExpenseCategory,
		OperationType = _OperationType,
		OrderDate = _OrderDate,
		OrderNumber = _OrderNumber,
		TransferDate = _TransferDate,
		TransferNumber = _TransferNumber,
		StartingNumber = _StartingNumber,
		InvoiceNumber = _InvoiceNumber,
		PolicyNumber = _PolicyNumber,
		Amount = _Amount
	WHERE 
		OutcomeId = _OutcomeId;
END//

CREATE PROCEDURE DeleteConacytOutcome(
	IN _OutcomeId INT(8)
)
BEGIN
	DELETE FROM COutcomes WHERE OutcomeId = _OutcomeId;
END//

CREATE PROCEDURE logIn(
	IN _UserName VARCHAR(225)
)
BEGIN
	SELECT UserType, UserPass FROM MUsers WHERE UserName = _UserName;
END// 

CREATE PROCEDURE updatePass(
	IN _UserId INT(4),
	IN _UserPass VARCHAR(32)
)
BEGIN
	UPDATE 
		MUsers 
	SET
		UserPass = _UserPass
	WHERE 
		UserId = _UserId;
END//

CREATE PROCEDURE updateUserName(
	IN _UserId INT(8),
	IN _UserName VARCHAR(255)
)
BEGIN
	UPDATE 
		MUsers
	SET
		UserName = _UserName
	WHERE 
		UserId = _UserId; 
END//

CREATE PROCEDURE addUser(
	IN _UserType CHAR(1),
	IN _UserName VARCHAR(255),
	IN _UserPass VARCHAR(32)	
)
BEGIN
	INSERT INTO MUsers(
		UserType,
		UserName,
		UserPass
	) VALUES (
		_UserType,
		_UserName,
		_UserPass	
	);
END//

CREATE PROCEDURE deleteUser(
	IN _UserName VARCHAR(255)
)
BEGIN
	DELETE FROM MUsers WHERE UserName = _UserName;
END//

CREATE PROCEDURE getUserData(
	IN _UserName VARCHAR(255)
)
BEGIN
	SELECT * FROM MUsers WHERE UserName = _UserName;
END//

CREATE PROCEDURE getUsers(
)
BEGIN
	SELECT * FROM MUsers WHERE NOT UserType = 'A';
END//

CREATE PROCEDURE checkMU(
)
BEGIN
	SELECT UserPass FROM MUsers WHERE UserType = 'A';
END//

DELIMITER ;
