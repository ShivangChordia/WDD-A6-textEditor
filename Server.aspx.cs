
/*
*  FILE : StartPage.aspx.cs
*  PROJECT : PROG2001 – WEB DEVELOPMENT AND DESIGN - JSON and Jquery
*  PROGRAMMER : Shivang Chordia - schordia1092@conestogac.on.ca - 8871092
              Hitarth Patel - hpatel7905@conestogac.on.ca - 8887905
*  FIRST VERSION : 1st Dec 2023
*  DESCRIPTION : The File contains the code for the Json and Jquery data handles from the main page
*/


using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace A6_shivang_Hitarth
{
    public partial class Server : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        /* Function: GetFileList()
        * Parameters: 
        * Description : This is the function that gets all the filenames from the directory and passes using JSon
        * Returns : void
        */
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetFileList()
        {
            string[] files = Directory.GetFiles(HttpContext.Current.Server.MapPath("~/MyFiles"));
            for (int i = 0; i < files.Length; i++)
            {
                files[i] = Path.GetFileName(files[i]);
            }


            // Convert the list to JSON format
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string jsonResult = serializer.Serialize(files);

            return jsonResult;
        }


        /* Function: LoadFile(string selectedFile)
        * Parameters: 
        * Description : This is the function that takes in data of the file and loads the content of that file
        * Returns : void
        */
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string LoadFile(string selectedFile)
        {
            string filePath = Path.Combine(HttpContext.Current.Server.MapPath("~/MyFiles"), selectedFile);
            string content = "[\""+ File.ReadAllText(filePath)+"\"]";

            return content;
        }


        /* Function: SaveFile(string fileName, string content)
        * Parameters: o
        * Description : This is the function that saves the new content into the file
        * Returns : void
        */
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static void SaveFile(string fileName, string content)
        {
            string filePath = Path.Combine(HttpContext.Current.Server.MapPath("~/MyFiles"), fileName);
            File.WriteAllText(filePath, content);
        }



        /* Function: SaveAsFile(string fileName, string content)
         * Parameters: o
         * Description : This is the function that saves the new content into a new file
         * Returns : void
         */
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static void SaveAs(string newFileName, string content)
        {
            string filePath = Path.Combine(HttpContext.Current.Server.MapPath("~/MyFiles"), newFileName);
            File.WriteAllText(filePath, content);
        }
    }


}

    

