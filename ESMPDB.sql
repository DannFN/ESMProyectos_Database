CREATE DATABASE PESM CHARACTER SET utf8 COLLATE utf8_general_ci;

USE PESM;

/*
 * Tablas
 */

CREATE TABLE MUserType(
	UserTypeId TINYINT(1) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	UserType CHAR(1) NOT NULL
);

CREATE TABLE CUsers(
	UserId SMALLINT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	UserTypeId TINYINT(1),
	UserName VARCHAR(255) NOT NULL,
	UserRealName VARCHAR(255) NOT NULL,
	UserSurnmame VARCHAR(255) NOT NULL,
	UserPass CHAR(32) NOT NULL,
	FOREIGN KEY (UserTypeId) REFERENCES MUserType(UserTypeId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE 	CCProyects(
	ProyectNumber INT(8) NOT NULL PRIMARY KEY,
	ProyectName VARCHAR(255) NOT NULL,
	ProyectTitular VARCHAR(255) NOT NULL
);

CREATE TABLE CCExpenseCategory(
	ExpenseCategoryId TINYINT(1) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ExpenseCategory CHAR(5)
);

CREATE TABLE CCExpenseSubCategory(
	ExpenseSubCategoryId INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ExpenseSubCategory CHAR(3)
);

CREATE TABLE CCIncomes(
	IncomeId INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	Administration TINYINT(1),
	ProyectNumber INT(8),
	Concept VARCHAR(255),
	ExpenseCategoryId TINYINT(1),
	ExpenseSubCategoryId INT(8),
	Amount DECIMAL(11,2),
	FOREIGN KEY (ProyectNumber) REFERENCES CCProyects(ProyectNumber) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ExpenseCategoryId) REFERENCES CCExpenseCategory(ExpenseCategoryId) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ExpenseSubCategoryId) REFERENCES CCExpenseSubCategory(ExpenseSubCategoryId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CCOutcomes(
	OutcomeId INT(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ProyectNumber INT(8),
	Concept VARCHAR(255),
	ExpenseCategoryId TINYINT(1),
	OperationType CHAR(1),
	OrderDate DATE,
	OrderNumber INT(8),
	TransferDate DATE,
	TransferNumber VARCHAR(255),
	StartingNumber VARCHAR(255),
	InvoiceNumber VARCHAR(255),
	PolicyNumber VARCHAR(255),
	Amount DECIMAL(11,2),	
	FOREIGN KEY (ProyectNumber) REFERENCES CCProyects(ProyectNumber) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ExpenseCategoryId) REFERENCES CCExpenseCategory(ExpenseCategoryId) ON DELETE CASCADE ON UPDATE CASCADE
);

/*
 * Inserts por defecto
 */

INSERT INTO MUserType(UserType)
VALUES
	('M'),
	('A'),
	('W'),
	('R');

INSERT INTO 
	CCExpenseCategory(ExpenseCategory) 
VALUES
	('GINVE'),
	('GCORR');

INSERT INTO 
	CCExpenseSubCategory(ExpenseSubCategory) 
VALUES
	('002'),
	('405');

/*
 * Procedimientos almacenados
 */

DELIMITER //

/*
 * Procediminetos de usuarios
 */

CREATE PROCEDURE getUsers(
)
BEGIN
	SELECT
		CUsers.UserId,
		MUserType.UserType,
		CUsers.UserName,
		CUsers.UserRealName,
		CUsers.UserSurnmame
	FROM 
		CUsers 
	INNER JOIN
		MUserType
	ON
		MUserType.UserTypeId = CUsers.UserTypeId
	WHERE 
		NOT MUserType.UserTypeId = 1;
END//

CREATE PROCEDURE getUserData(
	IN _UserName VARCHAR(255)
)
BEGIN
	SELECT
		CUsers.UserId,
		MUserType.UserType,
		CUsers.UserName,
		CUsers.UserRealName,
		CUsers.UserSurnmame
	FROM 
		CUsers 
	INNER JOIN
		MUserType
	ON
		MUserType.UserTypeId = CUsers.UserTypeId
	WHERE 
		UserName = _UserName;
END//

CREATE PROCEDURE validateDuplicatedUser(
	IN _UserRealName VARCHAR(255),
	IN _UserSurnmame VARCHAR(255)
)
BEGIN
	SELECT * FROM CUsers WHERE UserRealName = _UserRealName AND UserSurnmame = _UserSurnmame;
END//

CREATE PROCEDURE addUser(
	IN _UserType CHAR(1),
	IN _UserName VARCHAR(255),
	IN _UserRealName VARCHAR(255),
	IN _UserSurnmame VARCHAR(255),
	IN _UserPass VARCHAR(32)	
)
BEGIN
	INSERT INTO CUsers(
		UserTypeId,
		UserName,
		UserRealName,
		UserSurnmame,
		UserPass
	) VALUES (
		(SELECT UserTypeId FROM MUserType WHERE UserType = _UserType),
		_UserName,
		_UserRealName,
		_UserSurnmame,
		_UserPass	
	);
END//

CREATE PROCEDURE updateUserData(
	IN _UserId SMALLINT(4),
	IN _UserType CHAR(1),
	IN _UserName VARCHAR(255),
	IN _UserRealName VARCHAR(255),
	IN _UserSurnmame VARCHAR(255)
)
BEGIN
	UPDATE 
		CUsers
	SET
		UserTypeId = (SELECT UserTypeId FROM MUserType WHERE UserType = _UserType),
		UserName = _UserName,
		UserRealName = _UserRealName,
		UserSurnmame = _UserSurnmame
	WHERE 
		UserId = _UserId; 
END//

CREATE PROCEDURE deleteUser(
	IN _UserName VARCHAR(255)
)
BEGIN
	DELETE FROM CUsers WHERE UserName = _UserName;
END//

CREATE PROCEDURE updatePassword(
	IN _UserName VARCHAR(255),
	IN _UserPass VARCHAR(32)
)
BEGIN
	UPDATE 
		CUsers 
	SET
		UserPass = _UserPass
	WHERE 
		UserName = _UserName;
END//

CREATE PROCEDURE logIn(
	IN _UserName VARCHAR(225)
)
BEGIN
	SELECT 
		MUserType.UserType, 
		CUsers.UserPass 
	FROM 
		CUsers 
	INNER JOIN
		MUserType
	ON 
		CUsers.UserTypeId = MUserType.UserTypeId
	WHERE 
		CUsers.UserName = _UserName;
END// 

/*
 * Procedimientos de proyectos Conacyt
 */

CREATE PROCEDURE getConacytProyects()
BEGIN
	SELECT * FROM CCProyects;
END//

CREATE PROCEDURE getConacytProyectData(
	IN _ProyectNumber INT(8)
)
BEGIN
	SELECT * FROM CCProyects WHERE ProyectNumber = _ProyectNumber;	 
END//

CREATE PROCEDURE validateDuplicatedConacytProyect(
	IN _ProyectName VARCHAR(255),
	IN _ProyectTitular VARCHAR(255)
)
BEGIN
	SELECT ProyectNumber FROM CCProyects WHERE ProyectName = _ProyectName AND ProyectTitular = _ProyectTitular;
END//

CREATE PROCEDURE getConacytIncomesAmount(
	IN _ProyectNumber INT(8)
)
BEGIN
	SELECT Amount FROM CCIncomes WHERE ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE getConacytOutcomesAmount(
	IN _ProyectNumber INT(8)
)
BEGIN
	SELECT OperationType, Amount FROM CCOutcomes WHERE ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE addConacytProyect(
	IN _ProyectNumber INT(8),
	IN _ProyectName VARCHAR(255),
	IN _ProyectTitular VARCHAR(255)
)
BEGIN
	INSERT INTO CCProyects (
		ProyectNumber, 
		ProyectName,
		ProyectTitular
	) VALUES (
		_ProyectNumber,
		_ProyectName, 
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
		CCProyects 
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
	DELETE FROM CCProyects WHERE ProyectNumber = _ProyectNumber;
END//

/*
 * Procedimientos de ingresos
 */

CREATE PROCEDURE getConacytIncomes(
	IN _ProyectNumber INT(8)
)
BEGIN 
	SELECT 
		CCIncomes.IncomeId,
		CCIncomes.Administration,
		CCIncomes.ProyectNumber,
		CCIncomes.Concept,
		CCExpenseCategory.ExpenseCategory,
		CCExpenseSubCategory.ExpenseSubCategory,
		CCIncomes.Amount
	FROM 
		CCIncomes
	INNER JOIN
		CCExpenseCategory
	ON 
		CCIncomes.ExpenseCategoryId = CCExpenseCategory.ExpenseCategoryId
	INNER JOIN
		CCExpenseSubCategory
	ON 
		CCIncomes.ExpenseSubCategoryId = CCExpenseSubCategory.ExpenseSubCategoryId
	WHERE
		CCIncomes.ProyectNumber = _ProyectNumber;
END//

CREATE PROCEDURE validateDuplicatedConacytIncome(
	IN _ProyectNumber INT(8),
	IN _Administration TINYINT(1),
	IN _Concept VARCHAR(255),
	IN _ExpenseCategory CHAR(5),
	IN _ExpenseSubCategory CHAR(3),
	IN _Amount DECIMAL(11,2)
)
BEGIN
	SELECT IncomeId FROM 
		CCIncomes 
	WHERE 
		ProyectNumber = _ProyectNumber AND
		Administration = _Administration AND
		Concept = _Concept AND
		ExpenseCategoryId = (SELECT ExpenseCategoryId FROM CCExpenseCategory WHERE ExpenseCategory = _ExpenseCategory) AND
		ExpenseSubCategoryId = (SELECT ExpenseSubCategoryId FROM CCExpenseSubCategory WHERE ExpenseSubCategory = _ExpenseSubCategory) AND
		Amount = _Amount;
END//

CREATE PROCEDURE addConacytIncome(
	IN _ProyectNumber INT(8),
	IN _Administration TINYINT(1),
	IN _Concept VARCHAR(255),
	IN _ExpenseCategory CHAR(5),
	IN _ExpenseSubCategory CHAR(3),
	IN _Amount DECIMAL(11,2)
)
BEGIN
	INSERT INTO CCIncomes (
		ProyectNumber, 
		Administration,
		Concept,
		ExpenseCategoryId, 
		ExpenseSubCategoryId,  
		Amount
	) VALUES (
		_ProyectNumber,
		_Administration, 
		_Concept, 
		(SELECT ExpenseCategoryId FROM CCExpenseCategory WHERE ExpenseCategory = _ExpenseCategory), 
		(SELECT ExpenseSubCategoryId FROM CCExpenseSubCategory WHERE ExpenseSubCategory = _ExpenseSubCategory), 
		_Amount
	);
END//

CREATE PROCEDURE updateConacytIncome(
	IN _IncomeId INT(8),
	IN _Administration TINYINT(1),
	IN _Concept VARCHAR(255),
	IN _ExpenseCategory CHAR(5),
	IN _ExpenseSubCategory CHAR(3),
	IN _Amount DECIMAL(11,2)	
)
BEGIN
	UPDATE 
		CCIncomes 
	SET 
		Administration = _Administration,
		Concept = _Concept,
		ExpenseCategoryId = (SELECT ExpenseCategoryId FROM CCExpenseCategory WHERE ExpenseCategory = _ExpenseCategory),
		ExpenseSubCategoryId = (SELECT ExpenseSubCategoryId FROM CCExpenseSubCategory WHERE ExpenseSubCategory = _ExpenseSubCategory),
		Amount = _Amount
	WHERE
		IncomeId = _IncomeId; 
END//

CREATE PROCEDURE deleteConacytIncome(
	IN _IncomeId INT(8)
)
BEGIN
	DELETE FROM CCIncomes WHERE IncomeId = _IncomeId;
END//

/*
 * Procedimientos de egresos
 */

CREATE PROCEDURE getConacytOutcomes(
	IN _ProyectNumber INT(8)
)
BEGIN
	SELECT * FROM CCOutcomes WHERE ProyectNumber = _ProyectNumber;
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
	INSERT INTO CCOutcomes (
		ProyectNumber,
		Concept,
		ExpenseCategoryId,
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
		(SELECT ExpenseCategoryId FROM CCESxpenseCategory WHERE ExpenseCategory = _ExpenseCategory),
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
	IN _OrderNumber VARCHAR(255),
	IN _TransferDate DATE,
	IN _TransferNumber VARCHAR(255),
	IN _StartingNumber VARCHAR(255),	
	IN _InvoiceNumber VARCHAR(255),
	IN _PolicyNumber VARCHAR(255),
	IN _Amount DECIMAL(11,2)
)
BEGIN
	UPDATE 
		CCOutcomes
	SET
		Concept = _Concept,
		ExpenseCategoryId = (SELECT ExpenseCategoryId FROM CCESxpenseCategory WHERE ExpenseCategory = _ExpenseCategory),
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
	DELETE FROM CCOutcomes WHERE OutcomeId = _OutcomeId;
END//

DELIMITER ;

CALL addUser('M', 'Master', 'UDI', 'ESM', '21232f297a57a5a743894a0e4a801fc3');
