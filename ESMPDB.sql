CREATE DATABASE PESM CHARACTER SET utf8 COLLATE utf8_general_ci;

USE PESM;

CREATE TABLE MUsers(
	UserId INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	UserType CHAR(1) NOT NULL,
	UserName VARCHAR(32) NOT NULL,
	UserPass VARCHAR(32) NOT NULL
);

CREATE TABLE CProyects(
	ProyectNumber INT(8) NOT NULL PRIMARY KEY,
	ProyectTitular VARCHAR(255) NOT NULL
);

CREATE TABLE CIncomes(
	IncomeId INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ProyectNumber INT(8),
	ExpenseCategory CHAR(5),
	ExpenseSubCategory CHAR(3),
	Concept VARCHAR(255),
	Amount DECIMAL(7,2),
	FOREIGN KEY (ProyectNumber) REFERENCES CProyects(ProyectNumber) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE COutcomes(
	OutcomeId INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ProyectNumber INT(8),
	OperationType CHAR(1),
	OrderDate DATE,
	StartingNumber INT(8),
	ExpenseCategory CHAR(5),
	Concept VARCHAR(255),
	Amount DECIMAL(7,2),
	InvoiceNumber VARCHAR(255),
	TransferNumber VARCHAR(255),
	PolicyNumber VARCHAR(255),
	TransferDate DATE,
	FOREIGN KEY (ProyectNumber) REFERENCES CProyects(ProyectNumber) ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER //

CREATE PROCEDURE getProyects()
BEGIN
	SELECT * FROM CProyects;
END//

CREATE PROCEDURE getIncomes(
	IN _ProyectNumber INT(8)
)
BEGIN 
	SELECT * FROM CIncomes WHERE ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE getOutcomes(
	IN _ProyectNumber INT(8)
)
BEGIN
	SELECT * FROM COutcomes WHERE ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE updateProyect(
	IN _OldProyectNumber INT(8),
	IN _NewProyectNumber INT(8)
	IN _ProyectTitular VARCHAR(255)
)
BEGIN 
	UPDATE 
		CProyects 
	SET 
		ProyectNumber = _NewProyectNumber, 
		ProyectTitular = _ProyectTitular 
	WHERE 
		ProyectNumber = _OldProyectNumber;
END//

CREATE PROCEDURE updateIncome(
	IN _IncomeId INT(8),
	IN _ExpenseCategory CHAR(5),
	IN _ExpenseSubCategory CHAR(3),
	IN _Concept VARCHAR(255),
	IN _Amount DECIMAL(7,2),	
)
BEGIN
	UPDATE 
		CIncomes 
	SET 
		ExpenseCategory = _ExpenseCategory,
		ExpenseSubCategory = _ExpenseSubCategory,
		Concept = _Concept,
		Amount = _Amount
	WHERE
		IncomeId = _IncomeId; 
END//

CREATE PROCEDURE updateOutcome(
	IN _OutcomeId INT(8),
	IN _OperationType CHAR(1),
	IN _OrderDate DATE,
	IN _StartingNumber INT(8),
	IN _ExpenseCategory CHAR(5),
	IN _Concept VARCHAR(255),
	IN _Amount DECIMAL(7,2),
	IN _InvoiceNumber VARCHAR(255),
	IN _TransferNumber VARCHAR(255),
	IN _PolicyNumber VARCHAR(255),
	IN _TransferDate DATE,
)
BEGIN
	UPDATE 
		COutcomes
	SET
		OperationType = _OperationType,
		OrderDate = _OrderDate,
		StartingNumber = _StartingNumber,
		ExpenseCategory = _ExpenseCategory,
		Concept = _Concept,
		Amount = _Amount,
		InvoiceNumber = _InvoiceNumber,
		TransferNumber = _TransferNumber,
		PolicyNumber = _PolicyNumber,
		TransferDate = _TransferDate
	WHERE 
		OutcomeId = _OutcomeId;
END//

CREATE PROCEDURE deleteProyect(
	IN _ProyectNumber INT(8)
)
BEGIN
	DELETE FROM CProyects WHERE ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE deleteIncome(
	IN _IncomeId INT(8)
)
BEGIN
	DELETE FROM CIncomes WHERE IncomeId = _IncomeId;
END//

CREATE PROCEDURE DeleteOutcome(
	IN _OutcomeId INT(8)
)
BEGIN
	DELETE FROM COutcomes WHERE OutcomeId = _OutcomeId;
END//

CREATE PROCEDURE addProyect(
	IN _ProyectNumber INT(8),
	IN _ProyectTitular VARCHAR(255)
)
BEGIN
	INSERT INTO CProyects (
		ProyectNumber, 
		ProyectTitular
	)
	VALUES (
		_ProyectNumber, 
		_ProyectTitular
	); 
END//

CREATE PROCEDURE addIncome(
	IN _ProyectNumber INT(8),
	IN _ExpenseCategory CHAR(5),
	IN _ExpenseSubCategory CHAR(3),
	IN _Concept VARCHAR(255),
	IN _Amount DECIMAL(7,2)
)
BEGIN
	INSERT INTO CIncomes (
		ProyectNumber, 
		ExpenseCategory, 
		ExpenseSubCategory, 
		Concept, 
		Amount
	)
	VALUES (
		_ProyectNumber, 
		_ExpenseCategory, 
		_ExpenseSubCategory, 
		_Concept, 
		_Amount
	);
END//

CREATE PROCEDURE addOutcome(
	IN _ProyectNumber INT(8),
	IN _OperationType CHAR(1),
	IN _OrderDate DATE,
	IN _StartingNumber INT(8),
	IN _ExpenseCategory CHAR(5),
	IN _Concept VARCHAR(255),
	IN _Amount DECIMAL(7,2),
	IN _InvoiceNumber VARCHAR(255),
	IN _TransferNumber VARCHAR(255),
	IN _PolicyNumber VARCHAR(255),
	IN _TransferDate DATE	
)
BEGIN
	INSERT INTO COutcomes (
		ProyectNumber,
		OperationType,
		OrderDate,
		StartingNumber,
		ExpenseCategory,
		Concept,
		Amount,
		InvoiceNumber,
		TransferNumber,
		PolicyNumber,
		TransferDate	
	)
	VALUES (
		_ProyectNumber,
		_OperationType,
		_OrderDate,
		_StartingNumber,
		_ExpenseCategory,
		_Concept,
		_Amount,
		_InvoiceNumber,
		_TransferNumber,
		_PolicyNumber,
		_TransferDate		
	);
END//

CREATE PROCEDURE logIn(
	IN _UserName VARCHAR(32)
)
BEGIN
	SELECT UserType, UserPass FROM VWMInicioSesion WHERE UserName = _UserName;
END//
