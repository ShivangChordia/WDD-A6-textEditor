<!--
  /*
*  FILE : StartPage.aspx
*  PROJECT : PROG2001 – WEB DEVELOPMENT AND DESIGN - JSON and Jquery
*  PROGRAMMER : Shivang Chordia - schordia1092@conestogac.on.ca - 8871092
                Hitarth Patel - hpatel7905@conestogac.on.ca - 8887905
*  FIRST VERSION : 1st Dec 2023
*  DESCRIPTION : The File contains the Client side of homepage to of the text editor
*/  
-->


<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StartPage.aspx.cs" Inherits="A6_shivang_Hitarth.StartPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Royal Text Editor</title>

    <!-- Styling the Text editor -->
    <style>
        body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 20px;
    background-color: #f4f4f4;
}

h1 {
    text-align: center;
    color: #333;
}

#form1 {
    width: 80%;
    margin: 0 auto;
}

label {
    display: block;
    font-size: 16px;
    margin-bottom: 8px;
    color: #333;
}

#fileDropdown {
    
    margin-bottom: 12px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 14px;
}

#editor {
    width: 100%;
    height: 60vh;
    margin-bottom: 12px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 14px;
}

button {
    padding: 10px 20px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
}

button:hover {
    background-color: #45a049;
}

#charCount {
    font-size: 14px;
    color: #666;
    text-align: right;
}

/* Additional styling for the Load Button */
#LoadButton {
    background-color: #2196F3;
    margin-right: 10px;
}

#LoadButton:hover {
    background-color: #0b7dda;
}
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
  <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
  <script>

      // When the document is ready to display it call this functions
      $(document).ready(function () {
          ReloadFileList();
          LoadFileButton();
      });



        /* Function: countCharacters()
        * Parameters: object sender, EventArgs e
        * Description : This is the function that counts the charecters in the textbox after every key press
        * Returns : void
        */
        function countCharacters() {
            var editor = $('#editor');
            var charCount = $('#charCount');
            var count = editor.val().length;
            charCount.text(count + " characters");
        }

        /* Function: saveFile()
        * Parameters: 
        * Description : This is the function that send Ajax request to save the content of the Text editor
        * Returns : void
        */
        function saveFile() {
            var fileName = $('#fileDropdown').val();
            var content = $('#editor').val();


            if (!fileName) {
                // If fileName is null, call saveAsFile function
                saveAsFile();
                return; // Exit the function to prevent further execution
            }

                $.ajax({
                    url: 'Server.aspx/SaveFile',
                    method: 'POST',
                    data: JSON.stringify({ fileName: fileName, content: content }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (data) {
                        $(function () {
                            $("#dialog").dialog();
                        });
                    },
                    error: function (error) {
                        console.log(error);
                    }
                });
           
        }

        /* Function: saveAsFile()
        * Parameters: 
        * Description : This is the function that send Ajax request to save the content of the Text editor in a new file
        * Returns : void
        */
        function saveAsFile() {
            var newFileName = prompt('Enter a new file name:');
            var content = $('#editor').val();
            if (newFileName) {
                // Save to new file
                $.ajax({
                    url: 'Server.aspx/SaveAs',
                    method: 'POST',
                    data: JSON.stringify({ newFileName: newFileName, content: content }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (data) {
                        alert('File saved successfully!');
                    },
                    error: function (error) {
                        console.log(error);
                    }
                });

                ReloadFileList();
            }


        }



        /* Function:  ReloadFileList() 
        * Parameters: 
        * Description : This is the function that reloads files on all every moment as ther is a new file
        * Returns : void
        */
        function ReloadFileList() {
            $.ajax({
                url: 'Server.aspx/GetFileList',
                method: 'POST',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (data) {
                   
                    // Populate dropdown with file names
                    var dataArray = JSON.parse(data.d);
                    var dropdown = $('#fileDropdown');
                    dropdown.empty();
                    $.each(dataArray, function (index, value) {
                        dropdown.append($('<option></option>').val(value).html(value));
                    });

                },
                error: function (error) {
                    console.log(error);
                }
            });

            LoadFileButton();
        }


        /* Function:  LoadFileButton()
        * Parameters: 
        * Description : This is the function that loads contents from the selected file.
        * Returns : void
        */
        function LoadFileButton() {
            var selectedFile = $('#fileDropdown').val();
            $.ajax({
                url: "Server.aspx/LoadFile",
                method: 'POST',
                data: JSON.stringify({ selectedFile: selectedFile }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (data) {
                    var dataArray = JSON.parse(data.d);
                    $('#editor').val(dataArray);
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }


  </script>
</head>
<body>
    <!-- Form for the Royal Text Editor with server-side processing -->
    <form id="form1" runat="server">
        <!-- Heading for the Text Editor -->
        <h1>Royal Text Editor</h1>
        <div>
            <!-- Label and dropdown for file selection -->
            <label for="fileDropdown">Select a file:</label>
            <select id="fileDropdown"></select>
            <!-- Button to trigger file loading -->
            <button type="button" onclick="LoadFileButton()" id="LoadButton">Load Content</button>
            <br />
            <!-- Textarea for text editing with a keyup event handler for character count -->
            <textarea id="editor" rows="10" cols="50" onkeyup="countCharacters()"></textarea>
            <!-- Paragraph for displaying a success message (hidden by default) -->
            <p id="dialog" style="display:none; background-color:dodgerblue; color:white">File Saved Successfully!</p>
            <!-- Label for displaying character count -->
            <label id="charCount"></label>
            <br />
            <!-- Buttons for saving and saving as files -->
            <button type="button" onclick="saveFile()">Save</button>
            <button type="button" onclick="saveAsFile()">Save As</button>
        </div>
    </form>
</body>

</html>

