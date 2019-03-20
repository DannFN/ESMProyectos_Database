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
	PölicyNumber VARCHAR(255),
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

