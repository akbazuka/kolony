<?php

//Chnage this connection when swicth to remote server database
//$con=mysqli_connect("localhost","username","password","dbname");
$con = mysqli_connect("localhost","root","","kolony");

// Check connection
if (mysqli_connect_errno())
{
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
else print "Connection was success\n";

// This SQL statement selects ALL from the table 'products' for products that have not been sold
$sql = "SELECT * FROM products WHERE sold=0";
//echo $sql;

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

/*
$type = $_GET["type"];
$uID = $_GET["uID"];
$lifestyleID = $_GET["lifestyleID"];
$productID = $_GET["productID"];
*/
 
/*
    // This SQL statement selects ALL from the table 'Recipes'
    if($type == "pullRecipes"){
        $sql = "SELECT r.RecipeID, RecipeName, Calories, CookingTime, Cuisine, Image, Directions, LifeStyleID FROM Recipes r join LifeStyle_Recipes l on r.RecipeID = l.RecipeID where lifestyleID = '$lifestyleID';";
    }elseif ($type == "updateLifestyle"){
        $sql = "update Registration set LifeStyleID = '$lifestyleID' where RegistrationID = '$uID';";
    }elseif ($type == "pullUser"){
        $sql = "select LifeStyleID as lifestyleID from Registration where RegistrationID = '$uID' ";
    }elseif ($type == "insertFav"){
        $sql = "insert into Favorites values ('$uID','$recipeID');";
    }elseif ($type == "pullFav"){
        $sql = " SELECT r.RecipeID, RecipeName, Calories, CookingTime, Cuisine, 
        Directions FROM Registration reg
        join Favorites f on reg.registrationID=f.registrationID
        join Recipes r on f.recipeID=r.recipeID where f.RegistrationID = '$uID';";
    }elseif ($type == "insertUser"){
        $sql = "insert into Registration values ('$uID','$lifestyleID');";
    }
    
   

    // Check if there are results
    
    if ($result = mysqli_query($con, $sql)) {
        
        // If so, then create a results array and a temporary one
        
        // to hold the data
        
        $resultArray = array();
        
        $tempArray = array();
        
        
        
        // Loop through each row in the result set
        
        while ($row = $result->fetch_object()) {
            
            // Add each row into our results array
            $tempArray = $row;
            array_push($resultArray, $tempArray);
            
            //echo $row->Image;
            
        }
        
        
        
        // Finally, encode the array to JSON and output the results
        
        echo json_encode($resultArray);
        
    }
    
*/
    
    // Close connections
    
    mysqli_close($con);
?>