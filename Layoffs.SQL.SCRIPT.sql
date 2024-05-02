select *
from layoffs;

create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

/* 1. Remove duplicates
   2. Standardize copied Data
   3. Null values or blank values
   4. Remove any unwanted columns
*/

/* removing duplicates */

select *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

WITH duplicate_cte AS
(
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
	stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
Select *
from duplicate_cte
WHERE row_num >1;


select *
from layoffs_staging
where company ='Casper';




CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2

INSERT INTO layoffs_staging2
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`
, country, funds_raised_millions) as row_num
from layoffs_staging;




DELETE from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2


-- Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
where industry like 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
where industry like 'Crypto%'

SELECT DISTINCT industry
from layoffs_staging2


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
order by 1

Update layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
Where country like 'United States%';

select `date`, str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2

update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y')

select `date`
from layoffs_staging2

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

select *
from layoffs_staging2


-- Nulls and blank values


select *
from layoffs_staging2
where total_laid_off is NULL
AND percentage_laid_off is NULL;

select *
from layoffs_staging2
WHERE industry IS NULL
or industry = '';


UPDATE layoffs_staging2
SET industry = null
WHERE industry = ''




select *
from layoffs_staging2
where company = 'Airbnb'


select t1.industry, t2.industry
from layoffs_staging2 t1
JOIN layoffs_staging2 t2
	on t1.company = t2.company
WHERE (t1.industry IS NULL or t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	on t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


select *
from layoffs_staging2

-- removing columns and rows you dont need


select *
from layoffs_staging2
where total_laid_off is NULL
AND percentage_laid_off is NULL;

DELETE
from layoffs_staging2
where total_laid_off is NULL
AND percentage_laid_off is NULL;


select *
from layoffs_staging2

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


select *
from layoffs_staging2






