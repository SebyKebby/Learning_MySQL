select *
from layoffs;

select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs;


create table world_layoffs.layoffs_staging_me
like world_layoffs.layoffs;

insert layoffs_staging_me
select * from layoffs;

select *
from layoffs_staging_me;




create table `layoffs_staging_me2` (
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
from layoffs_staging_me2;

insert into layoffs_staging_me2
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging_me;


delete
from layoffs_staging_me2
where row_num >1;

select *
from layoffs_staging_me2;

-- 2 data standardization/.

select distinct *
from layoffs_staging_me2
where stage like ' %'
;

update layoffs_staging_me2
set company = trim(company);

select distinct industry
from layoffs_staging_me2
where industry like 'Crypto%'
;

update layoffs_staging_me2
set industry = 'Crypto'
where industry like 'Cryto%';

select *
from layoffs_staging_me2;

select distinct country
from layoffs_staging_me2;

update layoffs_staging_me2
set country = trim(trailing('.') from country);

select *
from layoffs_staging_me2;

select `date`,
date_format(str_to_date(`date`,'%m/%d/%Y'), '%d/%m/%y')
from layoffs_staging_me2;

update layoffs_staging_me2
set `date` = date_format(str_to_date(`date`,'%m/%d/%Y'), '%d/%m/%y');

select *
from layoffs_staging_me2;

delete
from layoffs_staging_me2
where total_laid_off is null
and percentage_laid_off is null;


update layoffs_staging_me2
set industry = null
where industry = ''
;
