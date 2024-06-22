-- exploratory data analysis

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc
 ;



select
MAX(total_laid_off),
MAX(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc
;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select `date`, sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select company , avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select SUBSTRING(`date`,1,7) as `month`,sum(total_laid_off)
from layoffs_staging2
where SUBSTRING(`date`,1,7) is not null
group by `month`
order by 1 asc;

with rolling_total as
(
select SUBSTRING(`date`,1,7) as `month`, 
sum(total_laid_off) as total_off
from layoffs_staging2
where SUBSTRING(`date`,1,7) is not null
group by `month`
order by 1 asc)
select `month`, total_off,  sum(total_off) over(order by `month`) as rolling_total 
from rolling_total;



select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

with Company_Year (company,years,total_laid_off)
 as 
(
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc
)
select *,
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from Company_Year
where years is not null
order by ranking asc
;

with Company_Year as
(
select company,year(`date`) as years,sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by company, year(`date`)
order by 3 desc
), Company_Year_Rank as
(
select *,
dense_rank() over (partition by years order by total_laid_off desc) as ranking
from Company_Year
where years is not null
)
SELECT *
from Company_Year_Rank
where ranking >= 5
;
