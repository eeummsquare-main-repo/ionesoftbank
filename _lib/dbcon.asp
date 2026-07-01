<%
'---------------------------변경후----------------------------------
Set dbcon = Server.CreateObject("ADODB.Connection") 
dbcon.Provider = "SQLOLEDB" 
dbcon.ConnectionString = "Server=db.ione.gabia.io; Database=dbione;Uid=ione;PWD=zmfflr!@#1;" 
dbcon.Open
'--------------------------------------------------------------------
%>