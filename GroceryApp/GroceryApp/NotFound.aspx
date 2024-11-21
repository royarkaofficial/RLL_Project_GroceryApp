<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NotFound.aspx.cs" Inherits="GroceryApp.NotFound" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="center">
            <center>
                <p class="mb-0" style="font-size: 120px;">
                    <b>Uh Oh!</b>
                </p>
                <p class="mb-4" style="font-size: 40px;">
                    <b>404 - Sorry, Page not found</b>
                </p>
                <p class="mb-4" style="font-size: 20px;">
                    The page you're looking for might have been removed, does not exist, or is temporarily unavailable
                </p>
                <button type="button" class="btn btn-primary btn-lg" onclick="redirectToWelcomePage()">Home</button>
            </center>
        </div>
    </form>
</body>
</html>

<style>
.center {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
</style>

<script>
    function redirectToWelcomePage() {
        window.location.href = "Welcome";
    }
</script>