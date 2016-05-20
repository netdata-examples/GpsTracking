using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Net;
using System.Xml;
using System.IO;
using System.Data;
using System.Web.Script.Serialization;
using System.Globalization;

public partial class _Default : System.Web.UI.Page
{
    public static string AccPo;
    public static string Xml;
    public static DataSet ds;
    protected void Page_Load(object sender, EventArgs e)
    {
        string dil = "";
        if (Request.QueryString["lang"] != null)
            dil = Request.QueryString["lang"].ToString();
        else
        {
            dil = "en-US";
        }
        ScriptManager1.EnableScriptLocalization = true;
        ScriptManager1.Scripts.First().ResourceUICultures = new string[] { dil };


        string csurl = null;
        Literal script = new Literal();
        script.Text = string.Format(
            @"<script src=""http://maps.googleapis.com/maps/api/js?sensor=false&language={0}"" type=""text/javascript""></script>", dil);
        Page.Header.Controls.Add(script);



        UICulture = dil;
        Culture = dil;
        InitializeCulture();
    }
    [WebMethod]
    public static void SaveProject(string accpo, string xml)
    {
        AccPo = accpo;
        Xml = xml;
    }
    [WebMethod]
    public static string GetData()
    {
        ds = new DataSet();
        ds.ReadXml(Xml);
        char[] labels = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'V', 'W', 'Y', 'Z' };
        StringBuilder sb = new StringBuilder();
        int i = 0;
        foreach (DataRow row in ds.Tables[0].Rows)
        {
            sb.Append("<a id='point-" + i + "' onclick=\"ShowPoint('" + i + "')\" class='list-group-item point' style='cursor:pointer;'>");
            sb.Append("<span class='badge'>" + labels[i % labels.Length] + "</span>");
            sb.Append("<h4 class='list-group-item-heading'>" + row["dc_Name"] + "</h4>");
            sb.Append("<p class='list-group-item-text'>Latitude:" + row["dc_Latitude"] + "<br/>Longitude:" + row["dc_Longitude"] + "</p>");
            sb.Append("</a>");
            i++;
        }
        return sb.ToString();
    }
    [WebMethod]
    public static string[] GetMarker()
    {
        ds = new DataSet();
        ds.ReadXml(Xml);
        string[] data = new string[ds.Tables[0].Rows.Count];
        int i = 0;
        foreach (DataRow row in ds.Tables[0].Rows)
        {
            data[i] = row["dc_Latitude"].ToString() + "," + row["dc_Longitude"].ToString() + "," + row["dc_Name"] + "," + row["ID"];
            i++;
        }
        return data;
    }
    [WebMethod]
    public static string EditData(string dataid, string name)
    {
        try
        {
            string Result = "";
            string Content = @"<?xml version=""1.0"" encoding=""utf-8""?>
<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
 <soap:Body>
    <UpdateRecord xmlns='http://tempuri.org/'>
        <APIKey>" + AccPo + @"</APIKey>
        <IDNumber>" + Convert.ToInt32(dataid) + @"</IDNumber>
        <UpdateFieldName>dc_Name</UpdateFieldName>
        <UpdateFieldNewValue>" + name + @"</UpdateFieldNewValue>
    </UpdateRecord>
  </soap:Body>
</soap:Envelope>";
            string url = "http://www.netdata.com/AccPo.asmx";
            string contentType = "text/xml; charset=utf-8";
            string method = "POST";
            string header = "SOAPAction: \"http://tempuri.org/UpdateRecord\"";

            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
            req.Method = method;
            req.ContentLength = Content.Length;
            req.ContentType = contentType;
            req.Headers.Add(header);

            Stream strRequest = req.GetRequestStream();
            StreamWriter sw = new StreamWriter(strRequest);
            sw.Write(Content);
            sw.Close();

            HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
            Stream strResponse = resp.GetResponseStream();
            StreamReader sr = new StreamReader(strResponse, System.Text.Encoding.ASCII);
            Result = sr.ReadToEnd();
            sr.Close();

            return Result;
        }
        catch (Exception)
        {
            return "exception";
        }
    }
    [WebMethod]
    public static string DeleteData(string id)
    {
        try
        {
            string Result = "";
            string Content = @"<?xml version=""1.0"" encoding=""utf-8""?>
<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
 <soap:Body>
    <DeleteRecord xmlns='http://tempuri.org/'>
        <APIKey>" + AccPo + @"</APIKey>
        <IDNumber>" + id + @"</IDNumber>
    </DeleteRecord>
 </soap:Body>
</soap:Envelope>";
            string url = "http://www.netdata.com/AccPo.asmx";
            string contentType = "text/xml; charset=utf-8";
            string method = "POST";
            string header = "SOAPAction: \"http://tempuri.org/DeleteRecord\"";

            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
            req.Method = method;
            req.ContentLength = Content.Length;
            req.ContentType = contentType;
            req.Headers.Add(header);

            Stream strRequest = req.GetRequestStream();
            StreamWriter sw = new StreamWriter(strRequest);
            sw.Write(Content);
            sw.Close();

            HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
            Stream strResponse = resp.GetResponseStream();
            StreamReader sr = new StreamReader(strResponse, System.Text.Encoding.ASCII);
            Result = sr.ReadToEnd();
            sr.Close();

            return Result;
        }
        catch (Exception)
        {
            return "exception";
        }
    }
    [WebMethod]
    public static string SaveData(string name, string lat, string lng)
    {
        try
        {
            string Result = "";
            string Content = @"<?xml version=""1.0"" encoding=""utf-8""?>
<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
 <soap:Body>
    <InsertRecord xmlns=""http://tempuri.org/"">
      <APIKey>8e3b2fba</APIKey>
      <InsertList>
        <AccPoKeyValuePair>
          <Key>dc_Name</Key>
          <Value>" + name + @"</Value>
        </AccPoKeyValuePair>
        <AccPoKeyValuePair>
          <Key>dc_Latitude</Key>
          <Value>" + lat + @"</Value>
        </AccPoKeyValuePair>
        <AccPoKeyValuePair>
          <Key>dc_Longitude</Key>
          <Value>" + lng + @"</Value>
        </AccPoKeyValuePair>
      </InsertList>
    </InsertRecord>
  </soap:Body>
</soap:Envelope>";
            string url = "http://www.netdata.com/AccPo.asmx";
            string contentType = "text/xml; charset=utf-8";
            string method = "POST";
            string header = "SOAPAction: \"http://tempuri.org/InsertRecord\"";

            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
            req.Method = method;
            req.ContentLength = Content.Length;
            req.ContentType = contentType;
            req.Headers.Add(header);

            Stream strRequest = req.GetRequestStream();
            StreamWriter sw = new StreamWriter(strRequest);
            sw.Write(Content);
            sw.Close();

            HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
            Stream strResponse = resp.GetResponseStream();
            StreamReader sr = new StreamReader(strResponse, System.Text.Encoding.ASCII);
            Result = sr.ReadToEnd();
            sr.Close();

            return Result;
        }
        catch (Exception)
        {
            return "false";
        }
    }

    [WebMethod]
    public static string GetMarkers(string url, string startDate, string endDate)
    {
        //var url = "http://www.netdata.com/XML/315BF07D";

        url = "http://www.netdata.com/XML/" + url;

        DateTime? StartDate = null;
        DateTime? EndDate = null;
        DataTable dt = new DataTable();
        DataSet ds = new DataSet();
        string setDate = "false";
        var jsonSerialiser = new JavaScriptSerializer();
        var json = "";

        if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
        {
            try
            {
                StartDate = DateTime.ParseExact(startDate, "dd.MM.yyyy", new System.Globalization.CultureInfo("tr-TR", true).DateTimeFormat).AddDays(-1);

                EndDate = DateTime.ParseExact(endDate, "dd.MM.yyyy", new System.Globalization.CultureInfo("tr-TR", true).DateTimeFormat).AddDays(1);

                url = url + "?$where=dc_Tarih>" + HttpUtility.UrlEncode(StartDate.Value.ToString("yyyy-MM-dd") + "[and]dc_Tarih<" + EndDate.Value.ToString("yyyy-MM-dd") + "");

                ds.ReadXml(url);
                dt = ds.Tables[0];

            }
            catch (Exception)
            {
                StartDate = null;
                EndDate = null;
                setDate = "true";
                ds.ReadXml(url);
                dt = ds.Tables[0];
            }
        }
        else
        {
            setDate = "true";
            ds.ReadXml(url);
            dt = ds.Tables[0];
        }

        List<MapPoint> points = new List<MapPoint>();

        if (dt.TableName == "Net_Data")
        {
            json = jsonSerialiser.Serialize(new { points = points, MaxDate = DateTime.Now.ToString("dd.MM.yyyy"), MinDate = DateTime.Now.ToString("dd.MM.yyyy"), setDate = "true" });
            return json;
        }



        //points = dt.AsEnumerable().Where(x => Convert.ToSingle(x["dc_Boylam"].ToString(), CultureInfo.CreateSpecificCulture("en-GB")) > 0).Select(x => new MapPoint { lat = Convert.ToSingle(x["dc_Enlem"].ToString(), CultureInfo.CreateSpecificCulture("en-GB")), lng = Convert.ToSingle(x["dc_Boylam"].ToString(), CultureInfo.CreateSpecificCulture("en-GB")) }).ToList();


        points = dt.AsEnumerable().Select(x => new MapPoint { lat = Convert.ToSingle(x["dc_Enlem"].ToString(), CultureInfo.CreateSpecificCulture("en-GB")), lng = Convert.ToSingle(x["dc_Boylam"].ToString(), CultureInfo.CreateSpecificCulture("en-GB")), date = x["dc_Tarih"].ToString().Replace("0000", "").Trim() }).ToList();


        DateTime MinDate = points.Select(x => Convert.ToDateTime(x.date)).Min();
        DateTime MaxDate = points.Select(x => Convert.ToDateTime(x.date)).Max();

        json = jsonSerialiser.Serialize(new { points = points, MaxDate = MaxDate.ToString("dd.MM.yyyy"), MinDate = MinDate.ToString("dd.MM.yyyy"), setDate = setDate });

        return json;
    }
    public class MapPoint
    {
        public float lat { get; set; }
        public float lng { get; set; }
        public string date { get; set; }
    }
}