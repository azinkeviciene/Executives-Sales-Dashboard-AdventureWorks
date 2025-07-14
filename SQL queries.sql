#Table "Product" in Power BI
SELECT
  sales_order_head.SalesOrderID,
  CASE
    WHEN customer.CustomerType = 'I'
    THEN 'Individual Customer'
    ELSE 'Business Customer'
  END AS Customers_type,
  product.ProductID,
  sales_order_detail.OrderQty,
  sales_order_detail.LineTotal,
  product.Name Product,
  product.StandardCost,
  product_sub_category.Name ProductSubCategory,
  product_category.Name ProductCategory
FROM `adwentureworks_db.salesorderheader` sales_order_head
JOIN `adwentureworks_db.customer` customer
ON sales_order_head.CustomerID = customer.CustomerID
JOIN `adwentureworks_db.salesorderdetail` sales_order_detail
ON sales_order_head.SalesOrderID = sales_order_detail.SalesOrderID
JOIN `adwentureworks_db.specialofferproduct` spec_offer_product
ON sales_order_detail.SpecialOfferID = spec_offer_product.SpecialOfferID
AND sales_order_detail.ProductID = spec_offer_product.ProductID
JOIN `adwentureworks_db.product` product
ON spec_offer_product.ProductID = product.ProductID
JOIN `adwentureworks_db.productsubcategory` product_sub_category
ON product.ProductSubcategoryID = product_sub_category.ProductSubcategoryID
JOIN `adwentureworks_db.productcategory` product_category
ON product_sub_category.ProductCategoryID = product_category.ProductCategoryID

#Table "Sales Persons" in Power BI
SELECT
  sales_person.SalesPersonID,
  CONCAT(contact.Firstname, ' ', contact.LastName) Sales_Person,
  sales_person.TerritoryID
FROM `adwentureworks_db.salesperson` sales_person
JOIN `adwentureworks_db.employee` employee
ON sales_person.SalesPersonID = employee.EmployeeId
JOIN `adwentureworks_db.contact` contact
ON employee.ContactID = contact.ContactId

#Table "Sales Reason" in Power BI
WITH sales_per_reason AS (
 SELECT
   sales_order_header.SalesOrderID,
   DATE_TRUNC(OrderDate, MONTH) AS year_month,
   sales_reason.SalesReasonID,
   SUM(sales_order_header.TotalDue) AS total_sales
 FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales_order_header
 INNER JOIN `tc-da-1.adwentureworks_db.salesorderheadersalesreason` AS sales_reason
 ON sales_order_header.SalesOrderID = sales_reason.salesOrderID
 GROUP BY 1,2,3
)
SELECT
 sales_per_reason.SalesOrderID,
 sales_per_reason.year_month,
 reason.Name sales_reason,
 sales_per_reason.total_sales
FROM sales_per_reason
LEFT JOIN `tc-da-1.adwentureworks_db.salesreason` AS reason
ON sales_per_reason.SalesReasonID = reason.SalesReasonID

#Table "Sales Territory" in Power BI
SELECT
  sales_order_head.SalesOrderID,
  state_province.CountryRegionCode CountryCode,
  state_province.StateProvinceCode,
  state_province.Name Province,
  country_region.Name Country
FROM `adwentureworks_db.salesorderheader` sales_order_head
JOIN `adwentureworks_db.address` address
ON sales_order_head.ShipToAddressID = address.AddressID
JOIN `adwentureworks_db.stateprovince` state_province
ON address.StateProvinceID = state_province.StateProvinceID
JOIN `adwentureworks_db.countryregion` country_region
ON state_province.CountryRegionCode = country_region.CountryRegionCode