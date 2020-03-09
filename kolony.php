<?php

//Chnage this connection when swicth to remote server database
//$con=mysqli_connect("localhost","username","password","dbname");
$con = mysqli_connect("localhost","root","","kolony");

// Check connection
if (mysqli_connect_errno())
{
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

//if (isset...) checks if form variable exists before accessign it; avoids undefined index error
if (isset($_GET['type'])) $type = $_GET["type"];
if (isset($_GET['uID'])) $uID = $_GET["uID"];
if (isset($_GET['productID'])) $productID = $_GET["productID"];
if (isset($_GET['indiProductID'])) $indiProductID = $_GET["indiProductID"];
if (isset($_GET['userName'])) $username = $_GET["userName"];
if (isset($_GET['email'])) $email = $_GET["email"];

// // This SQL statement selects ALL from the table 'products' for products that have not been sold
// $sql = "SELECT * FROM products WHERE sold=0";
// //echo $sql;

    // This SQL statement selects ALL from the table 'Recipes'
    if($type == "pullProducts"){
        $sql = "SELECT * FROM products WHERE sold=0";
    }elseif ($type == "insertCart"){
        $sql = "insert into kolony_cart values ('$uID','$indiProductID');";
    }elseif ($type == "pullCart"){
        $sql = "SELECT p.productid, c.eachproductid, productsizes, productname, productprice, productbrand, 
        productcolorway, productretail, productstyle, productrelease FROM users u
        join kolony_cart c on u.userid=c.userid
        join product_sizes ps on c.eachproductid=ps.eachproductid join products p 
        on ps.productid=p.productid where c.userid = '$uID';";
    }elseif ($type == "insertUser"){
        $sql = "insert into users values ('$uID','$username','$email');";
    }elseif ($type == "insertSold"){
        $sql = "insert into sold_products values ('$uID','$productID');"; 
    } elseif ($type == "updateProducts"){
        $sql = "update products set sold = '1' where productid = '$productID';";
    } elseif ($type == "pullProductSizes"){
        $sql = "SELECT * FROM product_sizes WHERE productid='$productID';";
    } elseif ($type == "removeFromCart"){
        $sql = "DELETE FROM kolony_cart WHERE userid='$uID' AND eachproductid = '$indiProductID';";
    }

// Check if there are results
if ($result = mysqli_query($con, $sql))
{
 // If so, then create a results array and a temporary one
 // to hold the data
 $resultArray = array();
 $tempArray = array();
 
 // Loop through each row in the result set
 while($row = $result->fetch_object())
 {
 // Add each row into our results array
 $tempArray = $row;
     array_push($resultArray, $tempArray);
 }
 
 // Finally, encode the array to JSON and output the results
 echo json_encode($resultArray);
}
    
    // Close connections
    
    mysqli_close($con);
?>