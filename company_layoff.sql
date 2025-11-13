-- SQL Project - Data Cleaning

SELECT * 
FROM layoffs;

-- 1. Remove duplicates

# Let check for duplicates

SELECT *
FROM ( 
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
			ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
	FROM layoffs) AS duplicates
WHERE row_num >1 
;
-- let's just look at Cazoo to confirm
SELECT *
FROM layoffs
WHERE company = "Cazoo";

-- these are the ones we want to delete where the row number is > 1 or 2 or greater

-- create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column

CREATE TABLE layoffs_02 (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT
) ;

INSERT INTO layoffs_02
(
  `company`,
  `location` ,
  `industry` ,
  `total_laid_off` ,
  `percentage_laid_off` ,
  `date` ,
  `stage` ,
  `country` ,
  `funds_raised_millions` ,
  `row_num`
)SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs;

-- now that we have this we can delete rows were row_num is greater than 2
DELETE 
FROM layoffs_02
WHERE row_num >= 2;

SELECT * 
FROM layoffs_02;

-- 2. Standardize Data

SELECT * 
FROM layoffs_02
WHERE industry is NULL OR 
industry = ""
ORDER BY industry;

-- Nothing wrong here 
SELECT * 
FROM layoffs_02
WHERE company LIKE "Bally%";

SELECT * 
FROM layoffs_02
WHERE company LIKE "Airbnb%";

UPDATE layoffs_02
SET industry = NULL 
WHERE industry  = "";

-- now if we check those are all null

SELECT * 
FROM layoffs_02
WHERE industry IS NULL OR 
industry = "";

-- now if we check those are all null

UPDATE layoffs_02 l1
JOIN layoffs_02 l2
ON l1.company = l2.company 
SET l1.industry = l2.industry
WHERE l1.industry IS NULL AND 
l2.industry IS NOT NULL;

-- and if we check it looks like Bally's was the only one without a populated row to populate this null values
SELECT * 
FROM layoffs_02
WHERE industry IS NULL OR 
industry = "";

-- I also noticed the Crypto
SELECT DISTINCT industry 
FROM layoffs_02
ORDER BY 1;

UPDATE layoffs_02
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency','CryptoCurrency');

SELECT DISTINCT industry 
FROM layoffs_02
ORDER BY 1;

-- Let fixed United State 
SELECT DISTINCT country 
FROM layoffs_02
ORDER BY country ;

UPDATE layoffs_02
SET country = trim(TRAILING "." FROM country);

SELECT DISTINCT country 
FROM layoffs_02
ORDER BY country ;

-- Let's also fix the date columns:

SELECT * 
FROM layoffs_02;

UPDATE layoffs_02
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

-- now we can convert the data type properly
ALTER TABLE layoffs_02
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_02;

-- 4. remove any columns and rows we need to

SELECT *
FROM layoffs_02
WHERE total_laid_off IS NULL;


SELECT *
FROM layoffs_02
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete Useless data we can't really use
DELETE FROM layoffs_02
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_02;

ALTER TABLE layoffs_02
DROP COLUMN row_num;


SELECT * 
FROM layoffs_02;







    
























