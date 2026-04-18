select * 
from layoffs;

-- find duplicates
select * ,
(row_number() over (
partition by company,location,total_laid_off,percentage_laid_off,`date`)) as row_num
from layoffs_staging;
-- taken duplicates seprate
with duplicate_cte as(
select * ,(
row_number() over (
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
)as row_num
from layoffs_staging
) select * from duplicate_cte
where row_num > 1;

select * from layoffs_staging
where company = "casper";

--  delete duplicate rows

with duplicate_cte as(
select * ,(
row_number() over (
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
)as row_num
from layoffs_staging
) delete from duplicate_cte
where row_num > 1;

-- done by some devloper but we will create one more table






-- empty table copy of layoff_staging
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






select * from layoffs_staging2;

insert into layoffs_staging2
select * ,(
row_number() over (
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
)as row_num
from layoffs_staging;

-- deleted dupli rows
Delete from layoffs_staging2
where row_num >1;

select * from layoffs_staging2;


-- standardixation  data (finding issue and fix it)

select distinct Company,trim(Company) from layoffs_staging2;
-- triming
update layoffs_staging2 
set company=trim(Company);

select distinct * from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry ='crypto'
where industry like "Crypto%";
-- order by 1 givee you data in ascending order
-- check by diff column 
select  distinct country from layoffs_staging2
order by 1;

update layoffs_staging2
set country = 'United States'
where country like 'United States.'
;


select * from layoffs_staging2;

-- format date from text to date format
select `date`, 
str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date`= str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

-- seeing null and blanks
select * from layoffs_staging2
where total_laid_off is null; -- if total laid and percentage is null its useless

select * from layoffs_staging2
where industry is null or industry  like ' ';

select * from layoffs_staging2
where company like"airbnb";
-- one have value and another not for industry 
select t1.industry ,t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
	and t1.location=t2.location
where t1.industry is null or t1.industry like ' '
and t2.industry is not null; 

update layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null or t1.industry like ' '
and t2.industry is not null;
-- we cant update blanks to the value so we have to update to null 
update layoffs_staging2
set industry = null
where industry like ' ';

select * from layoffs_staging2;

-- remove unwanted coloumn
select * 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;
-- its useless therefore we will remove it
delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- now done table so remove row_num
alter table layoffs_staging2
drop column row_num;

-- final table
select * from layoffs_staging2;
 