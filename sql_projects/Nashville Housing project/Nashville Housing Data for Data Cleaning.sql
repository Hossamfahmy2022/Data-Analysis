/*

Cleaning Data in SQL Queries

*/

select *
from [dbo].[houses]

-- Standardize Date Format
select [SaleDate],CONVERT(date,[SaleDate])
from [dbo].[houses]

update [dbo].[houses]
set [SaleDate]=CONVERT(date,[SaleDate])
-- If it doesn't Update properly
alter table houses
add  SaleDate_converted date

update houses
set SaleDate_converted = CONVERT(date,[SaleDate])

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
select [PropertyAddress]
from [dbo].[houses]
--where [PropertyAddress] is null

select a.ParcelID, a.PropertyAddress, b.ParcelID,ISNULL(a.PropertyAddress, b.ParcelID)
from [dbo].[houses] a join [dbo].[houses] b
on a.ParcelID=b.ParcelID and a.[UniqueID ] <>b.[UniqueID ]
where a.[PropertyAddress] is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.ParcelID)
from [dbo].[houses] a join [dbo].[houses] b
on a.ParcelID=b.ParcelID and a.[UniqueID ] <>b.[UniqueID ]
where a.[PropertyAddress] is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [houses]

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
From [houses]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)  ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)  , LEN(PropertyAddress)) as Address

From [houses]

alter table houses
add  PropertySplitAddress nvarchar(255)

update houses
set PropertySplitAddress =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)  )


ALTER TABLE houses
Add PropertySplitCity Nvarchar(255);

Update houses
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select [OwnerAddress]
 From [houses]

 select 
 PARSENAME(replace([OwnerAddress],',','.'),3),
 PARSENAME(replace([OwnerAddress],',','.'),2),
 PARSENAME(replace([OwnerAddress],',','.'),1)
  From [houses]

ALTER TABLE [houses]
Add OwnerSplitAddress Nvarchar(255);

Update [houses]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [houses]
Add OwnerSplitCity Nvarchar(255);

Update [houses]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [houses]
Add OwnerSplitState Nvarchar(255);

Update [houses]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From [houses]

select distinct(SoldAsVacant),COUNT(*) as freq
From [houses]
group by SoldAsVacant
order by freq desc

select SoldAsVacant,
case 
when SoldAsVacant ='N' then 'No'
when SoldAsVacant ='Y' then 'Yes'
else SoldAsVacant
end 
From [houses]

Update [houses]
SET SoldAsVacant = 
case 
when SoldAsVacant ='N' then 'No'
when SoldAsVacant ='Y' then 'Yes'
else SoldAsVacant
end 
From [houses]

---
select *
from (select *,
ROW_NUMBER() over (partition by  ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID) as rn 
from [houses]) as new_table
where rn >1
Order by PropertyAddress


ALTER TABLE [houses]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate