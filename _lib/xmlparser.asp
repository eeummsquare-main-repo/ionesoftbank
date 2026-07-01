<%
'------------------------------------------------
'  XML  Parse 용 클래스
'  필요한 핵심부분만 만듬   2010. 06.18  이수환
'------------------------------------------------
Class XMLDOMParse

   Private m_DOM ' XMLDOM 객체
   ' ---------------------- 생성자 -----------------------
   Private Sub Class_Initialize()
      Set m_DOM = Server.CreateObject("Microsoft.XMLDOM")
   End Sub

   ' ---------------------- 소멸자 -----------------------
   Private Sub Class_Terminate()
      Set m_DOM = Nothing
   End Sub
   ' ------------------- Property Get --------------------
   Public Property Get TagText(tagName, index)
      Dim Nodes

      Set Nodes = m_DOM.getElementsByTagName(tagName)
      TagText = Nodes(index).Text
      Set Nodes = Nothing
   End Property


  ' ------------------- Property Get --------------------
   Public  Property Get AttributeText(tagName, index , item)
 AttributeText =  m_DOM.getElementsByTagName(tagName)(index).attributes.getNamedItem(item).Text
 End Property


   ' ------------------- 원격 XML 읽기 --------------------
   Public Function LoadHTTP(url)
      with m_DOM
         .async = False ' 동기식 호출
         .setProperty "ServerHTTPRequest", True ' HTTP로 XML 데이터 가져옴

         LoadHTTP = .Load(url)
      end with
   End Function

   ' -------------------  XML 읽기 --------------------
   Public Function Load(strXML )
      with m_DOM
         .async = False ' 동기식 호출
         .loadXML(strXML)
      end with
   End Function
   ' -------------------  HTML 페이지  읽기 --------------------
  Public Function  OpenHttp( PgURL)
   Set xmlHttp = Server.CreateObject("Microsoft.XMLHTTP")
      xmlHttp.Open "GET", PgURL, False
        xmlHttp.Send
  Ret =  xmlHttp.ResponseText
      Set xmlHttp = Nothing
   OpenHttp = Ret
  End Function
End Class
'1>
'Set xml = new XMLDOMParse
'xml.LoadHTTP(http://domain.com/getval.asp?pc_a=" & sPC)
'ErrState = xml.TagText("ERROR",0)

'2>
'Set xml = new XMLDOMParse
'Data = xml.OpenHttp("http://domain.com/getcid.asp?filename=" & sFileName )
'xml.load(Data)
'gCID = xml.TagText("CID",0)
%>
