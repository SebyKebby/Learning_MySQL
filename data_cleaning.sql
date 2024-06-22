
-- 1 remove dupes
-- 2 standardize data (fix spelling, etc)
-- 3 null values or blank values (if we can populate or not)
-- 4 remove columns and rows that aren't neccesary
select *
from layoffs_staging
where company = 'Oda';

SELECT *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
FROM layoffs_staging;





with duplicate_cte as
(SELECT *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
FROM layoffs_staging
)
delete 
from duplicate_cte
where row_num >1;

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
from layoffs_staging2;

insert into layoffs_staging2
SELECT *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
FROM layoffs_staging
;
SET SQL_SAFE_UPDATES = 0;

delete
from layoffs_staging2
where row_num > 1;

SELECT *
FROM layoffs_staging2;
-- 1 remove dupes (DONE)
-- 2 standardize data (fix spelling, etc)
-- 3 null values or blank values (if we can populate or not)
-- 4 remove columns and rows that aren't neccesary


-- 2 standardize data (fix spelling, etc)
select distinct company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct industry
from layoffs_staging2;


update layoffs_staging2
set country = trim(trailing '.' from country);


select *
from layoffs_staging2;


select date,
date_format(str_to_date(`date`,'%y/%m/%d'), '%d/%m/%y') as formatted_date
from layoffs_staging2;

update layoffs_staging2
set date = date_format(str_to_date(`date`,'%Y/%m/%d'), '%m/%d/%y');

select  * 
from layoffs_staging2;

-- select *
-- from layoffs
-- where company like 'Blackbaud'
-- and location like 'Charleston';


alter table layoffs_staging2
modify column `date` date;


-- 3 null populating



select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;


select *
from layoffs_staging2
where industry is null
or industry = '';


select *
from layoffs_staging2
where company = 'airbnb';

update layoffs_staging2
set industry = null
where industry = '';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


-- 4 drop unecessary row and col
alter table layoffs_staging2
drop column row_num;


-- FINISHED CLEANING




