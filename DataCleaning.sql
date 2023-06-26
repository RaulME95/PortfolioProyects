/*
Cleaning data in sql Queries
*/

select*
from Nashville

---Standarize date format

Alter Table Nashville
add SaleDateConverted date

update Nashville
set SaleDateConverted = CONVERT(date,SaleDate)


--Populate Property address data

select*
from Nashville
where PropertyAddress is null
order by ParcelID

update a
set PropertyAddress = isnull (a.PropertyAddress,b.PropertyAddress) --1st parametro check is null or not, 2nd replace 1st
from Nashville a
join Nashville b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]  --este ID es unico  <> means not equal
where a.PropertyAddress is null

--breaking out address into Individual Comlumns

select PropertyAddress  --original has a delimitor
from Nashville

select
SUBSTRING(PropertyAddress,1,CHARINDEX (',', PropertyAddress ) -1) as address,   --find some subtring startin in 1st position and ending in a ","
CHARINDEX(',',PropertyAddress),
SUBSTRING(PropertyAddress,CHARINDEX (',', PropertyAddress ) + 1, len(PropertyAddress) ) as address
from Nashville
--we need to create 2 new columns and add the data

Alter Table Nashville
add PropertySplitAddress nvarchar(255);

update Nashville
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX (',', PropertyAddress ) -1) 

Alter Table Nashville
add PropertySplitCity nvarchar(255)

update Nashville
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX (',', PropertyAddress ) + 1, len(PropertyAddress) )

select PropertySplitAddress , PropertySplitCity
from Nashville

-----------------------------------------------------------------------------------------------------------

--owner address split without using "subtring"

select OwnerAddress
from Nashville

select
PARSENAME(REPLACE(OwnerAddress,',', '.'),3),   ---REPLACE function replaces a ',' and put a '.' 
PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
from Nashville

Alter Table Nashville
add OwnerSplitAddress nvarchar(255);
update Nashville
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

Alter Table Nashville
add OwnerSplitCity nvarchar(255);
update Nashville
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

Alter Table Nashville
add OwnerSplitState nvarchar(255);
update Nashville
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)


select*
from Nashville

-----------------------------------------------------------------------------------------------------------

----CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD

Select distinct(SoldAsVacant), count(SoldAsVacant)
from Nashville
group by SoldAsVacant
order by SoldAsVacant

select SoldAsVacant,
case when SoldAsVacant= 'N' then 'No'
     when SoldAsVacant= 'Y' then 'Yes'
else SoldAsVacant
end
from Nashville


update Nashville
set SoldAsVacant=
case when SoldAsVacant= 'N' then 'No'
     when SoldAsVacant= 'Y' then 'Yes'
else SoldAsVacant
end

-----------------------------------------------------------------------------------------------------------
--Remove Duplicates

with RowNumCTE as(
select*, 
        ROW_NUMBER()over (
        partition by ParcelID, 
		             PropertyAddress, 
					 SalePrice, 
					 Saledate, 
					 LegalReference 
					 order by 
					 UniqueID
					 ) row_run
from Nashville
--order by ParcelID
)

delete  --delete duplicates
from RowNumCTE
where row_run>1
--order by PropertyAddress



--Delete unused Columns

select*
from Nashville

alter table Nashville
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleData

alter table Nashville
drop column SaleDate